//
//  ViewController.m
//  Eventfully
//
//  Created by Daniel Mathews on 2012-10-22.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+AlphaAdditions.h"
#import "GAI.h"
#import "UIAlertView+Blocks.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mapView = _mapView;
@synthesize checkInButton = _checkInButton;
@synthesize dateFormatter = _dateFormatter;
@synthesize eventsArray = _eventsArray;
@synthesize currentLocation = _currentLocation;
@synthesize numberFormatter = _numberFormatter;
@synthesize currentTemp = _currentTemp;
@synthesize currentWeather = _currentWeather;
@synthesize mapViewInitiated = _mapViewInitiated;

@synthesize xmlParserFlickr = _xmlParserFlickr;
@synthesize stringURLFlickr = _stringURLFlickr;
@synthesize currentStringFlickr = _currentStringFlickr;

@synthesize xmlParserYahooW = _xmlParserYahooW;
@synthesize stringURLYahooW = _stringURLYahooW;
@synthesize temperatureStringYahooW = _temperatureStringYahooW;
@synthesize weatherStringYahooW = _weatherStringYahooW;

@synthesize dateFormatterForTime = _dateFormatterForTime;
@synthesize gotoFeed = _gotoFeed;
@synthesize dataView = _dataView;
@synthesize avatarProfileImage = _avatarProfileImage;
@synthesize refreshButton = _refreshButton;
@synthesize locationFinderButton = _locationFinderButton;
@synthesize avatarPadding = _avatarPadding;
@synthesize tempPadding = _tempPadding;

#define xInsert 6.0f
#define yInsert 6.0f
#define ySpacer 6.0f

#define xInsertForRefresh 5.0f

#define xSpacerDataView 4.0f
#define ySpacerDataView 4.0f

#define ySpacerAvatarViewToTempView 3.0f

#define heightofDataView 115.0f
#define widthofDataView 55.0f
#define widthofPlayButton 100.0f
#define heightofPlayButton 60.0f
#define widthofAvatarButton widthofDataView
#define heightofAvatarButton 55.0f
#define widthofFeedButton 30.0f
#define heightofFeedButton 30.0f
#define widthofTempButton widthofDataView
#define heightofTempButton 20.0f
#define widthofRefreshButton widthofDataView
#define heightofRefreshButton 20.0f
#define widthofWeatherButton widthofDataView
#define heightofWeatherButton 20.0f

#define zoominMapArea 2100

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _mapView.delegate = self;

    NSLog(@"View DID load in MapView");
    
    _eventsArray = [[NSMutableArray alloc] init];
    _currentStringFlickr = [[NSMutableString alloc] init];
    _weatherStringYahooW = [[NSMutableString alloc] init];
    _temperatureStringYahooW = [[NSMutableString alloc] init];
    
    _numberFormatter = [[NSNumberFormatter alloc] init];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.locale = [NSLocale currentLocale];
    _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    _dateFormatterForTime = [[NSDateFormatter alloc] init];
    _dateFormatterForTime.locale = [NSLocale currentLocale];
    [_dateFormatterForTime setTimeStyle: NSDateFormatterShortStyle];

    _mapViewInitiated = NO;
    
    //StartButton
    _checkInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *playButton = [UIImage imageNamed:@"playbutton.png"];
    
    [_checkInButton setFrame:CGRectMake(xInsert,(self.view.bounds.size.height)-playButton.size.height-6,playButton.size.width,playButton.size.height)];
    [_checkInButton setBackgroundImage:playButton forState:UIControlStateNormal];
    [_checkInButton addTarget:self action:@selector(userCheckIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkInButton];
    
    _gotoFeed = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *exploreButton = [UIImage imageNamed:@"explorebutton.png"];
    
    [_gotoFeed setFrame:CGRectMake(self.view.bounds.size.width-exploreButton.size.width-6,(self.view.bounds.size.height)-exploreButton.size.height-6,exploreButton.size.width,exploreButton.size.height)];
    [_gotoFeed setBackgroundImage:exploreButton forState:UIControlStateNormal];
    [_gotoFeed addTarget:self action:@selector(openFeed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gotoFeed];
    
    _dataView = [[UIView alloc] initWithFrame:CGRectMake(xInsert, yInsert, widthofDataView+(2*xSpacerDataView), heightofDataView+(2*ySpacerDataView))];
    [_dataView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_dataView];
    
    _tempPadding = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tempPaddingImage = [UIImage imageNamed:@"Temp-Background.png"];
    [_tempPadding setFrame:CGRectMake(0,70,tempPaddingImage.size.width,tempPaddingImage.size.height)];
    [_tempPadding setBackgroundImage:tempPaddingImage forState:UIControlStateNormal];
    _tempPadding.userInteractionEnabled= NO;
    //[self.dataView addSubview:_tempPadding];
    
    _avatarProfileImage = [[PlayProfileImageView alloc] initWithFrame:CGRectMake(xSpacerDataView, ySpacerDataView, widthofAvatarButton+1, heightofAvatarButton+1)];
    [_avatarProfileImage setFile:[[PFUser currentUser] objectForKey:kPlayUserProfilePictureMediumKey]];
    [_avatarProfileImage.profileButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayProfileTapped:)]];
    //[_avatarProfileImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.dataView addSubview:_avatarProfileImage];
    
    _avatarPadding = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *avatarPaddingImage = [UIImage imageNamed:@"Main-ProfileFrame.png"];
    [_avatarPadding setFrame:CGRectMake(5-xInsert,5-yInsert,avatarPaddingImage.size.width,avatarPaddingImage.size.height)];
    [_avatarPadding setBackgroundImage:avatarPaddingImage forState:UIControlStateNormal];
    _avatarPadding.userInteractionEnabled= NO;
    [self.dataView addSubview:_avatarPadding];
    
    //Current Temp
    _currentTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    [_currentTemp setTitle:@"" forState:UIControlStateNormal];
    [_currentTemp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _currentTemp.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
    [_currentTemp setFrame:CGRectMake(xSpacerDataView+1,_tempPadding.frame.origin.y,widthofDataView/2,heightofTempButton)];
    [_currentTemp setBackgroundColor:[UIColor clearColor]];
    [self.dataView addSubview:_currentTemp];

    //Current Weather
    _currentWeather = [UIButton buttonWithType:UIButtonTypeCustom];
    [_currentWeather setTitle:@"" forState:UIControlStateNormal];
    [_currentWeather setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _currentWeather.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
    [_currentWeather setFrame:CGRectMake(widthofDataView/2+xSpacerDataView,_tempPadding.frame.origin.y,widthofDataView/2,heightofWeatherButton)];
    [_currentWeather setBackgroundColor:[UIColor clearColor]];
    [self.dataView addSubview:_currentWeather];
    
    //Center Button
    _locationFinderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *locationCenterImage = [UIImage imageNamed:@"locationbutton.png"];
    [_locationFinderButton setFrame:CGRectMake(203,yInsert,locationCenterImage.size.width,locationCenterImage.size.height)];
    [_locationFinderButton addTarget:self action:@selector(centerMap) forControlEvents:UIControlEventTouchUpInside];
    [_locationFinderButton setBackgroundImage:locationCenterImage forState:UIControlStateNormal];
    [self.view addSubview:_locationFinderButton];
    
    //Refresh Button
    _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *refreshImage = [UIImage imageNamed:@"refreshbutton.png"];
    [_refreshButton setFrame:CGRectMake(261,yInsert,refreshImage.size.width,refreshImage.size.height)];
    [_refreshButton addTarget:self action:@selector(refreshTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_refreshButton setBackgroundImage:refreshImage forState:UIControlStateNormal];
    [self.view addSubview:_refreshButton];
    
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
    
    NSLog(@"[[PFUser currentUser] objectForKey:kPlayUseriOSAskPushRegistrationKey] is %@",[[PFUser currentUser] objectForKey:kPlayUseriOSAskPushRegistrationKey]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPins:) name:PlayUtilityUserRefreshPinsNotificationBecauseEventCreated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTapped:) name:PlayUtilityUserRefreshPinsNotificationBecauseEventDeleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTapped:) name:PlayUtilityUserRefreshPinsNotificationBecauseAppLaunched object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutUserAction:) name:PlayUtilityUserLogOffNotification object:[PFUser currentUser]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfilePic:) name:UserChangedProfilePicNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centerAndRefresh:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    NSLog(@"View DID Appear in MapView");
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Map Screen"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Map

- (void) initiateMap {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    //[appDelegate startLocationManager];
    //no need because startLocationManager initates on launch
    
    _currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
            
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
            
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
    [_mapView setRegion:adjustedRegion animated:YES];
    
    [self XMLParseFlickr:adjustedRegion];
    
    if(_currentLocation){
        [self queryForAllPostsNearLocation:_currentLocation withNearbyDistance:kPlayMaximumSearchDistance];
    }
    
    //NSLog(@"PFCurrent user is %@",[PFUser currentUser]);

    
    if(![[[PFUser currentUser] objectForKey:kPlayUseriOSAskPushRegistrationKey] boolValue]){
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
         UIRemoteNotificationTypeAlert|
         UIRemoteNotificationTypeSound];
    }

}

- (void) centerMap {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [appDelegate startLocationManager];
    
    _currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
    [_mapView setRegion:adjustedRegion animated:YES];
    
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    if (!_mapViewInitiated) {

        NSLog(@"in mapViewDidFinishLoadingMap");
        [self initiateMap];

        _mapViewInitiated = YES;
    }
}

-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    
    NSLog(@"mapViewDidFailLoadingMap with error %@",error);
}

#pragma mark -
#pragma mark UIButtons

- (void) userCheckIn:(UIGestureRecognizer *)gestureRecognizer {
        
    CheckInViewController *checkInView = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckInViewController"];
    
    SportsCollectionViewController *sportsPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"SportsCollectionViewController"];
    sportsPicker.delegate = checkInView;
    [sportsPicker setHasSportPicked:NO];
    [sportsPicker setBackground:[self captureView:_mapView]];
    
    UINavigationController *navPinView = [[UINavigationController alloc] initWithRootViewController:checkInView];
    
    UIImage* image = [UIImage imageNamed:@"backarrow.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton addTarget:checkInView action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [checkInView.navigationItem setLeftBarButtonItem:leftBarButton];
    //[checkInView.navigationItem setBackBarButtonItem:leftBarButton];
    
    [self presentViewController:navPinView animated:YES completion:nil];
    [navPinView pushViewController:sportsPicker animated:NO];

}

- (void) openFeed:(UIGestureRecognizer *)gestureRecognizer {
    
    EventFeedController *checkInView = [[EventFeedController alloc] initWithStyle:UITableViewStylePlain];
    [checkInView setPoint:[PFGeoPoint geoPointWithLocation:_currentLocation]];
    UINavigationController *navPinView = [[UINavigationController alloc] initWithRootViewController:checkInView];
    
    UIImage* image = [UIImage imageNamed:@"backarrow.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton addTarget:checkInView action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [checkInView.navigationItem setLeftBarButtonItem:leftBarButton];
    
    UIImage* rightimage = [UIImage imageNamed:@"finduser.png"];
    CGRect frame2 = CGRectMake(0, 0, rightimage.size.width, rightimage.size.height);
    UIButton* someButton2 = [[UIButton alloc] initWithFrame:frame2];
    [someButton2 setBackgroundImage:rightimage forState:UIControlStateNormal];
    [someButton2 addTarget:checkInView action:@selector(addUsersButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton2];
    [checkInView.navigationItem setRightBarButtonItem:rightBarButton];
    
    [self presentViewController:navPinView animated:YES completion:nil];

    
//    [self.navigationItem setRightBarButtonItem:someBarButtonItem];
    
    
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:checkInView action:@selector(doneButton:)];
 //   [leftBarButton setBackgroundImage:[UIImage imageNamed:@"backarrow.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] setBackgroundImage:[[UIImage imageNamed:@"backarrow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] style:UIBarButtonItemStylePlain target:checkInView action:@selector(doneButton:)];
    
    //checkInView.navigationItem.hidesBackButton = YES;
    
    
}

- (void)refreshTapped:(id)sender {
    
    MKCoordinateRegion mapRegion = [_mapView region];
        
    CLLocation *centerCLLocation = [[CLLocation alloc] initWithLatitude:mapRegion.center.latitude longitude:mapRegion.center.longitude];
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(centerCLLocation.coordinate.latitude, centerCLLocation.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);

    [self XMLParseFlickr:adjustedRegion];
    
    [self queryForAllPostsNearLocation:centerCLLocation withNearbyDistance:kPlayMaximumSearchDistance];
    
}

- (void)refreshPins:(NSNotification *)notification {
    
    CLLocation *eventLocation = [[notification userInfo] valueForKey:@"eventCoordinates"];

    Event *event = [[notification userInfo] valueForKey:@"event"];
    
    if(eventLocation && event){
        
        [self queryForAllPostsNearLocation:eventLocation withNearbyDistance:kPlayMaximumSearchDistance];
        
        CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(eventLocation.coordinate.latitude, eventLocation.coordinate.longitude);
        
        MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
        
        [_mapView setRegion:adjustedRegion animated:YES];
        
        
        [UIAlertView displayAlertWithTitle:@"Would you like to add this event to your calendar?"
                                   message:nil
                           leftButtonTitle:@"No"
                          leftButtonAction:^{
                              NSLog(@"No to Add to Calendar");
                          }
                          rightButtonTitle:@"Yes"
                         rightButtonAction:^{
                             [PlayUtility addEventToCalendar:event];
                         }];
        
    }

    return;
}

- (void)centerAndRefresh:(NSNotification *)notification {

    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [appDelegate startLocationManager];
    
    _currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
    [_mapView setRegion:adjustedRegion animated:YES];
    
    [self XMLParseFlickr:adjustedRegion];
    
    [self queryForAllPostsNearLocation:_currentLocation withNearbyDistance:kPlayMaximumSearchDistance];
    
}

- (void)displayProfileTapped:(id)sender {
    
    UserProfileTableViewController *displayProfileView = [[UserProfileTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [displayProfileView setUser:[PFUser currentUser]];
    
    UINavigationController *navPinView = [[UINavigationController alloc] initWithRootViewController:displayProfileView];
    
    UIImage* image = [UIImage imageNamed:@"backarrow.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton addTarget:displayProfileView action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [displayProfileView.navigationItem setLeftBarButtonItem:leftBarButton];
    [displayProfileView.navigationItem setHidesBackButton:YES];
    
    navPinView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navPinView animated:YES completion:nil];

}

- (void) saveImage:(UIGestureRecognizer *)gestureRecognizer {
    
    [self captureView:[_mapView.subviews objectAtIndex:0]];
}

#pragma mark -
#pragma mark NSNotifications

- (void)logOutUserAction:(NSNotification *)note {
    
    NSLog(@"Log off function initiated");
    
    [self performSelector:@selector(logOutUserAction2) withObject:nil afterDelay:1];
}

- (void)logOutUserAction2{

    [PFUser logOut];
    
    RegisterOrLoginViewController *registerView = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterOrLoginViewController"];
        
    [self presentViewController:registerView animated:YES completion:nil];
}

- (void)updateProfilePic:(NSNotification *)note {
    
    NSLog(@"in updateProfilePic NSNotification current User is %@",[PFUser currentUser]);
    [_avatarProfileImage.profileImageView setFile:[[PFUser currentUser] objectForKey:kPlayUserProfilePictureMediumKey]];
    [_avatarProfileImage.profileImageView loadInBackground];
}

#pragma mark -
#pragma mark XMLparser

-(void)XMLParseFlickr:(MKCoordinateRegion)mapRegion{

    _stringURLFlickr = @"http://query.yahooapis.com/v1/public/yql?q=select%20place.woeid%20from%20flickr.places%20where%20api_key%3D%201005407ac9da84de393be2972e6d1900%20and%20lat%3D";
    
    NSString *lon = @"%20and%20lon%3D";
    
    CLLocationCoordinate2D centerLocation2D = mapRegion.center;
    
    dispatch_queue_t flickrQueue;
    flickrQueue = dispatch_queue_create("com.thePlayApp.flickrQueue", NULL);
    dispatch_async(flickrQueue, ^{
        
    _xmlParserFlickr = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%1.6f%@%1.6f",_stringURLFlickr,centerLocation2D.latitude,lon,centerLocation2D.longitude]]];
        
        _xmlParserFlickr.delegate = self;
        
        if (_xmlParserFlickr.parse){
            NSLog(@"XML Flickr parsed");
            
        }else{
            NSLog(@"XML Flickr did not parse");
        }
    });
    
}

-(void)XMLParseYahooW:(NSString*)woeid{
    
    _stringURLYahooW = @"http://weather.yahooapis.com/forecastrss?w=";
    
    NSString *userlocation = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    NSMutableString *units = [[NSMutableString alloc] initWithFormat:@"&u=c"];
    
    if ([userlocation isEqualToString:@"US"]){
            [units setString:@"&u=f"];
    }
    
        _xmlParserYahooW = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@",_stringURLYahooW,woeid,units]]];
            
        _xmlParserYahooW.delegate = self;

        if (_xmlParserYahooW.parse){
            NSLog(@"XML YahooW parsed");
            
        }else{
            NSLog(@"XML YahooW did not parse");
        }
}

static NSString *kFlickr_Place = @"place";
//static NSString *kFlickr_woeid = @"woeid";

static NSString *kYahooW_weather = @"yweather:condition";

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if (parser == _xmlParserFlickr){
        if([elementName isEqualToString:kFlickr_Place]){
            [_currentStringFlickr setString:[attributeDict valueForKey:@"woeid"]];
        }
    }
    else if (parser == _xmlParserYahooW){
        if([elementName isEqualToString:kYahooW_weather]){
            dispatch_async(dispatch_get_main_queue(), ^(){
                //[_temperatureStringYahooW setString:[attributeDict valueForKey:@"temp"]];
                //[_temperatureStringYahooW appendString:@"\u00B0"];
                //[_temperatureStringYahooW appendString:@"C"];
                //[_weatherStringYahooW setString:[attributeDict valueForKey:@"code"]];
            });
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if (parser==_xmlParserFlickr){        
        if ([elementName isEqualToString:kFlickr_Place]) {
            NSLog(@"flickt_woeid = %@",_currentStringFlickr);
            [self XMLParseYahooW:_currentStringFlickr];
        }
    }
    else if (parser==_xmlParserYahooW){
        if ([elementName isEqualToString:kYahooW_weather]) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                [_currentTemp setTitle:_temperatureStringYahooW forState:UIControlStateNormal];
                [_currentWeather setTitle:_weatherStringYahooW forState:UIControlStateNormal];
            });
        }
    }
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"ERROR!! %@",parseError.description);
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    
    //[_spinner stopAnimating];
}

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance {
    
    NSLog(@"nearbyDistance is %f", nearbyDistance);

    [SVProgressHUD show];
	
    PFQuery *firstQuery = [PFQuery queryWithClassName:kPlayEventClassKey];
    PFQuery *invitedQuery = [PFQuery queryWithClassName:kPlayEventClassKey];
    PFQuery *query = [PFQuery queryWithClassName:kPlayEventClassKey];

	if (currentLocation == nil) {
		NSLog(@"%s got a nil location!", __PRETTY_FUNCTION__);
	}
    
    NSLog(@"_eventsArray count = %d", [_eventsArray count]);
    
	// If no objects are loaded in memory, we look to the cache first to fill the table
	// and then subsequently do a query against the network.
	if ([_eventsArray count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        firstQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        invitedQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
    
	// Query for posts sort of kind of near our current location.
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[firstQuery whereKey:kPlayEventCoordinatesKey nearGeoPoint:point withinKilometers:kPlayMaximumSearchDistance];
    [firstQuery whereKey:kPlayEventTimeKey greaterThanOrEqualTo:[[NSDate date]dateByAddingTimeInterval:(-60*60*3)]];
    [firstQuery whereKey:kPLayEventIsPrivate equalTo:[NSNumber numberWithBool:FALSE]];
    //[firstQuery orderByAscending:kPlayEventTimeKey];
	//firstQuery.limit = kPlayQueryLimit;

    // A pull-to-refresh should always trigger a network request.
    [invitedQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [firstQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];

    //Add Last 5 invitied private event within last 3 days
    [invitedQuery whereKey:kPlayEventCoordinatesKey nearGeoPoint:point withinKilometers:kPlayMaximumSearchDistance];
    [invitedQuery whereKey:kPlayEventTimeKey greaterThan:[[NSDate date]dateByAddingTimeInterval:(-60*60*24*3)]];
    [invitedQuery whereKey:kPLayEventIsPrivate equalTo:[NSNumber numberWithBool:TRUE]];
    
    NSLog(@"PFUser currentUser is %@",[PFUser currentUser]);
    [invitedQuery whereKey:kPLayEventInvitedUsers equalTo:[PFUser currentUser]];
    //[invitedQuery orderByAscending:kPlayEventTimeKey];
    //invitedQuery.limit = kPlayInvitedQueryLimit;
    
    query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:firstQuery,invitedQuery,nil]];
    [query orderByAscending:kPlayEventTimeKey];
	query.limit = kPlayQueryLimit;
    [query includeKey:kPlayEventUserKey];
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		        
        if (error) {

            [SVProgressHUD dismiss];

			NSLog(@"error in geo query in QUERY!"); // todo why is this ever happening?
            
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Oh oh! Looks like we are having problems connecting to the internets"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Ok", nil];
            [alertView show];
            
		} else {
			// We need to make new post objects from objects,
			// and update allPosts and the map to reflect this new array.
			// But we don't want to remove all annotations from the mapview blindly,
			// so let's do some work to figure out what's new and what needs removing.
            
            NSLog(@"NSArray green pins count = %d", [objects count]);
            
            id userLocation = [_mapView userLocation];
            NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[_mapView annotations]];
            if (userLocation != nil) {
                [pins removeObject:userLocation]; // avoid removing user location off the map
            }
            [_mapView removeAnnotations:pins];
            
            if([objects count]<15){
                                
                PFQuery *queryGreyPins = [PFQuery queryWithClassName:kPlayEventClassKey];
                                
                // If no objects are loaded in memory, we look to the cache first to fill the table
                // and then subsequently do a query against the network.
                if ([_eventsArray count] == 0) {
                    queryGreyPins.cachePolicy = kPFCachePolicyCacheThenNetwork;
                }
                
                // Query for posts sort of kind of near our current location.
                [queryGreyPins whereKey:kPlayEventCoordinatesKey nearGeoPoint:point withinKilometers:kPlayMaximumSearchDistance];
                [queryGreyPins includeKey:kPlayEventUserKey];
                [queryGreyPins whereKey:kPlayEventTimeKey lessThan:[[NSDate date]dateByAddingTimeInterval:(-60*60*3)]];
                [queryGreyPins whereKey:kPLayEventIsPrivate equalTo:[NSNumber numberWithBool:FALSE]];
                [queryGreyPins orderByDescending:kPlayEventTimeKey];
                queryGreyPins.limit = (kPlayQueryLimit-[objects count]);
                
                // A pull-to-refresh should always trigger a network request.
                [queryGreyPins setCachePolicy:kPFCachePolicyNetworkOnly];

                [queryGreyPins findObjectsInBackgroundWithBlock:^(NSArray *greyPinObjects, NSError *error) {
                    
                    NSLog(@"NSArray grey pins count = %d", [greyPinObjects count]);

                    [SVProgressHUD dismiss];

                    if (error) {
                                                
                        NSLog(@"error in geo query in QUERYGREYPINS!"); // todo why is this ever happening?
                        
                        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Oh oh! Looks like we are having problems connecting to the internets"
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"Ok", nil];
                        [alertView show];
                        
                    } else {
                            [SVProgressHUD dismiss];
                            
                            NSLog(@"in else of geo query in INVITEDQUERY!"); // todo why is this ever happening?
                                                        
                            NSMutableArray *allNewEvents = [[NSMutableArray alloc] initWithCapacity:(kPlayQueryLimit)];
                            
                            for (PFObject *object in objects) {
                                Event *newEvent = [[Event alloc] initWithPFObject:object];
                                [allNewEvents addObject:newEvent];
                            }
                            
                            for (PFObject *greyObject in greyPinObjects) {
                                Event *newEvent = [[Event alloc] initWithPFObject:greyObject];
                                [allNewEvents addObject:newEvent];
                            }
                            
                            [_mapView addAnnotations:[allNewEvents copy]];
                            _eventsArray = [allNewEvents copy];
                        
                            }

                }];
            }else{
                        
                        [SVProgressHUD dismiss];
                                                
                        NSMutableArray *allNewEvents = [[NSMutableArray alloc] initWithCapacity:(kPlayQueryLimit)];
                        
                        for (PFObject *object in objects) {
                            Event *newEvent = [[Event alloc] initWithPFObject:object];
                            [allNewEvents addObject:newEvent];
                        }
                        
                        [_mapView addAnnotations:[allNewEvents copy]];
                        _eventsArray = [allNewEvents copy];
            
            }
            
            /* 1. Find genuinely new posts:
			NSMutableArray *newEvents = [[NSMutableArray alloc] initWithCapacity:kPlayQueryLimit];
			// (Cache the objects we make for the search in step 2:)
			NSMutableArray *allNewEvents = [[NSMutableArray alloc] initWithCapacity:kPlayQueryLimit];
			for (PFObject *object in objects) {
				Event *newEvent = [[Event alloc] initWithPFObject:object];
				[allNewEvents addObject:newEvent];
				BOOL found = NO;
				for (Event *currentEvent in _eventsArray) {
					if ([newEvent equalToEvent:currentEvent]) {
						found = YES;
                        //[_mapView removeAnnotation:newEvent];
                        //[_mapView addAnnotation:newEvent];
					}
				}
				if (!found) {
					[newEvents addObject:newEvent];
				}
			}
			// newPosts now contains our new objects.
            
			// 2. Find posts in allPosts that didn't make the cut.
			NSMutableArray *eventsToRemove = [[NSMutableArray alloc] initWithCapacity:kPlayQueryLimit];
			for (Event *currentEvent in _eventsArray) {
				BOOL found = NO;
				// Use our object cache from the first loop to save some work.
				for (Event *allNewEvent in allNewEvents) {
					if ([currentEvent equalToEvent:allNewEvent]) {
						found = YES;
                        //[_mapView removeAnnotation:currentEvent];
                        //[_mapView addAnnotation:currentEvent];
					}
				}
				if (!found) {
					[eventsToRemove addObject:currentEvent];
				}
			}
			// postsToRemove has objects that didn't come in with our new results.
            
			// At this point, newAllPosts contains a new list of post objects.
			// We should add everything in newPosts to the map, remove everything in postsToRemove,
			// and add newPosts to allPosts.
			[_mapView removeAnnotations:eventsToRemove];
			[_mapView addAnnotations:newEvents];
            
			[_eventsArray addObjectsFromArray:newEvents];
			[_eventsArray removeObjectsInArray:eventsToRemove];*/
            
			//self.mapPinsPlaced = YES;
		}
	}];
    
}

#pragma mark -
#pragma mark PinAnnotations

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *identifier = @"Event";
    if ([annotation isKindOfClass:[Event class]]) {
        
        Event *myAnnotation = (Event*) annotation;
                
        //NSLog(@"myAnnotation.iconType is %d",[myAnnotation.iconType intValue]);
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
                
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        
        float alpha = [PlayUtility returnAlphaForIconType:myAnnotation.startTime];
        
        if ([PlayUtility returnShouldImageBeGray:myAnnotation.startTime]) {
            annotationView.image = [PlayUtility greyImageForEventType:myAnnotation.iconType];
        }else{
            annotationView.image = [[PlayUtility imageForEventType:myAnnotation.iconType] imageByApplyingAlpha:alpha];
        }

        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
        
        /*NSDictionary *attributesForEvent = [[PlayCache sharedCache] getAttributesForEvent:myAnnotation.object];
        BOOL isEventHappening = NO;
        
        if (attributesForEvent) {

            int locationCheckins = [[[PlayCache sharedCache] locationCheckInCountForEvent:myAnnotation.object]intValue];
            
            if (locationCheckins > 0) {
                isEventHappening = YES;
                NSLog(@"in annotionView, isEventHappening is YES");
            }
        
        }else{
                        
            PFQuery *queryLocationCheckIns = [PFQuery queryWithClassName:kPlayActivityClassKey];
            [queryLocationCheckIns whereKey:kPlayActivityEventKey equalTo:myAnnotation.object];
            [queryLocationCheckIns whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsLocationCheckIn];
            [queryLocationCheckIns setCachePolicy:kPFCachePolicyNetworkOnly];
            
            [queryLocationCheckIns findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                if (objects.count > 0) {
                        NSLog(@"in annotionView, found a locationCheckin object for %@",objects);

                }];
        }*/
        
        //NSLog(@"Event icontype = %@, startTime = %@, endTime = %@",myAnnotation.iconType,myAnnotation.startTime,myAnnotation.endTime);
        

    }else{
        
        NSLog(@"inside else of viewForAnnotation, annotation is %@",annotation);
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([view annotation]){        
        DetailedEventViewController *detailedPinView =[[DetailedEventViewController alloc] initWithObject:[(Event*)[view annotation] getObject]];
        
        UINavigationController *navPinView = [[UINavigationController alloc] initWithRootViewController:detailedPinView];

        UIImage* image = [UIImage imageNamed:@"backarrow.png"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
        [someButton setBackgroundImage:image forState:UIControlStateNormal];
        [someButton addTarget:detailedPinView action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        [detailedPinView.navigationItem setLeftBarButtonItem:leftBarButton];
        
        [self presentViewController:navPinView animated:YES completion:nil];
                
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        //TO FIND WHICH EVENT YOU ARE ON
        //NSLog(@"av.annotation is %@",aV.annotation);
        
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options: UIViewAnimationOptionCurveLinear animations:^{
            
            aV.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            aV.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    }
}

- (UIImage*)captureView:(UIView *)view
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
    CGContextSaveGState(context);
    // Center the context around the window's anchor point
    CGContextTranslateCTM(context, [view center].x, [view center].y);
    // Apply the window's transform about the anchor point
    CGContextConcatCTM(context, [view transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[view bounds].size.width * [[view layer] anchorPoint].x,
                          -[view bounds].size.height * [[view layer] anchorPoint].y);

    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /* Save the image to photo album*/
    //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    
    return img;
}



@end