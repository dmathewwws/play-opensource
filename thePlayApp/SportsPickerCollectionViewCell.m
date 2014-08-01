//
//  SportsPickerCollectionViewCell.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-30.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "SportsPickerCollectionViewCell.h"
#import "PlayConstants.h"

@implementation SportsPickerCollectionViewCell

@synthesize sportsIcon = _sportsIcon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    _sportsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sport0.png"]];
    [_sportsIcon setFrame:frame];
    [self addSubview:_sportsIcon];
    
    }
    return self;
}

- (void) setImage:(NSInteger)index{
    _sportsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Sport%d.png",index]]];
    [_sportsIcon setFrame:CGRectMake(0,0,90,90)];
    [self addSubview:_sportsIcon];
    
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
