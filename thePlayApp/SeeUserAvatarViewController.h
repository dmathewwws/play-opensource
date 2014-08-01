//
//  SeeUserAvatarViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-04-08.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SeeUserAvatarViewController : UIViewController

@property (nonatomic, strong) PFImageView *profileImageView;
- (void)setFile:(PFFile *)file;

- (void) dismissScreen:(id) sender;

@end
