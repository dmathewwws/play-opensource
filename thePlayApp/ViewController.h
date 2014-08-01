//
//  ViewController.h
//  Eventfully
//
//  Created by Daniel Mathews on 2012-10-22.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "Event.h"
#import "EventFeedController.h"
#import "DetailedEventViewController.h"
#import "CheckInViewController.h"
#import "SportsCollectionViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "UserProfileTableViewController.h"

@interface ViewController : UIViewController <NSXMLParserDelegate, MKMapViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UIButton *checkInButton;
@property (strong,nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) UIButton *currentTemp;
@property (strong, nonatomic) UIButton *avatarPadding;
@property (strong, nonatomic) UIButton *tempPadding;
@property (strong, nonatomic) UIButton *currentWeather;

@property (strong, nonatomic) UIButton *refreshButton;
@property (strong, nonatomic) UIButton *locationFinderButton;

@property (nonatomic) BOOL mapViewInitiated;

@property (strong,nonatomic) NSXMLParser *xmlParserFlickr;
@property (strong,nonatomic) NSString *stringURLFlickr;
@property (strong,nonatomic) NSMutableString *currentStringFlickr;

@property (strong,nonatomic) NSXMLParser *xmlParserYahooW;
@property (strong,nonatomic) NSString *stringURLYahooW;
@property (strong,nonatomic) NSMutableString *temperatureStringYahooW;
@property (strong,nonatomic) NSMutableString *weatherStringYahooW;

@property (strong,nonatomic) NSDateFormatter *dateFormatterForTime;

@property (strong,nonatomic) NSDateFormatter *dateFormatter;
@property (strong,nonatomic) NSMutableArray *eventsArray;
@property (strong,nonatomic) NSNumberFormatter *numberFormatter;

@property (strong, nonatomic) UIButton *gotoFeed;
@property (strong, nonatomic) UIView *dataView;
@property (strong, nonatomic) PlayProfileImageView *avatarProfileImage;


- (void) displayProfileTapped:(id)sender;
- (void) XMLParseFlickr:(MKCoordinateRegion)mapRegion;
- (void) XMLParseYahooW:(NSString*)woeid;
- (void) userCheckIn:(UIGestureRecognizer *)gestureRecognizer;
- (void) openFeed:(UIGestureRecognizer *)gestureRecognizer;
- (void) logOutUserAction:(NSNotification *)note;

- (void) refreshTapped:(id)sender;
- (void) refreshPins:(id)sender;
- (void) updateProfilePic:(NSNotification *)note;


- (UIImage*)captureView:(UIView *)view;

- (void) initiateMap;
- (void) centerMap;


@end
