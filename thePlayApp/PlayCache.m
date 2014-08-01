//
//  PlayCache.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-20.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "PlayCache.h"
#import "PlayConstants.h"

@implementation PlayCache

@synthesize cache = _cache;

#pragma mark -
#pragma mark - init

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark -
#pragma mark - Event Attributes

- (void)setAttributesForEvent:(PFObject *)event checkedInUsers:(NSDictionary *)checkedInUsers commenters:(NSArray *)commenters currentUserCheckedIn:(BOOL)currentUserCheckedIn locationCheckedIn:(BOOL)locationCheckedIn{
    
    NSArray *checkedInUsersArray = [checkedInUsers objectForKey:kPlayEventAttributesCheckedInUsersUserArrayKey];
    NSArray *locationCheckedInUsersArray = [checkedInUsers objectForKey:kPlayEventAttributesLocationCheckedInUsersArrayKey];
        
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:currentUserCheckedIn],kPlayEventAttributesCurrentUserCheckedInKey,
                                [NSNumber numberWithBool:locationCheckedIn],kPlayEventAttributesCurrentUserLocationCheckedInKey,
                                [NSNumber numberWithInt:[checkedInUsersArray count]],kPlayEventAttributesCheckedInCountKey,
                                [NSNumber numberWithInt:[locationCheckedInUsersArray count]],kPlayEventAttributesLocationCheckedInCountKey,
                                checkedInUsers,kPlayEventAttributesCheckedInUsersKey,
                                [NSNumber numberWithInt:[commenters count]],kPlayEventAttributesCommentCountKey,
                                commenters,kPlayEventAttributesCommentersKey,
                                nil];
    [self setAttributes:attributes forEvent:event];
}

- (void)setAttributes:(NSDictionary *)attributes forEvent:(PFObject *)event {
    NSString *key = [self keyForEvent:event];
    [_cache setObject:attributes forKey:key];
}

- (NSDictionary *)getAttributesForEvent:(PFObject *)event{
    NSString *key = [self keyForEvent:event];
    return [self.cache objectForKey:key];
}

- (NSString *)keyForEvent:(PFObject *)event {
    return [NSString stringWithFormat:@"event_%@", [event objectId]];
}

- (void)incrementCheckinCountForEvent:(PFObject *)event{
    NSNumber *checkInCount = [NSNumber numberWithInt:[[self checkInCountForEvent:event] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributesForEvent:event]];
    [attributes setObject:checkInCount forKey:kPlayEventAttributesCheckedInCountKey];
    [self setAttributes:attributes forEvent:event];
}

- (void)decrementCheckinCountForEvent:(PFObject *)event{
    NSNumber *checkInCount = [NSNumber numberWithInt:[[self checkInCountForEvent:event] intValue] - 1];
    
    if ([checkInCount intValue] < 0) {
        return;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributesForEvent:event]];
    [attributes setObject:checkInCount forKey:kPlayEventAttributesCheckedInCountKey];
    [self setAttributes:attributes forEvent:event];
}

- (void)incrementCommentCountForEvent:(PFObject *)event{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForEvent:event] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributesForEvent:event]];
    [attributes setObject:commentCount forKey:kPlayEventAttributesCommentCountKey];
    [self setAttributes:attributes forEvent:event];
}

- (void)decrementCommentCountForEvent:(PFObject *)event{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForEvent:event] intValue] + 1];
    
    if ([commentCount intValue] < 0) {
        return;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributesForEvent:event]];
    [attributes setObject:commentCount forKey:kPlayEventAttributesCommentCountKey];
    [self setAttributes:attributes forEvent:event];
}

- (NSNumber *)checkInCountForEvent:(PFObject *)event {
    NSDictionary *attributes = [self getAttributesForEvent:event];
    if (attributes) {
        return [attributes objectForKey:kPlayEventAttributesCheckedInCountKey];
    }
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)locationCheckInCountForEvent:(PFObject *)event {
    NSDictionary *attributes = [self getAttributesForEvent:event];
    if (attributes) {
        return [attributes objectForKey:kPlayEventAttributesLocationCheckedInCountKey];
        
    }
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForEvent:(PFObject *)event {
    NSDictionary *attributes = [self getAttributesForEvent:event];
    if (attributes) {
        return [attributes objectForKey:kPlayEventAttributesCommentCountKey];
    }
    return [NSNumber numberWithInt:0];
}


- (NSDictionary *)checkedInUsersForEvent:(PFObject *)event {
    NSDictionary *attributes = [self getAttributesForEvent:event];
    if (attributes) {
        return [attributes objectForKey:kPlayEventAttributesCheckedInUsersKey];
    }
    return [NSDictionary dictionary];
}

- (NSArray *)commentersForEvent:(PFObject *)event {
    NSDictionary *attributes = [self getAttributesForEvent:event];
    if (attributes) {
        return [attributes objectForKey:kPlayEventAttributesCommentersKey];
    }
    return [NSArray array];
}

- (void)setCurrentUserIsCheckedIntoEvent:(PFObject *)event checkedIn:(BOOL)checkedIn locationCheckedIn:(BOOL)locationCheckedIn{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributesForEvent:event]];
    [attributes setObject:[NSNumber numberWithBool:checkedIn] forKey:kPlayEventAttributesCurrentUserCheckedInKey];
    [attributes setObject:[NSNumber numberWithBool:locationCheckedIn] forKey:kPlayEventAttributesCurrentUserLocationCheckedInKey];
    [self setAttributes:attributes forEvent:event];
}

- (BOOL)isCurrentUserCheckedIntoEvent:(PFObject *)event {
    NSDictionary *attributes = [self getAttributesForEvent:event];
    if (attributes) {
        return [[attributes objectForKey:kPlayEventAttributesCurrentUserCheckedInKey] boolValue];
    }
    
    return NO;
}

- (void)setFollowStatus:(BOOL)following user:(PFUser *)user{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:[NSNumber numberWithBool:following] forKey:kPlayUserAttributeIsFollowedByCurrentUser];
    [self setAttributes:attributes forUser:user];
    
}

- (BOOL)followStatusForUser:(PFUser *)user{
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *followStatus = [attributes objectForKey:kPlayUserAttributeIsFollowedByCurrentUser];
        if (followStatus) {
            return [followStatus boolValue];
        }
    }
    return NO;
}

- (NSDictionary *)attributesForUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (NSString *)keyForUser:(PFUser *)user {
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];
}

@end
