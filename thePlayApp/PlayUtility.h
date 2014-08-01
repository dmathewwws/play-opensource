//
//  PlayUtility.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-05.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PlayUtility : NSObject <UIAlertViewDelegate>

+ (PFQuery *)queryForActivitiesOnEvent:(PFObject *)event cachePolicy:(PFCachePolicy)cachePolicy;
+ (void)queryForActivitiesOnEventForDelete:(PFObject *)event;
+ (void)checkIntoEventInBackground:(id)event locationCheckIn:(BOOL)locationCheckIn block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)locationCheckIntoEventByRegionMonitoringInBackground:(id)event block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)uncheckIntoEventInBackground:(id)event block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)addEventToCalendar:(id)eventDetails;

+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)setFirstFollowerEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unfollowUserEventually:(PFUser *)user  block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (BOOL)islocationCheckInTrue:(PFObject*)event currentLocation:(CLLocation*)currentLocation;
+ (NSString*)indexRow:(NSInteger)indexRow;
+ (void)refreshCacheforEvent:(id)event checkedIn:(BOOL)checkedIn;
+ (NSString*)setDeviceType;
+ (UIImage*)imageForEventType:(NSNumber*)indexRow;
+ (UIImage*)greyImageForEventType:(NSNumber*)indexRow;
+ (UIImage*)greyFeedImageForEventType:(NSNumber*)indexRow;
+ (UIImage*)imageFeedIconForEventType:(NSNumber*)indexRow;
+ (UIImage*)greyTopSportsImagesForProfile:(NSString*)sportType;

+ (NSString*)returnTimeUntilEvent:(NSDate*)eventDate displayTime:(NSString*)displayTime;
+ (float)returnAlphaForIconType:(NSDate*)eventDate;
+ (BOOL) returnShouldImageBeGray:(NSDate*)eventDate;

+ (void)isLinkedToFacebook:(PFUser*)user block:(void (^)(BOOL success, NSError *error))completionBlock;
+ (void) authorizePermissionsForFacebook:(PFObject *) event postedString:(NSString*)postedString;
+ (void) postEventToFacebookTimeline:(PFObject *)event postedString:(NSString*)postedString;

+ (void)isLinkedToTwitter:(PFUser*)user block:(void (^)(BOOL success, NSError *error))completionBlock;
+ (BOOL) postTwitterStatus:(NSString *)status;
+ (NSString *)urlEncodeValue:(NSString *)str;
+ (void)responseFrom4sq:(CLLocation*)currentLocation limit:(NSString*)limit block:(void (^)(NSArray *locationDictionary, NSError *error))completionBlock;
//+ (NSString*)returnTimeUntilEventForFeed:(NSDate*)eventDate displayTime:(NSString*)displayTime;

#pragma mark -
#pragma mark Push Notifications

+ (NSString*)returnUserPrivateChannel:(NSString*)userObjectID;
+ (void)inviteFollowersInBackground:(id)event invitedUsers:(NSSet*)invitedUsers;
+ (void)pushNotificationsinBackground:(NSDictionary*)data pushUsers:(NSSet*)pushUsers;

@end