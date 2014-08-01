//
//  EventFeedHeaderView.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-03.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PlayConstants.h"
#import "TTTTimeIntervalFormatter.h"
#import "PlayProfileImageView.h"

typedef enum {
    PlayPhotoHeaderButtonsNone = 0,
    PlayPhotoHeaderButtonsLike = 1 << 0,
    PlayPhotoHeaderButtonsComment = 1 << 1,
    PlayPhotoHeaderButtonsUser = 1 << 2,
    
    PlayPhotoHeaderButtonsDefault = PlayPhotoHeaderButtonsLike | PlayPhotoHeaderButtonsComment | PlayPhotoHeaderButtonsUser
} PlayPhotoHeaderButtons;

@protocol EventFeedHeaderViewDelegate;

@interface EventFeedHeaderView : UIView

/// The photo associated with this view
@property (nonatomic,strong) PFObject *event;
@property (nonatomic,strong) PFUser *user;

/// The bitmask which specifies the enabled interaction elements in the view
@property (nonatomic, assign) PlayPhotoHeaderButtons buttons;

/// The CheckInTo Event button
@property (nonatomic,strong) UIButton *checkInButton;

/// The Comment On Photo button
@property (nonatomic,strong) UIButton *commentButton;

/*! @name Delegate */
@property (nonatomic,weak) id <EventFeedHeaderViewDelegate> delegate;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@property (nonatomic, strong) PlayProfileImageView *avatarImageView;
@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UILabel *timestampLabel;

- (void)shouldEnableCheckInButton:(BOOL)enable;
- (void)setCheckInStatus:(BOOL)checkedIn;

- (id)initWithFrame:(CGRect)frame buttons:(PlayPhotoHeaderButtons)otherButtons;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */

@protocol EventFeedHeaderViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped @param user the PFUser associated with this button
 */
- (void)eventFeedHeaderView:(EventFeedHeaderView *)eventFeedHeaderView didTapUserButton:(UIButton *)button user:(PFUser *)user;

/*!
 Sent to the delegate when the like photo button is tapped @param photo the PFObject for the photo that is being liked or disliked
 */
- (void)eventFeedHeaderView:(EventFeedHeaderView *)eventFeedHeaderView didTapCheckIntoEventButton:(UIButton *)button event:(PFObject *)event;

/*!
 Sent to the delegate when the comment on photo button is tapped @param photo the PFObject for the photo that will be commented on
 */
- (void)eventFeedHeaderView:(EventFeedHeaderView *)eventFeedHeaderView didTapCommentOnEventButton:(UIButton *)button event:(PFObject *)event;

@end