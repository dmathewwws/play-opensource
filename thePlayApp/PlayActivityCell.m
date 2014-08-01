//
//  PlayActivityCell.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-28.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "PlayActivityCell.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation PlayActivityCell

@synthesize activity = _activity;
@synthesize activityImageView = _activityImageView;
@synthesize activityImageButton = _activityImageButton;
@synthesize hasActivityImage;
@synthesize horizontalTextSpace = _horizontalTextSpace;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _horizontalTextSpace = [PlayBaseTextCell horizontalTextSpaceForInsetWidth:0];
        
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        // Create subviews and set cell properties
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.hasActivityImage = NO; //No until one is set
        
        self.activityImageView = [[PlayProfileImageView alloc] init];
        [self.activityImageView setBackgroundColor:[UIColor clearColor]];
        [self.activityImageView setOpaque:YES];
        [self.mainView addSubview:self.activityImageView];
        
        self.activityImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.activityImageButton setBackgroundColor:[UIColor clearColor]];
        [self.activityImageButton addTarget:self action:@selector(didTapActivityButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.activityImageButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Layout the activity image and show it if it is not nil (no image for the follow activity).
    // Note that the image view is still allocated and ready to be dispalyed since these cells
    // will be reused for all types of activity.
    [self.activityImageView setFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - 46.0f, 8.0f, 33.0f, 33.0f)];
    [self.activityImageButton setFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - 46.0f, 8.0f, 33.0f, 33.0f)];
    
    // Add activity image if one was set
    if (self.hasActivityImage) {
        [self.activityImageView setHidden:NO];
        [self.activityImageButton setHidden:NO];
    } else {
        [self.activityImageView setHidden:YES];
        [self.activityImageButton setHidden:YES];
    }
    
    // Change frame of the content text so it doesn't go through the right-hand side picture
    CGSize contentSize = [self.contentLabel.text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 72.0f - 46.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    [self.contentLabel setFrame:CGRectMake( 46.0f, 10.0f, contentSize.width, contentSize.height)];
    
    // Layout the timestamp label given new vertical
    CGSize timeSize = [self.timeLabel.text sizeWithFont:[UIFont systemFontOfSize:11.0f] forWidth:[UIScreen mainScreen].bounds.size.width - 72.0f - 46.0f lineBreakMode:NSLineBreakByTruncatingTail];
    [self.timeLabel setFrame:CGRectMake( 46.0f, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 2.0f, timeSize.width, timeSize.height)];
}

- (void)setIsNew:(BOOL)isNew{
    
    
}

- (void)setActivity:(PFObject *)activity {
    // Set the activity property
    _activity = activity;
    if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsCheckIn] || [[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsComment]) {
        [self setActivityImageFile:(PFFile*)[[activity objectForKey:kPlayActivityEventKey] objectForKey:kPlayEventThumbnailKey]];
    } else {
        [self setActivityImageFile:nil];
    }
    
    /*NSString *activityString = [PAPActivityFeedViewController stringForActivityType:(NSString*)[activity objectForKey:kPAPActivityTypeKey]];
    self.user = [activity objectForKey:kPAPActivityFromUserKey];
    
    // Set name button properties and avatar image
    [self.avatarImageView setFile:[self.user objectForKey:kPAPUserProfilePicSmallKey]];
    [self.nameButton setTitle:[self.user objectForKey:kPAPUserDisplayNameKey] forState:UIControlStateNormal];
    [self.nameButton setTitle:[self.user objectForKey:kPAPUserDisplayNameKey] forState:UIControlStateHighlighted];
    
    // If user is set after the contentText, we reset the content to include padding
    if (self.contentLabel.text) {
        [self setContentText:self.contentLabel.text];
    }
    
    if (self.user) {
        CGSize nameSize = [self.nameButton.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:13.0f] forWidth:nameMaxWidth lineBreakMode:UILineBreakModeTailTruncation];
        NSString *paddedString = [PAPBaseTextCell padString:activityString withFont:[UIFont systemFontOfSize:13.0f] toWidth:nameSize.width];
        [self.contentLabel setText:paddedString];
    } else { // Otherwise we ignore the padding and we'll add it after we set the user
        [self.contentLabel setText:activityString];
    }
    
    [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[activity createdAt]]];*/
    
    [self setNeedsDisplay];
}

- (void)setCellInsetWidth:(CGFloat)insetWidth {
    [super setCellInsetWidth:insetWidth];
    _horizontalTextSpace = [PlayActivityCell horizontalTextSpaceForInsetWidth:insetWidth];
}


- (void)setActivityImageFile:(PFFile *)image{
    
}

- (void)didTapActivityButton:(id)sender{
    
}

+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth {
    return ([UIScreen mainScreen].bounds.size.width - (insetWidth * 2.0f)) - 72.0f - 46.0f;
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
