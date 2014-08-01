//
//  PlayBaseTextCell.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-30.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PlayProfileImageView.h"
#import "PlayConstants.h"
#import "TTTTimeIntervalFormatter.h"

/*! Layout constants */

@protocol PlayBaseTextCellDelegate;

@interface PlayBaseTextCell : UITableViewCell

@property (nonatomic) NSUInteger horizontalTextSpace;
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) PFUser *user;

/*! The horizontal inset of the cell */
@property (nonatomic) CGFloat cellInsetWidth;

// The cell's views
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) UIButton *avatarImageButton;
@property (nonatomic, strong) PlayProfileImageView *avatarImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (void)setUser:(PFUser *)aUser;
- (void)setContentText:(NSString *)contentString;
- (void)setDate:(NSDate *)date;
- (void)setCellInsetWidth:(CGFloat)insetWidth;

+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content;
+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content cellInsetWidth:(CGFloat)cellInset;
+ (NSString *)padString:(NSString *)string withFont:(UIFont *)font toWidth:(CGFloat)width;
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;

@end

/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol PlayBaseTextCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(PlayBaseTextCell *)cellView didTapUserButton:(PFUser *)aUser;

@end
