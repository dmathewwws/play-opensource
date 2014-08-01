//
//  PlayActivityCell.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-28.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "PlayBaseTextCell.h"

@interface PlayActivityCell : PlayBaseTextCell

/*!Setter for the activity associated with this cell */
@property (nonatomic, strong) PFObject *activity;

@property (nonatomic, strong) PlayProfileImageView *activityImageView;
@property (nonatomic, strong) UIButton *activityImageButton;

/*! Flag to remove the right-hand side image if not necessary */
@property (nonatomic) BOOL hasActivityImage;

/*! Private setter for the right-hand side image */
- (void)setActivityImageFile:(PFFile *)image;

/*! Button touch handler for activity image button overlay */
- (void)didTapActivityButton:(id)sender;

/*! Static helper method to calculate the space available for text given images and insets */
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;

/*!Set the new state. This changes the background of the cell. */
- (void)setIsNew:(BOOL)isNew;


@end

/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.

@protocol PlayActivityCellDelegate <PlayBaseTextCellDelegate>
@optional

- (void)cell:(PlayActivityCell *)cellView didTapActivityButton:(PFObject *)activity;

@end
*/