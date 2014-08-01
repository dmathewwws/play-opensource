//
//  PlayLoadMoreCell.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-31.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "PlayLoadMoreCell.h"
#import "PlayConstants.h"

@implementation PlayLoadMoreCell

@synthesize mainView = _mainView;
@synthesize separatorImageTop = _separatorImageTop;
@synthesize separatorImageBottom = _separatorImageBottom;
@synthesize loadMoreImageView = _loadMoreImageView;
@synthesize hideSeparatorTop = _hideSeparatorTop;
@synthesize hideSeparatorBottom = _hideSeparatorBottom;
@synthesize cellInsetWidth = _cellInsetWidth;
@synthesize loadMoreButton = _loadMoreButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.cellInsetWidth = 0.0f;
        _hideSeparatorTop = NO;
        _hideSeparatorBottom = NO;
        
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        
        _mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
        //[_mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]]];
        
        _loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //UIImage *emailButton = [UIImage imageNamed:@"loadmore.png"];
        //[_loadMoreButton setBackgroundImage:emailButton forState:UIControlStateNormal];
        [_loadMoreButton setTitle:@"LOAD MORE" forState:UIControlStateNormal];
        [_loadMoreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _loadMoreButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:13.0f];
        _loadMoreButton.userInteractionEnabled = NO;
        [self.mainView addSubview:_loadMoreButton];
        
        /*self.loadMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lbutton.png"]];
        [_loadMoreImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [_mainView addSubview:self.loadMoreImageView];
        
        self.separatorImageTop = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake( 0.0f, 1.0f, 0.0f, 1.0f)]];
        [_mainView addSubview:_separatorImageTop];
        
        self.separatorImageBottom = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake( 0.0f, 1.0f, 0.0f, 1.0f)]];
        [_mainView addSubview:_separatorImageBottom];*/
        
        [self.contentView addSubview:_mainView];
    }
    
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [_mainView setFrame:CGRectMake( self.cellInsetWidth, self.contentView.frame.origin.y, self.contentView.frame.size.width-2*self.cellInsetWidth, self.contentView.frame.size.height)];
    
    // Layout load more text
    //[self.loadMoreImageView setFrame:CGRectMake( -self.cellInsetWidth, 8.0f, 320.0f, 31.0f)];
    [_loadMoreButton setFrame:CGRectMake(10.0f, 8.0f, 300.0f, 29.0f)];

    
    // Layout separator
    /*[self.separatorImageBottom setFrame:CGRectMake( 0.0f, self.frame.size.height - 2.0f, self.frame.size.width-self.cellInsetWidth * 2.0f, 2.0f)];
    [self.separatorImageBottom setHidden:_hideSeparatorBottom];
    
    [self.separatorImageTop setFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width - self.cellInsetWidth * 2.0f, 2.0f)];*/
    [self.separatorImageTop setHidden:_hideSeparatorTop];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInsetWidth:(CGFloat)insetWidth {
    _cellInsetWidth = insetWidth;
    [_mainView setFrame:CGRectMake( insetWidth, _mainView.frame.origin.y, _mainView.frame.size.width - 2.0f * insetWidth, _mainView.frame.size.height)];
    [self setNeedsDisplay];
}

@end
