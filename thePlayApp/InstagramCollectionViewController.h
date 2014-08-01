//
//  InstagramCollectionViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-14.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramCollectionViewCell.h"

@protocol InstagramCollectionViewControllerDelegate;

@interface InstagramCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong,nonatomic) NSArray *instagramDataArray;
@property (strong,nonatomic) NSString *instagramSearchTerm;
@property (strong,nonatomic) NSDictionary *instagramDataDictionary;

/*! @name Delegate */
@property (nonatomic, strong) id<InstagramCollectionViewControllerDelegate> delegate;

- (void)instagramString:(NSString *)instagramURL;
- (void)backButtonPressed:(id)sender;

@end

@protocol InstagramCollectionViewControllerDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the photgrapher's name/avatar is tapped
 @param button the tapped UIButton
 @param user the PFUser for the photograper
 */
- (void)instaPickerController:(InstagramCollectionViewController*)instaPickerController anImage:(UIImage *)anImage;

@end