//
//  PlayConstants.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-18.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "PlayConstants.h"

@implementation PlayConstants

#pragma mark -
#pragma mark Query Events Constants

double const kPlayMaximumSearchDistance = 10.0;
double const kPlayMaximumSearchDistanceForFeed = 25.0;

int const kPlayQueryLimit = 15;
int const kPlayInvitedQueryLimit = 5;

int const kPlayGeofenceRadius = 250;
float const kPlayAvatarLargeSize = 200.0f;
float const kPlayAvatarSmallSize = 86.0f;
float const kPlayEventFeedHeaderHeight = 48.0f;

NSString *const kPlayFontName = @"Varela Round";

#pragma mark -
#pragma mark User Info Keys

NSString *const kPlayCheckInUserInfoCommentKey = @"comment";
NSString *const kPlayCheckInPlaceholderText = @"Enter event description";
NSString *const kPlayCheckInStartTimeText = @"Start Time:";

#pragma mark -
#pragma mark User Keys

NSString *const kPlayUserUsernameKey = @"username";
NSString *const kPlayUserEmailKey = @"email";
NSString *const kPlayUserLocationCheckInKey = @"locationCheckIn";
NSString *const kPlayUserNameKey = @"name";
NSString *const kPlayUserProfilePictureMediumKey = @"profilePictureMedium";
NSString *const kPlayUserProfilePictureSmallKey = @"profilePictureSmall";
NSString *const kPlayUserSignupTypeKey = @"signupType";
NSString *const kPlayUserPrivateChannelKey = @"privateChannel";
NSString *const kPlayUseriOSAskPushRegistrationKey = @"iOSPushReg";
NSString *const kPlayUserPushArrayKey = @"pushArray";
NSString *const kPlayUserPlayGenderKey = @"gender";
NSString *const kPlayUserPlayAgeKey = @"age";
NSString *const kPlayUserPlayBioKey = @"bio";

#pragma mark -
#pragma mark User Push Keys

int const kPlayPushSettingsWhenFollowKey = 0;
int const kPlayPushSettingsWhenJoinsEventKey = 1;
int const kPlayPushSettingsWhenInvitesToEventKey = 2;
int const kPlayPushSettingsWhenEventEditedOrDeletedKey = 3;
int const kPlayPushSettingsWhenSomeoneCommentsOnEventKey = 4;

#pragma mark -
#pragma mark Installation Keys

NSString *const kPlayInstallationChannelsKey = @"channels";
NSString *const kPlayInstallationUserKey = @"userCreated";

#pragma mark -
#pragma mark Event Key

NSString *const kPlayEventClassKey = @"Event";
NSString *const kPlayEventUserKey = @"createdUser";
NSString *const kPlayEventPictureKey = @"picture";
NSString *const kPlayEventThumbnailKey = @"thumbnail";
NSString *const kPlayEventCreatedCommentKey = @"creatorCommentKey";
NSString *const kPlayEventTypeKey = @"type";
NSString *const kPlayEventIconTypeKey = @"iconType";
NSString *const kPlayEventLocationKey = @"location";
NSString *const kPlayEventCoordinatesKey = @"coordinates";
NSString *const kPlayEventTimeKey = @"startTime";
NSString *const kPlayEventEndTimeKey = @"endTime";
NSString *const kPLayEventDescriptionKey = @"description";
NSString *const kPLayEventDisplayStartTimeKey = @"displayStartTime";
NSString *const kPLayEventUtcOffsetKey = @"utcOffset";
NSString *const kPLayEventIsPrivate = @"privateEvent";
NSString *const kPLayEventInvitedUsers = @"invitedUsers";

#pragma mark -
#pragma mark - Cached Event Attributes
// keys
NSString *const kPlayEventAttributesCurrentUserCheckedInKey = @"currentUserIsCheckedIn";
NSString *const kPlayEventAttributesCurrentUserLocationCheckedInKey = @"currentUserIsLocationCheckedIn";
NSString *const kPlayEventAttributesCheckedInCountKey = @"checkedInUsersCount";
NSString *const kPlayEventAttributesLocationCheckedInCountKey = @"locationCheckedInUsersCount";
NSString *const kPlayEventAttributesCheckedInUsersKey = @"checkedInUsers";
NSString *const kPlayEventAttributesCommentCountKey = @"commentCount";
NSString *const kPlayEventAttributesCommentersKey = @"commenters";

#pragma mark -
#pragma mark - CheckedInUsers Dictionary Attributes

NSString *const kPlayEventAttributesCheckedInUsersUserArrayKey = @"userCheckedInUsers";
NSString *const kPlayEventAttributesLocationCheckedInUsersArrayKey = @"locationCheckedInUsers";

#pragma mark -
#pragma mark - Cached Event Attributes
// keys

NSString *const kPlayUserAttributeIsFollowedByCurrentUser = @"userIsFollowedByCurrentUser";
NSString *const kPlayUserAttributeIsFollowedByUser = @"isFollowedByUser";
NSString *const kPlayUserAttributeIsFollowingUser = @"isFollowingUser";

#pragma mark -
#pragma mark - Activity Keys

// Class key
NSString *const kPlayActivityClassKey = @"Activity";

// Field keys
NSString *const kPlayActivityTypeKey = @"Type";
NSString *const kPlayActivityFromUserKey = @"fromUser";
NSString *const kPlayActivityToUserKey = @"toUser";
NSString *const kPlayActivityContentKey = @"content";
NSString *const kPlayActivityEventKey = @"event";

#pragma mark -
#pragma mark - Activity Types

NSString *const kPlayActivityTypeIsComment = @"comment";
NSString *const kPlayActivityTypeIsCheckIn = @"checkIn";
NSString *const kPlayActivityTypeIsLocationCheckIn = @"locationCheckIn";
NSString *const kPlayActivityTypeIsFollow = @"follow";
NSString *const kPlayActivityTypeIsOldFollow = @"oldFollow";
NSString *const kPlayActivityTypeIsInvite = @"invite";

#pragma mark -
#pragma mark - NSNotification

NSString *const PlayUtilityUserCheckedInorUncheckedIntoEventNotification = @"theplayapp.com.PlayUtilityUserCheckedInorUncheckedIntoEventNotification";
NSString *const PlayUtilityUserLogOffNotification = @"theplayapp.com.PlayUtilityUserLogOffNotification";
NSString *const PlayUtilityUserRefreshPinsNotificationBecauseEventCreated = @"theplayapp.com.PlayUtilityUserRefreshPinsNotificationBecauseEventCreated";
NSString *const PlayUtilityUserRefreshPinsNotificationBecauseEventDeleted = @"theplayapp.com.PlayUtilityUserRefreshPinsNotificationBecauseEventDeleted";
NSString *const PlayUtilityUserRefreshPinsNotificationBecauseAppLaunched = @"theplayapp.com.PlayUtilityUserRefreshPinsNotificationBecauseAppLaunched";
NSString *const PlayEditProfileChanged = @"theplayapp.com.PlayEditProfileChanged";
NSString *const PlayUtilityFollowingCountChanged = @"theplayapp.com.PlayUtilityFollowingCountChanged";
NSString *const PlayUtilityUserRefreshPinsNotification = @"theplayapp.com.PlayUtilityUserRefreshPinsNotification";
NSString *const CheckInControllerDidFinishEditingEventNotification = @"theplayapp.com.CheckInControllerDidFinishEditingEventNotification";
NSString *const SportsPickerControllerDidNotPickSport = @"theplayapp.com.SportsPickerControllerDidNotPickSport";
NSString *const UserChangedProfilePicNotification = @"theplayapp.com.UserChangedProfilePicNotification";
NSString *const DetailedViewControllerUserDeletedEventNotification = @"theplayapp.com.DetailedViewControllerUserDeletedEventNotification";
NSString *const DetailedViewControllerUserCheckedInorUncheckedIntoEventNotification = @"theplayapp.com.DetailedViewControllerUserCheckedInorUncheckedIntoEventNotification";
NSString *const DetailedViewControllerUserCommentedOnEventNotification = @"theplayapp.com.DetailedViewControllerUserCommentedOnEventNotification";

#pragma mark -
#pragma mark - NSNotification UserInfo keys

NSString *const UserCheckedInorUncheckedIntoEventNotificationUserInfoCheckedInKey = @"UserCheckedInorUncheckedIntoEventNotificationUserInfoCheckedInKey";

#pragma mark -
#pragma mark - UI Texts

NSString *const facebookAccountAlreadyConnected= @"UserCheckedInorUncheckedIntoEventNotificationUserInfoCheckedInKey";

#pragma mark -
#pragma mark - English Sport Names

NSString *const SportPickedisSoccer= @"#soccer";
NSString *const SportPickedisBasketball= @"#basketball";
NSString *const SportPickedisFootball= @"#football";
NSString *const SportPickedisAmericanFootball= @"#americanfootball";
NSString *const SportPickedisHockey= @"#hockey";
NSString *const SportPickedisVolleyBall= @"#volleyball";
NSString *const SportPickedisBaseball= @"#baseball";
NSString *const SportPickedisTennis= @"#tennis";
NSString *const SportPickedisFrisbee= @"#frisbee";
NSString *const SportPickedisRunning= @"#running";
NSString *const SportPickedisYoga= @"#yoga";
NSString *const SportPickedisClimbing= @"#climbing";
NSString *const SportPickedisWildcard= @"#custom";

#pragma mark -
#pragma mark - CreateViewTypes

NSString *const kFacebookViewType= @"facebook";
NSString *const kTwitterViewType= @"twitter";
NSString *const kEmailViewType= @"email";

#pragma mark -
#pragma mark - Facebook Post Types

NSString *const FacebookPostTypeIsLink = @"link";
NSString *const FacebookPostTypeIsPicture = @"picture";
NSString *const FacebookPostTypeIsName = @"name";
NSString *const FacebookPostTypeIsCaption = @"caption";
NSString *const FacebookPostTypeIsDescription = @"description";

@end