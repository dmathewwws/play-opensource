//
//  AppDelegate.h
//  Eventfully
//
//  Created by Daniel Mathews on 2012-10-22.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "RegisterOrLoginViewController.h"
#import "ViewController.h"
#import "CreateAccountViewController.h"
#import "Mixpanel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) Mixpanel *mixpanel;
@property (strong, nonatomic) NSString *deviceType;
@property (strong, nonatomic) NSDate *maxEndDateForRegionMonitoringTurnOff;
@property (nonatomic, assign) BOOL locationManagerIsSigChanges;

- (void)startLocationManager;
- (void)stopLocationManager;
- (void)startLocationManagerForMonitoringRegions:(CLRegion*)newRegion;
- (void)cleanUpRegionMonitoring;
- (void)cleanUpSpecificRegion:(PFObject*)event;
- (void)removeRegionMonitoring:(CLRegion*)removedRegion;

@end