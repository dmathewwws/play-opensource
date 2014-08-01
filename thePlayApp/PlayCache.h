//
//  PlayCache.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-20.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PlayCache : NSObject

@property (nonatomic, strong) NSCache *cache;

+ (id)sharedCache;

- (void)setAttributesForEvent:(PFObject *)event checkedInUsers:(NSDictionary *)checkedInUsers commenters:(NSArray *)commenters currentUserCheckedIn:(BOOL)currentUserCheckedIn locationCheckedIn:(BOOL)locationCheckedIn;
- (void)setAttributes:(NSDictionary *)attributes forEvent:(PFObject *)event;
- (NSDictionary *)getAttributesForEvent:(PFObject *)event;
- (NSString *)keyForEvent:(PFObject *)event;

- (void)incrementCheckinCountForEvent:(PFObject *)event;
- (void)decrementCheckinCountForEvent:(PFObject *)event;
- (void)incrementCommentCountForEvent:(PFObject *)event;
- (void)decrementCommentCountForEvent:(PFObject *)event;

- (NSNumber *)checkInCountForEvent:(PFObject *)event;
- (NSNumber *)locationCheckInCountForEvent:(PFObject *)event;
- (NSNumber *)commentCountForEvent:(PFObject *)event;
- (void)setCurrentUserIsCheckedIntoEvent:(PFObject *)event checkedIn:(BOOL)checkedIn locationCheckedIn:(BOOL)locationCheckedIn;
- (BOOL)isCurrentUserCheckedIntoEvent:(PFObject *)event;
- (NSDictionary *)checkedInUsersForEvent:(PFObject *)event;
- (NSArray *)commentersForEvent:(PFObject *)event;

- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user;
- (NSDictionary *)attributesForUser:(PFUser *)user;
- (NSString *)keyForUser:(PFUser *)user;
- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user;

@end