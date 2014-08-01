//
//  SportsPickerCollectionViewCell.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-30.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportsPickerCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *sportsIcon;

- (void) setImage:(NSInteger)index;

@end
