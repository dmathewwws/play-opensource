//
//  CheckInViewController.m
//  Eventfully
//
//  Created by Daniel Mathews on 2012-11-07.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "CheckInViewController.h"
#import "AppDelegate.h"
#import "BlockAlertView.h"
#import "PlayProfileImageView.h"
#import "GAI.h"
//#import "UINavigationController+Additions.h"

@interface CheckInViewController ()

@end

@implementation CheckInViewController

#define xIndent 11.0f
#define yIndent 8.0f
#define ySpacerEventImageAndCaption 3.0f
#define ySpacerCaptionAndTime 3.0f
#define ySpacerTimeAndMapView 3.0f
#define heightofEventImage 150.0f
#define heightofSportImage 100.0f
#define widthofSportImage 100.0f
#define heightofEventCaption 75.0f
#define heightofStartTime 30.0f
#define heightofMapView 60.0f
#define heightofSportIcon 80.0f
#define inviteFriendsyIndent 360.0f

#define zoomedInMiniMap 600

#define transitionDuration 0.3
#define transitionType kCATransitionFade

#define charLimitEventCaption 160

@synthesize addEventImage = _addEventImage;
@synthesize addSportImage = _addSportImage;
@synthesize picker =_picker;
@synthesize photoFile = _photoFile;
@synthesize eventCaption = _eventCaption;
@synthesize timeTextView = _timeTextView;
@synthesize locationTextView = _locationTextView;
@synthesize locationName = _locationName;
@synthesize actionSheetDatePicker = _actionSheetDatePicker;
@synthesize dateFormatterForTime = _dateFormatterForTime;
@synthesize eventIconType = _eventIconType;
@synthesize fileUploadBackgroundTaskId = _fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId = _photoPostBackgroundTaskId;
@synthesize currentLocation = _currentLocation;
@synthesize userCurrentLocation = _userCurrentLocation;
@synthesize locationInfo = _locationInfo;
@synthesize createEventButton = _createEventButton;
@synthesize sportsCollectionController = _sportsCollectionController;
@synthesize instaCollectionController = _instaCollectionController;
@synthesize locationPickerController = _locationPickerController;
@synthesize searchTerm = _searchTerm;
@synthesize timeofEvent = _timeofEvent;
@synthesize endtimeofEvent = _endtimeofEvent;
@synthesize mapView = _mapView;
@synthesize eventType = _eventType;
@synthesize facebookPost = _facebookPost;
@synthesize shouldPostToFacebook = _shouldPostToFacebook;
@synthesize twitterPost = _twitterPost;
@synthesize shouldPostTwitter = _shouldPostTwitter;
@synthesize emailPost = _emailPost;
@synthesize utcOffset;
@synthesize displayStartTimeofEvent = _displayStartTimeofEvent;
@synthesize inviteFriends = _inviteFriends;
@synthesize invitedUsersSet = _invitedUsersSet;
@synthesize pushUsersSet = _pushUsersSet;
@synthesize profilePictureImageView = _profilePictureImageView;
@synthesize chooseAPhoto = _chooseAPhoto;
@synthesize timeTillEvent = _timeTillEvent;
@synthesize bioStringCount = _bioStringCount;
@synthesize segmentedControl = _segmentedControl;
@synthesize segmentControlNumber = _segmentControlNumber;

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
    [super viewDidLoad];
    
    _segmentControlNumber = 0;
    
    //UIsegmentController
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@" ",@" ",nil]];
    [_segmentedControl setFrame:CGRectMake(230,20,80,28)];
    _segmentedControl.selectedSegmentIndex=_segmentControlNumber;
    [_segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_segmentedControl setImage:[UIImage imageNamed:@"nocheckmark.png"] forSegmentAtIndex:0];
    [_segmentedControl setImage:[UIImage imageNamed:@"invitationicon.png"] forSegmentAtIndex:1];
    [_segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem * segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView: _segmentedControl];
    
    self.navigationItem.rightBarButtonItem = segmentBarItem;
    
    if ([self isKindOfClass:[CheckInViewController class]]) {
        
        NSLog(@"in CheckInView Controller");

        float iphone5spacer = 0;
        if (self.view.bounds.size.height == 460) {
            iphone5spacer = 0;
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"create2bgi4.png"]]];
        }else{
            iphone5spacer = 22;
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"create2bgi5.png"]]];
        }
        
        UIImage *eventImage = [UIImage imageNamed:@"photobox.png"];
        _addEventImage = [[UIImageView alloc] initWithImage:eventImage];
        
        if (iphone5spacer>0) {
            [_addEventImage setFrame:CGRectMake((self.view.frame.size.width/2)-(eventImage.size.width/2), yIndent+20, eventImage.size.width, eventImage.size.height)];
        }else{
            [_addEventImage setFrame:CGRectMake((self.view.frame.size.width/2)-(eventImage.size.width/2), yIndent+5, eventImage.size.width, eventImage.size.height)];
        }
        _addEventImage.userInteractionEnabled = NO;
        [_addEventImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:_addEventImage];
        
        _chooseAPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseAPhoto.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_chooseAPhoto.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_chooseAPhoto setTitle:@"CHOOSE\nA\nPHOTO" forState:UIControlStateNormal];
        [_chooseAPhoto setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:178.0f/255.0f blue:137.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        _chooseAPhoto.titleLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
        [_chooseAPhoto setFrame:_addEventImage.frame];
        [_chooseAPhoto addTarget:self action:@selector(loadAddEventPic:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_chooseAPhoto];
        
        _addSportImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sport11.png"]];
        UIImage *logoImage = [UIImage imageNamed:@"logobox.png"];
        [_addSportImage setFrame:CGRectMake(xIndent, yIndent+5, logoImage.size.width, logoImage.size.height)];
        _addSportImage.userInteractionEnabled = YES;
        [_addSportImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadSportsPicker:)]];
        [self.view addSubview:_addSportImage];
        
        //UIView *chooseAPhotobkg = [[UIView alloc] initWithFrame:_addSportImage.frame];
        //[self.view addSubview:chooseAPhotobkg];
        
        UIImage *eventCaptionImage = [UIImage imageNamed:@"planbox.png"];
        UIImage *eventCaptionImagei5 = [UIImage imageNamed:@"planboxi5.png"];
        _eventCaption = [[UITextView alloc] init];
        _eventCaption.delegate = self;
        _eventCaption.text = kPlayCheckInPlaceholderText;
        _eventCaption.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
        _eventCaption.scrollEnabled=NO;
        
        if (iphone5spacer>0) {
            [_eventCaption setFrame:CGRectMake(xIndent, 265+(3*iphone5spacer), eventCaptionImagei5.size.width, eventCaptionImagei5.size.height)];
            _eventCaption.backgroundColor = [UIColor colorWithPatternImage:eventCaptionImagei5];
        }else{
            [_eventCaption setFrame:CGRectMake(xIndent, 265+(3*iphone5spacer), eventCaptionImage.size.width, eventCaptionImage.size.height)];
            _eventCaption.backgroundColor = [UIColor colorWithPatternImage:eventCaptionImage];
            
        }
        
        [_eventCaption setReturnKeyType:UIReturnKeyDone];
        [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)]];
        
        UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(_eventCaption.frame.origin.x, _eventCaption.frame.origin.y - 19, eventCaptionImage.size.width, 20)];
        planLabel.text = @"ENTER DESCRIPTION";
        planLabel.font = [UIFont fontWithName:kPlayFontName size:13.0f];
        planLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
        planLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:planLabel];
        [self.view addSubview:_eventCaption];
        
        UIImage *startTimeImage = [UIImage imageNamed:@"timebox.png"];
        UIImage *startTimeImagei5 = [UIImage imageNamed:@"timeboxi5.png"];
        _timeTextView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeTextView setTitle:[NSString stringWithFormat:@"NOW"] forState:UIControlStateNormal];
        [_timeTextView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_timeTextView setContentHorizontalAlignment:UIControlContentVerticalAlignmentCenter];
        if (iphone5spacer>0) {
            [_timeTextView setFrame:CGRectMake(xIndent,210+(iphone5spacer*2),startTimeImagei5.size.width,startTimeImagei5.size.height)];
            [_timeTextView setBackgroundImage:startTimeImagei5 forState:UIControlStateNormal];
        }else{
            [_timeTextView setFrame:CGRectMake(xIndent,210+(iphone5spacer*2),startTimeImage.size.width,startTimeImage.size.height)];
            [_timeTextView setBackgroundImage:startTimeImage forState:UIControlStateNormal];
            
        }
        
        [_timeTextView setBackgroundImage:startTimeImage forState:UIControlStateNormal];
        _timeTextView.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
        [_timeTextView setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        [_timeTextView addTarget:self action:@selector(selectADate:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeTextView.frame.origin.x, _timeTextView.frame.origin.y - 19, startTimeImage.size.width, 20)];
        timeLabel.text = @"CHOOSE TIME";
        timeLabel.font = [UIFont fontWithName:kPlayFontName size:13.0f];
        timeLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:timeLabel];
        [self.view addSubview:_timeTextView];
        
        //CreateEventButton
        UIImage *createEventImage = [UIImage imageNamed:@"playbutton1.png"];
        _createEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createEventButton setTitle:@"CREATE" forState:UIControlStateNormal];
        [_createEventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _createEventButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:18.0f];
        _createEventButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        [_createEventButton setFrame:CGRectMake(222,347+(iphone5spacer*4),createEventImage.size.width,createEventImage.size.height)];
        [_createEventButton addTarget:self action:@selector(createEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_createEventButton setBackgroundImage:createEventImage forState:UIControlStateNormal];
        [self.view addSubview:_createEventButton];
        
        _dateFormatterForTime = [[NSDateFormatter alloc] init];
        _dateFormatterForTime.locale = [NSLocale currentLocale];
        [_dateFormatterForTime setTimeStyle: NSDateFormatterShortStyle];
        [_dateFormatterForTime setDateStyle: NSDateFormatterMediumStyle];
        
        _fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        _photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
        
        _eventIconType= [[NSNumber alloc] init];
        _locationName = [[NSString alloc] init];
        _timeTillEvent = [[NSString alloc] init];
        _eventType = [[NSString alloc] init];
        
        UIImage *locationImage = [UIImage imageNamed:@"locationbox.png"];
        UIImage *locationImagei5 = [UIImage imageNamed:@"locationboxi5.png"];
        _locationTextView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationTextView setTitle:@"" forState:UIControlStateNormal];
        [_locationTextView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_locationTextView.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_locationTextView setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        //[_locationTextView setTitleEdgeInsets:UIEdgeInsetsMake(0,(locationImage.size.width/2)+3, 3, 0)];
        //[_locationTextView setBackgroundColor:[UIColor clearColor]];
        _locationTextView.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
        if (iphone5spacer>0) {
            [_locationTextView setFrame:CGRectMake(xIndent, 140 + (iphone5spacer) , locationImagei5.size.width, locationImagei5.size.height)];
            [_locationTextView setBackgroundImage:locationImagei5 forState:UIControlStateNormal];
        }else{
            [_locationTextView setFrame:CGRectMake(xIndent, 140 + (iphone5spacer) , locationImage.size.width, locationImage.size.height)];
            [_locationTextView setBackgroundImage:locationImage forState:UIControlStateNormal];
        }
        
        [_locationTextView addTarget:self action:@selector(openLocationPicker:) forControlEvents:UIControlEventTouchUpInside];
        
        _mapView = [[MKMapView alloc] init];
        [_mapView setFrame:_locationTextView.frame];
        _mapView.userInteractionEnabled = NO;
        
        UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationTextView.frame.origin.x, _locationTextView.frame.origin.y - 19, locationImage.size.width, 20)];
        locationLabel.text = @"CHOOSE LOCATION";
        locationLabel.font = [UIFont fontWithName:kPlayFontName size:13.0f];
        locationLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
        locationLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:locationLabel];
        
        [self.view addSubview:_mapView];
        [self.view addSubview:_locationTextView];
        
        _mapView.delegate = self;
        
        //remove Legal from Map
        UIView *legalView = nil;
        for (UIView *subview in self.mapView.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                legalView = subview;
                break;
            }
        }
        if (legalView) {
            [legalView removeFromSuperview];
        }
        
        _shouldPostToFacebook = NO;
        _shouldPostTwitter = NO;
        
        UIButton *inviteFriendsText = [UIButton buttonWithType:UIButtonTypeCustom];
        [inviteFriendsText setTitle:[NSString stringWithFormat:@"INVITE FRIENDS"] forState:UIControlStateNormal];
        [inviteFriendsText setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:178.0f/255.0f blue:137.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        inviteFriendsText.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
        [inviteFriendsText setFrame:CGRectMake(xIndent,343+(iphone5spacer*4),195,10)];;
        [self.view addSubview:inviteFriendsText];
        
        //Invite Friends Button
        UIImage *followsharebutton = [UIImage imageNamed:@"follower0.png"];
        _inviteFriends = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteFriends setBackgroundImage:followsharebutton forState:UIControlStateNormal];
        [_inviteFriends setBackgroundImage:[UIImage imageNamed:@"follower1.png"] forState:UIControlStateSelected];
        [_inviteFriends setFrame:CGRectMake(111,inviteFriendsyIndent+(iphone5spacer*4),followsharebutton.size.width,followsharebutton.size.height)];
        [_inviteFriends addTarget:self action:@selector(pressedInviteFriends:) forControlEvents:UIControlEventTouchUpInside];
        [_inviteFriends setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:178.0f/255.0f blue:137.0f/255.0f alpha:1.0f] forState:UIControlStateSelected];
        _inviteFriends.titleLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
        _inviteFriends.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 10, 0);
        
        [self.view addSubview:_inviteFriends];
        
        //Post to Facebook Button
        UIImage *facebookSharebutton = [UIImage imageNamed:@"facebook0.png"];
        _facebookPost = [UIButton buttonWithType:UIButtonTypeCustom];
        [_facebookPost setBackgroundImage:[UIImage imageNamed:@"facebook0.png"] forState:UIControlStateNormal];
        [_facebookPost setBackgroundImage:[UIImage imageNamed:@"facebook1.png"] forState:UIControlStateSelected];
        [_facebookPost setFrame:CGRectMake(61,inviteFriendsyIndent+(iphone5spacer*4),facebookSharebutton.size.width,facebookSharebutton.size.height)];
        [_facebookPost addTarget:self action:@selector(pressedPostToFacebookButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_facebookPost];
        
        //Post to Twitter Button
        UIImage *twitterSharebutton = [UIImage imageNamed:@"twitter0.png"];
        _twitterPost = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twitterPost setBackgroundImage:[UIImage imageNamed:@"twitter0.png"] forState:UIControlStateNormal];
        [_twitterPost setBackgroundImage:[UIImage imageNamed:@"twitter1.png"] forState:UIControlStateSelected];
        [_twitterPost setFrame:CGRectMake(xIndent,inviteFriendsyIndent+(iphone5spacer*4),twitterSharebutton.size.width,twitterSharebutton.size.height)];
        [_twitterPost addTarget:self action:@selector(pressedPostToTwitterButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_twitterPost];
        
        //Post to Email Button
        UIImage *emailSharebutton = [UIImage imageNamed:@"email0.png"];
        _emailPost = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emailPost setBackgroundImage:[UIImage imageNamed:@"email0.png"] forState:UIControlStateNormal];
        [_emailPost setBackgroundImage:[UIImage imageNamed:@"email1.png"] forState:UIControlStateSelected];
        [_emailPost setFrame:CGRectMake(161,inviteFriendsyIndent+(iphone5spacer*4),emailSharebutton.size.width,emailSharebutton.size.height)];
        [_emailPost addTarget:self action:@selector(pressedPostToEmailButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_emailPost];
        
        _bioStringCount = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bioStringCount setFrame:CGRectMake(self.view.frame.size.width - 45.0f - 5.0f, self.view.frame.size.height - 145.0f, 45.0f, 25.0f)];
        [_bioStringCount setBackgroundColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f]];
        [_bioStringCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bioStringCount setUserInteractionEnabled:NO];
        //[_bioStringCount setTitle:@"Hi" forState:UIControlStateNormal];
        [[_bioStringCount titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:12.0f]];
        _bioStringCount.hidden = YES;
        [self.view addSubview:_bioStringCount];

        
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        [appDelegate startLocationManager];
        
        _currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
        
        _userCurrentLocation = _currentLocation;
        
        _locationInfo = [[NSMutableArray alloc] initWithObjects:@" ",@" ",[NSNumber numberWithInt:0],@" ",@" ",@" ",@" ",@" ",@" ", nil];
        
        [self initiateMap:_currentLocation];
        [self showTime];
        
    }
    

        
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self setTitle:@"CREATE EVENT"];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Create Event Screen"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSIndexPath *test = [self.navigationController valueForKey:@"sportPicked"];
    NSLog(@"%d",test.row);
}*/

- (void)setBackground:(UIImage*)bkgdImage{
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:bkgdImage];
    [self.view setBackgroundColor:[background colorWithAlphaComponent:0.2]];

}

#pragma mark -
#pragma mark Touch events - Load Event Pic, Dismiss Keyboard

- (void) loadAddEventPic:(id) sender {
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // If User can use Camera or Choose from Photo Library
        UIActionSheet *eventAlertSheet1 = [[UIActionSheet alloc]
                                           initWithTitle:@"Choose a picture" delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:@"Take A Photo", @"Choose An Existing Photo", @"Search Instagram", nil];
        eventAlertSheet1.actionSheetStyle = UIActionSheetStyleDefault;
        [eventAlertSheet1 showInView:self.view];
        eventAlertSheet1.tag = 1;

    }else if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // If User can only Choose from Photo Library        
        UIActionSheet *eventAlertSheet2 = [[UIActionSheet alloc]
                                           initWithTitle:@"Choose an Event Picture" delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:@"Choose An Existing Photo", @"Search Instagram", nil];
        eventAlertSheet2.actionSheetStyle = UIActionSheetStyleDefault;
        [eventAlertSheet2 showInView:self.view];
        eventAlertSheet2.tag = 2;
        
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // If User can only use Camera
        UIActionSheet *eventAlertSheet3 = [[UIActionSheet alloc]
                                           initWithTitle:@"Choose an Event Picture" delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:@"Take A Photo", @"Search Instagram", nil];
        eventAlertSheet3.actionSheetStyle = UIActionSheetStyleDefault;
        [eventAlertSheet3 showInView:self.view];
        eventAlertSheet3.tag = 3;
    }
    return;
}

- (void) loadSportsPicker:(id) sender {
    _sportsCollectionController = [self.storyboard instantiateViewControllerWithIdentifier:@"SportsCollectionViewController"];
    [_sportsCollectionController setHasSportPicked:YES];
    _sportsCollectionController.delegate = self;
    
   // UINavigationBar    
    CATransition* transition = [CATransition animation];
    transition.duration = transitionDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = transitionType; 
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] pushViewController:_sportsCollectionController animated:NO];
}

- (void) dismissKeyboard:(id) sender {
    [_eventCaption resignFirstResponder];
}

#pragma mark -
#pragma mark init Time and Location and check for Hastags

-(void) showTime{
    
    _timeofEvent = [NSDate date];
    _endtimeofEvent = [[NSDate date] dateByAddingTimeInterval:(60*60*3)];
    utcOffset = [[NSTimeZone localTimeZone] secondsFromGMT];
    _displayStartTimeofEvent = [[NSDate date] dateByAddingTimeInterval:utcOffset];
    NSLog(@"_timeofEvent is %@ _endtimeofEvent is %@",_timeofEvent,_endtimeofEvent);

}

- (void)openLocationPicker:(id)sender {
    
    _locationPickerController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationPickerController"];
    [_locationPickerController setCurrentLocation:_currentLocation];
    [_locationPickerController setEventIconType:_eventIconType];
    _locationPickerController.delegate = self;
    
    [self setTitle:@" "];
    CATransition* transition = [CATransition animation];
    transition.duration = transitionDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = transitionType;
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] pushViewController:_locationPickerController animated:NO];
}

- (void) launchInstagram{
    //Search Instagram
    
    NSArray *componentsArray = [_eventCaption.text componentsSeparatedByString:@" "];
    
    for (NSString *word in componentsArray) {
       
       if ([word hasPrefix:@"#"]){
           _searchTerm = [word stringByReplacingOccurrencesOfString:@"#" withString:@""];
           NSLog(@"word id %@",word);
           break;
       }
    }

    [self setTitle:@" "];
    _instaCollectionController = [self.storyboard instantiateViewControllerWithIdentifier:@"InstagramCollectionViewController"];
    _instaCollectionController.delegate = self;
    [_instaCollectionController setInstagramSearchTerm:_searchTerm];
    [_instaCollectionController instagramString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=x",_searchTerm]];
    
    CATransition* transition = [CATransition animation];
    transition.duration = transitionDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = transitionType;
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] pushViewController:_instaCollectionController animated:NO];
}

- (void) initiateMap:(CLLocation*)location{
    
    [PlayUtility responseFrom4sq:_currentLocation limit:@"1" block:^(NSArray *locationDictionary, NSError *error) {
        if (!error){
            
            NSLog(@"in PlayUtility responseFrom4sq completed");
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self getVenueData4sq:locationDictionary index:0];
            });
            
        }
    }];
    
    [self setMap:_currentLocation];

}

- (void) setMap:(CLLocation*)location{
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoomedInMiniMap, zoomedInMiniMap);
    
    //Adjust center to focus on Custom Pin
    adjustedRegion.center.latitude = adjustedRegion.center.latitude - 0.001;
    
    [_mapView setRegion:adjustedRegion animated:YES];
    
    Event *newAnnotation = [[Event alloc] initWithCoordinate:zoomLocation];
    
    [self.mapView addAnnotation:newAnnotation];
    NSLog(@"addAnnotation called, event is %@, _eventIconType is %@", newAnnotation,_eventIconType);
        
}

#pragma mark -
#pragma mark PinAnnotations

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //NSLog(@"in viewForAnnotation");
    
    static NSString *identifier = @"Event";
    if ([annotation isKindOfClass:[Event class]]) {
                        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            //annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.image = [PlayUtility imageForEventType:_eventIconType];
        annotationView.enabled = NO;
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }
    return nil;
}

#pragma mark -
#pragma mark JSONparser

-(void) getVenueData4sq:(NSArray *)venueArray index:(NSInteger)index{
    
    NSDictionary *firstVenue = [venueArray objectAtIndex:index];
    
    NSDictionary *locationDetailsDict = [firstVenue objectForKey:@"location"];
    NSDictionary *locationContactDict = [firstVenue objectForKey:@"contact"];
    
    
    if([firstVenue objectForKey:@"id"]){
        [_locationInfo replaceObjectAtIndex:0 withObject:[firstVenue objectForKey:@"id"]];
    }
    
    if([firstVenue objectForKey:@"name"]){
        [_locationInfo replaceObjectAtIndex:1 withObject:[firstVenue objectForKey:@"name"]];
    }
    
    if([locationDetailsDict objectForKey:@"distance"]){
        [_locationInfo replaceObjectAtIndex:2 withObject:[locationDetailsDict objectForKey:@"distance"]];
    }
    
    if([locationContactDict objectForKey:@"phone"]){
        [_locationInfo replaceObjectAtIndex:3 withObject:[locationContactDict objectForKey:@"phone"]];
    }
    
    if([locationDetailsDict objectForKey:@"address"]){
        [_locationInfo replaceObjectAtIndex:4 withObject:[locationDetailsDict objectForKey:@"address"]];
    }
    
    if([locationDetailsDict objectForKey:@"postalCode"]){
        [_locationInfo replaceObjectAtIndex:5 withObject:[locationDetailsDict objectForKey:@"postalCode"]];
    }
    
    if([locationDetailsDict objectForKey:@"city"]){
        [_locationInfo replaceObjectAtIndex:6 withObject:[locationDetailsDict objectForKey:@"city"]];
    }
    
    if([locationDetailsDict objectForKey:@"state"]){
        [_locationInfo replaceObjectAtIndex:7 withObject:[locationDetailsDict objectForKey:@"state"]];
    }
    
    if([locationDetailsDict objectForKey:@"country"]){
        [_locationInfo replaceObjectAtIndex:8 withObject:[locationDetailsDict objectForKey:@"country"]];
    }

    NSString *oldLocationName = _locationName;
    _locationName = [NSString stringWithFormat:@"%@",[firstVenue objectForKey:@"name"]];
    
    NSRange range = [_eventCaption.text rangeOfString:oldLocationName];
        
    if(range.location == NSNotFound)
    {
        _eventCaption.text = [NSString stringWithFormat:@"%@%@",_eventCaption.text,_locationName];
            
    }else{
            
        NSString *subString = [_eventCaption.text substringToIndex:range.location];
        _eventCaption.text = [NSString stringWithFormat:@"%@%@%@",subString,_locationName,_timeTillEvent];
        }        
        
    [_locationTextView setTitle:_locationName forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark ActionSheet and ImagePicker

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            //User to Take a Photo
            [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if (buttonIndex == 1){
            //User to Choose an Exisiting Photo
            [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            //[_picker set
        }
        else if (buttonIndex == 2){
            //Search Instagram
            [self launchInstagram];
            
            return;
        }
        else {
            //hit cancel
            return;
        }
    }
    else if (actionSheet.tag == 2) {
        if (buttonIndex == 0){
            //User to Choose an Exisiting Photo
            [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else if (buttonIndex == 1){
            [self launchInstagram];
            
            return;
        }
        else {
            //hit cancel
            return;
        }
    }
    else if (actionSheet.tag == 3) {
        if (buttonIndex == 0){
            //User to Take a Photo
            [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if (buttonIndex == 1){
            [self launchInstagram];
            
            return;
        }
        else {
            //hit cancel
            return;
        }
    }
    [_picker setAllowsEditing:YES];
    [self presentViewController:_picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self uploadImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
    [_chooseAPhoto setTitle:@"" forState:UIControlStateNormal];

}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
 [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Uploading Image

- (BOOL) uploadImage:(UIImage *)anImage{
    
    // Resize the image to be square (what is shown in the preview)
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                bounds:CGSizeMake(heightofEventImage, heightofEventImage)
                                interpolationQuality:kCGInterpolationHigh];
    //UIImage *smallerResizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(heightofEventImage, heightofEventImage) interpolationQuality:kCGInterpolationHigh];

    //set display image
    _addEventImage.image = resizedImage;
    
    // Get an NSData representation of our images. We use JPEG for the larger image
    // for better compression and PNG for the thumbnail to keep the corner radius transparency
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 1.0f);
    
    if (!imageData) {
        return NO;
    }
    
    // Create the PFFiles and store them in properties since we'll need them later
    self.photoFile = [PFFile fileWithData:imageData];
    
    // Save the files
    [self.photoFile saveInBackground];

    return YES;
}

#pragma mark -
#pragma mark TextView DelegateMethod

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if(textView == _eventCaption){
        _bioStringCount.hidden = NO;
        NSInteger textLength = 0;
        textLength = [textView.text length];
        [_bioStringCount setTitle:[NSString stringWithFormat:@"%d",charLimitEventCaption-textLength] forState:UIControlStateNormal];
        
        if ([textView.text isEqualToString:kPlayCheckInPlaceholderText]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor]; //optional
        }
            [textView becomeFirstResponder];
            _addSportImage.userInteractionEnabled = NO;
            _timeTextView.userInteractionEnabled = NO;
            _locationTextView.userInteractionEnabled = NO;
            _chooseAPhoto.userInteractionEnabled = NO;
            [self animateTextField:textView up:YES];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView == _eventCaption){
        
        _bioStringCount.hidden = YES;
        
        if ([textView.text isEqualToString:@""]) {
            textView.text = kPlayCheckInPlaceholderText;
            textView.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f]; //optional
        }
        [textView resignFirstResponder];
        _addSportImage.userInteractionEnabled = YES;
        _timeTextView.userInteractionEnabled = YES;
        _locationTextView.userInteractionEnabled = YES;
        _chooseAPhoto.userInteractionEnabled = YES;
        [self animateTextField:textView up:NO];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(textView == _eventCaption){
        
        NSInteger textLength = 0;
        textLength = [textView.text length] + [text length] - range.length;
        [_bioStringCount setTitle:[NSString stringWithFormat:@"%d",charLimitEventCaption-textLength] forState:UIControlStateNormal];
        
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

-(void) animateTextField:(UITextView*)textField up:(BOOL)up{
        const int movementDistance = -145; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
}

#pragma mark -
#pragma mark UIButtons

- (void)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pressedPostToFacebookButton:(UIButton*)sender {
    
   [PlayUtility isLinkedToFacebook:[PFUser currentUser] block:^(BOOL success, NSError *error) {
       if (success) {
           sender.selected = !sender.selected;
           _shouldPostToFacebook = sender.selected;
       }
   }];
}

- (void)pressedPostToTwitterButton:(UIButton*)sender {

    [PlayUtility isLinkedToTwitter:[PFUser currentUser] block:^(BOOL success, NSError *error) {
        if (success) {
            sender.selected = !sender.selected;
            _shouldPostTwitter = sender.selected;
        }
    }];
}

- (void)pressedPostToEmailButton:(UIButton*)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
       
        [self setTitle:@" "];
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[NSString stringWithFormat:@"%@ is inviting you to an event",[PFUser currentUser].username]];
        [mailViewController setMessageBody:[NSString stringWithFormat:@"%@ is inviting you to %@ <br><br>Interested in joining? <a href=\"https://itunes.apple.com/us/app/play-a-sports-community/id646639758?ls=1&mt=8\">Download the Play app (it's free!) </a>",[PFUser currentUser].username,_eventCaption.text] isHTML:YES];
          [self presentViewController:mailViewController animated:YES completion:nil];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Device is currently unable to send email."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Dismiss",nil];
        [alert show];
    }
}

- (void)pressedInviteFriends:(UIButton*)sender {
    
        [self setTitle:@" "];
    
        InviteUsersFollowViewController *followerViewController = [[InviteUsersFollowViewController alloc] initWithStyle:UITableViewStylePlain];
        //[followerViewController setUser:[PFUser currentUser]];
        [followerViewController setQueryType:@"Followers"];
        if (_invitedUsersSet) {
            [followerViewController setInvitedUsersSet:_invitedUsersSet];
            [followerViewController setPushUsersSet:_pushUsersSet];
        }
        followerViewController.delegate = self;
    
    CATransition* transition = [CATransition animation];
    transition.duration = transitionDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = transitionType;
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] pushViewController:followerViewController animated:NO];
}


- (void)createEvent:(id)sender {
    NSString *eventDesc = [_eventCaption.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!eventDesc || eventDesc.length == 0 || eventDesc.length > 160 || !self.photoFile) {
        
        NSMutableString *errorAlert = [[NSMutableString alloc] initWithString:@""];
        
        if (!eventDesc || eventDesc.length == 0){
            [errorAlert appendString:@"Event description is blank\n"];
        }
        if (eventDesc.length > 160){
            [errorAlert appendString:@"Event description cannot be longer than 160 characters. Please write a shorter description\n"];
        }
        if (!self.photoFile) {
            [errorAlert appendString:@"Please choose a photo\n"];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorAlert
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Dismiss",nil];
        [alert show];
        return;
    }
    else {
                
        PFGeoPoint *currentPoint = [PFGeoPoint geoPointWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        
        if ([[_locationInfo objectAtIndex:1] isEqualToString:@" "]) {
            
            NSRange range = [_eventCaption.text rangeOfString:@"@"];
            
            NSString *subString = [_eventCaption.text substringFromIndex:range.location];
            
            NSString *subSubString = [subString stringByReplacingOccurrencesOfString:@"@ " withString:@""];
            
            [_locationInfo replaceObjectAtIndex:1 withObject:subSubString];
            
        }
        
        // Create a Photo object
        PFObject *event = [PFObject objectWithClassName:kPlayEventClassKey];
        [event setObject:[PFUser currentUser] forKey:kPlayEventUserKey];
        [event setObject:self.photoFile forKey:kPlayEventPictureKey];
        [event setObject:_locationInfo forKey:kPlayEventLocationKey];
        [event setObject:currentPoint forKey:kPlayEventCoordinatesKey];
        [event setObject:_timeofEvent forKey:kPlayEventTimeKey];
        [event setObject:_endtimeofEvent forKey:kPlayEventEndTimeKey];
        [event setObject:eventDesc forKey:kPLayEventDescriptionKey];
        [event setObject:_eventIconType forKey:kPlayEventIconTypeKey];
        [event setObject:_displayStartTimeofEvent forKey:kPLayEventDisplayStartTimeKey];
        [event setObject:[NSNumber numberWithInt:utcOffset] forKey:kPLayEventUtcOffsetKey];
        [event setObject:[NSNumber numberWithBool:[_segmentControlNumber boolValue]] forKey:kPLayEventIsPrivate];
        
        PFRelation *relation = [event relationforKey:kPLayEventInvitedUsers];
        for (NSString *person in _invitedUsersSet) {
            PFUser *user1 = [PFUser objectWithoutDataWithObjectId:person];
            [relation addObject:user1];
        }
        
        [relation addObject:[PFUser currentUser]];

        NSArray *componentsArray = [_eventCaption.text componentsSeparatedByString:@" "];
        
        for (NSString *word in componentsArray) {
            
            if ([word hasPrefix:@"#"]){
                _eventType = word;
                break;
            }
        }
        
        [event setObject:_eventType forKey:kPlayEventTypeKey];
        
        // Photos are public, but may only be modified by the user who uploaded them
        PFACL *eventACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [eventACL setPublicReadAccess:YES];
        event.ACL = eventACL;
                
        // Save the Photo PFObject
        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Event Added. saveinBackgroud is a successful. Event: %@",event);

                BOOL locationCheckIn = NO;
                
                locationCheckIn = [PlayUtility islocationCheckInTrue:event currentLocation:_userCurrentLocation];
                                
                NSLog(@"In createEvent locationCheck in is %d",locationCheckIn);

                [PlayUtility checkIntoEventInBackground:event locationCheckIn:locationCheckIn block:^(BOOL succeeded, NSError *error){
                    if (succeeded) {
                        
                        NSLog(@"checkIntoEvent is a success. Event:%@",event);
                        
                        //[[PlayCache sharedCache] incrementCheckinCountForEvent:event];
                        //[[PlayCache sharedCache] setCurrentUserIsCheckedIntoEvent:event checkedIn:YES locationCheckedIn:locationCheckIn];
                    }
                }];
                
                if(_shouldPostToFacebook){
                    [PlayUtility authorizePermissionsForFacebook:event postedString:@""];
                    
                }
                
                if (_shouldPostTwitter) {
                    [PlayUtility postTwitterStatus:[event objectForKey:kPLayEventDescriptionKey]];
                    
                }
                
                NSLog(@"_invitedUsersSet.count is %d", _invitedUsersSet.count);
                
                if (_invitedUsersSet.count > 0) {
                    
                    NSLog(@"in _invitedUsersSet.count");
                    
                    [PlayUtility inviteFollowersInBackground:event invitedUsers:_invitedUsersSet];
                    
                    NSLog(@"_pushUsersSet.count is %d", _pushUsersSet.count);

                    if(_pushUsersSet.count > 0){
                        
                        NSLog(@"in _pushUsersSet.count");
                        
                        [PlayUtility pushNotificationsinBackground:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"Yea! %@ has invited you to an event",[PFUser currentUser].username], @"alert",
                            event.objectId,@"e",
                            @"Increment", @"badge",nil]
                            pushUsers:_pushUsersSet];
                    }
                }

                [[NSNotificationCenter defaultCenter] postNotificationName:PlayUtilityUserRefreshPinsNotificationBecauseEventCreated object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:event,@"event",_currentLocation,@"eventCoordinates",nil]];
            
            }
            
            // Send a notification. The main timeline will refresh itself when caught
            // [[NSNotificationCenter defaultCenter] postNotificationName:PAPTabBarControllerDidFinishEditingPhotoNotification object:photo];
            else {
            NSLog(@"Event failed to save: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post the Event, please try again later" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
            // [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
        }];
        
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark SportsPickerControllerDelegate

-(void)sportPickerController:(SportsCollectionViewController *)sportPickerController indexRow:(NSInteger)indexRow{
    
    _eventType = [PlayUtility indexRow:indexRow];
    _eventCaption.text = [NSString stringWithFormat:@"%@ @ %@%@",_eventType,_locationName,_timeTillEvent];
    _eventIconType = [NSNumber numberWithInt:indexRow];
    _addSportImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Sport%d",indexRow]];
    [self setMap:_currentLocation];
    
 }

#pragma mark -
#pragma mark InstaPickerControllerDelegate

-(void)instaPickerController:(InstagramCollectionViewController *)instaPickerController anImage:(UIImage *)anImage{
    
    [self uploadImage:anImage];
    [_chooseAPhoto setTitle:@"" forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark LocationPickerControllerDelegate

-(void)locationPickerController:(LocationPickerController *)locationPickerController currentLocation:(CLLocation *)currentLocation venueArray:(NSArray *)venueArray indexArray:(NSInteger)indexArray{
    
    _currentLocation = currentLocation;
    [self setMap:_currentLocation];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self getVenueData4sq:venueArray index:indexArray];
    });
    
}

#pragma mark -
#pragma mark InviteUsersControllerDelegate

-(void)inviteFriendsController:(InviteUsersFollowViewController *)inviteFriendsController invitedUserSet:(NSSet *)invitedUserSet pushUserSet:(NSSet *)pushUserSet{
    
    _invitedUsersSet = [NSMutableSet setWithSet:invitedUserSet];
    _pushUsersSet = [NSMutableSet setWithSet:pushUserSet];
    
    if(_invitedUsersSet.count > 0){
        [_inviteFriends setSelected:YES];
        [_inviteFriends setTitle:[NSString stringWithFormat:@"%d",_invitedUsersSet.count] forState:UIControlStateNormal];
    }else{
        [_inviteFriends setSelected:NO];
        [_inviteFriends setTitle:@"" forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark TimePicker

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    //set for DB Save
    
    if ([[selectedDate dateByAddingTimeInterval:(120)] compare:[NSDate date]] == NSOrderedAscending){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Woah time traveler, please choose a future date" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alertView show];
        
    }else{
        
        _timeofEvent = selectedDate;
        _endtimeofEvent = [selectedDate dateByAddingTimeInterval:(60*60*3)];
        _displayStartTimeofEvent = [selectedDate dateByAddingTimeInterval:utcOffset];        
        //may have originated from textField or barButtonItem, use an IBOutlet instead of element
        NSString *displayTime = [_dateFormatterForTime stringFromDate:selectedDate];
        [_timeTextView setTitle:[NSString stringWithFormat:@"%@",displayTime] forState:UIControlStateNormal];
        
        NSString *oldTimeTillEvent = _timeTillEvent;
        _timeTillEvent = [PlayUtility returnTimeUntilEvent:selectedDate displayTime:displayTime];
        
        NSRange range = [_eventCaption.text rangeOfString:oldTimeTillEvent];
        
        if(range.location == NSNotFound)
        {
            // oldLocationName not found
            
            _eventCaption.text = [NSString stringWithFormat:@"%@%@",_eventCaption.text,_timeTillEvent];
            
        }else{
            
            NSString *subString = [_eventCaption.text substringToIndex:range.location];
            _eventCaption.text = [NSString stringWithFormat:@"%@%@",subString,_timeTillEvent];
        }        
        
    }
}

- (void)selectADate:(UIControl *)sender {
    _actionSheetDatePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.timeofEvent target:self action:@selector(dateWasSelected:element:) origin:sender];
    [_actionSheetDatePicker addCustomButtonWithTitle:@"Now" value:[NSDate date]];
    _actionSheetDatePicker.hideCancel = YES;
    [_actionSheetDatePicker showActionSheetPicker];
}

- (void)dateButtonTapped:(UIBarButtonItem *)sender {
    [self selectADate:sender];
}

#pragma mark -
#pragma mark MFMailComposerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
 
    if (!error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Email successfull sent" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alertView show];
    }
    
    [self dismissViewControllerAnimated:controller completion:nil];
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

- (void) segmentChanged:(id)sender{
    
    UISegmentedControl* tempSeg=(UISegmentedControl *)sender;
    if(tempSeg.selectedSegmentIndex==0){
        [tempSeg setImage:[UIImage imageNamed:@"nocheckmark.png"] forSegmentAtIndex:0];
        [tempSeg setImage:[UIImage imageNamed:@"invitationicon.png"] forSegmentAtIndex:1];
        _segmentControlNumber = [NSNumber numberWithInt:0];
        NSLog(@"_segmentControlNumber is %@",_segmentControlNumber);
    }
    else{
        [tempSeg setImage:[UIImage imageNamed:@"nocheckmark.png"] forSegmentAtIndex:1];
        [tempSeg setImage:[UIImage imageNamed:@"invitationicon.png"] forSegmentAtIndex:0];
        _segmentControlNumber = [NSNumber numberWithInt:1];
        NSLog(@"_segmentControlNumber is %@",_segmentControlNumber);

    }
    
}


int solution(NSMutableArray *A) {
    

    return -1;
}

@end
