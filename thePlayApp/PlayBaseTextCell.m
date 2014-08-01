//
//  PlayBaseTextCell.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-30.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "PlayBaseTextCell.h"

#define vertBorderSpacing 8.0f
#define vertElemSpacing 0.0f

#define horiBorderSpacing 5.0f
#define horiBorderSpacingBottom 8.0f
#define horiElemSpacing 7.0f

#define vertTextBorderSpacing 10.0f

#define avatarX horiBorderSpacing
#define avatarY vertBorderSpacing
#define avatarDim 35.0f

#define nameX avatarX+avatarDim+horiElemSpacing
#define nameY vertTextBorderSpacing
#define nameMaxWidth 200.0f

#define timeX avatarX+avatarDim+horiElemSpacing

static TTTTimeIntervalFormatter *timeFormatter;

@implementation PlayBaseTextCell

@synthesize delegate = _delegate;
@synthesize user = _user;
@synthesize mainView = _mainView;
@synthesize nameButton = _nameButton;
@synthesize avatarImageButton = _avatarImageButton;
@synthesize avatarImageView = _avatarImageView;
@synthesize contentLabel = _contentLabel;
@synthesize timeLabel = _timeLabel;
@synthesize cellInsetWidth = _cellInsetWidth;
@synthesize horizontalTextSpace = _horizontalTextSpace;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        _cellInsetWidth = 0.0f;
        self.clipsToBounds = YES;
        _horizontalTextSpace =  [PlayBaseTextCell horizontalTextSpaceForInsetWidth:_cellInsetWidth];
        
        _mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
        
        self.avatarImageView = [[PlayProfileImageView alloc] initWithFrame:CGRectMake(avatarX, avatarY, avatarDim, avatarDim)];
        [_mainView addSubview:self.avatarImageView];

        self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nameButton setBackgroundColor:[UIColor clearColor]];
        [self.nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.nameButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [self.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:self.nameButton];
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentLabel setFont:[UIFont systemFontOfSize:13.0f]];
        //[self.contentLabel setTextColor:[UIColor colorWithRed:73./255. green:55./255. blue:35./255. alpha:1.000]];
        [self.contentLabel setNumberOfLines:0];
        [self.contentLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        [_mainView addSubview:self.contentLabel];

        self.timeLabel = [[UILabel alloc] init];
        [self.timeLabel setFont:[UIFont systemFontOfSize:11]];
        [self.timeLabel setTextColor:[UIColor grayColor]];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [_mainView addSubview:self.timeLabel];
        
        self.avatarImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.avatarImageButton setBackgroundColor:[UIColor clearColor]];
        [self.avatarImageButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_mainView addSubview:self.avatarImageButton];
        
        [self.contentView addSubview:_mainView];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_mainView setFrame:CGRectMake(_cellInsetWidth, self.contentView.frame.origin.y, self.contentView.frame.size.width-2*_cellInsetWidth, self.contentView.frame.size.height)];
    
    [self.avatarImageButton setFrame:CGRectMake(avatarX, avatarY, avatarDim, avatarDim)];
    
    // Layout the name button
    CGSize nameSize = [self.nameButton.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:13] forWidth:nameMaxWidth lineBreakMode:NSLineBreakByTruncatingTail];
    [self.nameButton setFrame:CGRectMake(nameX, nameY, nameSize.width, nameSize.height)];
    
    // Layout the content
    CGSize contentSize = [self.contentLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(_horizontalTextSpace, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    [self.contentLabel setFrame:CGRectMake(nameX, vertTextBorderSpacing, contentSize.width, contentSize.height)];
    
    // Layout the timestamp label
    CGSize timeSize = [self.timeLabel.text sizeWithFont:[UIFont systemFontOfSize:11] forWidth:_horizontalTextSpace lineBreakMode:NSLineBreakByTruncatingTail];
    [self.timeLabel setFrame:CGRectMake(timeX, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + vertElemSpacing, timeSize.width, timeSize.height)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(PFUser *)aUser {
    _user = aUser;
    
    [_user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    // Set name button properties and avatar image
    [self.avatarImageView setFile:[self.user objectForKey:kPlayUserProfilePictureSmallKey]];
    [self.nameButton setTitle:[self.user objectForKey:kPlayUserUsernameKey] forState:UIControlStateNormal];
    [self.nameButton setTitle:[self.user objectForKey:kPlayUserUsernameKey] forState:UIControlStateHighlighted];
        
    }];
    
    // If user is set after the contentText, we reset the content to include padding
    if (self.contentLabel.text) {
        [self setContentText:self.contentLabel.text];
    }
    [self setNeedsDisplay];
}

- (void)setContentText:(NSString *)contentString {
    // If we have a user we pad the content with spaces to make room for the name
    if (self.user) {
        CGSize nameSize = [self.nameButton.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:13] forWidth:nameMaxWidth lineBreakMode:NSLineBreakByTruncatingTail];
        NSString *paddedString = [PlayBaseTextCell padString:contentString withFont:[UIFont systemFontOfSize:13] toWidth:nameSize.width];
        [self.contentLabel setText:paddedString];
    } else { // Otherwise we ignore the padding and we'll add it after we set the user
        [self.contentLabel setText:contentString];
    }
    [self setNeedsDisplay];
}

- (void)setDate:(NSDate *)date {
    // Set the label with a human readable time
    [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:date]];
    [self setNeedsDisplay];
}

- (void)setCellInsetWidth:(CGFloat)insetWidth {
    // Change the mainView's frame to be insetted by insetWidth and update the content text space
    _cellInsetWidth = insetWidth;
    [_mainView setFrame:CGRectMake(insetWidth, _mainView.frame.origin.y, _mainView.frame.size.width-2*insetWidth, _mainView.frame.size.height)];
    _horizontalTextSpace = [PlayBaseTextCell horizontalTextSpaceForInsetWidth:insetWidth];
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark - PlayBaseTextCell methods

+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content{
    return [PlayBaseTextCell heightForCellWithName:name contentString:content cellInsetWidth:0];
    
}

+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content cellInsetWidth:(CGFloat)cellInset{
    
    CGSize nameSize = [name sizeWithFont:[UIFont boldSystemFontOfSize:13] forWidth:nameMaxWidth lineBreakMode:NSLineBreakByTruncatingTail];
    NSString *paddedString = [PlayBaseTextCell padString:content withFont:[UIFont systemFontOfSize:13] toWidth:nameSize.width];
    CGFloat horizontalTextSpace = [PlayBaseTextCell horizontalTextSpaceForInsetWidth:cellInset];
    
    CGSize contentSize = [paddedString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(horizontalTextSpace, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat singleLineHeight = [@"test" sizeWithFont:[UIFont systemFontOfSize:13]].height;
    
    // Calculate the added height necessary for multiline text. Ensure value is not below 0.
    CGFloat multilineHeightAddition = (contentSize.height - singleLineHeight) > 0 ? (contentSize.height - singleLineHeight) : 0;
    
    return horiBorderSpacing + avatarDim + horiBorderSpacingBottom + multilineHeightAddition;
    
}

+ (NSString *)padString:(NSString *)string withFont:(UIFont *)font toWidth:(CGFloat)width{
    // Find number of spaces to pad
    NSMutableString *paddedString = [[NSMutableString alloc] init];
    while (true) {
        [paddedString appendString:@" "];
        if ([paddedString sizeWithFont:font].width >= width) {
            break;
        }
    }
    
    // Add final spaces to be ready for first word
    [paddedString appendString:[NSString stringWithFormat:@" %@",string]];
    return paddedString;

}

+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth{
    return (320-(insetWidth*2)) - (horiBorderSpacing+avatarDim+horiElemSpacing+horiBorderSpacing);
    
}

#pragma mark -
#pragma mark - Delegate methods

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        [self.delegate cell:self didTapUserButton:self.user];
    }
}

@end
