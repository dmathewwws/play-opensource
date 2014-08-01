//
//  PlayImageView.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-30.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PlayImageView : UIImageView

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) PFFile *currentFile;
@property (nonatomic, strong) NSString *url;

- (void) setFile:(PFFile *)file;

@end
