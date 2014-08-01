//
//  AppDelegate.m
//  Eventfully
//
//  Created by Daniel Mathews on 2012-10-22.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayUtility.h"
#import "UIDeviceHardware.h"
#import "PlayConstants.h"
#import "GAI.h"
#import <Crashlytics/Crashlytics.h>

////////// CHANGE THESE VALUES ///////////////

#define MIXPANEL_TOKEN @"x"
#define MONITORREGIONLIMIT 20
#define TWITTER_CONSUMER_KEY @"x"
#define TWITTER_CONSUMER_SECRET @"x"
#define FACEBOOK_APP_ID @"x"
#define CRASHLYTICS @"x"
#define GA_CODE @"x"

#define PARSESANDBOXAPPID @"x"
#define PARSESANDBOXCLIENTID @"x"

#define PARSEPRODUCTIONAPPID @"x"
#define PARSEPRODUCTIONCLIENTID @"x"

////////// /////////////////////// ///////////////

@implementation AppDelegate

@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;
@synthesize mixpanel = _mixpanel;
@synthesize window = _window;
@synthesize locationManagerIsSigChanges;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
            
    [Parse setApplicationId:PARSEPRODUCTIONAPPID clientKey:PARSEPRODUCTIONCLIENTID];
    
    //[Parse setApplicationId:PARSESANDBOXAPPID clientKey:PARSESANDBOXCLIENTID];
    
    //[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    
    self.mixpanel = [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
        
    // Optional: automatically send uncaught exceptions to Google Analytics.
    //[GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    //[GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:GA_CODE];
    [tracker sendView:@"didFinishLaunchingWithOptions"];
    
    [Crashlytics startWithAPIKey:CRASHLYTICS];
    
    locationManagerIsSigChanges = NO;
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:kPlayFontName size:16] forKey:UITextAttributeFont];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:178.0f/255.0f blue:137.0f/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary: [[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal]];
    [attributes setValue:[UIFont fontWithName:kPlayFontName size:12] forKey:UITextAttributeFont];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:141.0f/255.0f green:141.0f/255.0f blue:141.0f/255.0f alpha:1.0f]];
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backarrow.png"] style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"backarrow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
    
    // If we have a cached user, we'll get it back here
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        NSLog(@"We have a current User");
         //A user was cached, so skip straight to the main view
        
        if(![currentUser objectForKey:kPlayUserProfilePictureSmallKey]){
            
            CreateAccountViewController *createAccountView = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
            
            if ([[currentUser objectForKey:kPlayUserSignupTypeKey] isEqualToString:@"twitter"]) {
                    [createAccountView setSignupType:kTwitterViewType];
            }
            else{
                    [createAccountView setSignupType:kFacebookViewType];
                
            }
            _window.rootViewController= createAccountView;
            return YES;
            
        }else{
            
        ViewController *mapView = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MapViewController"];
        
        _window.rootViewController = mapView;
            
        // Extract the notification data
        NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
            
            NSLog(@"notificationPayload is %@",notificationPayload);

            if(notificationPayload){
                
                // Create a pointer to the Photo object
                NSString *eventId = [notificationPayload objectForKey:@"e"];
                NSString *userId = [notificationPayload objectForKey:@"u"];
                
                if (eventId) {
                    
                    PFObject *targetPhoto = [PFObject objectWithoutDataWithClassName:kPlayEventClassKey objectId:eventId];
                    
                    // Fetch photo object
                    [targetPhoto fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        // Show photo view controller
                        if (!error) {
                            
                            DetailedEventViewController *detailedPinView = [[DetailedEventViewController alloc] initWithObject:object];;
                            
                            UINavigationController *navPinView = [[UINavigationController alloc] initWithRootViewController:detailedPinView];
                            
                            UIImage* image = [UIImage imageNamed:@"backarrow.png"];
                            CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
                            UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
                            [someButton setBackgroundImage:image forState:UIControlStateNormal];
                            [someButton addTarget:detailedPinView action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
                            UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
                            [detailedPinView.navigationItem setLeftBarButtonItem:leftBarButton];
                            
                            [_window.rootViewController presentViewController:navPinView animated:YES completion:nil];
                            
                        }
                    }];
                }else if (userId){
                    
                    PFObject *targetUser = [PFUser objectWithoutDataWithObjectId:userId];
                    
                    // Fetch photo object
                    [targetUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        // Show photo view controller
                        if (!error) {
                            
                            UserProfileTableViewController *displayProfileView = [[UserProfileTableViewController alloc] initWithStyle:UITableViewStylePlain];
                            [displayProfileView setUser:(PFUser*)object];
                            
                            UINavigationController *navPinView = [[UINavigationController alloc] initWithRootViewController:displayProfileView];
                            
                            UIImage* image = [UIImage imageNamed:@"backarrow.png"];
                            CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
                            UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
                            [someButton setBackgroundImage:image forState:UIControlStateNormal];
                            [someButton addTarget:displayProfileView action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
                            UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
                            [displayProfileView.navigationItem setLeftBarButtonItem:leftBarButton];
                            [displayProfileView.navigationItem setHidesBackButton:YES];
                            
                            [_window.rootViewController presentViewController:navPinView animated:YES completion:nil];
                            
                        }
                    }];
                }

            }
            
        return YES;
        }
        
    }
    
    _mixpanel = [Mixpanel sharedInstance];
    [_mixpanel track:@"Enter LaunchTour"];
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationDidEnterBackground");
    [self cleanUpRegionMonitoring];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [self startLocationManager];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }

    //[[NSNotificationCenter defaultCenter] postNotificationName:PlayUtilityUserRefreshPinsNotificationBecauseAppLaunched object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   // [self stopLocationManager];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Location Manager

- (void)startLocationManager{
    if ([CLLocationManager locationServicesEnabled]) {
       
        if (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)){
            if (!_locationManager) {
                _locationManager = [[CLLocationManager alloc] init];
                _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
                
                _locationManager.distanceFilter = 10;
                //have to move 100m before location manager checks again
                
                _locationManager.delegate = self;
                NSLog(@"new location Manager in startLocationManager");
                
            }
            
            if(locationManagerIsSigChanges){
                [_locationManager stopMonitoringSignificantLocationChanges];
                locationManagerIsSigChanges = NO;
            }
            
            [_locationManager startUpdatingLocation];
            NSLog(@"Start Regular Location Manager");

        }else{
            
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Location services are disabled, Please go into Settings > Privacy > Location to enable them for Play"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Ok", nil];
            [alertView show];
        }
    }
}

-(void)stopLocationManager{
    if ([CLLocationManager locationServicesEnabled]) {
        if (_locationManager) {
            if(!locationManagerIsSigChanges){
                [_locationManager stopUpdatingLocation];
                NSLog(@"Stop Regular Location Manager");
                //_locationManager = nil;
                //_locationManager.delegate = nil;

            }
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation * loc = [locations objectAtIndex: [locations count] - 1];
    
    NSString *locationDetials = [NSString stringWithFormat:@"Time %@, latitude %+.6f, longitude %+.6f currentLocation accuracy %1.2f loc accuracy %1.2f timeinterval %d",[NSDate date],
          _currentLocation.coordinate.latitude,
          _currentLocation.coordinate.longitude, _currentLocation.horizontalAccuracy, loc.horizontalAccuracy, abs([loc.timestamp timeIntervalSinceNow])];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"didUpdateLocations"
             properties:[NSDictionary dictionaryWithObjectsAndKeys:locationDetials, @"Location Details", nil]];
    
    if(!locationManagerIsSigChanges){
        NSTimeInterval locationAge = -[loc.timestamp timeIntervalSinceNow];
        if (locationAge > 10.0){
            NSLog(@"locationAge is %1.2f",locationAge);
            return;
        }
        
        if (loc.horizontalAccuracy < 0){
            NSLog(@"loc.horizontalAccuracy is %1.2f",loc.horizontalAccuracy);
            return;
        }
        
        if (_currentLocation == Nil || _currentLocation.horizontalAccuracy >= loc.horizontalAccuracy){
            _currentLocation = loc;
            
            NSLog(@"New CurrentLocation with loc.horizontalAccuracy = %1.6f and _locationManager.desiredAccuracy = %1.6f",loc.horizontalAccuracy,_locationManager.desiredAccuracy);
            
            [mixpanel track:@"New currentLocation" properties:[NSDictionary dictionaryWithObjectsAndKeys:locationDetials, @"Location Details", nil]];

            if (loc.horizontalAccuracy <= _locationManager.desiredAccuracy) {
                [self stopLocationManager];
                [mixpanel track:@"Stop Location Manager" properties:[NSDictionary dictionaryWithObjectsAndKeys:locationDetials, @"Location Details", nil]];
            }
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    if ( [error code] != kCLErrorLocationUnknown ){
        if(!locationManagerIsSigChanges){
            [self stopLocationManager];
        }
    }
}

- (void)startLocationManagerForMonitoringRegions:(CLRegion*)newRegion{
    if ([CLLocationManager locationServicesEnabled]) {
        
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            _locationManager.distanceFilter = 10;
            //have to move 100m before location manager checks again
            
            _locationManager.delegate = self;
            NSLog(@"new location Manager in startLocationManagerForMonitoringRegions");

        }
        if ([CLLocationManager regionMonitoringAvailable]) {
            
            NSLog(@"can monitor regions, startedMonitoring for: %@",newRegion);
            [_locationManager startMonitoringForRegion:newRegion];
                
        }else{
            NSLog(@"cannot monitor regions");
        }
    }
}

- (void)cleanUpRegionMonitoring{    
    if ([CLLocationManager locationServicesEnabled]) {
        
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            _locationManager.distanceFilter = 10;
            //have to move 100m before location manager checks again
            
            _locationManager.delegate = self;
            NSLog(@"new location Manager in startLocationManagerForMonitoringRegions");
        }
    
        if ([_locationManager monitoredRegions].count == 0) {
            return;
        
        }else{
            for (CLRegion* monitoredRegion in [_locationManager monitoredRegions]){
                
                NSLog(@"%@ is still being Monitored",monitoredRegion);
                
                PFObject *event = [PFObject objectWithoutDataWithClassName:kPlayEventClassKey objectId:monitoredRegion.identifier];
                [event fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    
                    NSLog(@"event identified End Date is %@",[object valueForKey:kPlayEventEndTimeKey]);
                    if ([[NSDate date] compare:[object valueForKey:kPlayEventEndTimeKey]] == NSOrderedDescending){
                        [self removeRegionMonitoring:monitoredRegion];
                        NSLog(@"removed Region:%@",monitoredRegion);

                    }
                }];
            }
        }
    }
    return;
}

- (void)cleanUpSpecificRegion:(PFObject*)event{
    if ([CLLocationManager locationServicesEnabled]) {
        
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            _locationManager.distanceFilter = 10;
            //have to move 100m before location manager checks again
            
            _locationManager.delegate = self;
            NSLog(@"new location Manager in startLocationManagerForMonitoringRegions");
        }
        
        if ([_locationManager monitoredRegions].count == 0) {
            return;
            
        }else{
            for (CLRegion* monitoredRegion in [_locationManager monitoredRegions]){
                if([monitoredRegion.identifier isEqualToString:[event objectId]]){
                    [self removeRegionMonitoring:monitoredRegion];
                }
            }
        }
    }
    return;
}


- (void)removeRegionMonitoring:(CLRegion*)removedRegion {
    if ([CLLocationManager locationServicesEnabled]) {
        
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            _locationManager.distanceFilter = 10;
            //have to move 100m before location manager checks again
            
            _locationManager.delegate = self;
            NSLog(@"new location Manager in startLocationManagerForMonitoringRegions");
        }
        
        [_locationManager stopMonitoringForRegion:removedRegion];
        
    }
    return;
}

#pragma mark -
#pragma mark Location Mangager Region Monitoring

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
    PFObject *event = [PFObject objectWithoutDataWithClassName:kPlayEventClassKey objectId:region.identifier];
    [event fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if ([[[NSDate date]dateByAddingTimeInterval:(-60*30)] compare:[object valueForKey:kPlayEventTimeKey]] == NSOrderedDescending){
            return;
        }else if ([[NSDate date] compare:[object valueForKey:kPlayEventEndTimeKey]] == NSOrderedDescending){
            [self removeRegionMonitoring:region];
        }else{
            
            [PlayUtility locationCheckIntoEventByRegionMonitoringInBackground:object block:^(BOOL succeeded, NSError *error){
                if (succeeded) {
                        [self removeRegionMonitoring:region];
                }
            }];
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    /*UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"did Exit Region for: "
                                                      message:region.identifier
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];*/
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    
    PFObject *event = [PFObject objectWithoutDataWithClassName:kPlayEventClassKey objectId:region.identifier];
    [event fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        /*UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"did Start Region Monitoring for: "
                                                          message:event.description
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];*/
    }];

}

#pragma mark -
#pragma mark Facebook Connect

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

#pragma mark -
#pragma mark Push Notifications

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //Be careful, you make not have a PFUser currentUser
    
    PFUser *currentUser = [PFUser currentUser];
    
    if(currentUser){
        
        NSLog(@"in currentUser for didRegisterForRemoteNotificationsWithDeviceToken");
        // Store the deviceToken in the current installation and save it to Parse.
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:currentUser forKey:kPlayInstallationUserKey];
        [currentInstallation setObject:[NSArray arrayWithObjects:[PlayUtility returnUserPrivateChannel:currentUser.objectId], nil] forKey:kPlayInstallationChannelsKey];
        [currentInstallation setDeviceTokenFromData:deviceToken];
        [currentInstallation saveInBackground];
        
        [currentUser setObject:[PlayUtility returnUserPrivateChannel:currentUser.objectId] forKey:kPlayUserPrivateChannelKey];
        [currentUser setObject:[NSNumber numberWithBool:YES] forKey:kPlayUseriOSAskPushRegistrationKey];
        [currentUser saveInBackground];
        
    }else{
        NSLog(@"Error! No currentUser for didRegisterForRemoteNotificationsWithDeviceToken");
    }
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Failed to register for Push, error %@",error.description);
    
    PFUser *currentUser = [PFUser currentUser];
    
    if(currentUser){
        NSLog(@"in currentUser for didFailToRegisterForRemoteNotificationsWithError");
        [currentUser setObject:[NSNumber numberWithBool:NO] forKey:kPlayUseriOSAskPushRegistrationKey];
        [currentUser saveInBackground];
    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [PFPush handlePush:userInfo];
    
    if(userInfo){
        
        // Create a pointer to the Photo object
        NSString *eventId = [userInfo objectForKey:@"e"];
        NSString *userId = [userInfo objectForKey:@"u"];
            
        if (eventId) {
                    
            PFObject *targetPhoto = [PFObject objectWithoutDataWithClassName:kPlayEventClassKey objectId:eventId];
            
            // Fetch photo object
            [targetPhoto fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                // Show photo view controller
                if (!error) {
                    
                    DetailedEventViewController *detailedPinView = [[DetailedEventViewController alloc] initWithObject:object];;
                    
                    UINavigationController *navPinView = [[UINavigationController alloc] initWithRootViewController:detailedPinView];
                    
                    UIImage* image = [UIImage imageNamed:@"backarrow.png"];
                    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
                    [someButton setBackgroundImage:image forState:UIControlStateNormal];
                    [someButton addTarget:detailedPinView action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
                    [detailedPinView.navigationItem setLeftBarButtonItem:leftBarButton];
                    
                    [_window.rootViewController presentViewController:navPinView animated:YES completion:nil];
                    
                }
            }];
        }else if (userId){
                        
            PFObject *targetUser = [PFUser objectWithoutDataWithObjectId:userId];
            
            // Fetch photo object
            [targetUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                // Show photo view controller
                if (!error) {
                    
                    
                    UserProfileTableViewController *displayProfileView = [[UserProfileTableViewController alloc] initWithStyle:UITableViewStylePlain];
                    [displayProfileView setUser:(PFUser*)object];
                    
                    UINavigationController *navPinView = [[UINavigationController alloc] initWithRootViewController:displayProfileView];
                    
                    UIImage* image = [UIImage imageNamed:@"backarrow.png"];
                    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
                    [someButton setBackgroundImage:image forState:UIControlStateNormal];
                    [someButton addTarget:displayProfileView action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
                    [displayProfileView.navigationItem setLeftBarButtonItem:leftBarButton];
                    [displayProfileView.navigationItem setHidesBackButton:YES];
                    
                    [_window.rootViewController presentViewController:navPinView animated:YES completion:nil];
                    
                }
            }];
        }
    }
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }

}

@end