//
//  ShareDetailedViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-04-24.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "ShareDetailedViewController.h"
#import "GAI.h"

@interface ShareDetailedViewController ()

@end

@implementation ShareDetailedViewController

#define xIndent 11.0f
#define yIndent 8.0f
#define ySpacerEventImageAndCaption 3.0f
#define ySpacerCaptionAndTime 3.0f
#define ySpacerTimeAndMapView 3.0f
#define heightofEventImage 250.0f
#define heightofSportImage 100.0f
#define widthofSportImage 100.0f
#define heightofEventCaption 75.0f
#define heightofStartTime 30.0f
#define heightofMapView 60.0f
#define heightofSportIcon 80.0f
#define inviteFriendsyIndent 360.0f

#define zoominMapArea 600

#define transitionDuration 0.3
#define transitionType kCATransitionFade

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
@synthesize event = _event;
@synthesize dateString = _dateString;
@synthesize eventCaptionString = _eventCaptionString;

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
    //
    //[super viewDidLoad];
        
    float iphone5spacer = 0;
    if (self.view.bounds.size.height == 460) {
        iphone5spacer = 0;
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"create2bgi4.png"]]];
    }else{
        iphone5spacer = 22;
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"create2bgi5.png"]]];
    }
    
    UIImage *eventImage = [UIImage imageNamed:@"photobox.png"];
    _addEventImage = [[PFImageView alloc] initWithImage:eventImage];
    
    if (iphone5spacer>0) {
        [_addEventImage setFrame:CGRectMake((self.view.frame.size.width/2)-(eventImage.size.width/2), yIndent+20, eventImage.size.width, eventImage.size.height)];
    }else{
        [_addEventImage setFrame:CGRectMake((self.view.frame.size.width/2)-(eventImage.size.width/2), yIndent+5, eventImage.size.width, eventImage.size.height)];
    }
    _addEventImage.userInteractionEnabled = NO;
    
    PFFile *imageFile = [self.event objectForKey:kPlayEventPictureKey];
    
    if (imageFile) {
        self.addEventImage.file = imageFile;
        [self.addEventImage loadInBackground];
    }

    [_addEventImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_addEventImage];
    
    /*_chooseAPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chooseAPhoto.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_chooseAPhoto.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_chooseAPhoto setTitle:@"CHOOSE\nA\nPHOTO" forState:UIControlStateNormal];
    [_chooseAPhoto setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:178.0f/255.0f blue:137.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    _chooseAPhoto.titleLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    [_chooseAPhoto setFrame:_addEventImage.frame];
    //[_chooseAPhoto addTarget:self action:@selector(loadAddEventPic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseAPhoto];*/
    
    _eventIconType = [_event objectForKey:kPlayEventIconTypeKey];
    _addSportImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Sport%@.png",_eventIconType]]];
    UIImage *logoImage = [UIImage imageNamed:@"logobox.png"];
    [_addSportImage setFrame:CGRectMake(xIndent, yIndent+5, logoImage.size.width, logoImage.size.height)];
    _addSportImage.userInteractionEnabled = YES;
    //[_addSportImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadSportsPicker:)]];
    [self.view addSubview:_addSportImage];
    
    //UIView *chooseAPhotobkg = [[UIView alloc] initWithFrame:_addSportImage.frame];
    //[self.view addSubview:chooseAPhotobkg];
    
    UIImage *eventCaptionImage = [UIImage imageNamed:@"planbox.png"];
    UIImage *eventCaptionImagei5 = [UIImage imageNamed:@"planboxi5.png"];
    _eventCaption = [[UITextView alloc] init];
    _eventCaption.delegate = self;

    if(_eventCaptionString){
     _eventCaption.text = _eventCaptionString;
    }
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
    
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(_eventCaption.frame.origin.x, _eventCaption.frame.origin.y - 20, eventCaptionImage.size.width, 20)];
    planLabel.text = @"PLAN";
    planLabel.font = [UIFont fontWithName:kPlayFontName size:14.0f];
    planLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    planLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:planLabel];
    [self.view addSubview:_eventCaption];
    
    UIImage *startTimeImage = [UIImage imageNamed:@"timebox.png"];
    UIImage *startTimeImagei5 = [UIImage imageNamed:@"timeboxi5.png"];
    _timeTextView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(_dateString){
        [_timeTextView setTitle:_dateString forState:UIControlStateNormal];
    }
    
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
    
    //[_timeTextView addTarget:self action:@selector(selectADate:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeTextView.frame.origin.x, _timeTextView.frame.origin.y - 20, startTimeImage.size.width, 20)];
    timeLabel.text = @"TIME";
    timeLabel.font = [UIFont fontWithName:kPlayFontName size:14.0f];
    timeLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLabel];
    [self.view addSubview:_timeTextView];
    
    //CreateEventButton
    UIImage *createEventImage = [UIImage imageNamed:@"playbutton1.png"];
    _createEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_createEventButton setTitle:@"SHARE" forState:UIControlStateNormal];
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
    
    NSArray *locationArray = [_event objectForKey:kPlayEventLocationKey];
    NSString *locationTitle = [locationArray objectAtIndex:1];
    
    UIImage *locationImage = [UIImage imageNamed:@"locationbox.png"];
    UIImage *locationImagei5 = [UIImage imageNamed:@"locationboxi5.png"];
    _locationTextView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationTextView setTitle:locationTitle forState:UIControlStateNormal];
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
    //[_locationTextView setUserInteractionEnabled:NO];
    
    //[_locationTextView addTarget:self action:@selector(openLocationPicker:) forControlEvents:UIControlEventTouchUpInside];
    
    _mapView = [[MKMapView alloc] init];
    [_mapView setFrame:_locationTextView.frame];
    _mapView.userInteractionEnabled = NO;
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationTextView.frame.origin.x, _locationTextView.frame.origin.y - 20, locationImage.size.width, 20)];
    locationLabel.text = @"LOCATION";
    locationLabel.font = [UIFont fontWithName:kPlayFontName size:14.0f];
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
    
    PFGeoPoint *eventPoint = [self.event objectForKey:kPlayEventCoordinatesKey];
    CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude:eventPoint.latitude longitude:eventPoint.longitude];
    
    [self setMap:eventLocation];
    //[self showTime];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self setTitle:@"SHARE EVENT"];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Share Event Screen"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark TextView DelegateMethod

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if(textView == _eventCaption){
        if ([textView.text isEqualToString:kPlayCheckInPlaceholderText]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor]; //optional
        }
        [textView becomeFirstResponder];
        
        [self animateTextField:textView up:YES];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView == _eventCaption){
        if ([textView.text isEqualToString:@""]) {
            textView.text = kPlayCheckInPlaceholderText;
            textView.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f]; //optional
        }
        
        [textView resignFirstResponder];
        [self animateTextField:textView up:NO];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(textView == _eventCaption){
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

- (void) dismissKeyboard:(id) sender {
    [_eventCaption resignFirstResponder];
}

- (void) setMap:(CLLocation*)location{
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
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
        
    static NSString *identifier = @"Event";
    if ([annotation isKindOfClass:[Event class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            //annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }

        NSLog(@"in viewForAnnotation _eventIconType = %@", _eventIconType);

        
        annotationView.image = [PlayUtility imageForEventType:_eventIconType];
        annotationView.enabled = NO;
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }
    return nil;
}


#pragma mark -
#pragma mark Sharing Actions

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
    if (!eventDesc || eventDesc.length == 0 || (!_shouldPostToFacebook && !_shouldPostTwitter && _invitedUsersSet.count == 0)) {
        
        NSMutableString *errorAlert = [[NSMutableString alloc] initWithString:@""];
        
       // NSLog(@"_shouldPostToFacebook is %d",_shouldPostToFacebook);
        
        if (!eventDesc || eventDesc.length == 0){
            [errorAlert appendString:@"Event description is blank\n"];
        }
        if (!_shouldPostToFacebook && !_shouldPostTwitter && _invitedUsersSet.count == 0) {
            [errorAlert appendString:@"Please choose a social network or Invite friends on Play\n"];
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
                
            if(_shouldPostToFacebook){
                [PlayUtility authorizePermissionsForFacebook:_event postedString:_eventCaption.text];
            }
            
            if (_shouldPostTwitter) {
                [PlayUtility postTwitterStatus:_eventCaption.text];
            }
            
            NSLog(@"_invitedUsersSet.count is %d", _invitedUsersSet.count);
            
            if (_invitedUsersSet.count > 0) {
                
                NSLog(@"in _invitedUsersSet.count");
                
                [PlayUtility inviteFollowersInBackground:_event invitedUsers:_invitedUsersSet];
                
                NSLog(@"_pushUsersSet.count is %d", _pushUsersSet.count);
                
                if(_pushUsersSet.count > 0){
                    
                    NSLog(@"in _pushUsersSet.count");
                    
                    [PlayUtility pushNotificationsinBackground:[NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"Yea! %@ has invited you to an event",[PFUser currentUser].username], @"alert",
                                                                _event.objectId,@"e",
                                                                @"Increment", @"badge",nil]
                                                     pushUsers:_pushUsersSet];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PlayUtilityUserRefreshPinsNotificationBecauseEventCreated object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_event,@"event",_currentLocation,@"eventCoordinates",nil]];
            
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark InviteUsersControllerDelegate

-(void)inviteFriendsController:(InviteUsersFollowViewController *)inviteFriendsController invitedUserSet:(NSSet *)invitedUserSet pushUserSet:(NSSet *)pushUserSet{
    
    //    NSLog(@"inside inviteFriendsController Delegate");
    
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

@end
