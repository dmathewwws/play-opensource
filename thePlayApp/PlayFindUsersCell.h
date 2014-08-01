//
//  PlayFindUsersCell.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-05-03.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "PlayProfileImageView.h"
#import "PlayConstants.h"

@protocol PlayFindUsersCellDelegate;

@interface PlayFindUsersCell : UITableViewCell

@property (nonatomic, strong) id<PlayFindUsersCellDelegate> delegate;

/*! The user represented in the cell */
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) UIButton *avatarImageButton;
@property (nonatomic, strong) PlayProfileImageView *avatarImageView;

/*! Setters for the cell's content */
- (void)setUser:(PFUser *)aUser;
- (void)didTapUserButtonAction:(id)sender;
/*! Static Helper methods */
+ (CGFloat)heightForCell;

@end

@protocol PlayFindUsersCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */

- (void)cell:(PlayFindUsersCell *)cellView didTapUserButton:(PFUser *)aUser;

@end