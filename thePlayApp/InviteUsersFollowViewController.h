//
//  InviteUsersFollowViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-04-09.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "UserFollowViewController.h"

@protocol InviteUsersFollowViewControllerDelegate;

@interface InviteUsersFollowViewController : UserFollowViewController

/*! @name Delegate */
@property (nonatomic, strong) id<InviteUsersFollowViewControllerDelegate> delegate;
//@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *queryType;
@property (nonatomic, strong) NSMutableSet *invitedUsersSet;
@property (nonatomic, strong) NSMutableSet *pushUsersSet;
@property (nonatomic, strong) NSSet *oldInvitedUsersSet;
@property (nonatomic, strong) NSSet *oldPushUsersSet;
@property (nonatomic, strong) UIBarButtonItem *inviteButton;

- (void) inviteButton:(id) sender;
- (void)backButtonPressed:(id)sender;

@end

@protocol InviteUsersFollowViewControllerDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the photgrapher's name/avatar is tapped
 @param button the tapped UIButton
 @param user the PFUser for the photograper
 */

- (void)inviteFriendsController:(InviteUsersFollowViewController*)inviteFriendsController invitedUserSet:(NSSet*)invitedUserSet pushUserSet:(NSSet*)pushUserSet;

@end

