//
//  Event.h
//  Eventfully
//
//  Created by Daniel Mathews on 2012-10-22.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"
#import <Parse/Parse.h>
#import "PlayConstants.h"

@interface Event : NSObject <MKAnnotation>

@property  (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *locationName;
@property (copy, nonatomic) NSNumber *iconType;
@property (copy, nonatomic) NSDate *startTime;
@property (copy, nonatomic) NSDate *endTime;

@property (copy, nonatomic) PFObject *object;
@property (nonatomic, readonly, strong) PFGeoPoint *geopoint;
@property (nonatomic, readonly, strong) PFUser *user;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle;
- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
- (id)initWithPFObject:(PFObject *)anObject;
- (BOOL)equalToEvent:(Event *)anEvent;
- (PFObject*)getObject;

- (NSString *)title;
- (NSString *)subtitle;

@end