//
//  SportsCollectionViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-30.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsPickerCollectionViewCell.h"

@protocol SportsCollectionViewControllerDelegate;

@interface SportsCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

/*! @name Delegate */
@property (nonatomic, strong) id<SportsCollectionViewControllerDelegate> delegate;
@property (nonatomic) BOOL hasSportPicked;

- (void)setBackground:(UIImage*)bkgdImage;

@end

@protocol SportsCollectionViewControllerDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the photgrapher's name/avatar is tapped
 @param button the tapped UIButton
 @param user the PFUser for the photograper
 */
- (void)sportPickerController:(SportsCollectionViewController*)sportPickerController indexRow:(NSInteger)indexRow;

- (void)backButtonPressed:(id)sender;

@end
