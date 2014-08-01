//
//  PlayConstants.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-18.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayConstants : NSObject

#pragma mark -
#pragma mark Query Events Constants

extern double const kPlayMaximumSearchDistance;
extern double const kPlayMaximumSearchDistanceForFeed;
extern int const kPlayQueryLimit;
extern int const kPlayInvitedQueryLimit;
extern int const kPlayGeofenceRadius;

extern float const kPlayAvatarLargeSize;
extern float const kPlayAvatarSmallSize;
extern float const kPlayEventFeedHeaderHeight;

extern NSString *const kPlayFontName;

#pragma mark -
#pragma mark User Info Keys

extern NSString *const kPlayCheckInUserInfoCommentKey;
extern NSString *const kPlayCheckInPlaceholderText;
extern NSString *const kPlayCheckInStartTimeText;

#pragma mark -
#pragma mark User Keys

extern NSString *const kPlayUserUsernameKey;
extern NSString *const kPlayUserEmailKey;
extern NSString *const kPlayUserLocationCheckInKey;
extern NSString *const kPlayUserGenderKey;
extern NSString *const kPlayUserPlayGenderKey;
extern NSString *const kPlayUserPlayAgeKey;
extern NSString *const kPlayUserPlayBioKey;
extern NSString *const kPlayUserNameKey;
extern NSString *const kPlayUserProfilePictureMediumKey;
extern NSString *const kPlayUserProfilePictureSmallKey;
extern NSString *const kPlayUserSignupTypeKey;
extern NSString *const kPlayUserPrivateChannelKey;
extern NSString *const kPlayUseriOSAskPushRegistrationKey;
extern NSString *const kPlayUserPushArrayKey;

#pragma mark -
#pragma mark User Push Keys

extern int const kPlayPushSettingsWhenFollowKey;
extern int const kPlayPushSettingsWhenJoinsEventKey;
extern int const kPlayPushSettingsWhenInvitesToEventKey;
extern int const kPlayPushSettingsWhenEventEditedOrDeletedKey;
extern int const kPlayPushSettingsWhenSomeoneCommentsOnEventKey;

#pragma mark -
#pragma mark Installation Keys

extern NSString *const kPlayInstallationChannelsKey;
extern NSString *const kPlayInstallationUserKey;


#pragma mark -
#pragma mark Event Keys

extern NSString *const kPlayEventClassKey;
extern NSString *const kPlayEventUserKey;
extern NSString *const kPlayEventPictureKey;
extern NSString *const kPlayEventThumbnailKey;
extern NSString *const kPlayEventCreatedCommentKey;
extern NSString *const kPlayEventTypeKey;
extern NSString *const kPlayEventIconTypeKey;
extern NSString *const kPlayEventLocationKey;
extern NSString *const kPlayEventCoordinatesKey;
extern NSString *const kPlayEventTimeKey;
extern NSString *const kPlayEventEndTimeKey;
extern NSString *const kPLayEventDescriptionKey;
extern NSString *const kPLayEventDisplayStartTimeKey;
extern NSString *const kPLayEventUtcOffsetKey;
extern NSString *const kPLayEventIsPrivate;
extern NSString *const kPLayEventInvitedUsers;

#pragma mark -
#pragma mark - Cached Event Attributes

extern NSString *const kPlayEventAttributesCurrentUserCheckedInKey;
extern NSString *const kPlayEventAttributesCurrentUserLocationCheckedInKey;
extern NSString *const kPlayEventAttributesCheckedInCountKey;
extern NSString *const kPlayEventAttributesLocationCheckedInCountKey;
extern NSString *const kPlayEventAttributesCheckedInUsersKey;
extern NSString *const kPlayEventAttributesCommentCountKey;
extern NSString *const kPlayEventAttributesCommentersKey;

#pragma mark -
#pragma mark - CheckedInUsers Dictionary Attributes

extern NSString *const kPlayEventAttributesCheckedInUsersUserArrayKey;
extern NSString *const kPlayEventAttributesLocationCheckedInUsersArrayKey;

#pragma mark -
#pragma mark - Cached User Attributes
// keys

extern NSString *const kPlayUserAttributeIsFollowedByCurrentUser;
extern NSString *const kPlayUserAttributeIsFollowedByUser;
extern NSString *const kPlayUserAttributeIsFollowingUser;

#pragma mark -
#pragma mark - Activity Keys

// Class key
extern NSString *const kPlayActivityClassKey;

// Field keys
extern NSString *const kPlayActivityTypeKey;
extern NSString *const kPlayActivityFromUserKey;
extern NSString *const kPlayActivityToUserKey;
extern NSString *const kPlayActivityContentKey;
extern NSString *const kPlayActivityEventKey;

#pragma mark -
#pragma mark - Activity Types

extern NSString *const kPlayActivityTypeIsComment;
extern NSString *const kPlayActivityTypeIsCheckIn;
extern NSString *const kPlayActivityTypeIsLocationCheckIn;
extern NSString *const kPlayActivityTypeIsFollow;
extern NSString *const kPlayActivityTypeIsOldFollow;
extern NSString *const kPlayActivityTypeIsInvite;

#pragma mark -
#pragma mark - NSNotification

extern NSString *const PlayUtilityUserCheckedInorUncheckedIntoEventNotification;
extern NSString *const PlayUtilityUserLogOffNotification;
extern NSString *const PlayUtilityUserRefreshPinsNotificationBecauseEventCreated;
extern NSString *const PlayUtilityUserRefreshPinsNotificationBecauseEventDeleted;
extern NSString *const PlayUtilityUserRefreshPinsNotificationBecauseAppLaunched;
extern NSString *const PlayEditProfileChanged;
extern NSString *const PlayUtilityFollowingCountChanged;
extern NSString *const CheckInControllerDidFinishEditingEventNotification;
extern NSString *const SportsPickerControllerDidNotPickSport;
extern NSString *const UserChangedProfilePicNotification;
extern NSString *const DetailedViewControllerUserDeletedEventNotification;
extern NSString *const DetailedViewControllerUserCheckedInorUncheckedIntoEventNotification;
extern NSString *const DetailedViewControllerUserCommentedOnEventNotification;

#pragma mark -
#pragma mark - NSNotification UserInfo keys

extern NSString *const UserCheckedInorUncheckedIntoEventNotificationUserInfoCheckedInKey;

#pragma mark -
#pragma mark - UI Texts

extern NSString *const facebookAccountAlreadyConnected;

#pragma mark -
#pragma mark - English Sport Names

extern NSString *const SportPickedisSoccer;
extern NSString *const SportPickedisBasketball;
extern NSString *const SportPickedisFootball;
extern NSString *const SportPickedisAmericanFootball;
extern NSString *const SportPickedisHockey;
extern NSString *const SportPickedisVolleyBall;
extern NSString *const SportPickedisBaseball;
extern NSString *const SportPickedisTennis;
extern NSString *const SportPickedisFrisbee;
extern NSString *const SportPickedisRunning;
extern NSString *const SportPickedisYoga;
extern NSString *const SportPickedisClimbing;
extern NSString *const SportPickedisWildcard;

#pragma mark -
#pragma mark - CreateViewTypes

extern NSString *const kFacebookViewType;
extern NSString *const kTwitterViewType;
extern NSString *const kEmailViewType;

#pragma mark -
#pragma mark - Facebook Post Types

extern NSString *const FacebookPostTypeIsLink;
extern NSString *const FacebookPostTypeIsPicture;
extern NSString *const FacebookPostTypeIsName;
extern NSString *const FacebookPostTypeIsCaption;
extern NSString *const FacebookPostTypeIsDescription;


@end