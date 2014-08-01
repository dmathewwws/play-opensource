//
//  DetailedEventHeaderView.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-01.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "DetailedEventHeaderView.h"
#import "TTTTimeIntervalFormatter.h"
#import "PlayConstants.h"
#import "PlayCache.h"
#import "PlayUtility.h"
#import "PlayProfileImageView.h"
#import "AppDelegate.h"
#import "ShareDetailedViewController.h" 
#import "UIImage+AlphaAdditions.h"
#import "UIAlertView+Blocks.h"

#define baseHorizontalOffset 7.5f

#define xOffset 5.0f
#define yOffset 5.0f

#define baseWidth 280.0f

#define horiBorderSpacing 7.5f
#define horiMediumSpacing 3.0f

#define vertBorderSpacing 6.0f
#define vertSmallSpacing 2.0f

#define nameHeaderX 0.0f
#define nameHeaderY 0.0f
#define nameHeaderWidth baseWidth
#define nameHeaderHeight 46.0f

#define avatarImageX baseHorizontalOffset
#define avatarImageY vertBorderSpacing
#define avatarImageDim 35.0f

#define headerImageX baseHorizontalOffset
#define headerImageY avatarImageY + avatarImageDim + yOffset

#define nameLabelX avatarImageX + avatarImageDim
#define nameLabelY avatarImageY+vertSmallSpacing
#define nameLabelMaxWidth 280.0f - (horiBorderSpacing+avatarImageDim+horiMediumSpacing+horiBorderSpacing)

#define timeLabelX nameLabelX
#define timeLabelMaxWidth nameLabelMaxWidth

#define spaceBetweenBoxesX 5.0f
#define spaceBetweenBoxesY 5.0f

#define xOffsetForSquare 57.5f
#define yOffsetForSquare 46.0f
#define squareBOX 150.0f

#define mainImageX baseHorizontalOffset
#define mainImageY headerImageY + 30 + yOffset
#define mainImageWidth squareBOX
#define mainImageHeight squareBOX

#define locationImageX baseHorizontalOffset + mainImageWidth + xOffset
#define locationImageY mainImageY
#define locationImageWidth squareBOX
#define locationImageHeight squareBOX

#define timeImageX baseHorizontalOffset
#define timeImageY mainImageY + mainImageHeight + yOffset

#define planTextViewX baseHorizontalOffset
#define planTextViewY timeImageY + 30 + yOffset

#define likeBarX baseHorizontalOffset - 5.0f
#define likeBarY 325.0f
#define likeBarWidth self.bounds.size.width - (baseHorizontalOffset - 5.0f)*2
#define likeBarHeight 45.0f

#define likeButtonX 5.0f
#define likeButtonY 5.0f
#define likeButtonDimx 90.0f
#define likeButtonDimy 45.0f

#define likeProfileXBase likeButtonDimx + likeProfileXSpace + likeProfileXSpace + 10.0f
#define likeProfileXSpace 5.0f
#define likeProfileY 5.0f
#define likeProfileDim 45.0f

#define commentAndShareX 0.0f
#define commentAndShareY likeBarY + likeBarHeight + 15.0f
#define commentAndShareDim 25.0f

#define viewTotalHeight likeBarY + likeBarHeight + 15.0f
#define numLikePics 3.0f
#define zoominMapArea 1200

@implementation DetailedEventHeaderView

static TTTTimeIntervalFormatter *timeFormatter;

@synthesize event = _event;
@synthesize createdUser = _createdUser;
@synthesize checkedInUsers = _checkedInUsers;
@synthesize checkedInButton = _checkedInButton;
@synthesize delegate = _delegate;
@synthesize nameHeaderView = _nameHeaderView;
@synthesize photoImageView = _photoImageView;
@synthesize checkedInBarView = _checkedInBarView;
@synthesize currentCheckedInAvatars = _currentCheckedInAvatars;
@synthesize sortedCheckedInArray = _sortedCheckedInArray;
@synthesize sportIconImageView = _sportIconImageView;
@synthesize mapView = _mapView;
@synthesize locationTextView = _locationTextView;
@synthesize eventLocation = _eventLocation;
@synthesize planTextView = _planTextView;
@synthesize dateFormatterForTime = _dateFormatterForTime;
@synthesize headerButton = _headerButton;
@synthesize footerButton = _footerButton;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame event:(PFObject*)anEvent{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        self.event = anEvent;
        self.createdUser = [self.event objectForKey:kPlayEventUserKey];
        PFGeoPoint *eventPoint = [self.event objectForKey:kPlayEventCoordinatesKey];
        self.eventLocation = [[CLLocation alloc] initWithLatitude:eventPoint.latitude longitude:eventPoint.longitude];
        self.checkedInUsers = nil;
        
        [self createView];
        
        NSLog(@"initWithFrame -no dict in called");

    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame event:(PFObject*)anEvent createdUser:(PFUser*)acreatedUser checkedInUsers:(NSDictionary*)checkedInUsers{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }

        self.event = anEvent;
        self.createdUser = [self.event objectForKey:kPlayEventUserKey];
        PFGeoPoint *eventPoint = [self.event objectForKey:kPlayEventCoordinatesKey];
        self.eventLocation = [[CLLocation alloc] initWithLatitude:eventPoint.latitude longitude:eventPoint.longitude];
        self.checkedInUsers = checkedInUsers;

        if (self.event && self.createdUser && self.checkedInUsers) {
            [self createView];
        }
        
        NSLog(@"initWithFrame -with dict in called");

    }
    return self;

}

+ (CGRect)rectForView{
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, viewTotalHeight);
}

-(void)setEvent:(PFObject *)event{
    _event = event;
    
    NSLog(@"setEvent in called");
    
    if (self.event && self.createdUser && self.checkedInUsers) {
        [self createView];
        [self setNeedsDisplay];
        
            NSLog(@"in self.event && self.createdUser && self.checkedInUsers is TRUE");
    }
}

- (void)setCheckedInButtonState:(BOOL)selected{
        if (selected) {
            [_checkedInButton setTitleEdgeInsets:UIEdgeInsetsMake( -1.0f, 0.0f, 0.0f, 0.0f)];
            //[[_checkedInButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
        } else {
            [_checkedInButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 0.0f, 0.0f, 0.0f)];
            //[[_checkedInButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        }
        [_checkedInButton setSelected:selected];
    
    NSLog(@"in setCheckedInButtonState is %s", selected ? "true" : "false");

}

- (void)reloadCheckInBar{
    self.checkedInUsers = [[PlayCache sharedCache] checkedInUsersForEvent:self.event];
    [self setCheckedInButtonState:[[PlayCache sharedCache] isCurrentUserCheckedIntoEvent:self.event]];
    NSLog(@"in reloadCheckinBar setCheckedInButtonState is %s",[[PlayCache sharedCache] isCurrentUserCheckedIntoEvent:self.event] ? "true" : "false");
}

- (void)createView {
    /*
     Create middle section of the header view; the image
     */
    
    NSString *sportType = [_event objectForKey:kPlayEventTypeKey];
    
    UIImage *headerImage = nil;
    UIImage *startButtonImage = nil;


    if ([PlayUtility returnShouldImageBeGray:[_event objectForKey:kPlayEventTimeKey]]) {
        headerImage = [UIImage imageNamed:@"frametopgrey.png"];
        startButtonImage = [UIImage imageNamed:@"framebottomgrey.png"];
    }else{
        headerImage = [UIImage imageNamed:@"frametopgreen.png"];
        startButtonImage = [UIImage imageNamed:@"framebottomgreen.png"];
    }
    
    _headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headerButton setTitle:[sportType uppercaseString] forState:UIControlStateNormal];
    [_headerButton setTintColor:[UIColor whiteColor]];
     //[_headerButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    _headerButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
    [_headerButton setFrame:CGRectMake(headerImageX, headerImageY, headerImage.size.width, headerImage.size.height)];
    [_headerButton setBackgroundImage:headerImage forState:UIControlStateNormal];
    [_headerButton setUserInteractionEnabled:NO];
    [self addSubview:_headerButton];
    
    self.photoImageView = [[PFImageView alloc] initWithFrame:CGRectMake(mainImageX, mainImageY, mainImageWidth, mainImageHeight)];
    self.photoImageView.image = [UIImage imageNamed:@"detailphoto.png"];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    PFFile *imageFile = [self.event objectForKey:kPlayEventPictureKey];

    if (imageFile) {
        self.photoImageView.file = imageFile;
        [self.photoImageView loadInBackground];
    }
    
//    [self.profileButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadAddAvatarPic:)]];

    [self addSubview:self.photoImageView];
    
    _mapView = [[MKMapView alloc] init];
    [_mapView setFrame:CGRectMake(locationImageX, locationImageY, locationImageWidth, locationImageHeight)];
    _mapView.userInteractionEnabled = NO;
    
    //UIImage *locationImage = [UIImage imageNamed:@"detailmapframe.png"];
    _locationTextView = [UIButton buttonWithType:UIButtonTypeCustom];

    NSArray *locationArray = [_event objectForKey:kPlayEventLocationKey];
    NSString *locationTitle = [NSString stringWithFormat:@"\n\n%@",[locationArray objectAtIndex:1]];
    
    [_locationTextView setTitle:locationTitle forState:UIControlStateNormal];
    [_locationTextView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_locationTextView.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_locationTextView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    _locationTextView.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
    [_locationTextView setFrame:_mapView.frame];
    
    [_locationTextView addTarget:self action:@selector(openMaps:) forControlEvents:UIControlEventTouchUpInside];
    
    _mapView.delegate = self;
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(_eventLocation.coordinate.latitude, _eventLocation.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
    //Adjust center to focus on Custom Pin
    adjustedRegion.center.latitude = adjustedRegion.center.latitude - 0.002;
    
    [_mapView setRegion:adjustedRegion animated:YES];
    
    [self addSubview:_mapView];
    [self addSubview:_locationTextView];
        
    Event *eventAnnotation = [[Event alloc] initWithCoordinate:zoomLocation andTitle:nil andSubtitle:nil];
    [self.mapView addAnnotation:eventAnnotation];
    
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
    
    _dateFormatterForTime = [[NSDateFormatter alloc] init];
    _dateFormatterForTime.locale = [NSLocale currentLocale];
    [_dateFormatterForTime setTimeStyle: NSDateFormatterShortStyle];
    [_dateFormatterForTime setDateStyle: NSDateFormatterMediumStyle];
    
    NSDate *startDate = [_event objectForKey:kPlayEventTimeKey];
    NSString *displayTime = [_dateFormatterForTime stringFromDate:startDate];
    
    _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_footerButton setTitle:displayTime forState:UIControlStateNormal];
    [_footerButton setTintColor:[UIColor whiteColor]];
    [_footerButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    //[_locationTextView setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    _footerButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
    [_footerButton setFrame:CGRectMake(timeImageX, timeImageY, startButtonImage.size.width, startButtonImage.size.height)];
    [_footerButton setBackgroundImage:startButtonImage forState:UIControlStateNormal];
    //[_startDateButton addTarget:self action:@selector(openLocationPicker:) forControlEvents:UIControlEventTouchUpInside];
    [_footerButton setUserInteractionEnabled:NO];
    [self addSubview:_footerButton];
    
    _planTextView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_planTextView setTitle:[_event objectForKey:kPLayEventDescriptionKey] forState:UIControlStateNormal];
    [_planTextView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_planTextView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_planTextView setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [_planTextView.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    _planTextView.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
    [_planTextView setFrame:CGRectMake(planTextViewX, planTextViewY,self.bounds.size.width-15,60)];
    [_planTextView setUserInteractionEnabled:NO];
    [self addSubview:_planTextView];
    
    /*
     Create top of header view with name and avatar
     */
    
    self.nameHeaderView = [[UIView alloc] initWithFrame:CGRectMake(nameHeaderX, nameHeaderY, nameHeaderWidth, nameHeaderHeight)];
    [self addSubview:self.nameHeaderView];

    // Load data for header
    [self.createdUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        // Create avatar view
        PlayProfileImageView *avatarImageView = [[PlayProfileImageView alloc] initWithFrame:CGRectMake(avatarImageX, avatarImageY, avatarImageDim, avatarImageDim)];
        [avatarImageView setBackgroundColor:[UIColor clearColor]];
        [avatarImageView setFile:[self.createdUser objectForKey:kPlayUserProfilePictureSmallKey]];
        [avatarImageView.profileButton addTarget:self action:@selector(didTapUserNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_nameHeaderView addSubview:avatarImageView];
        
        // Create name label
        NSString *nameString = [self.createdUser objectForKey:kPlayUserUsernameKey];
        UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameHeaderView addSubview:userButton];
        [userButton setBackgroundColor:[UIColor clearColor]];
        [[userButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:14.0f]];
        [userButton setTitle:nameString forState:UIControlStateNormal];
        [userButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        //[userButton setTitleColor:[UIColor colorWithRed:134.0f/255.0f green:100.0f/255.0f blue:65.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [[userButton titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
        //[[userButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        //[userButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
        [userButton addTarget:self action:@selector(didTapUserNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // we resize the button to fit the user's name to avoid having a huge touch area
        CGPoint userButtonPoint = CGPointMake(avatarImageX+avatarImageDim+5, 7.0f);
        CGFloat constrainWidth = self.nameHeaderView.bounds.size.width - (avatarImageView.bounds.origin.x + avatarImageView.bounds.size.width);
        CGSize constrainSize = CGSizeMake(constrainWidth, self.nameHeaderView.bounds.size.height - userButtonPoint.y*2.0f);
        CGSize userButtonSize = [userButton.titleLabel.text sizeWithFont:userButton.titleLabel.font constrainedToSize:constrainSize lineBreakMode:NSLineBreakByTruncatingTail];
        CGRect userButtonFrame = CGRectMake(userButtonPoint.x, userButtonPoint.y, userButtonSize.width, userButtonSize.height);
        [userButton setFrame:userButtonFrame];
    
        /* Create time label
        NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[_event createdAt]];
        CGSize timeLabelSize = [timeString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(nameLabelMaxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, nameLabelY+userButtonSize.height, timeLabelSize.width, timeLabelSize.height)];
        [timeLabel setText:timeString];
        [timeLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [timeLabel setTextColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:1.0f]];
        [timeLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        [timeLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameHeaderView addSubview:timeLabel];*/
        
        [self setNeedsDisplay];
    }];
    
    /*
     Create bottom section fo the header view; the likes
     */
    _checkedInBarView = [[UIView alloc] initWithFrame:CGRectMake(likeBarX, likeBarY, likeBarWidth, likeBarHeight)];
    [_checkedInBarView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_checkedInBarView];
    
    // Create the Play button
    _checkedInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkedInButton setFrame:CGRectMake(likeButtonX, likeButtonY, likeButtonDimx, likeButtonDimy)];
    [_checkedInButton setBackgroundColor:[UIColor clearColor]];
//    [_checkedInButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
//    [_checkedInButton setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.750f] forState:UIControlStateSelected];
    [_checkedInButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [[_checkedInButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:13.0f]];
    // [[_checkedInButton titleLabel] setMinimumFontSize:11.0f];
    //[[_checkedInButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
    //[[_checkedInButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    //[_checkedInButton setAdjustsImageWhenDisabled:NO];
    //[_checkedInButton setAdjustsImageWhenHighlighted:NO];
    [_checkedInBarView addSubview:_checkedInButton];
    
    
    if([[NSDate date] compare:[_event objectForKey:kPlayEventEndTimeKey]] == NSOrderedDescending){
        
        [_checkedInButton setBackgroundImage:[UIImage imageNamed:@"detaildone.png"] forState:UIControlStateNormal];
        [_checkedInButton setBackgroundImage:[UIImage imageNamed:@"detaildone.png"] forState:UIControlStateSelected];
        [_checkedInButton setTitle:[NSString stringWithFormat:@"EVENT OVER"] forState:UIControlStateNormal];
        [_checkedInButton setTitle:[NSString stringWithFormat:@"EVENT OVER"] forState:UIControlStateSelected];
        [_checkedInButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_checkedInButton setUserInteractionEnabled:NO];
        //[_checkedInButton removeTarget:self action:@selector(didTapCheckIntoEventButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }else{
        [_checkedInButton setBackgroundImage:[UIImage imageNamed:@"detailplay.png"] forState:UIControlStateNormal];
        [_checkedInButton setBackgroundImage:[UIImage imageNamed:@"detailplay1.png"] forState:UIControlStateSelected];
        [_checkedInButton setTitle:[NSString stringWithFormat:@"JOIN"] forState:UIControlStateNormal];
        [_checkedInButton setTitle:[NSString stringWithFormat:@"JOINED"] forState:UIControlStateSelected];
        [_checkedInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_checkedInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[_checkedInButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [_checkedInButton addTarget:self action:@selector(didTapCheckIntoEventButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    //NSLog(@"in createview reloadCheckInBar is called");
    //[self reloadCheckInBar];
    
    /*UIImageView *separator = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f)]];
    [separator setFrame:CGRectMake(0.0f, likeBarView.frame.size.height - 2.0f, likeBarView.frame.size.width, 2.0f)];
    [likeBarView addSubview:separator];*/

}

- (void)didTapCheckIntoEventButtonAction:(UIButton *)button {
    BOOL checkedIn = !button.selected;
    [button removeTarget:self action:@selector(didTapCheckIntoEventButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setCheckedInButtonState:checkedIn];
    
    NSDictionary *originalCheckedInUsersDictionary = [NSDictionary dictionaryWithDictionary:self.checkedInUsers];
    
    NSArray *originalCheckedInUsersArray = [originalCheckedInUsersDictionary objectForKey:kPlayEventAttributesCheckedInUsersUserArrayKey];
    NSArray *originalLocationCheckedInUsersArray = [originalCheckedInUsersDictionary objectForKey:kPlayEventAttributesLocationCheckedInUsersArrayKey];
    
    NSMutableArray *newCheckedIUsersMutableArray = [NSMutableArray arrayWithCapacity:[originalCheckedInUsersArray count]];
    NSMutableArray *newLocationCheckedIUsersMutableArray = [NSMutableArray arrayWithCapacity:[originalLocationCheckedInUsersArray count]];

    for (PFUser *aUser in originalCheckedInUsersArray) {
        if (![[aUser objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            [newCheckedIUsersMutableArray addObject:aUser];
        }
    }
    
    for (PFUser *aUser in originalLocationCheckedInUsersArray) {
        if (![[aUser objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            [newLocationCheckedIUsersMutableArray addObject:aUser];
        }
    }
    
    BOOL locationCheckIn = NO;
    
    if (checkedIn) {

        //checkIN
        [[PlayCache sharedCache] incrementCheckinCountForEvent:self.event];
        [newCheckedIUsersMutableArray addObject:[PFUser currentUser]];
        
        //LocationCheckIN
        
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        [appDelegate startLocationManager];
        
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
        
        locationCheckIn = [PlayUtility islocationCheckInTrue:_event currentLocation:currentLocation];
        
        if(locationCheckIn){
            [newLocationCheckedIUsersMutableArray addObject:[PFUser currentUser]];
        }
        
        
    } else {
        [[PlayCache sharedCache] decrementCheckinCountForEvent:self.event];
    }
    
    [[PlayCache sharedCache] setCurrentUserIsCheckedIntoEvent:_event checkedIn:checkedIn locationCheckedIn:locationCheckIn];
    
    
    NSDictionary *newCheckedInUsersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[newCheckedIUsersMutableArray copy],kPlayEventAttributesCheckedInUsersUserArrayKey,[newLocationCheckedIUsersMutableArray copy],kPlayEventAttributesLocationCheckedInUsersArrayKey, nil];
    
    [self setCheckedInUsers:newCheckedInUsersDictionary];
    
    if (checkedIn) {
        [PlayUtility checkIntoEventInBackground:self.event locationCheckIn:locationCheckIn block:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [self setCheckedInUsers:originalCheckedInUsersDictionary];
                NSLog(@"in !successful checkIn");
                [self setCheckedInButtonState:NO];
            }else{
                
                [UIAlertView displayAlertWithTitle:@"Would you like to add this event to your calendar?"
                                           message:nil
                                   leftButtonTitle:@"No"
                                  leftButtonAction:^{
                                      NSLog(@"No to Add to Calendar");
                                  }
                                  rightButtonTitle:@"Yes"
                                 rightButtonAction:^{
                                     [PlayUtility addEventToCalendar:_event];
                                 }];
            }
        }];
    } else {
        [PlayUtility uncheckIntoEventInBackground:self.event block:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [self setCheckedInUsers:originalCheckedInUsersDictionary];
                [self setCheckedInButtonState:YES];
            }
        }];
    }
    
    [button addTarget:self action:@selector(didTapCheckIntoEventButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DetailedViewControllerUserCheckedInorUncheckedIntoEventNotification object:self.event userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:checkedIn] forKey:UserCheckedInorUncheckedIntoEventNotificationUserInfoCheckedInKey]];
}

-(void)setCheckedInUsers:(NSDictionary *)aDictionary{

    _checkedInUsers = aDictionary;
    
    if(!_checkedInUsers){
        return;
    }
    
    NSArray *checkedInArray = [aDictionary valueForKey:kPlayEventAttributesCheckedInUsersUserArrayKey];
    NSArray *locationCheckedInArray = [aDictionary valueForKey:kPlayEventAttributesLocationCheckedInUsersArrayKey];
    
    NSLog(@"checkedInArray is %@",checkedInArray);
    NSLog(@"locationCheckedInArray is %@",locationCheckedInArray);
    
    _sortedCheckedInArray = [checkedInArray sortedArrayUsingComparator:^NSComparisonResult(PFUser *liker1, PFUser *liker2) {
        NSString *displayName1 = liker1.username;
        NSString *displayName2 = liker2.username;
        
        if ([[liker1 objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            return NSOrderedAscending;
        } else if ([[liker2 objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            return NSOrderedDescending;
        }
        
        return [displayName1 compare:displayName2 options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
    }];
    
    NSArray *sortedLocationCheckedInArray = [locationCheckedInArray sortedArrayUsingComparator:^NSComparisonResult(PFUser *liker1, PFUser *liker2) {
        NSString *displayName1 = liker1.username;
        NSString *displayName2 = liker2.username;
        
        if ([[liker1 objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            return NSOrderedAscending;
        } else if ([[liker2 objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            return NSOrderedDescending;
        }
        
        return [displayName1 compare:displayName2 options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
    }];
    
    NSMutableSet *checkedInSet = [[NSMutableSet alloc] initWithCapacity:[_sortedCheckedInArray count]];
    
    for (PFUser* aUser in _sortedCheckedInArray){
        NSString *displayNameUser = aUser.username;
        [checkedInSet addObject:displayNameUser];
    }
    
    NSMutableSet *locationCheckedInSet = [[NSMutableSet alloc] initWithCapacity:[sortedLocationCheckedInArray count]];
    
    for (PFUser* aUser in sortedLocationCheckedInArray){
        NSString *displayNameUser = aUser.username;
        [locationCheckedInSet addObject:displayNameUser];
    }
    
    for (PlayProfileImageView *image in _currentCheckedInAvatars) {
        [image removeFromSuperview];
    }
    
    [checkedInSet intersectSet:locationCheckedInSet];
    NSLog(@"checkedInSet after instersetSet is %@",checkedInSet);
    
    self.currentCheckedInAvatars = [[NSMutableArray alloc] initWithCapacity:[_sortedCheckedInArray count]];
    int i;
    int numOfPics = numLikePics > _sortedCheckedInArray.count ? _sortedCheckedInArray.count : numLikePics;
    
    for (i = 0; i < numOfPics; i++) {
        
        PFUser *eachUser = [_sortedCheckedInArray objectAtIndex:i];
        
        NSLog(@"user %@ is at index %d",eachUser.username, i);
        
        PlayProfileImageView *profilePic = [[PlayProfileImageView alloc] initWithFrame:CGRectMake(likeProfileXBase + (i * (likeProfileXSpace + likeProfileDim)), likeProfileY, likeProfileDim, likeProfileDim)];
        
        // user's avatar
        [eachUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            // Create avatar view
                        
            BOOL setLocationCheckMark = NO;
            
            for (NSString* username in checkedInSet){
                if ([eachUser.username isEqualToString:username]){
                    setLocationCheckMark = YES;
                    break;
                }
            }
            
            [profilePic setFile:[eachUser objectForKey:kPlayUserProfilePictureSmallKey] isLocationCheckedIn:setLocationCheckMark];
            
            CALayer * l = [profilePic.profileImageView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:3.5];

            NSLog(@"profilePic set isLocationCheckedIn is %@", setLocationCheckMark ? @"Yes" : @"No" );
            
            [_checkedInBarView addSubview:profilePic];
            [_currentCheckedInAvatars addObject:profilePic];
            
            NSLog(@"user %@ added to checkinbar",eachUser.username);

        }];

        [profilePic.profileButton addTarget:self action:@selector(didTapCheckInButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        profilePic.profileButton.tag = i;
        
    }
    
    if(_sortedCheckedInArray.count > numLikePics){
        
        NSNumber *sortedCount = [NSNumber numberWithUnsignedInteger:_sortedCheckedInArray.count];
        NSInteger sortedInt = [sortedCount intValue];
        int numofPicsInt = (int)floor(numLikePics);
        int difference = sortedInt - numofPicsInt;
        
        
        UIImage *morePicImage = [UIImage imageNamed:@"detailadd.png"];
        UIButton *morePic = [UIButton buttonWithType:UIButtonTypeCustom];
        [morePic setFrame:CGRectMake(self.bounds.size.width-15-morePicImage.size.width, likeProfileY, morePicImage.size.width, morePicImage.size.height)];
        [morePic addTarget:self action:@selector(didTapSeeMoreUsersButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [morePic setTitle:[NSString stringWithFormat:@"+%@",[NSNumber numberWithInt:difference]] forState:UIControlStateNormal];
        [morePic setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [morePic.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        //[_locationTextView setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        morePic.titleLabel.font = [UIFont fontWithName:kPlayFontName size:11.0f];
        [morePic setBackgroundImage:morePicImage forState:UIControlStateNormal];
        //[morePic setUserInteractionEnabled:NO];

        [_checkedInBarView addSubview:morePic];
    }
    
    [self setNeedsDisplay];
}

- (void)didTapCheckInButtonAction:(UIButton *)button {
    
    PFUser *user = [_sortedCheckedInArray objectAtIndex:button.tag];
    
    if (_delegate && [_delegate respondsToSelector:@selector(photoDetailsHeaderView:didTapUserButton:user:)]) {
        [_delegate photoDetailsHeaderView:self didTapUserButton:button user:user];
    }
}

- (void)didTapUserNameButtonAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(photoDetailsHeaderView:didTapUserButton:user:)]) {
        [_delegate photoDetailsHeaderView:self didTapUserButton:button user:self.createdUser];
    }
}

- (void)didTapSeeMoreUsersButtonAction:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(photoDetailsHeaderView:didTapUserButton:user:event:)]) {
        [_delegate photoDetailsHeaderView:self didTapUserButton:button user:self.createdUser event:_event];
    }
}

#pragma mark -
#pragma mark PinAnnotations

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    NSLog(@"inside viewForAnnotation");
    
    static NSString *identifier = @"Event";
    if ([annotation isKindOfClass:[Event class]]) {
        
        Event *myAnnotation = (Event*) annotation;
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        
        //float alpha = [PlayUtility returnAlphaForIconType:[_event objectForKey:kPlayEventTimeKey]];
        
        if ([PlayUtility returnShouldImageBeGray:[_event objectForKey:kPlayEventTimeKey]]) {
            annotationView.image = [PlayUtility greyImageForEventType:[_event objectForKey:kPlayEventIconTypeKey]];
        }else{
            annotationView.image = [PlayUtility imageForEventType:[_event objectForKey:kPlayEventIconTypeKey]];
        }
        
        annotationView.enabled = NO;
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }
    return nil;
}


- (void)openMaps:(id)sender {
    
    [UIAlertView displayAlertWithTitle:@"Would you like to get directions to this event?"
                               message:nil
                       leftButtonTitle:@"No"
                      leftButtonAction:^{
                          NSLog(@"No to Open Map");
                      }
                      rightButtonTitle:@"Yes"
                     rightButtonAction:^{
                         Class mapItemClass = [MKMapItem class];
                         if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
                         {
                             // Create an MKMapItem to pass to the Maps app
                             CLLocationCoordinate2D coordinate =
                             CLLocationCoordinate2DMake(_eventLocation.coordinate.latitude, _eventLocation.coordinate.longitude);
                             MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                                            addressDictionary:nil];
                             MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                             
                             NSArray *locationArray = [_event objectForKey:kPlayEventLocationKey];
                             NSString *locationTitle = [NSString stringWithFormat:@"%@",[locationArray objectAtIndex:1]];
                             
                             [mapItem setName:[NSString stringWithFormat:@"%@ @ %@",[_event objectForKey:kPlayEventTypeKey],locationTitle]];
                             
                             // Set the directions mode to "Walking"
                             // Can use MKLaunchOptionsDirectionsModeDriving instead
                             NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
                             // Get the "Current User Location" MKMapItem
                             MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                             // Pass the current location and destination map items to the Maps app
                             // Set the direction mode in the launchOptions dictionary
                             [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                                            launchOptions:launchOptions];
                         }

                     }];
}


@end