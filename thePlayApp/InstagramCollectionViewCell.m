//
//  InstagramCollectionViewCell.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-14.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "InstagramCollectionViewCell.h"

#define widthofImage 300.0f
#define heightofImage 300.0f

@implementation InstagramCollectionViewCell

@synthesize instagramImage = _instagramImage;

-(id) init{
    self = [super init];
    if (self) {
        _instagramImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,widthofImage,heightofImage)];
        [self addSubview:_instagramImage];
    
        NSLog(@"in init for InstargramCell");
        
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _instagramImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,widthofImage,heightofImage)];
        [self addSubview:_instagramImage];
        
                NSLog(@"in initWithFrame for InstargramCell");
        
    }
    return self;
}

- (void) setImage:(UIImage*)anImage{
    _instagramImage = [[UIImageView alloc] initWithImage:anImage];
    [_instagramImage setFrame:CGRectMake(0,0,widthofImage,heightofImage)];
    [self addSubview:_instagramImage];
 
    NSLog(@"in setImage for InstargramCell");
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
