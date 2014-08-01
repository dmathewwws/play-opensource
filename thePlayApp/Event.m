//
//  Event.m
//  Eventfully
//
//  Created by Daniel Mathews on 2012-10-22.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "Event.h"
#import "PlayUtility.h"

@implementation Event

@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;
@synthesize object = _object;
@synthesize geopoint = _geopoint;
@synthesize user = _user;
@synthesize iconType = _iconType;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize locationName = _locationName;
@synthesize type = _type;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle {
	self = [super init];
	if (self) {
		_coordinate = aCoordinate;
		_title = aTitle;
		_subtitle = aSubtitle;
	}
	return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate{
	self = [super init];
	if (self) {
		_coordinate = aCoordinate;
	}
	return self;
}

- (id)initWithPFObject:(PFObject *)anObject {

    [anObject fetchIfNeeded];
    
    _object = anObject;
	_geopoint = [anObject objectForKey:kPlayEventCoordinatesKey];
	_user = [anObject objectForKey:kPlayEventUserKey];
    _iconType = [anObject objectForKey:kPlayEventIconTypeKey];
    _startTime = [anObject objectForKey:kPlayEventTimeKey];
    _endTime = [anObject objectForKey:kPlayEventEndTimeKey];
    _type = [anObject objectForKey:kPlayEventTypeKey];
    NSArray *locationDic = [anObject objectForKey:kPlayEventLocationKey];
    _locationName = [locationDic objectAtIndex:1];
    
	CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(_geopoint.latitude, _geopoint.longitude);
	
    NSString *aTitle = [NSString stringWithFormat:@"%@ @ %@",_type,_locationName];
    NSString *aSubtitle = @"";
    
	return [self initWithCoordinate:aCoordinate andTitle:aTitle andSubtitle:aSubtitle];
}

- (BOOL)equalToEvent:(Event *)anEvent{
	if (anEvent == nil) {
		return NO;
	}
    
	if (anEvent.object && _object) {
		// We have a PFObject inside the Event, use that instead.
		if ([anEvent.object.objectId compare:self.object.objectId] != NSOrderedSame) {
			return NO;
		}
		return YES;
	} else {
		// Fallback code:
		return NO;
	}
}

-(PFObject *)getObject{
    return _object;
}

- (NSString *) title{
    return _title;
}

- (NSString *) subtitle{
    return _subtitle;
}

@end