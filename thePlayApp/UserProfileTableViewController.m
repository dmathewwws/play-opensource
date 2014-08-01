//
//  UserProfileTableViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-02-08.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "UserProfileTableViewController.h"
#import "RegisterOrLoginViewController.h"
#import "UserFollowViewController.h"
#import "DetailedEventViewController.h"
#import "PlayConstants.h"
#import "PlayUtility.h"
#import "PlayCache.h"
#import "EventFeedCell.h"
#import "PlayLoadMoreCell.h"
#import "SeeUserAvatarViewController.h"
#import "EditProfileTableViewController.h"
#import "UserSettingsProfileControllerViewController.h"
#import "GAI.h"
#import "OLGhostAlertView.h"

@interface UserProfileTableViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (strong,nonatomic) CLLocation *currentLocation;

@end

@implementation UserProfileTableViewController

#define xofHeader 4.5f
#define yofHeader 4.5f

#define xofAvatar xofHeader + 9.0f
#define yofAvatar yofHeader + 9.0f
#define squareAvatar 75.0f

#define xofPlan xofAvatar + squareAvatar + 8.0f
#define yofPlan yofHeader + 3.5f
#define widthofPlan 71.0f
#define heightofPlan 42.0f

#define xofFollowers xofPlan + widthofPlan + 1.0f
#define yofFollowers yofHeader + 3.5f
#define widthofFollowers 71.0f
#define heightofFollowers 42.0f

#define xofFollowing xofFollowers + widthofFollowers + 2.0f
#define yofFollowing yofHeader + 3.5f
#define widthofFollowing 71.0f
#define heightofFollowing 42.0f

#define xofFollowButton xofAvatar + squareAvatar + 8.0f + 6.0f
#define yofFollowButton yofHeader + 3.5f + heightofFollowing+ 8.0f
#define widthFollowButton 72.0f*3
#define heightFollowButton 44.0f

#define xofTitle xofAvatar
#define xofSubtTitle xofPlan
#define yofBio yofAvatar + squareAvatar + 10.0f
#define yofGender yofBio + 58.0f
#define yofAge yofGender + 20.0f

#define yofFollowButton yofHeader + 3.5f + heightofFollowing+ 8.0f
#define widthFollowButton 72.0f*3
#define heightFollowButton 44.0f

#define xStartingPoint 15.0f
#define followersView 0
#define followingView 1

#define squareSizeOfSportsIcon 20.0f
#define topSportSpot1 320-squareSizeOfSportsIcon-20-(squareSizeOfSportsIcon*2)-(5*2), yofAge-6, squareSizeOfSportsIcon, squareSizeOfSportsIcon
#define topSportSpot2 320-squareSizeOfSportsIcon-20-(squareSizeOfSportsIcon*1)-(5*1), yofAge-6, squareSizeOfSportsIcon, squareSizeOfSportsIcon
#define topSportSpot3 320-squareSizeOfSportsIcon-20-(squareSizeOfSportsIcon*0)-(5*0), yofAge-6, squareSizeOfSportsIcon, squareSizeOfSportsIcon

#define kSelectedIndexisEvents 0
#define kSelectedIndexisInvitations 1

@synthesize user = _user;
@synthesize headerView = _headerView;
@synthesize profilePictureImageView = _profilePictureImageView;
@synthesize followerCountLabel = _followerCountLabel;
@synthesize followingCountLabel = _followingCountLabel;
@synthesize userDisplayNameLabel = _userDisplayNameLabel;
@synthesize followUserButton = _followUserButton;
@synthesize userfollowingCount = _userfollowingCount;
@synthesize segmentedControl = _segmentedControl;
@synthesize reusableSectionHeaderViews = _reusableSectionHeaderViews;
@synthesize outstandingSectionHeaderQueries = _outstandingSectionHeaderQueries;
@synthesize shouldReloadOnAppear = _shouldReloadOnAppear;
@synthesize currentLocation = _currentLocation;
@synthesize picker = _picker;
@synthesize userMediumAvatar = _userMediumAvatar;
@synthesize userSmallAvatar = _userSmallAvatar;
@synthesize shouldScrollToTopView = _shouldScrollToTopView;
@synthesize planLabel = _planLabel;
@synthesize followersLabel = _followersLabel;
@synthesize followingLabel = _followingLabel;
@synthesize planCountLabel = _planCountLabel;
@synthesize bioTitleButton = _bioTitleButton;
@synthesize genderTitleButton = _genderTitleButton;
@synthesize ageTitleButton = _ageTitleButton;
@synthesize bioBigTitleButton = _bioBigTitleButton;
@synthesize genderBigTitleButton = _genderBigTitleButton;
@synthesize ageBigTitleButton = _ageBigTitleButton;
@synthesize shouldSegmentChangeScrollToTopView = _shouldSegmentChangeScrollToTopView;
@synthesize dateFormatterForTime = _dateFormatterForTime;
@synthesize topSport1Button = _topSport1Button;
@synthesize topSport2Button = _topSport2Button;
@synthesize topSport3Button = _topSport3Button;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 15;
        
        self.shouldReloadOnAppear = NO;
        
        // Improve scrolling performance by reusing UITableView section headers
        self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:4];
        
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        [appDelegate startLocationManager];
        
        _currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; // PFQueryTableViewController reads this in viewDidLoad -- would prefer to throw this in init, but didn't work
    
    [super viewDidLoad];
    
    NSLog(@"in viewDIdLoad");
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    
    //refreshControl.tintColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    
    // Call refreshControlValueChanged: when the user pulls the table view down.
    [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _dateFormatterForTime = [[NSDateFormatter alloc] init];
    _dateFormatterForTime.locale = [NSLocale currentLocale];
    [_dateFormatterForTime setTimeStyle: NSDateFormatterShortStyle];
    [_dateFormatterForTime setDateStyle: NSDateFormatterMediumStyle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCheckInOrUncheckIntoEvent:) name:PlayUtilityUserCheckedInorUncheckedIntoEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPublishEvent:) name:CheckInControllerDidFinishEditingEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidDeleteEvent:) name:DetailedViewControllerUserDeletedEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCheckInOrUncheckIntoEvent:) name:DetailedViewControllerUserCheckedInorUncheckedIntoEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCommentOnEvent:) name:DetailedViewControllerUserCommentedOnEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileBio:) name:PlayEditProfileChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFollowingCount:) name:PlayUtilityFollowingCountChanged object:nil];
    
    UIImage *headerImage = [UIImage imageNamed:@"profilecard.png"];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake( xofHeader, yofHeader, self.tableView.bounds.size.width, headerImage.size.height)];
    
    [self.headerView setBackgroundColor:[UIColor clearColor]]; // should be clear, this will be the container for our avatar, photo count, follower count, following count, and so on
    
    UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerButton setFrame:CGRectMake(xofHeader, yofHeader, headerImage.size.width, headerImage.size.height)];
    [headerButton setBackgroundImage:headerImage forState:UIControlStateNormal];
    [headerButton setUserInteractionEnabled:NO];
    [self.headerView addSubview:headerButton];
    
    if ([[PFUser currentUser].objectId isEqualToString:_user.objectId]) {
        UIImage* image = [UIImage imageNamed:@"settingicon.png"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
        [someButton setBackgroundImage:image forState:UIControlStateNormal];
        [someButton addTarget:self action:@selector(openProfileSettings:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        [self.navigationItem setRightBarButtonItem:settingsBarButton];
        
        /* Unselected background */
        UIImage *unselectedBackgroundImage = [[UIImage imageNamed:@"profilebuttonblank.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        /*[[UISegmentedControl appearance] setBackgroundImage:unselectedBackgroundImage
                                                   forState:UIControlStateNormal
                                                 barMetrics:UIBarMetricsDefault];*/
        
        /* Selected background */
        UIImage *selectedBackgroundImage = [[UIImage imageNamed:@"profilebuttonblank1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        /*[[UISegmentedControl appearance] setBackgroundImage:selectedBackgroundImage
                                                   forState:UIControlStateSelected
                                                 barMetrics:UIBarMetricsDefault];*/
        
        /* Image between two unselected segments
        UIImage *bothUnselectedImage = [[UIImage imageNamed:@"segment_middle_unselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 0, 15, 0)];
        [[UISegmentedControl appearance] setDividerImage:bothUnselectedImage
                                     forLeftSegmentState:UIControlStateNormal
                                       rightSegmentState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        
       //  Image between segment selected on the left and unselected on the right 
        UIImage *leftSelectedImage = [[UIImage imageNamed:@"segment_middle_left_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 0, 15, 0)];
        [[UISegmentedControl appearance] setDividerImage:leftSelectedImage
                                     forLeftSegmentState:UIControlStateSelected
                                       rightSegmentState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        
        // Image between segment selected on the right and unselected on the left 
        UIImage *rightSelectedImage = [[UIImage imageNamed:@"segment_middle_right_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 0, 15, 0)];
        [[UISegmentedControl appearance] setDividerImage:rightSelectedImage
                                     forLeftSegmentState:UIControlStateNormal
                                       rightSegmentState:UIControlStateSelected
                                              barMetrics:UIBarMetricsDefault];*/
        
        [_headerView setFrame:CGRectMake( xofHeader, yofHeader, self.tableView.bounds.size.width, headerImage.size.height+selectedBackgroundImage.size.height+10)];
        
        //UIsegmentController
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@" ",@" ",nil]];
        [_segmentedControl setFrame:CGRectMake(xofHeader, headerButton.frame.size.height+10, self.tableView.bounds.size.width-(xofHeader*2), selectedBackgroundImage.size.height)];
        [_segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [_segmentedControl setBackgroundImage:unselectedBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedControl setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        /*[_segmentedControl setDividerImage:bothUnselectedImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedControl setDividerImage:leftSelectedImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedControl setDividerImage:rightSelectedImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];*/
        
        [_segmentedControl addTarget:self
                              action:@selector(segmentChanged:)
                    forControlEvents:UIControlEventValueChanged];
        
        _segmentedControl.selectedSegmentIndex = kSelectedIndexisEvents;
        [_headerView addSubview:_segmentedControl];
        
        UIImage *feedImage = [UIImage imageNamed:@"feedicon.png"];
        UIButton *feedImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [feedImageButton setFrame:CGRectMake(xofHeader+(self.tableView.bounds.size.width-(xofHeader*2))/4-feedImage.size.width/2, headerButton.frame.size.height+10+selectedBackgroundImage.size.height/2-feedImage.size.height/2, feedImage.size.width, feedImage.size.height)];
        [feedImageButton setBackgroundImage:feedImage forState:UIControlStateNormal];
        [feedImageButton setUserInteractionEnabled:NO];
        [self.headerView addSubview:feedImageButton];
        
        UIImage *invitationImage = [UIImage imageNamed:@"invitationicon.png"];
        UIButton *invitationImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [invitationImageButton setFrame:CGRectMake(xofHeader+(self.tableView.bounds.size.width-(xofHeader*2))*3/4-invitationImage.size.width/2, headerButton.frame.size.height+10+selectedBackgroundImage.size.height/2-invitationImage.size.height/2, invitationImage.size.width, invitationImage.size.height)];
        [invitationImageButton setBackgroundImage:invitationImage forState:UIControlStateNormal];
        [invitationImageButton setUserInteractionEnabled:NO];
        [self.headerView addSubview:invitationImageButton];
        
    }
    
    /*CreateEventButton
    UIImage *createEventImage = [UIImage imageNamed:@"playbutton1.png"];
    _createEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_createEventButton setTitle:@"PLAY" forState:UIControlStateNormal];
    [_createEventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _createEventButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:25.0f];
    [_createEventButton setFrame:CGRectMake(222,347+(iphone5spacer*4),createEventImage.size.width,createEventImage.size.height)];
    [_createEventButton addTarget:self action:@selector(createEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_createEventButton setBackgroundImage:createEventImage forState:UIControlStateNormal];
    [self.view addSubview:_createEventButton];*/
    
    _profilePictureImageView = [[PlayProfileImageView alloc] initWithFrame:CGRectMake(xofAvatar, yofAvatar, squareAvatar, squareAvatar)];
    [_profilePictureImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.headerView addSubview:_profilePictureImageView];
    //layer = [profilePictureImageView layer];
    //layer.cornerRadius = 10.0f;
    //layer.masksToBounds = YES;
    //_profilePictureImageView.alpha = 0.0f;
    /*UIImageView *profilePictureStrokeImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 88.0f, 34.0f, 143.0f, 143.0f)];
     profilePictureStrokeImageView.alpha = 0.0f;
     [profilePictureStrokeImageView setImage:[UIImage imageNamed:@"ProfilePictureStroke.png"]];
     [self.headerView addSubview:profilePictureStrokeImageView];*/
    
    PFFile *imageFile = [self.user objectForKey:kPlayUserProfilePictureMediumKey];
    if (imageFile) {
        [_profilePictureImageView setFile:imageFile];
    }
    
    CALayer * l = [_profilePictureImageView.profileImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:3.5];
    
    _planLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_planLabel setFrame:CGRectMake(xofPlan, yofPlan, widthofPlan, heightofPlan)];
    [_planLabel setBackgroundColor:[UIColor clearColor]];
    [_planLabel setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_planLabel setUserInteractionEnabled:NO];
    [_planLabel setTitle:@"PLAYS" forState:UIControlStateNormal];
    [_planLabel setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [[_planLabel titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:9.0f]];
    [self.headerView addSubview:_planLabel];
    
    _followersLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followersLabel setFrame:CGRectMake(xofFollowers, yofFollowers, widthofFollowers, heightofFollowers)];
    [_followersLabel setBackgroundColor:[UIColor clearColor]];
    [_followersLabel setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_followersLabel setUserInteractionEnabled:NO];
    [_followersLabel setTitle:@"FOLLOWERS" forState:UIControlStateNormal];
    [_followersLabel setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [[_followersLabel titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:9.0f]];
    [self.headerView addSubview:_followersLabel];
    
    _followingLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followingLabel setFrame:CGRectMake(xofFollowing, yofFollowing, widthofFollowing, heightofFollowing)];
    [_followingLabel setBackgroundColor:[UIColor clearColor]];
    [_followingLabel setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_followingLabel setUserInteractionEnabled:NO];
    [_followingLabel setTitle:@"FOLLOWING" forState:UIControlStateNormal];
    [_followingLabel setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [[_followingLabel titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:9.0f]];
    [self.headerView addSubview:_followingLabel];
    
    _planCountLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_planCountLabel setFrame:CGRectMake(xofPlan, yofPlan-2, widthofPlan, heightofPlan)];
    [_planCountLabel setBackgroundColor:[UIColor clearColor]];
    [_planCountLabel setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[_planCountLabel titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:20.0f]];
    //[_planCountLabel setTag:followersView];
    _planCountLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);

    [self.headerView addSubview:_planCountLabel];
    
    _followerCountLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followerCountLabel setFrame:CGRectMake(xofFollowers, yofFollowers-2, widthofFollowers, heightofFollowers)];
    [_followerCountLabel setBackgroundColor:[UIColor clearColor]];
    [_followerCountLabel setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[_followerCountLabel titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:20.0f]];
    [_followerCountLabel setTag:followersView];
    [_followerCountLabel addTarget:self action:@selector(openFollowView:) forControlEvents:UIControlEventTouchUpInside];
    _followerCountLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);

    [self.headerView addSubview:_followerCountLabel];
        
    _followingCountLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followingCountLabel setFrame:CGRectMake(xofFollowing, yofFollowing-2, widthofFollowing, heightofFollowing)];
    [_followingCountLabel setBackgroundColor:[UIColor clearColor]];
    [_followingCountLabel setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [[_followingCountLabel titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:20.0f]];
    [_followingCountLabel setTag:followingView];
    [_followingCountLabel addTarget:self action:@selector(openFollowView:) forControlEvents:UIControlEventTouchUpInside];
    _followingCountLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);

    [self.headerView addSubview:_followingCountLabel];
    
    _followUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *followButton = [UIImage imageNamed:@"profilefollow.png"];
    
    [_followUserButton setFrame:CGRectMake(xofFollowButton, yofFollowButton, followButton.size.width, followButton.size.height)];
    [_followUserButton setTitle:@"FOLLOW" forState:(UIControlStateNormal)];
    [_followUserButton setTitle:@"FOLLOWING" forState:(UIControlStateSelected)];
    [_followUserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followUserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    //[_followUserButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:178.0f/255.0f blue:137.0f/255.0f alpha:1.0f] forState:UIControlStateSelected];
    [_followUserButton setBackgroundImage:[UIImage imageNamed:@"profilefollow.png"] forState:UIControlStateNormal];
    [_followUserButton setBackgroundImage:[UIImage imageNamed:@"profilefollowing.png"] forState:UIControlStateSelected];
    [[_followUserButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:18.0f]];
    [self.headerView addSubview:_followUserButton];
    
    /*_userDisplayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xStartingPoint, 176.0f, self.headerView.bounds.size.width, 22.0f)];
    //[_userDisplayNameLabel setTextAlignment:NSTextAlignmentCenter];
    [_userDisplayNameLabel setBackgroundColor:[UIColor clearColor]];
    [_userDisplayNameLabel setTextColor:[UIColor blackColor]];
    [_userDisplayNameLabel setText:[self.user objectForKey:kPlayUserUsernameKey]];
    [_userDisplayNameLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [self.headerView addSubview:_userDisplayNameLabel];*/
        
    [_followerCountLabel setTitle:@"0" forState:UIControlStateNormal];
    
    PFQuery *queryFollowerCount = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [queryFollowerCount whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
    [queryFollowerCount whereKey:kPlayActivityToUserKey equalTo:self.user];
    [queryFollowerCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowerCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            _userfollowingCount = number;
            [_followerCountLabel setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
            [_followersLabel setTitle:[NSString stringWithFormat:@"FOLLOWER%@", number==1?@"":@"S"] forState:UIControlStateNormal];
        }
    }];
    
    [_followingCountLabel setTitle:@"0" forState:UIControlStateNormal];
    
    PFQuery *queryFollowingCount = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [queryFollowingCount whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
    [queryFollowingCount whereKey:kPlayActivityFromUserKey equalTo:self.user];
    [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [_followingCountLabel setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
        }
    }];
    
    [_planCountLabel setTitle:@"0" forState:UIControlStateNormal];
    
    PFQuery *queryPlayCount = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [queryPlayCount whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsCheckIn];
    [queryPlayCount whereKey:kPlayActivityFromUserKey equalTo:self.user];
    [queryPlayCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryPlayCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [_planCountLabel setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
            [_planLabel setTitle:[NSString stringWithFormat:@"PLAY%@", number==1?@"":@"S"] forState:UIControlStateNormal];
        }
    }];
    
    NSString *bioString = [self.user objectForKey:kPlayUserPlayBioKey];
    
    NSArray *ageArray = [self.user objectForKey:kPlayUserPlayAgeKey];
    NSString *ageString = [ageArray objectAtIndex:0];
    
    NSArray *genderArray = [self.user objectForKey:kPlayUserPlayGenderKey];
    NSString *genderString = [genderArray objectAtIndex:0];

    int spacer = 0;
    if (bioString.length<80) {
        spacer=15;
    }
    
    _bioBigTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bioBigTitleButton setFrame:CGRectMake(xofTitle, yofBio, squareAvatar, 60.0f-spacer)];
    [_bioBigTitleButton setBackgroundColor:[UIColor clearColor]];
    [_bioBigTitleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_bioBigTitleButton setUserInteractionEnabled:NO];
    [_bioBigTitleButton setTitle:@"BIO:" forState:UIControlStateNormal];
    [_bioBigTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [[_bioBigTitleButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:13.0f]];
    [self.headerView addSubview:_bioBigTitleButton];
    
    _bioTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bioTitleButton setFrame:CGRectMake(xofSubtTitle, yofBio, widthFollowButton, 60.0f-spacer)];
    [_bioTitleButton setBackgroundColor:[UIColor clearColor]];
    [_bioTitleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_bioTitleButton setUserInteractionEnabled:NO];
    [_bioTitleButton setTitle:bioString forState:UIControlStateNormal];
    [_bioTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_bioTitleButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [[_bioTitleButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:12.0f]];
    [self.headerView addSubview:_bioTitleButton];
    
    _genderBigTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_genderBigTitleButton setFrame:CGRectMake(xofTitle, yofGender-spacer, squareAvatar, 30.0f)];
    [_genderBigTitleButton setBackgroundColor:[UIColor clearColor]];
    [_genderBigTitleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_genderBigTitleButton setUserInteractionEnabled:NO];
    [_genderBigTitleButton setTitle:@"GENDER:" forState:UIControlStateNormal];
    [_genderBigTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [[_genderBigTitleButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:13.0f]];
    [self.headerView addSubview:_genderBigTitleButton];
    
    _genderTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_genderTitleButton setFrame:CGRectMake(xofSubtTitle, yofGender-spacer, widthFollowButton, 30.0f)];
    [_genderTitleButton setBackgroundColor:[UIColor clearColor]];
    [_genderTitleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_genderTitleButton setUserInteractionEnabled:NO];
    [_genderTitleButton setTitle:genderString forState:UIControlStateNormal];
    [_genderTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [[_genderTitleButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:12.0f]];
    [self.headerView addSubview:_genderTitleButton];
    
    _ageBigTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ageBigTitleButton setFrame:CGRectMake(xofTitle, yofAge-spacer, squareAvatar, 30.0f)];
    [_ageBigTitleButton setBackgroundColor:[UIColor clearColor]];
    [_ageBigTitleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_ageBigTitleButton setUserInteractionEnabled:NO];
    [_ageBigTitleButton setTitle:@"AGE:" forState:UIControlStateNormal];
    [_ageBigTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [[_ageBigTitleButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:13.0f]];
    [self.headerView addSubview:_ageBigTitleButton];
    
    _ageTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ageTitleButton setFrame:CGRectMake(xofSubtTitle, yofAge-spacer, widthFollowButton, 30.0f)];
    [_ageTitleButton setBackgroundColor:[UIColor clearColor]];
    [_ageTitleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_ageTitleButton setUserInteractionEnabled:NO];
    [_ageTitleButton setTitle:ageString forState:UIControlStateNormal];
    [_ageTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [[_ageTitleButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:12.0f]];
    [self.headerView addSubview:_ageTitleButton];
    
    if(!bioString && !ageString && !genderString){
        _bioBigTitleButton.hidden = YES;
        _genderBigTitleButton.hidden = YES;
        _ageBigTitleButton.hidden = YES;
    }
    
    _topSport1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topSport1Button setBackgroundImage:[UIImage imageNamed:@"sport11minig.png"] forState:UIControlStateNormal];
    [_topSport1Button setUserInteractionEnabled:NO];
    [self.headerView addSubview:_topSport1Button];
    
    _topSport2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topSport2Button setBackgroundImage:[UIImage imageNamed:@"sport11minig.png"] forState:UIControlStateNormal];
    [_topSport2Button setUserInteractionEnabled:NO];
    [self.headerView addSubview:_topSport2Button];
    
    _topSport3Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topSport3Button setBackgroundImage:[UIImage imageNamed:@"sport11minig.png"] forState:UIControlStateNormal];
    [_topSport3Button setUserInteractionEnabled:NO];
    [self.headerView addSubview:_topSport3Button];
    
    // check if the currentUser is following this user
    PFQuery *queryTopSports = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [queryTopSports whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsCheckIn];
    [queryTopSports whereKey:kPlayActivityFromUserKey equalTo:self.user];
    [queryTopSports includeKey:kPlayActivityEventKey];
    [queryTopSports setCachePolicy:kPFCachePolicyCacheThenNetwork];
    queryTopSports.limit = 25;
    [queryTopSports findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error && [error code] != kPFErrorCacheMiss) {
            NSLog(@"Couldn't find top sports: %@", error);
        } else {
         
            int countOfIcon0 = 0;
            int countOfIcon1 = 0;
            int countOfIcon2 = 0;
            int countOfIcon3 = 0;
            int countOfIcon4 = 0;
            int countOfIcon5 = 0;
            int countOfIcon6 = 0;
            int countOfIcon7 = 0;
            int countOfIcon8 = 0;
            int countOfIcon9 = 0;
            int countOfIcon10 = 0;
            int countOfIcon11 = 0;
                        
            for (PFObject *anActivity in objects) {
                
                PFObject *anEvent = [anActivity objectForKey:kPlayActivityEventKey];
                NSNumber *iconType = [anEvent objectForKey:kPlayEventIconTypeKey];
                //NSLog(@"numicon0 is %@ numicon1 is %@",numIcon0,numIcon1.stringValue);

                switch ([iconType intValue]) {
                    case 0:
                        countOfIcon0++;
                        break;
                    case 1:
                        countOfIcon1++;
                        break;
                    case 2:
                        countOfIcon2++;
                        break;
                    case 3:
                        countOfIcon3++;
                        break;
                    case 4:
                        countOfIcon4++;
                        break;
                    case 5:
                        countOfIcon5++;
                        break;
                    case 6:
                        countOfIcon6++;
                        break;
                    case 7:
                        countOfIcon7++;
                        break;
                    case 8:
                        countOfIcon8++;
                        break;
                    case 9:
                        countOfIcon9++;
                        break;
                    case 10:
                        countOfIcon10++;
                        break;
                    case 11:
                        countOfIcon11++;
                        break;
                    default:
                        break;
                }
            }
        
            NSString * TYPE      = @"type";
            NSString * FREQUENCY = @"frequency";
            
            NSMutableArray * array = [NSMutableArray array];
            
            NSDictionary * dict;
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon0", TYPE,[NSNumber numberWithInt:countOfIcon0], FREQUENCY,nil];
            [array addObject:dict];

            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon1", TYPE,[NSNumber numberWithInt:countOfIcon1], FREQUENCY,nil];
            [array addObject:dict];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon2", TYPE,[NSNumber numberWithInt:countOfIcon2], FREQUENCY,nil];
            [array addObject:dict];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon3", TYPE,[NSNumber numberWithInt:countOfIcon3], FREQUENCY,nil];
            [array addObject:dict];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon4", TYPE,[NSNumber numberWithInt:countOfIcon4], FREQUENCY,nil];
            [array addObject:dict];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon5", TYPE,[NSNumber numberWithInt:countOfIcon5], FREQUENCY,nil];
            [array addObject:dict];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon6", TYPE,[NSNumber numberWithInt:countOfIcon6], FREQUENCY,nil];
            [array addObject:dict];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon7", TYPE,[NSNumber numberWithInt:countOfIcon7], FREQUENCY,nil];
            [array addObject:dict];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon8", TYPE,[NSNumber numberWithInt:countOfIcon8], FREQUENCY,nil];
            [array addObject:dict];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon9", TYPE,[NSNumber numberWithInt:countOfIcon9], FREQUENCY,nil];
            [array addObject:dict];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon10", TYPE,[NSNumber numberWithInt:countOfIcon10], FREQUENCY,nil];
            [array addObject:dict];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys: @"countOfIcon11", TYPE,[NSNumber numberWithInt:countOfIcon11], FREQUENCY,nil];
            [array addObject:dict];
            
            NSSortDescriptor * frequencyDescriptor = [[NSSortDescriptor alloc] initWithKey:FREQUENCY ascending:YES];
            
            //id obj;
            //NSEnumerator * enumerator = [array objectEnumerator];
            //while ((obj = [enumerator nextObject])) NSLog(@"%@", obj);
            
            NSArray * descriptors = [NSArray arrayWithObjects:frequencyDescriptor, nil];
            NSArray * sortedArray = [array sortedArrayUsingDescriptors:descriptors];
            
            NSLog(@"\nSorted ...");
            //NSLog(@"descriptors is %@",descriptors);
            
            //enumerator = [sortedArray objectEnumerator];
            //while ((obj = [enumerator nextObject])) NSLog(@"%@", obj);

            int countOfTopSports = 0;
            for (NSDictionary *dictSorted in sortedArray) {
                
                NSNumber *numTopSports = [dictSorted objectForKey:FREQUENCY];
                if ([numTopSports intValue]>0) {
                     countOfTopSports++;
                 }
             }
             
             if(countOfTopSports>2){
                 [_topSport1Button setFrame:CGRectMake(topSportSpot1)];
                 [_topSport2Button setFrame:CGRectMake(topSportSpot2)];
                 [_topSport3Button setFrame:CGRectMake(topSportSpot3)];
                 
                NSDictionary *dictTopSport1 = [sortedArray objectAtIndex:11];
                NSString *topSport1Type = [dictTopSport1 objectForKey:TYPE];
                     
                [_topSport1Button setBackgroundImage:[PlayUtility greyTopSportsImagesForProfile:topSport1Type] forState:UIControlStateNormal];
                     
                NSDictionary *dictTopSport2 = [sortedArray objectAtIndex:10];
                NSString *topSport2Type = [dictTopSport2 objectForKey:TYPE];
                     
                [_topSport2Button setBackgroundImage:[PlayUtility greyTopSportsImagesForProfile:topSport2Type] forState:UIControlStateNormal];
                     
                NSDictionary *dictTopSport3 = [sortedArray objectAtIndex:9];
                NSString *topSport3Type = [dictTopSport3 objectForKey:TYPE];
                     
                [_topSport3Button setBackgroundImage:[PlayUtility greyTopSportsImagesForProfile:topSport3Type] forState:UIControlStateNormal];
                 
             }else if (countOfTopSports==2){
                 [_topSport1Button setFrame:CGRectMake(topSportSpot2)];
                 [_topSport2Button setFrame:CGRectMake(topSportSpot3)];
             
                 NSDictionary *dictTopSport1 = [sortedArray objectAtIndex:11];
                 NSString *topSport1Type = [dictTopSport1 objectForKey:TYPE];
                 
                 [_topSport1Button setBackgroundImage:[PlayUtility greyTopSportsImagesForProfile:topSport1Type] forState:UIControlStateNormal];
                 
                 NSDictionary *dictTopSport2 = [sortedArray objectAtIndex:10];
                 NSString *topSport2Type = [dictTopSport2 objectForKey:TYPE];
                 
                 [_topSport2Button setBackgroundImage:[PlayUtility greyTopSportsImagesForProfile:topSport2Type] forState:UIControlStateNormal];
             
             }else if(countOfTopSports==1){
                 [_topSport1Button setFrame:CGRectMake(topSportSpot3)];
                 
                 NSDictionary *dictTopSport1 = [sortedArray objectAtIndex:11];
                 NSString *topSport1Type = [dictTopSport1 objectForKey:TYPE];
                 
                 [_topSport1Button setBackgroundImage:[PlayUtility greyTopSportsImagesForProfile:topSport1Type] forState:UIControlStateNormal];
             }
        }
    }];
    
    if (![[self.user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        
        NSLog(@"in is currentUser != you in UserProfile");

        
        [_profilePictureImageView.profileButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeUsersAvatarPic:)]];

        // check if the currentUser is following this user
        PFQuery *queryIsFollowing = [PFQuery queryWithClassName:kPlayActivityClassKey];
        [queryIsFollowing whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
        [queryIsFollowing whereKey:kPlayActivityToUserKey equalTo:self.user];
        [queryIsFollowing whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];
        [queryIsFollowing setCachePolicy:kPFCachePolicyCacheThenNetwork];
        [queryIsFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error && [error code] != kPFErrorCacheMiss) {
                NSLog(@"Couldn't determine follow relationship: %@", error);
            } else {
                NSLog(@"Followbutton added");
                
                if (number == 0) {
                    [_followUserButton addTarget:self action:@selector(unfollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self configureFollowButton];
                } else {
                    [_followUserButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self configureUnfollowButton];
                }
            }
        }];
        
        // check if the user whose profile you are on is following the currentUser
        
        PFQuery *queryIsFollowed = [PFQuery queryWithClassName:kPlayActivityClassKey];
        [queryIsFollowed whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
        [queryIsFollowed whereKey:kPlayActivityFromUserKey equalTo:self.user];
        [queryIsFollowed whereKey:kPlayActivityToUserKey equalTo:[PFUser currentUser]];
        [queryIsFollowed setCachePolicy:kPFCachePolicyCacheThenNetwork];
        [queryIsFollowed countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error && [error code] != kPFErrorCacheMiss) {
                NSLog(@"Couldn't determine follow relationship: %@", error);
            } else {
                if (number == 0) {
                    //[self configureFollowButton];
                } else {
                    //[self configureUnfollowButton];
                }
            }
        }];
    }else {
        
        NSLog(@"in is currentUser = you in UserProfile");

        
        [_profilePictureImageView.profileButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadAddAvatarPic:)]];
        
        UIImage *transparentImageFollowButton = [UIImage imageNamed:@"nocheckmark.png"];

        [_followUserButton setFrame:CGRectMake(xofFollowButton-6.0f, yofFollowButton-7.0f, widthFollowButton, heightFollowButton)];
        [_followUserButton setTitle:@"Edit My Profile" forState:(UIControlStateNormal)];
        [_followUserButton setTitle:@"Edit My Profile" forState:(UIControlStateSelected)];
        [[_followUserButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:13.0f]];
        [_followUserButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_followUserButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateSelected];
        [_followUserButton setBackgroundImage:transparentImageFollowButton forState:UIControlStateNormal];
        [_followUserButton setBackgroundImage:transparentImageFollowButton forState:UIControlStateSelected];
        [_followUserButton addTarget:self action:@selector(openEditProfileView:) forControlEvents:UIControlEventTouchUpInside];
        
        /*UIButton *logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [logOutButton setFrame:CGRectMake(self.view.bounds.size.width-52.0f-15.0f, 176, 52.0f, 32.0f)];
        [logOutButton setTitle:@"Log Out" forState:UIControlStateNormal];
        [logOutButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [[logOutButton titleLabel] setFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]];
        //[logOutButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5.0f, 0, 0)];
        [logOutButton addTarget:self action:@selector(logOutAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:logOutButton];*/
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setTitle:(NSString*)[[self.user objectForKey:kPlayUserUsernameKey] uppercaseString]];
    
    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"User Profile Screen"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self setTitle:@" "];

}


- (void)configureFollowButton {
    
    [_followUserButton removeTarget:self action:@selector(unfollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_followUserButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_followUserButton setSelected:NO];
    
    [[PlayCache sharedCache] setFollowStatus:NO user:self.user];
}

- (void)configureUnfollowButton {

    [_followUserButton removeTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_followUserButton addTarget:self action:@selector(unfollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_followUserButton setSelected:YES];
    [[PlayCache sharedCache] setFollowStatus:YES user:self.user];
}

- (void)openEditProfileView:(id) sender{

    EditProfileTableViewController *editViewController = [[EditProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [editViewController setCurrentUser:[PFUser currentUser]];
    [self.navigationController pushViewController:editViewController animated:YES];
    
}

- (void)followButtonAction:(id)sender {
    /*UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];*/
    
    [self configureUnfollowButton];
    _userfollowingCount++;
    [_followerCountLabel setTitle:[NSString stringWithFormat:@"%d", _userfollowingCount] forState:UIControlStateNormal];
    [_followersLabel setTitle:[NSString stringWithFormat:@"FOLLOWER%@", _userfollowingCount==1?@"":@"S"] forState:UIControlStateNormal];
    
    [PlayUtility followUserEventually:self.user block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"followUserEventually succeeded");
        }else{
            [self configureFollowButton];
            _userfollowingCount--;
            [_followerCountLabel setTitle:[NSString stringWithFormat:@"%d", _userfollowingCount] forState:UIControlStateNormal];
            [_followersLabel setTitle:[NSString stringWithFormat:@"FOLLOWER%@", _userfollowingCount==1?@"":@"S"] forState:UIControlStateNormal];        }
    }];
}

- (void)unfollowButtonAction:(id)sender {
    /*UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];*/
    
    [self configureFollowButton];
    _userfollowingCount--;
    [_followerCountLabel setTitle:[NSString stringWithFormat:@"%d", _userfollowingCount] forState:UIControlStateNormal];
    [_followersLabel setTitle:[NSString stringWithFormat:@"FOLLOWER%@", _userfollowingCount==1?@"":@"S"] forState:UIControlStateNormal];
    
    [PlayUtility unfollowUserEventually:self.user block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"unfollowUserEventually succeeded");
        }else{
            [self configureUnfollowButton];
            _userfollowingCount++;
            [_followerCountLabel setTitle:[NSString stringWithFormat:@"%d", _userfollowingCount] forState:UIControlStateNormal];
            [_followersLabel setTitle:[NSString stringWithFormat:@"FOLLOWER%@", _userfollowingCount==1?@"":@"S"] forState:UIControlStateNormal];        }
    }];

}

- (void)openProfileSettings:(id)sender {    
    
    UserSettingsProfileControllerViewController *editViewController = [[UserSettingsProfileControllerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [editViewController setCurrentUser:[PFUser currentUser]];
    [self.navigationController pushViewController:editViewController animated:YES];

    
}


- (void)openFollowView:(UIButton*)sender {
    
    [self setTitle:@" "];

    if (sender.tag == followersView) {
        UserFollowViewController *followerViewController = [[UserFollowViewController alloc] initWithStyle:UITableViewStylePlain];
        [followerViewController setUser:self.user];
        [followerViewController setQueryType:@"Followers"];
        [self.navigationController pushViewController:followerViewController animated:YES];
    
    }else if (sender.tag == followingView){
        UserFollowViewController *followingViewController = [[UserFollowViewController alloc] initWithStyle:UITableViewStylePlain];
        [followingViewController setUser:self.user];
        [followingViewController setQueryType:@"Following"];
        [self.navigationController pushViewController:followingViewController animated:YES];
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [self.refreshControl endRefreshing];
    
    self.tableView.tableHeaderView = _headerView;
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


- (PFQuery *)queryForTable {
    if (!self.user) {
        PFQuery *query = [PFQuery queryWithClassName:kPlayEventClassKey];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *eventsAttendedQuery = [PFQuery queryWithClassName:kPlayActivityClassKey];
    PFQuery *eventsInvitedQuery = [PFQuery queryWithClassName:kPlayActivityClassKey];
    PFQuery *publicEventQuery = [PFQuery queryWithClassName:kPlayEventClassKey];
    PFQuery *finalQuery = [PFQuery queryWithClassName:kPlayActivityClassKey];
    
    if ([self.objects count] == 0) {
        finalQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        publicEventQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        eventsAttendedQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        eventsInvitedQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    switch (_segmentedControl.selectedSegmentIndex) {
        case kSelectedIndexisEvents:
                        
            if (![[self.user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            
                [publicEventQuery whereKey:kPLayEventIsPrivate equalTo:[NSNumber numberWithBool:FALSE]];
                publicEventQuery.cachePolicy = kPFCachePolicyNetworkOnly;
                
                [eventsAttendedQuery whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsCheckIn];
                [eventsAttendedQuery whereKey:kPlayActivityFromUserKey equalTo:self.user];
                [eventsAttendedQuery whereKey:kPlayEventUserKey doesNotMatchKey:kPlayActivityFromUserKey inQuery:publicEventQuery];
                eventsAttendedQuery.cachePolicy = kPFCachePolicyNetworkOnly;
                
                [eventsInvitedQuery whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsCheckIn];
                [eventsInvitedQuery whereKey:kPlayActivityFromUserKey equalTo:self.user];
                //[eventsInvitedQuery whereKey:@"event.invitedUsers" equalTo:[PFUser currentUser]];
                eventsInvitedQuery.cachePolicy = kPFCachePolicyNetworkOnly;                
                
                finalQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:eventsAttendedQuery,eventsInvitedQuery,nil]];
                [finalQuery includeKey:kPlayActivityEventKey];
                [finalQuery includeKey:@"event.createdUser"];
                [finalQuery orderByDescending:@"createdAt"];
                
                return finalQuery;
                
            }else{
                [eventsAttendedQuery whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsCheckIn];
                [eventsAttendedQuery whereKey:kPlayActivityFromUserKey equalTo:self.user];
                [eventsAttendedQuery includeKey:kPlayActivityEventKey];
                [eventsAttendedQuery includeKey:@"event.createdUser"];
                //[eventsAttendedQuery includeKey:@"event.createdAt"];
                eventsAttendedQuery.cachePolicy = kPFCachePolicyNetworkOnly;
                [eventsAttendedQuery orderByDescending:@"createdAt"];
                
                return eventsAttendedQuery;
            }
            
            
            break;
        case kSelectedIndexisInvitations:
            
            [eventsAttendedQuery whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsInvite];
            [eventsAttendedQuery whereKey:kPlayActivityToUserKey equalTo:self.user];
            [eventsAttendedQuery includeKey:kPlayActivityEventKey];
            [eventsAttendedQuery includeKey:@"event.createdUser"];
            eventsAttendedQuery.cachePolicy = kPFCachePolicyNetworkOnly;
            [eventsAttendedQuery orderByDescending:@"createdAt"];
            
            return eventsAttendedQuery;
            
            break;
        default:
            [eventsAttendedQuery whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsCheckIn];
            [eventsAttendedQuery whereKey:kPlayActivityFromUserKey equalTo:self.user];
            [eventsAttendedQuery includeKey:kPlayActivityEventKey];
            [eventsAttendedQuery includeKey:@"event.createdUser"];
            eventsAttendedQuery.cachePolicy = kPFCachePolicyNetworkOnly;
            [eventsAttendedQuery orderByDescending:@"createdAt"];
            
            return eventsAttendedQuery;

            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    PlayLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[PlayLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == self.objects.count) {
        // Load More section
        return nil;
    }
    
    EventFeedHeaderView *headerView = [self dequeueReusableSectionHeaderView];
    
    if (!headerView) {
        headerView = [[EventFeedHeaderView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:PlayPhotoHeaderButtonsDefault];
        headerView.delegate = self;
        [self.reusableSectionHeaderViews addObject:headerView];
    }
    
    PFObject *event = [[self.objects objectAtIndex:section] objectForKey:kPlayActivityEventKey];
    [headerView setEvent:event];
    headerView.tag = section;
    [headerView.checkInButton setTag:section];
    
    NSDictionary *attributesForPhoto = [[PlayCache sharedCache] getAttributesForEvent:event];
    
    if (attributesForPhoto) {
        [headerView setCheckInStatus:[[PlayCache sharedCache] isCurrentUserCheckedIntoEvent:event]];
        [headerView.checkInButton setTitle:[[[PlayCache sharedCache] checkInCountForEvent:event] description] forState:UIControlStateNormal];
        [headerView.commentButton setTitle:[[[PlayCache sharedCache] commentCountForEvent:event] description] forState:UIControlStateNormal];
        
        if (headerView.checkInButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
            [UIView animateWithDuration:0.200f animations:^{
                headerView.checkInButton.alpha = 1.0f;
                headerView.commentButton.alpha = 1.0f;
            }];
        }
    } else {
        headerView.checkInButton.alpha = 0.0f;
        headerView.commentButton.alpha = 0.0f;
        
        @synchronized(self) {
            // check if we can update the cache
            NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:[NSNumber numberWithInt:section]];
            if (!outstandingSectionHeaderQueryStatus) {
                
                PFQuery *query = [PlayUtility queryForActivitiesOnEvent:event cachePolicy:kPFCachePolicyNetworkOnly];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    @synchronized(self) {
                        [self.outstandingSectionHeaderQueries removeObjectForKey:[NSNumber numberWithInt:section]];
                        
                        if (error) {
                            return;
                        }
                        
                        NSMutableArray *checkedInUsers = [NSMutableArray array];
                        NSMutableArray *locationCheckedInUsers = [NSMutableArray array];
                        NSMutableArray *commenters = [NSMutableArray array];
                        
                        BOOL currentUserCheckedIn = NO;
                        BOOL currentUserLocationCheckedIn = NO;
                        
                        for (PFObject *activity in objects) {
                            if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsCheckIn] && [activity objectForKey:kPlayActivityFromUserKey]) {
                                [checkedInUsers addObject:[activity objectForKey:kPlayActivityFromUserKey]];
                            } else if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsComment] && [activity objectForKey:kPlayActivityFromUserKey]) {
                                [commenters addObject:[activity objectForKey:kPlayActivityFromUserKey]];
                            }else if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsLocationCheckIn] && [activity objectForKey:kPlayActivityFromUserKey]) {
                                [locationCheckedInUsers addObject:[activity objectForKey:kPlayActivityFromUserKey]];
                            }
                            
                            if ([[[activity objectForKey:kPlayActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsCheckIn]) {
                                    currentUserCheckedIn = YES;
                                }
                                if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsLocationCheckIn]) {
                                    currentUserLocationCheckedIn = YES;
                                }
                            }
                        }
                        
                        NSArray *checkedInUsersFinal = [checkedInUsers copy];
                        NSArray *locationCheckedInUsersFinal = [locationCheckedInUsers copy];
                        
                        NSDictionary *checkedInUsersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:checkedInUsersFinal,kPlayEventAttributesCheckedInUsersUserArrayKey,locationCheckedInUsersFinal,kPlayEventAttributesLocationCheckedInUsersArrayKey, nil];
                        
                        [[PlayCache sharedCache] setAttributesForEvent:event checkedInUsers:checkedInUsersDictionary commenters:commenters currentUserCheckedIn:currentUserCheckedIn locationCheckedIn:currentUserLocationCheckedIn];
                        
                        if (headerView.tag != section) {
                            return;
                        }
                        
                        [headerView setCheckInStatus:[[PlayCache sharedCache] isCurrentUserCheckedIntoEvent:event]];
                        [headerView.checkInButton setTitle:[[[PlayCache sharedCache] checkInCountForEvent:event] description] forState:UIControlStateNormal];
                        [headerView.commentButton setTitle:[[[PlayCache sharedCache] commentCountForEvent:event] description] forState:UIControlStateNormal];
                        
                        if (headerView.checkInButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
                            [UIView animateWithDuration:0.200f animations:^{
                                headerView.checkInButton.alpha = 1.0f;
                                headerView.commentButton.alpha = 1.0f;
                            }];
                        }
                    }
                }];
            }
        }
    }
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.section == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
    } else {
        
        EventFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[EventFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.photoButton addTarget:self action:@selector(didTapOnEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.photoButton.tag = indexPath.section;
        cell.imageView.image = [UIImage imageNamed:@"infocardeventimage.png"];
        
        if (object) {
            cell.imageView.file = [object objectForKey:kPlayEventPictureKey];
            
            // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
            if ([cell.imageView.file isDataAvailable]) {
                [cell.imageView loadInBackground];
            }
            
            if ([PlayUtility returnShouldImageBeGray:[object objectForKey:kPlayEventTimeKey]]) {
                [cell.iconTypeButton setBackgroundImage:[PlayUtility greyFeedImageForEventType:[object objectForKey:kPlayEventIconTypeKey]] forState:UIControlStateNormal];
                [cell.iconLocationButton setBackgroundImage:[UIImage imageNamed:@"infocardlocation.png"] forState:UIControlStateNormal];
                [cell.iconTimeButton setBackgroundImage:[UIImage imageNamed:@"infocardtime.png"] forState:UIControlStateNormal];
            }else{
                [cell.iconTypeButton setBackgroundImage:[PlayUtility imageFeedIconForEventType:[object objectForKey:kPlayEventIconTypeKey]] forState:UIControlStateNormal];
                [cell.iconLocationButton setBackgroundImage:[UIImage imageNamed:@"infocardlocationgreen.png"] forState:UIControlStateNormal];
                [cell.iconTimeButton setBackgroundImage:[UIImage imageNamed:@"infocardtimegreen.png"] forState:UIControlStateNormal];
            }
            
            cell.iconTypeLabel.text = [object objectForKey:kPlayEventTypeKey];
            
            NSString *displayTime = [_dateFormatterForTime stringFromDate:[object objectForKey:kPlayEventTimeKey]];
            NSString *timeTillNow = [PlayUtility returnTimeUntilEvent:[object objectForKey:kPlayEventTimeKey] displayTime:displayTime];
            
            NSString *displayedTimeTillNow = [timeTillNow isEqualToString:@""]?@"In Progress":timeTillNow;
            
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",displayedTimeTillNow];
            cell.locationLabel.text = [[object objectForKey:kPlayEventLocationKey] objectAtIndex:1];
            
        }
        return cell;
    }
    
}

-(void)eventFeedHeaderView:(EventFeedHeaderView *)eventFeedHeaderView didTapUserButton:(UIButton *)button user:(PFUser *)user{
    
    if (![[self.user objectId] isEqualToString:[user objectId]]) {
        
        [self setTitle:@" "];
        UserProfileTableViewController *accountViewController = [[UserProfileTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [accountViewController setUser:user];
        [self.navigationController pushViewController:accountViewController animated:YES];
    }
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    // overridden, since we want to implement sections
    if (indexPath.section < self.objects.count) {
        return [[self.objects objectAtIndex:indexPath.section] objectForKey:kPlayActivityEventKey];
    }
    
    return nil;
}

- (NSIndexPath *)indexPathForObject:(PFObject *)targetObject {
    for (int i = 0; i < self.objects.count; i++) {
        PFObject *object = [[self.objects objectAtIndex:i] objectForKey:kPlayActivityEventKey];
        if ([[object objectId] isEqualToString:[targetObject objectId]]) {
            return [NSIndexPath indexPathForRow:0 inSection:i];
        }
    }
    
    return nil;
}

- (void)didTapOnEvent:(UIButton *)sender {
    PFObject *event = [[self.objects objectAtIndex:sender.tag]objectForKey:kPlayActivityEventKey];
    if (event) {
        
        [self setTitle:@" "];
        DetailedEventViewController *photoDetailsVC = [[DetailedEventViewController alloc] initWithObject:event];
        [self.navigationController pushViewController:photoDetailsVC animated:YES];
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.objects.count) {
        return 0.0f;
    }
    return kPlayEventFeedHeaderHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 16.0f)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.objects.count) {
        return 0.0f;
    }
    return 16.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.objects.count) {
        // Load More Section
        return kPlayEventFeedHeaderHeight;
    }
    return 122.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == self.objects.count && self.paginationEnabled) {
        // Load More Cell
        [self loadNextPage];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = self.objects.count;
    if (self.paginationEnabled && sections != 0)
        sections++;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDelegate


#pragma mark - EventFeedHeaderDelegate

- (EventFeedHeaderView *)dequeueReusableSectionHeaderView {
    for (EventFeedHeaderView *sectionHeaderView in self.reusableSectionHeaderViews) {
        if (!sectionHeaderView.superview) {
            // we found a section header that is no longer visible
            return sectionHeaderView;
        }
    }
    return nil;
}

-(void)eventFeedHeaderView:(EventFeedHeaderView *)eventFeedHeaderView didTapCheckIntoEventButton:(UIButton *)button event:(PFObject *)event{
    
    [eventFeedHeaderView shouldEnableCheckInButton:NO];
    
    // CheckIn Button wasnt selected, therefore you werent checkedIn but want to check in
    BOOL checkedIn = !button.selected;
    [eventFeedHeaderView setCheckInStatus:checkedIn];
    
    NSString *originalButtonTitle = button.titleLabel.text;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSNumber *checkedInCount = [numberFormatter numberFromString:button.titleLabel.text];
    if (checkedIn) {
        checkedInCount = [NSNumber numberWithInt:[checkedInCount intValue] + 1];
        OLGhostAlertView *alert = [[OLGhostAlertView alloc] initWithTitle:@"Joined" message:nil timeout:1 dismissible:NO];
        [alert show];
        [[PlayCache sharedCache] incrementCheckinCountForEvent:event];
    } else {
        if ([checkedInCount intValue] > 0) {
            checkedInCount = [NSNumber numberWithInt:[checkedInCount intValue] - 1];
        }
        OLGhostAlertView *alert = [[OLGhostAlertView alloc] initWithTitle:@"Left Event" message:nil timeout:1 dismissible:NO];
        [alert show];
        [[PlayCache sharedCache] decrementCheckinCountForEvent:event];
    }
    
    BOOL locationCheckedIn = NO;
    
    locationCheckedIn = [PlayUtility islocationCheckInTrue:event currentLocation:_currentLocation];
    
    [[PlayCache sharedCache] setCurrentUserIsCheckedIntoEvent:event checkedIn:checkedIn locationCheckedIn:locationCheckedIn];
    
    [button setTitle:[numberFormatter stringFromNumber:checkedInCount] forState:UIControlStateNormal];
    
    if (checkedIn) {
        [PlayUtility checkIntoEventInBackground:event locationCheckIn:locationCheckedIn block:^(BOOL succeeded, NSError *error) {
            
            EventFeedHeaderView *actualHeaderView = (EventFeedHeaderView *)[self tableView:self.tableView viewForHeaderInSection:button.tag];
            [actualHeaderView shouldEnableCheckInButton:YES];
            [actualHeaderView setCheckInStatus:succeeded];
            
            if (!succeeded) {
                [actualHeaderView.checkInButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
        }];
    } else {
        [PlayUtility uncheckIntoEventInBackground:event block:^(BOOL succeeded, NSError *error) {
            EventFeedHeaderView *actualHeaderView = (EventFeedHeaderView *)[self tableView:self.tableView viewForHeaderInSection:button.tag];
            [actualHeaderView shouldEnableCheckInButton:YES];
            [actualHeaderView setCheckInStatus:!succeeded];
            
            if (!succeeded) {
                [actualHeaderView.checkInButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
        }];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = kPlayEventFeedHeaderHeight;
    // NSLog(@"in scrollViewDidScroll contentOffset.y = %f",scrollView.contentOffset.y);
    if(_shouldScrollToTopView){
        
    }else if (_shouldSegmentChangeScrollToTopView){
        if (scrollView.contentOffset.y == 0) {
            _shouldSegmentChangeScrollToTopView = NO;
        }
    }
    else if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"in scrollViewShouldScrollToTop");
    _shouldScrollToTopView = YES;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"in scrollViewDidScrollToTop");
    _shouldScrollToTopView = NO;
}


-(void)eventFeedHeaderView:(EventFeedHeaderView *)eventFeedHeaderView didTapCommentOnEventButton:(UIButton *)button event:(PFObject *)event{
    
    [self setTitle:@" "];
    DetailedEventViewController *photoDetailsVC = [[DetailedEventViewController alloc] initWithObject:event];
    [self.navigationController pushViewController:photoDetailsVC animated:YES];
    
}

- (void)updateProfileBio:(NSNotification *)note {
    
    NSString *bioString = [self.user objectForKey:kPlayUserPlayBioKey];
    
    NSArray *ageArray = [self.user objectForKey:kPlayUserPlayAgeKey];
    NSString *ageString = [ageArray objectAtIndex:0];
    
    NSArray *genderArray = [self.user objectForKey:kPlayUserPlayGenderKey];
    NSString *genderString = [genderArray objectAtIndex:0];
    
    int spacer = 0;
    if (bioString.length<80) {
        spacer=15;
    }
    
    [_bioTitleButton setFrame:CGRectMake(xofSubtTitle, yofBio, widthFollowButton, 60.0f-spacer)];
    [_bioTitleButton setTitle:bioString forState:UIControlStateNormal];
    
    [_genderTitleButton setFrame:CGRectMake(xofSubtTitle, yofGender-spacer, widthFollowButton, 30.0f)];
    [_genderTitleButton setTitle:genderString forState:UIControlStateNormal];
    
    [_ageTitleButton setFrame:CGRectMake(xofSubtTitle, yofAge-spacer, widthFollowButton, 30.0f)];
    [_ageTitleButton setTitle:ageString forState:UIControlStateNormal];
    
    [_bioBigTitleButton setFrame:CGRectMake(xofTitle, yofBio, squareAvatar, 60.0f-spacer)];
    [_genderBigTitleButton setFrame:CGRectMake(xofTitle, yofGender-spacer, squareAvatar, 30.0f)];
    [_ageBigTitleButton setFrame:CGRectMake(xofTitle, yofAge-spacer, squareAvatar, 30.0f)];
    
    if(bioString || ageString || genderString){
        _bioBigTitleButton.hidden = NO;
        _genderBigTitleButton.hidden = NO;
        _ageBigTitleButton.hidden = NO;
    }

}

- (void)updateFollowingCount:(NSNotification *)note {
    
    
    if ([[self.user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
    
        [_followingCountLabel setTitle:[NSString stringWithFormat:@"-"] forState:UIControlStateNormal];

        PFQuery *queryFollowingCount = [PFQuery queryWithClassName:kPlayActivityClassKey];
        [queryFollowingCount whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
        [queryFollowingCount whereKey:kPlayActivityFromUserKey equalTo:self.user];
    //    [queryFollowingCount setCachePolicy:kPFCachePolicyNetworkOnly];
        [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (!error) {
                [_followingCountLabel setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
                NSLog(@"in updateFollowingCount");
            }
        }];
    }
}


- (void)userDidCheckInOrUncheckIntoEvent:(NSNotification *)note {
    
    //[self.tableView reloadData];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidPublishEvent:(NSNotification *)note {
    if (self.objects.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [self loadObjects];
    
}

- (void)userDidDeleteEvent:(NSNotification *)note {
    [self performSelector:@selector(loadObjects) withObject:nil afterDelay:1.0f];
}

- (void)userDidCommentOnEvent:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void) segmentChanged:(id)sender{
    
    if (self.objects.count > 0) {
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }
    
    [self loadObjects];
}


#pragma mark - UIButtons

- (void)doneButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Touch events - Avatar Picker

- (void) loadAddAvatarPic:(id) sender {
    
    NSLog(@"inside loadAddAvatarPic");
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // If User can use Camera or Choose from Photo Library
        UIActionSheet *avatarAlertSheet = [[UIActionSheet alloc]
                                           initWithTitle:@"Choose an Avatar" delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:@"Take A Photo", @"Choose An Existing Photo", nil];
        avatarAlertSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [avatarAlertSheet showInView:self.view];
        return ;
    }else if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // If User can only Choose from Photo Library
        [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // If User can only use Camera
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        NSArray *cameraTypeArray = [UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceFront];
        
        for (NSNumber *cameraNumber in cameraTypeArray){
            if (cameraNumber == [NSNumber numberWithInt:UIImagePickerControllerCameraDeviceFront]) {
                [_picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            }
        }
    }
    
    [_picker setAllowsEditing:YES];
    [self presentViewController:_picker animated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        //User to Take a Photo
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        NSArray *cameraTypeArray = [UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceFront];
        
        for (NSNumber *cameraNumber in cameraTypeArray){
            if (cameraNumber == [NSNumber numberWithInt:UIImagePickerControllerCameraDeviceFront]) {
                [_picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            }
        }
    }
    
    else if (buttonIndex == 1){
        //User to Choose an Exisiting Photo
        [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else {
        //hit cancel
        return;
    }
    
    [_picker setAllowsEditing:YES];
    [self presentViewController:_picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    _profilePictureImageView.profileImageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadImage:_profilePictureImageView.profileImageView.image];
    NSLog(@"upload new pic");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) uploadImage:(UIImage *)anImage{
    
    // Resize the image to be square (what is shown in the preview)
    UIImage *resizedImage = [anImage thumbnailImage:kPlayAvatarLargeSize
                                  transparentBorder:0.0f
                                       cornerRadius:0.0f
                               interpolationQuality:kCGInterpolationHigh];
    // Create a thumbnail and add a corner radius for use in table views
    UIImage *thumbnailImage = [anImage thumbnailImage:kPlayAvatarSmallSize
                                    transparentBorder:0.0f
                                         cornerRadius:10.0f
                                 interpolationQuality:kCGInterpolationDefault];
    
    //set display image
    _profilePictureImageView.profileImageView.image = resizedImage;
    
    // Get an NSData representation of our images. We use JPEG for the larger image
    // for better compression and PNG for the thumbnail to keep the corner radius transparency
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 1.0f);
    NSData *thumbnailImageData = UIImageJPEGRepresentation(thumbnailImage, 0.8f);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    _userMediumAvatar = [PFFile fileWithData:imageData];
    _userSmallAvatar = [PFFile fileWithData:thumbnailImageData];
    
    [_user setObject:_userMediumAvatar forKey:kPlayUserProfilePictureMediumKey];
    [_user setObject:_userSmallAvatar forKey:kPlayUserProfilePictureSmallKey];
    
    [_user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserChangedProfilePicNotification object:nil];

    }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    

    
    return YES;
}

- (void) seeUsersAvatarPic:(id) sender {

    SeeUserAvatarViewController *seeUserController = [[SeeUserAvatarViewController alloc] init];
    [seeUserController setFile:[_user objectForKey:kPlayUserProfilePictureMediumKey]];
    
    [seeUserController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:seeUserController animated:YES completion:nil];
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    // The user just pulled down the table view. Start loading data.
    [self loadObjects];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
        
        UINavigationBar *bar = navigationController.navigationBar;
        UINavigationItem *top = bar.topItem;
        
        //[top setHidesBackButton:YES];
        
        UIImage* image = [UIImage imageNamed:@"backarrow.png"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
        [someButton setBackgroundImage:image forState:UIControlStateNormal];
        [someButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        
        [top setTitle:@" "];
        [top setLeftBarButtonItem:leftBarButton];
        [top setRightBarButtonItem:nil];
        
    }
}

- (void) backButton:(id) sender {
    //This is when you exit the image picker
    //[PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end