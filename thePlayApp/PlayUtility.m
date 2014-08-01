//
//  PlayUtility.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-05.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "PlayUtility.h"
#import "PlayConstants.h"
#import "PlayCache.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@implementation PlayUtility

+ (PFQuery *)queryForActivitiesOnEvent:(PFObject *)event cachePolicy:(PFCachePolicy)cachePolicy{
    PFQuery *queryCheckIns = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [queryCheckIns whereKey:kPlayActivityEventKey equalTo:event];
    [queryCheckIns whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsCheckIn];

    PFQuery *queryLocationCheckIns = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [queryLocationCheckIns whereKey:kPlayActivityEventKey equalTo:event];
    [queryLocationCheckIns whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsLocationCheckIn];
    
    PFQuery *queryComments = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [queryComments whereKey:kPlayActivityEventKey equalTo:event];
    [queryComments whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsComment];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryCheckIns,queryComments,queryLocationCheckIns,nil]];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kPlayActivityFromUserKey];
    [query includeKey:kPlayActivityEventKey];
    
    return query;
    
}

+ (void)queryForActivitiesOnEventForDelete:(PFObject *)event{
    PFQuery *query = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [query whereKey:kPlayActivityEventKey equalTo:event];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteInBackground];
            }
                PFObject *eventQuery = [PFObject objectWithoutDataWithClassName:kPlayEventClassKey objectId:event.objectId];
                [eventQuery deleteInBackground];
                [[PlayCache sharedCache] setAttributes:[NSDictionary dictionary] forEvent:event];
                [[NSNotificationCenter defaultCenter] postNotificationName:PlayUtilityUserRefreshPinsNotificationBecauseEventDeleted object:nil];
        
            }
    }];
}

+ (void)checkIntoEventInBackground:(id)event locationCheckIn:(BOOL)locationCheckIn block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFObject *eventObject = event;
    PFObject *eventQuery = [PFObject objectWithoutDataWithClassName:kPlayEventClassKey objectId:eventObject.objectId];
    [eventQuery fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error2) {
        if (error2) {
            NSLog(@"in checkIntoEventInBackground no object found");
            
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"This event no longer exists!"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Ok", nil];
            [alertView show];

            completionBlock(NO,error2);
            return ;
        }else{
            
            NSLog(@"in checkIntoEventInBackground object found");

            //find current checkin
            PFQuery *queryExistingCheckIns = [PFQuery queryWithClassName:kPlayActivityClassKey];
            [queryExistingCheckIns whereKey:kPlayActivityEventKey equalTo:event];
            [queryExistingCheckIns whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsCheckIn];
            [queryExistingCheckIns whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];
            
            PFQuery *queryExistingLocationLikes = [PFQuery queryWithClassName:kPlayActivityClassKey];
            [queryExistingLocationLikes whereKey:kPlayActivityEventKey equalTo:event];
            [queryExistingLocationLikes whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsLocationCheckIn];
            [queryExistingLocationLikes whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];
            
            PFQuery *bothQueries = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryExistingCheckIns,queryExistingLocationLikes,nil]];
            [bothQueries setCachePolicy:kPFCachePolicyNetworkOnly];
            
            [bothQueries findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
                if (!error) {
                    for (PFObject *activity in activities) {
                        [activity deleteInBackground];
                    }
                }
                
                // proceed to creating new checkin
                PFObject *checkInActivity = [PFObject objectWithClassName:kPlayActivityClassKey];
                [checkInActivity setObject:kPlayActivityTypeIsCheckIn forKey:kPlayActivityTypeKey];
                [checkInActivity setObject:[PFUser currentUser] forKey:kPlayActivityFromUserKey];
                [checkInActivity setObject:[event objectForKey:kPlayEventUserKey] forKey:kPlayActivityToUserKey];
                [checkInActivity setObject:event forKey:kPlayActivityEventKey];
                
                PFACL *checkInACL = [PFACL ACLWithUser:[PFUser currentUser]];
                [checkInACL setPublicReadAccess:YES];
                [checkInACL setWriteAccess:YES forUser:[event objectForKey:kPlayEventUserKey]];
                checkInActivity.ACL = checkInACL;
                
                [checkInActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (completionBlock) {
                        completionBlock(succeeded,error);
                        
                        if(!error){
                            
                            NSLog(@"No error here");
                            /*UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Would you like this event added to your calendar?"
                                                                               message:nil
                                                                              delegate:self
                                                                     cancelButtonTitle:@"No"
                                                                     otherButtonTitles:@"Yes", nil];
                            [alertView show];*/
                        }
                    }
                    
                    if(locationCheckIn){
                        PFObject *locationCheckInActivity = [PFObject objectWithClassName:kPlayActivityClassKey];
                        [locationCheckInActivity setObject:kPlayActivityTypeIsLocationCheckIn forKey:kPlayActivityTypeKey];
                        [locationCheckInActivity setObject:[PFUser currentUser] forKey:kPlayActivityFromUserKey];
                        [locationCheckInActivity setObject:[event objectForKey:kPlayEventUserKey] forKey:kPlayActivityToUserKey];
                        [locationCheckInActivity setObject:event forKey:kPlayActivityEventKey];
                        
                        locationCheckInActivity.ACL = checkInACL;
                        
                        [locationCheckInActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (completionBlock) {
                                completionBlock(succeeded,error);
                                
                            }
                        }];
                        
                    }else{
                        
                        // set StartMonitoringforLocationCheckIn
                        
                        if ([[[PFUser currentUser] objectForKey:kPlayUserLocationCheckInKey] boolValue]) {
                            PFGeoPoint *eventCoordinates = [event objectForKey:kPlayEventCoordinatesKey];
                            NSString *eventKey = [event objectId];
                            
                            CLRegion *eventRegion = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(eventCoordinates.latitude, eventCoordinates.longitude) radius:kPlayGeofenceRadius identifier:eventKey];
                            
                            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                            
                            [appDelegate startLocationManagerForMonitoringRegions:eventRegion];
                        }
                        
                    }
                    
                    
                    /* Send Push Notification
                     
                     if (succeeded && ![[[photo objectForKey:kPAPPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                     NSString *privateChannelName = [[photo objectForKey:kPAPPhotoUserKey] objectForKey:kPAPUserPrivateChannelKey];
                     if (privateChannelName && privateChannelName.length != 0) {
                     NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSString stringWithFormat:@"%@ likes your photo.", [PAPUtility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]]], kAPNSAlertKey,
                     kPAPPushPayloadPayloadTypeActivityKey, kPAPPushPayloadPayloadTypeKey,
                     kPAPPushPayloadActivityLikeKey, kPAPPushPayloadActivityTypeKey,
                     [[PFUser currentUser] objectId], kPAPPushPayloadFromUserObjectIdKey,
                     [photo objectId], kPAPPushPayloadPhotoObjectIdKey,
                     nil];
                     PFPush *push = [[PFPush alloc] init];
                     [push setChannel:privateChannelName];
                     [push setData:data];
                     [push sendPushInBackground];
                     }
                     }*/
                    
                    // refresh cache
                    [self refreshCacheforEvent:event checkedIn:YES];
                    
                }];
            }];
            
            /*
             // like photo in Facebook if possible
             NSString *fbOpenGraphID = [photo 465];
             if (fbOpenGraphID && fbOpenGraphID.length > 0) {
             NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
             NSString *objectURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@", fbOpenGraphID];
             [params setObject:objectURL forKey:@"object"];
             [[PFFacebookUtils facebook] requestWithGraphPath:@"me/og.likes" andParams:params andHttpMethod:@"POST" andDelegate:nil];
             }
             */
        }
    }];
    
    
}

+ (void)locationCheckIntoEventByRegionMonitoringInBackground:(id)event block:(void (^)(BOOL succeeded, NSError *error))completionBlock{

    //find current checkin
    PFQuery *queryExistingLocationLikes = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [queryExistingLocationLikes whereKey:kPlayActivityEventKey equalTo:event];
    [queryExistingLocationLikes whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsLocationCheckIn];
    [queryExistingLocationLikes whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLocationLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    
    [queryExistingLocationLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteInBackground];
            }
        }
            PFObject *locationCheckInActivity = [PFObject objectWithClassName:kPlayActivityClassKey];
            [locationCheckInActivity setObject:kPlayActivityTypeIsLocationCheckIn forKey:kPlayActivityTypeKey];
            [locationCheckInActivity setObject:[PFUser currentUser] forKey:kPlayActivityFromUserKey];
            [locationCheckInActivity setObject:[event objectForKey:kPlayEventUserKey] forKey:kPlayActivityToUserKey];
            [locationCheckInActivity setObject:event forKey:kPlayActivityEventKey];
            
            PFACL *checkInACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [checkInACL setPublicReadAccess:YES];
            [checkInACL setWriteAccess:YES forUser:[event objectForKey:kPlayEventUserKey]];            
            locationCheckInActivity.ACL = checkInACL;
            
            [locationCheckInActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (completionBlock) {
                    completionBlock(succeeded,error);
                }
            }];

        //refresh cache
        [self refreshCacheforEvent:event checkedIn:YES];
    }];
}

+ (void)uncheckIntoEventInBackground:(id)event block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [queryExistingLikes whereKey:kPlayActivityEventKey equalTo:event];
    [queryExistingLikes whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsCheckIn];
    [queryExistingLikes whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];
    
    PFQuery *queryExistingLocationLikes = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [queryExistingLocationLikes whereKey:kPlayActivityEventKey equalTo:event];
    [queryExistingLocationLikes whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsLocationCheckIn];
    [queryExistingLocationLikes whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];

    PFQuery *bothQueries = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryExistingLikes,queryExistingLocationLikes,nil]];
    [bothQueries setCachePolicy:kPFCachePolicyNetworkOnly];

    [bothQueries findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteInBackground];
            }
            
            [self refreshCacheforEvent:event checkedIn:NO];
            
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            
            [appDelegate cleanUpSpecificRegion:(PFObject*)event];
                        
            if (completionBlock) {
                completionBlock(YES,nil);
            }
            
        } else {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
     }];
}

+ (BOOL)islocationCheckInTrue:(PFObject*)event currentLocation:(CLLocation*)currentLocation{
    if ([[[NSDate date]dateByAddingTimeInterval:(-60*30)] compare:[event valueForKey:kPlayEventTimeKey]] == NSOrderedDescending){
        return FALSE;
    }else if(![[[PFUser currentUser] objectForKey:kPlayUserLocationCheckInKey] boolValue]){
        //NSLog(@"in locationcheckin ![[[PFUser currentUser] objectForKey:kPlayUserLocationCheckInKey] boolValue]");
        return FALSE;
    }
    
    PFGeoPoint *eventCoordinates = [event objectForKey:kPlayEventCoordinatesKey];
    NSString *eventKey = [event objectId];
    
    NSLog(@"currentLocation is %@",currentLocation);
    NSLog(@"eventCoordinates is %@",eventCoordinates);
    
    CLRegion *regionAroundCurrentLocation = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(eventCoordinates.latitude, eventCoordinates.longitude) radius:kPlayGeofenceRadius identifier:eventKey];
    
    if([regionAroundCurrentLocation containsCoordinate:CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)]){
        
        NSLog(@"In regionAroundCurrentLocation is TRUE");
        return TRUE;
    }else{

        NSLog(@"In regionAroundCurrentLocation is FALSE");
        return FALSE;
    }
}

+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kPlayActivityClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kPlayActivityFromUserKey];
    [followActivity setObject:user forKey:kPlayActivityToUserKey];
    [followActivity setObject:kPlayActivityTypeIsFollow forKey:kPlayActivityTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [[PlayCache sharedCache] setFollowStatus:YES user:user];
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayUtilityFollowingCountChanged object:nil];
    [followActivity saveInBackgroundWithBlock:completionBlock];
    
    if([user objectForKey:kPlayUserPrivateChannelKey]){
     
        PFQuery *oldFollowQuery = [PFQuery queryWithClassName:kPlayActivityClassKey];
        [oldFollowQuery whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];
        [oldFollowQuery whereKey:kPlayActivityToUserKey equalTo:user];
        [oldFollowQuery whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsOldFollow];
        [oldFollowQuery findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
            // While normally there should only be one follow activity returned, we can't guarantee that.
            
            if (!error &&followActivities.count == 0) {
                
                [self pushNotificationsinBackground:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     [NSString stringWithFormat:@"Yea! %@ is now following you",[PFUser currentUser].username], @"alert",
                                                     [PFUser currentUser].objectId,@"u",
                                                     @"Increment", @"badge",nil] pushUsers:[NSSet setWithObject:[self returnUserPrivateChannel:user.objectId]]];
            }
        }];
        
    }
    
}

+ (void)setFirstFollowerEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kPlayActivityClassKey];
    [followActivity setObject:user forKey:kPlayActivityFromUserKey];
    [followActivity setObject:[PFUser currentUser] forKey:kPlayActivityToUserKey];
    [followActivity setObject:kPlayActivityTypeIsFollow forKey:kPlayActivityTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:user];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveInBackgroundWithBlock:completionBlock];
    
}

+ (void)unfollowUserEventually:(PFUser *)user  block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }    
    
    PFQuery *query = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [query whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kPlayActivityToUserKey equalTo:user];
    [query whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
        // While normally there should only be one follow activity returned, we can't guarantee that.
        
        if (!error) {
            [[PlayCache sharedCache] setFollowStatus:NO user:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:PlayUtilityFollowingCountChanged object:nil];
            
            for (PFObject *followActivity in followActivities) {
                [followActivity deleteInBackgroundWithBlock:completionBlock];
            }
        }
    }];
        
    PFObject *oldFollowActivity = [PFObject objectWithClassName:kPlayActivityClassKey];
    [oldFollowActivity setObject:[PFUser currentUser] forKey:kPlayActivityFromUserKey];
    [oldFollowActivity setObject:user forKey:kPlayActivityToUserKey];
    [oldFollowActivity setObject:kPlayActivityTypeIsOldFollow forKey:kPlayActivityTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    oldFollowActivity.ACL = followACL;
    
    [oldFollowActivity saveInBackground];
    
}

+ (NSString*)indexRow:(NSInteger)indexRow{

    NSString *userlocation = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];

    switch (indexRow) {
        case 0:
            if ([userlocation isEqualToString:@"US"] || [userlocation isEqualToString:@"CA"]){
                return SportPickedisSoccer;
            }else{
                return SportPickedisFootball;
            }
        case 1:
            return SportPickedisBasketball;
        case 2:
            if ([userlocation isEqualToString:@"US"] || [userlocation isEqualToString:@"CA"]){
                return SportPickedisFootball;
            }else{
                return SportPickedisAmericanFootball;
            }
        case 3:
            return SportPickedisHockey;
        case 4:
            return SportPickedisVolleyBall;
        case 5:
            return SportPickedisBaseball;
        case 6:
            return SportPickedisTennis;
        case 7:
            return SportPickedisFrisbee;
        case 8:
            return SportPickedisRunning;
        case 9:
            return SportPickedisYoga;
        case 10:
            return SportPickedisClimbing;
        case 11:
            return SportPickedisWildcard;
        default:
            return SportPickedisWildcard;
    }
}

+ (UIImage*)greyFeedImageForEventType:(NSNumber*)indexRow{
    
    int intIndexRow = [indexRow intValue];
    
    switch (intIndexRow) {
        case 0:
            return [UIImage imageNamed:@"sport0minig.png"];
        case 1:
            return [UIImage imageNamed:@"sport1minig.png"];
        case 2:
            return [UIImage imageNamed:@"sport2minig.png"];
        case 3:
            return [UIImage imageNamed:@"sport3minig.png"];
        case 4:
            return [UIImage imageNamed:@"sport4minig.png"];
        case 5:
            return [UIImage imageNamed:@"sport5minig.png"];
        case 6:
            return [UIImage imageNamed:@"sport6minig.png"];
        case 7:
            return [UIImage imageNamed:@"sport7minig.png"];
        case 8:
            return [UIImage imageNamed:@"sport8minig.png"];
        case 9:
            return [UIImage imageNamed:@"sport9minig.png"];
        case 10:
            return [UIImage imageNamed:@"sport10minig.png"];
        case 11:
            return [UIImage imageNamed:@"sport11minig.png"];
        default:
            return [UIImage imageNamed:@"sport11minig.png"];
    }
}

+ (UIImage*)greyTopSportsImagesForProfile:(NSString*)sportType{
    
    if ([sportType isEqualToString:@"countOfIcon0"]){
        return [UIImage imageNamed:@"sport0minig.png"];
        
    }else if([sportType isEqualToString:@"countOfIcon1"]){
        return [UIImage imageNamed:@"sport1minig.png"];

    }else if([sportType isEqualToString:@"countOfIcon2"]){
        return [UIImage imageNamed:@"sport2minig.png"];
        
    }else if([sportType isEqualToString:@"countOfIcon3"]){
        return [UIImage imageNamed:@"sport3minig.png"];
        
    }else if([sportType isEqualToString:@"countOfIcon4"]){
        return [UIImage imageNamed:@"sport4minig.png"];
        
    }else if([sportType isEqualToString:@"countOfIcon5"]){
        return [UIImage imageNamed:@"sport5minig.png"];
        
    }else if([sportType isEqualToString:@"countOfIcon6"]){
        return [UIImage imageNamed:@"sport6minig.png"];
        
    }else if([sportType isEqualToString:@"countOfIcon7"]){
        return [UIImage imageNamed:@"sport7minig.png"];
        
    }else if([sportType isEqualToString:@"countOfIcon8"]){
        return [UIImage imageNamed:@"sport8minig.png"];
        
    }else if([sportType isEqualToString:@"countOfIcon9"]){
        return [UIImage imageNamed:@"sport9minig.png"];
        
    }else if([sportType isEqualToString:@"countOfIcon10"]){
        return [UIImage imageNamed:@"sport10minig.png"];
        
    }else if([sportType isEqualToString:@"countOfIcon11"]){
        return [UIImage imageNamed:@"sport11minig.png"];
        
    }else{
        return [UIImage imageNamed:@"sport11minig.png"];
    }
}


+ (UIImage*)imageFeedIconForEventType:(NSNumber*)indexRow{
    
    int intIndexRow = [indexRow intValue];
    
    switch (intIndexRow) {
        case 0:
            return [UIImage imageNamed:@"sport0mini.png"];
        case 1:
            return [UIImage imageNamed:@"sport1mini.png"];
        case 2:
            return [UIImage imageNamed:@"sport2mini.png"];
        case 3:
            return [UIImage imageNamed:@"sport3mini.png"];
        case 4:
            return [UIImage imageNamed:@"sport4mini.png"];
        case 5:
            return [UIImage imageNamed:@"sport5mini.png"];
        case 6:
            return [UIImage imageNamed:@"sport6mini.png"];
        case 7:
            return [UIImage imageNamed:@"sport7mini.png"];
        case 8:
            return [UIImage imageNamed:@"sport8mini.png"];
        case 9:
            return [UIImage imageNamed:@"sport9mini.png"];
        case 10:
            return [UIImage imageNamed:@"sport10mini.png"];
        case 11:
            return [UIImage imageNamed:@"sport11mini.png"];
        default:
            return [UIImage imageNamed:@"sport11mini.png"];
    }
}

+ (UIImage*)greyImageForEventType:(NSNumber*)indexRow{
    
    int intIndexRow = [indexRow intValue];
    
    switch (intIndexRow) {
        case 0:
            return [UIImage imageNamed:@"pin0grey.png"];
        case 1:
            return [UIImage imageNamed:@"pin1grey.png"];
        case 2:
            return [UIImage imageNamed:@"pin2grey.png"];
        case 3:
            return [UIImage imageNamed:@"pin3grey.png"];
        case 4:
            return [UIImage imageNamed:@"pin4grey.png"];
        case 5:
            return [UIImage imageNamed:@"pin5grey.png"];
        case 6:
            return [UIImage imageNamed:@"pin6grey.png"];
        case 7:
            return [UIImage imageNamed:@"pin7grey.png"];
        case 8:
            return [UIImage imageNamed:@"pin8grey.png"];
        case 9:
            return [UIImage imageNamed:@"pin9grey.png"];
        case 10:
            return [UIImage imageNamed:@"pin10grey.png"];
        case 11:
            return [UIImage imageNamed:@"pin11grey.png"];
        default:
            return [UIImage imageNamed:@"pin11grey.png"];
    }
}


+ (UIImage*)imageForEventType:(NSNumber*)indexRow{
    
    int intIndexRow = [indexRow intValue];
    
    switch (intIndexRow) {
        case 0:
            return [UIImage imageNamed:@"pin0.png"];
        case 1:
            return [UIImage imageNamed:@"pin1.png"];
        case 2:
            return [UIImage imageNamed:@"pin2.png"];
        case 3:
            return [UIImage imageNamed:@"pin3.png"];
        case 4:
            return [UIImage imageNamed:@"pin4.png"];
        case 5:
            return [UIImage imageNamed:@"pin5.png"];
        case 6:
            return [UIImage imageNamed:@"pin6.png"];
        case 7:
            return [UIImage imageNamed:@"pin7.png"];
        case 8:
            return [UIImage imageNamed:@"pin8.png"];
        case 9:
            return [UIImage imageNamed:@"pin9.png"];
        case 10:
            return [UIImage imageNamed:@"pin10.png"];
        case 11:
            return [UIImage imageNamed:@"pin11.png"];
        default:
            return [UIImage imageNamed:@"pin11.png"];
    }
}

+ (NSString*)returnTimeUntilEvent:(NSDate*)eventDate displayTime:(NSString*)displayTime{
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = eventDate;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];

    NSInteger seconds = ([components second]+300);
                
    double roundedMins = round(seconds/5/60);
    double hours = seconds/60/60;
    
    NSLog(@"seconds is %ld roundedMins is %f, hours is %f",(long)seconds, roundedMins,hours);
    
    if (seconds>0) { //in future
    
        if (hours < 1){
            if (roundedMins == 0) {
                return [NSString stringWithFormat:@""];
            }else{
                return [NSString stringWithFormat:@" in %1.0f mins",roundedMins*5];
            }
        }else if (hours >= 12){
            return [NSString stringWithFormat:@" on %@",displayTime];
        }else{
            
            if((roundedMins*5)-(hours*60)>0){
                return [NSString stringWithFormat:@" in %1.0f hour%@ and %1.0f mins",hours, hours==1?@"":@"s",(roundedMins*5)-(hours*60)];
            }else{
                return [NSString stringWithFormat:@" in %1.0f hour%@",hours, hours==1?@"":@"s"];
            }
        }
    }else{
        if (hours <-3) {
            if(hours<-24){
                //float days = (;
                int days = (int)ceil(hours/24);
                return [NSString stringWithFormat:@"%d day%@ ago",-days, -days==1?@"":@"s"];
            }else if((-roundedMins*5)-(-hours*60)>0){
                return [NSString stringWithFormat:@"%1.0f hour%@ and %1.0f mins ago",-hours, -hours==1?@"":@"s",(-roundedMins*5)-(-hours*60)];
            }else{
                return [NSString stringWithFormat:@"%1.0f hour%@ ago",-hours, -hours==1?@"":@"s"];
            }
        }else{
            return [NSString stringWithFormat:@"In Progress"];
        }
    }
}

+ (BOOL)returnShouldImageBeGray:(NSDate*)eventDate{
 
    NSDate *startDate = [NSDate date];
    NSDate *endDate = eventDate;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];
    
    NSInteger seconds = [components second];
        
    if (seconds>(-60*60*3)) {
        return NO;
    }else{
        
        return YES;
    }
}

+ (float)returnAlphaForIconType:(NSDate*)eventDate{
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = eventDate;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];
    
    NSInteger seconds = [components second];
    
    if (seconds>(60*60*3)) {
        return 0.60f;
    }else{
        return 1.0f;
    }
        
/*    return ([[NSNumber numberWithInt:1] floatValue]-[[NSNumber numberWithInt:seconds] floatValue]/60/60/24);*/
}

+ (void)refreshCacheforEvent:(id)event checkedIn:(BOOL)checkedIn{
    
    // refresh cache
    PFQuery *query = [PlayUtility queryForActivitiesOnEvent:event cachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSMutableArray *checkedInUsers = [NSMutableArray array];
            NSMutableArray *locationCheckedInUsers = [NSMutableArray array];
            NSMutableArray *commenters = [NSMutableArray array];
            
            BOOL currentUserCheckedIn = NO;
            BOOL currentUserLocationCheckedIn = NO;
            
            for (PFObject *activity in objects) {
                if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsCheckIn] && [activity objectForKey:kPlayActivityFromUserKey]) {
                    [checkedInUsers addObject:[activity objectForKey:kPlayActivityFromUserKey]];
                } else if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsComment] && [activity objectForKey:kPlayActivityFromUserKey]) {
                    [commenters addObject:[activity objectForKey:kPlayActivityFromUserKey]];
                }else if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsLocationCheckIn] && [activity objectForKey:kPlayActivityFromUserKey]) {
                    [locationCheckedInUsers addObject:[activity objectForKey:kPlayActivityFromUserKey]];
                }
                
                if ([[[activity objectForKey:kPlayActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                    if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsCheckIn]) {
                        currentUserCheckedIn = YES;
                    }
                    if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsLocationCheckIn]) {
                        currentUserLocationCheckedIn = YES;
                    }
                }
            }
            
            NSArray *checkedInUsersFinal = [checkedInUsers copy];
            NSArray *locationCheckedInUsersFinal = [locationCheckedInUsers copy];
            
            NSDictionary *checkedInUsersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:checkedInUsersFinal,kPlayEventAttributesCheckedInUsersUserArrayKey,locationCheckedInUsersFinal,kPlayEventAttributesLocationCheckedInUsersArrayKey, nil];
            
            [[PlayCache sharedCache] setAttributesForEvent:event checkedInUsers:checkedInUsersDictionary commenters:commenters currentUserCheckedIn:currentUserCheckedIn locationCheckedIn:currentUserLocationCheckedIn];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PlayUtilityUserCheckedInorUncheckedIntoEventNotification object:event userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:checkedIn] forKey:UserCheckedInorUncheckedIntoEventNotificationUserInfoCheckedInKey]];
    }];
}

#pragma mark -
#pragma mark Set Device Type

+ (NSString*)setDeviceType {
    
    UIDeviceHardware *device = [[UIDeviceHardware alloc] init];
    return  [device platformString];
}

#pragma mark -
#pragma mark Facebook

+ (void)isLinkedToFacebook:(PFUser*)user block:(void (^)(BOOL success, NSError *error))completionBlock{
    
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        
        NSLog(@"in ![PFFacebookUtils isLinkedWithUser:user] in isLinkedToFacebook");
        
        NSArray *permissionsArray = @[@"email"];
        
        [PFFacebookUtils linkUser:user permissions:permissionsArray block:^(BOOL success, NSError *error) {
            
            if (completionBlock) {
                completionBlock(success,error);
            }
            
            if (success) {
                //Create request for user's Facebook data
                FBRequest *request = [FBRequest requestForMe];
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        
                        NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
                        
                        NSString *fBid = userData[@"id"];
                        NSString *gender = userData[@"gender"];
                        
                        // add FB data to Parse db
                        [user setObject:gender forKey:@"fBgender"];
                        [user setObject:fBid forKey:@"fBId"];
                        [user saveInBackground];
                    }
                }];
                
            }else{
                if (!error) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                    
                }else {
                    if (error.code == 2){
                        NSLog(@"Uh oh. An error occurred: %@ Code:%d", error, error.code);
                        
                        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Login Cancelled, if you have connected Facebook natively please go to your iOS Settings > Facebook > Make sure Facebook access is turned on for Play"]
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"Ok", nil];
                        [alertView show];
                        
                    }else if (error.code == 208){
                        NSLog(@"Uh oh. An error occurred: %@ Code:%d", error, error.code);
                        
                        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error! This Facebook account is already attached to another user"]
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"Ok", nil];
                        [alertView show];
                    }else {
                        NSLog(@"Uh oh. An error occurred: %@ Code:%d", error, error.code);
                        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error accessing Facebook, please try again"]
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"Ok", nil];
                        [alertView show];
                    }
                }
            }
        }];
    }else{
        
        BOOL success = YES;
        NSError *error = nil;
        
        if (completionBlock) {
            completionBlock(success,error);
        }
        
    }
}

+ (void) authorizePermissionsForFacebook:(PFObject *) object postedString:(NSString*)postedString{
    
    if ([PFFacebookUtils session]) {
        
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                if ([[PFFacebookUtils session].permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                    // No permissions found in session, ask for it
                    
                    NSLog(@"in authorizePermissionsForFacebook, @publish_actions not found");
                    
                    [PFFacebookUtils reauthorizeUser:[PFUser currentUser] withPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] audience:FBSessionDefaultAudienceFriends block: ^(BOOL succeeded, NSError *error){
                        if (!error) {
                            // If permissions granted, publish the story
                            [PlayUtility postEventToFacebookTimeline:object postedString:postedString];
                        }
                    }];
                    
                } else {
                    
                    NSLog(@"in authorizePermissionsForFacebook, @publish_actions FOUND");
                    
                    // If permissions present, publish the story
                    [PlayUtility postEventToFacebookTimeline:object postedString:postedString];
                }

            } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                NSLog(@"The facebook session was invalidated");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ah! Facebook must be reconnected to work properly. Please go to your Profile > Log out of Play > Log into Play using Facebook. Thanks" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Some other error: %@", error);
            }
        }];
    }
}

+ (void) postEventToFacebookTimeline:(PFObject *)event postedString:(NSString*)postedString{
    
    
    NSString* link = [[NSString alloc] initWithFormat:@"http://theplayapp.com"];
    PFFile* picture = [event objectForKey:kPlayEventPictureKey];
    
    NSString* name = nil;
    NSString* description = nil;
    
    if (![postedString isEqualToString:@""]) {
        name = [[NSString alloc] initWithFormat:@"%@",postedString];
        description = [[NSString alloc] initWithFormat:@"Interested in joining? Click here to download the Play app"];
    }else{
        name = [[NSString alloc] initWithFormat:@"%@",[event objectForKey:kPLayEventDescriptionKey]];
        description = [[NSString alloc] initWithFormat:@"Interested in joining? Click here to download the Play app"];
    }
        
    NSDictionary* postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:link,FacebookPostTypeIsLink, picture.url, FacebookPostTypeIsPicture, name, FacebookPostTypeIsName, description, FacebookPostTypeIsDescription ,nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:postDictionary HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        NSString *alertText;
         if (error) {
             
             NSLog( @"error: domain = %@, code = %d", error.domain, error.code);
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post the Event to Facebook, please try again later" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
             [alert show];
             
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         // Show the result in an alert
    }];
}

#pragma mark -
#pragma mark Twitter

+ (void)isLinkedToTwitter:(PFUser*)user block:(void (^)(BOOL success, NSError *error))completionBlock{
    
    if (![PFTwitterUtils isLinkedWithUser:user]) {
                
        [PFTwitterUtils linkUser:user block:^(BOOL success, NSError *error) {

            if (completionBlock) {
                completionBlock(success,error);
                
            }
            
            if(success){
                
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
                NSMutableURLRequest *tweetRequest = [NSMutableURLRequest requestWithURL:url];
                
                [[PFTwitterUtils twitter] signRequest:tweetRequest];
                
                NSURLResponse *response = nil;
                NSError *error = nil;
                
                // Post status synchronously.
                NSData *data = [NSURLConnection sendSynchronousRequest:tweetRequest
                                                     returningResponse:&response
                                                                 error:&error];
                
                NSError* error2;
                NSDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error2];
                
                // Handle response.
                if (!error && !error2) {
                    
                    NSString *twitterId = [json objectForKey:@"id"];
                    // add FB data to Parse db
                    [user setObject:twitterId forKey:@"twitterId"];
                    [user saveInBackground];
                    
                }
            }else {
                if (!error) {
                    NSLog(@"Uh oh. The user cancelled the Twitter login.");
                    
                } else {
                    if (error.code == 2){
                        NSLog(@"Uh oh. An error occurred: %@ Code:%d", error, error.code);
                        
                        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Please go to your iOS Settings > Twitter > Turn on access to Play"]
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"Ok", nil];
                        [alertView show];
                        
                    }else if (error.code == 208){
                        NSLog(@"Uh oh. An error occurred: %@ Code:%d", error, error.code);
                        
                        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error! This Twitter account is already attached to another user"]
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"Ok", nil];
                        [alertView show];
                    }else {
                        NSLog(@"Uh oh. An error occurred: %@ Code:%d", error, error.code);
                        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error accessing Twitter, please try again"]
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"Ok", nil];
                        [alertView show];
                    }
                }
            }
        }];
    }else{
        
        BOOL success = YES;
        NSError *error = nil;
        
        if (completionBlock) {
            completionBlock(success,error);
        }
        
    }
}

+ (BOOL)postTwitterStatus:(NSString *)status {
    
    NSLog(@"in postTwitterStatus");
    
    status = [status stringByAppendingString:@". Join via http://theplayapp.com"];

    // Construct the parameters string. The value of "status" is percent-escaped.
    NSString* bodyString = [NSString stringWithFormat:@"status=%@",[self urlEncodeValue:status]];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
    
    NSMutableURLRequest *tweetRequest = [NSMutableURLRequest requestWithURL:url];
    tweetRequest.HTTPMethod = @"POST";
    tweetRequest.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [tweetRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [[PFTwitterUtils twitter] signRequest:tweetRequest];
    
    dispatch_queue_t twitterQueue;
    twitterQueue = dispatch_queue_create("com.thePlayApp.twitterQueue", NULL);
    dispatch_async(twitterQueue, ^{
        
        NSURLResponse *response = nil;
        NSError *error = nil;

        NSData *data = [NSURLConnection sendSynchronousRequest:tweetRequest
                                             returningResponse:&response
                                                         error:&error];
        
        if (!error) {
            NSLog(@"Sending Tweet Success. Response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"Sending TweetError: %@", error);
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                if (error.code == -1012) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post the Event to Twitter, you are using an unsupported character" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                    [alert show];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post the Event to Twitter, please try again later" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                    [alert show];
                }
            });
        }
    });
    
    return TRUE;

}

+ (NSString *)urlEncodeValue:(NSString *)str
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    return result;
}

+ (void)responseFrom4sq:(CLLocation*)currentLocation limit:(NSString*)limit block:(void (^)(NSArray *locationDictionary, NSError *error))completionBlock{
    NSString *apiString4aq= @"https://api.foursquare.com/v2/venues/search?ll=";
    NSString *clientID = @"&client_id=x&client_secret=y";
    NSString *version = @"&v=20121219";
    
    NSMutableURLRequest *foursqRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%1.6f,%1.6f%@%@&limit=%@",apiString4aq,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,clientID,version,limit]]];
    
    dispatch_queue_t foursqQueue;
    foursqQueue = dispatch_queue_create("com.thePlayApp.foursqQueue", NULL);
    dispatch_async(foursqQueue, ^{
    
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSError *error2 = nil;

        NSData *data = [NSURLConnection sendSynchronousRequest:foursqRequest
                                             returningResponse:&response
                                                         error:&error];
    if(!error){
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error2];
        
        if (!error2) {
            
            NSLog(@"4sq data retrieved successfully");
            
            NSDictionary *dataDictionary4sq = [json objectForKey:@"response"];
            NSArray *venueArray = [dataDictionary4sq objectForKey:@"venues"];
            
            completionBlock(venueArray,error);
            
        }else{
            completionBlock([NSArray array] ,error);
            NSLog(@"4sq data not retrieved successfully :(");
        }
    }else{
        completionBlock([NSArray array] ,error);
        NSLog(@"4sq data not retrieved successfully :(");
    }
    
    });
}

#pragma mark -
#pragma mark Push Notifications


+ (NSString*)returnUserPrivateChannel:(NSString*)userObjectID{
                return [NSString stringWithFormat:@"u_%@",userObjectID];
}

+ (void)inviteFollowersInBackground:(id)event invitedUsers:(NSSet*)invitedUsers{
    
    for (NSString *userString in invitedUsers) {
        
        PFUser *user = [PFUser objectWithoutDataWithObjectId:userString];

        // proceed to creating new checkin
        PFObject *inviteUserActivity = [PFObject objectWithClassName:kPlayActivityClassKey];
        [inviteUserActivity setObject:kPlayActivityTypeIsInvite forKey:kPlayActivityTypeKey];
        [inviteUserActivity setObject:[PFUser currentUser] forKey:kPlayActivityFromUserKey];
        [inviteUserActivity setObject:user forKey:kPlayActivityToUserKey];
        [inviteUserActivity setObject:event forKey:kPlayActivityEventKey];
        
        PFACL *inviteUserACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [inviteUserACL setPublicReadAccess:YES];
        [inviteUserACL setWriteAccess:YES forUser:[event objectForKey:kPlayEventUserKey]];
        [inviteUserACL setWriteAccess:YES forUser:[PFUser currentUser]];
        inviteUserActivity.ACL = inviteUserACL;
        
        [inviteUserActivity saveInBackground];
    }
}

+ (void)pushNotificationsinBackground:(NSDictionary*)data pushUsers:(NSSet*)pushUsers{

    PFPush *push = [[PFPush alloc] init];
    [push setChannels:[pushUsers allObjects]];
    [push setData:data];
    [push sendPushInBackground];
    
}

+ (void)addEventToCalendar:(id)eventDetails{
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    // display error message here
                    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Error! Could not access your calendar."
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:@"Ok", nil];
                    [alertView show];
                }
                else if (!granted)
                {
                    // display access denied error message here
                    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Error! Could not access your calendar."
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:@"Ok", nil];
                    [alertView show];
                }
                else
                {
                    // access granted
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    
                    NSArray *locationArray = [eventDetails objectForKey:kPlayEventLocationKey];
                    NSString *locationTitle = [NSString stringWithFormat:@"%@",[locationArray objectAtIndex:1]];
                    
                    event.title = [NSString stringWithFormat:@"%@ @ %@",[eventDetails objectForKey:kPlayEventTypeKey],locationTitle];
                    event.notes = [eventDetails objectForKey:kPLayEventDescriptionKey];
                    
                    NSDate *startDate = (NSDate*)[eventDetails objectForKey:kPlayEventTimeKey];
                    
                    event.startDate = [eventDetails objectForKey:kPlayEventTimeKey];
                    event.endDate   = [eventDetails objectForKey:kPlayEventEndTimeKey];
                    event.alarms = [NSArray arrayWithObjects:[EKAlarm alarmWithAbsoluteDate:[eventDetails objectForKey:kPlayEventTimeKey]],[EKAlarm alarmWithAbsoluteDate:[startDate dateByAddingTimeInterval:(-60*60*2)]],nil];
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                }
            });
        }];
    }
    
    
}

@end