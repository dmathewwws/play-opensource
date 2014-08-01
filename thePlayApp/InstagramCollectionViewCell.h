//
//  InstagramCollectionViewCell.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-14.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *instagramImage;

- (void) setImage:(UIImage*)anImage;

@end
