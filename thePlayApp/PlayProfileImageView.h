//
//  PlayProfileImageView.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-30.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PlayProfileImageView : UIView

@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) PFImageView *profileImageView;
@property (nonatomic, strong) UIImageView *locationCheckInImageview;


- (void)setFile:(PFFile *)file;
- (void)setFile:(PFFile *)file isLocationCheckedIn:(BOOL)isLocationCheckedIn;

@end
