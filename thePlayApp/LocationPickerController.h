//
//  LocationPickerController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-02-21.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "Event.h"

@protocol LocationPickerControllerDelegate;

@interface LocationPickerController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *foursquareResponses;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocation *touchLocation;
@property (strong, nonatomic) NSArray *venueArray;
@property (strong, nonatomic) Event *theEventAnnotation;
@property (strong, nonatomic) UIButton *locationFinderButton;
@property (strong, nonatomic) NSNumber *eventIconType;

/*! @name Delegate */
@property (nonatomic, strong) id<LocationPickerControllerDelegate> delegate;

- (void) handleLongPress:(UIGestureRecognizer *)gestureRecognizer;
- (void) centerMap;
- (void) sTouchLocation:(CLLocation *)touchLocation;
- (void)backButtonPressed:(id)sender;

@end

@protocol LocationPickerControllerDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the photgrapher's name/avatar is tapped
 @param button the tapped UIButton
 @param user the PFUser for the photograper
 */
- (void)locationPickerController:(LocationPickerController*)locationPickerController currentLocation:(CLLocation*)currentLocation venueArray:(NSArray*)venueArray indexArray:(NSInteger)indexArray;

@end
