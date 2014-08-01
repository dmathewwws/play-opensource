//
//  PlayImageView.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-30.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "PlayImageView.h"

@implementation PlayImageView

@synthesize placeholderImage = _placeholderImage;
@synthesize currentFile = _currentFile;
@synthesize url = _url;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setFile:(PFFile *)file{
    UIImageView *border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultprofile.png"]];
    [self addSubview:border];
    
    NSString *requestURL = file.url; // Save copy of url locally (will not change in block)
    [self setUrl:file.url]; // Save copy of url on the instance
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            if ([requestURL isEqualToString:self.url]) {
                [self setImage:image];
                [self setNeedsDisplay];
            }
        } else {
            NSLog(@"Error on fetching file");
        }
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
