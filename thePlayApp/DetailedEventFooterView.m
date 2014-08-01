//
//  DetailedEventFooterView.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-01.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "DetailedEventFooterView.h"
#import "PlayConstants.h"

@implementation DetailedEventFooterView

@synthesize commentField = _commentField;
@synthesize hideDropShadow = _hideDropShadow;
@synthesize mainView = _mainView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _mainView = [[UIView alloc] initWithFrame:CGRectMake( 7.5f, 0.0f, 280.0f, 51.0f)];
      //  _mainView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]];
        [self addSubview:_mainView];
        
        /*UIImageView *messageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconAddComment.png"]];
        messageIcon.frame = CGRectMake( 9.0f, 17.0f, 19.0f, 17.0f);
        [_mainView addSubview:messageIcon];
        
        UIImageView *commentBox = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"TextFieldComment.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f)]];
        commentBox.frame = CGRectMake(35.0f, 8.0f, 237.0f, 35.0f);
        [_mainView addSubview:commentBox];*/
        
        _commentField = [[UITextField alloc] initWithFrame:CGRectMake(7.5f, 0.0f, 280.0f, 31.0f)];
        _commentField.font = [UIFont fontWithName:kPlayFontName size:12.0f];
        _commentField.placeholder = @"Add a comment";
        _commentField.returnKeyType = UIReturnKeySend;
        _commentField.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
        _commentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
       // [_commentField setValue:[UIColor colorWithRed:154.0f/255.0f green:146.0f/255.0f blue:138.0f/255.0f alpha:1.0f] forKeyPath:@"_placeholderLabel.textColor"]; // Are we allowed to modify private properties like this? -Héctor
        [_mainView addSubview:_commentField];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (CGRect)rectForView{
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 69.0f);
}

@end
