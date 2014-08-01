//
//  EventFeedHeaderView.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-03.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "EventFeedHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventFeedHeaderView

@synthesize event = _event;
@synthesize user = _user;
@synthesize buttons = _buttons;
@synthesize checkInButton = _checkInButton;
@synthesize commentButton = _commentButton;
@synthesize delegate = _delegate;
@synthesize timeIntervalFormatter = _timeIntervalFormatter;
@synthesize avatarImageView = _avatarImageView;
@synthesize userButton = _userButton;
@synthesize timestampLabel = _timestampLabel;
@synthesize containerView = _containerView;

#define xInsert 4.0f
#define yInsert 4.0f
#define xInsertForAvatar 8.0f
#define yInsertForAvatar 8.0f
#define xInsertForUsernameAndTime 50.0f
#define yInsertForUsername 8.0f
#define yInsertForTime xInsertForAvatar + 20.0f

- (id)initWithFrame:(CGRect)frame buttons:(PlayPhotoHeaderButtons)otherButtons{
    self = [super initWithFrame:frame];
    if (self) {
    
        [EventFeedHeaderView validateButtons:otherButtons];
        _buttons = otherButtons;

        self.clipsToBounds = NO;
        self.containerView.clipsToBounds = NO;
        self.superview.clipsToBounds = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        
        // translucent portion
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake( xInsert, yInsert, self.bounds.size.width-(xInsert*2), self.bounds.size.height)];
        
        [self addSubview:self.containerView];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"infocardheader.png"]];
    
        [self.containerView addSubview:backgroundImageView];
        backgroundImageView.clipsToBounds = YES;
                
        self.avatarImageView = [[PlayProfileImageView alloc] initWithFrame:CGRectMake(xInsertForAvatar, yInsertForAvatar, 35.0f, 35.0f)];
       // [self.avatarImageView.profileButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.avatarImageView setBackgroundColor:[UIColor clearColor]];
       // self.avatarImageView.profileImageView.layer.cornerRadius = 5.0f;
        //self.avatarImageView.profileImageView.layer.cornerRadius = 5.0f;
        [self.containerView addSubview:self.avatarImageView];
        
        CALayer * l = [_avatarImageView.profileImageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:3.5];
        
        if (self.buttons & PlayPhotoHeaderButtonsComment) {
            // comments button
            _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_containerView addSubview:self.commentButton];
            
            UIImage *commentImage = [UIImage imageNamed:@"infocardcomments.png"];
            [self.commentButton setFrame:CGRectMake(216.0f, 8.0f, commentImage.size.width, commentImage.size.height)];
            [self.commentButton setBackgroundColor:[UIColor clearColor]];
            [self.commentButton setTitle:@"" forState:UIControlStateNormal];
            [self.commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //[self.commentButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
            [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 2.5f, 0.0f, 0.0f)];
            //[[self.commentButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
            [[self.commentButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:11.0f]];
            [[self.commentButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
            [self.commentButton setBackgroundImage:commentImage forState:UIControlStateNormal];
            [self.commentButton setSelected:NO];
        }
        
        if (self.buttons & PlayPhotoHeaderButtonsLike) {
            // like button
            _checkInButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_containerView addSubview:self.checkInButton];
            UIImage *checkInImage = [UIImage imageNamed:@"infocardplayers.png"];
            [self.checkInButton setFrame:CGRectMake(261.0f, 5.0f, checkInImage.size.width, checkInImage.size.height)];
            [self.checkInButton setBackgroundColor:[UIColor clearColor]];
            [self.checkInButton setTitle:@"" forState:UIControlStateNormal];
            [self.checkInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.checkInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            //[self.checkInButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
            //[self.checkInButton setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.750f] forState:UIControlStateSelected];
            //[self.checkInButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 7.0f, 0.0f)];
           // [[self.checkInButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
            [[self.checkInButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:12.0f]];
           // [[self.checkInButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
            [self.checkInButton setAdjustsImageWhenHighlighted:NO];
            [self.checkInButton setAdjustsImageWhenDisabled:NO];
            [self.checkInButton setBackgroundImage:checkInImage forState:UIControlStateNormal];
            [self.checkInButton setBackgroundImage:checkInImage forState:UIControlStateSelected];
            [self.checkInButton setSelected:NO];
        }
        
        if (self.buttons & PlayPhotoHeaderButtonsUser) {
            // This is the user's display name, on a button so that we can tap on it
            self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_containerView addSubview:self.userButton];
            [self.userButton setBackgroundColor:[UIColor clearColor]];
            [[self.userButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:15.0f]];
            [self.userButton setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            //[self.userButton setTitleColor:[UIColor colorWithRed:134.0f/255.0f green:100.0f/255.0f blue:65.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
            [[self.userButton titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
            //[[self.userButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
            //[self.userButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
        }
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
        // timestamp
        self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(xInsertForUsernameAndTime, yInsertForTime, _containerView.bounds.size.width - 50.0f - 72.0f, 18.0f)];
        [_containerView addSubview:self.timestampLabel];
        [self.timestampLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
        //[self.timestampLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        //[self.timestampLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.timestampLabel setFont:[UIFont fontWithName:kPlayFontName size:9.0f]];
        [self.timestampLabel setBackgroundColor:[UIColor clearColor]];
        
      /*  CALayer *layer = _containerView.layer;
        layer.backgroundColor = [[UIColor whiteColor] CGColor];
        layer.masksToBounds = NO;
        layer.shadowRadius = 1.0f;
        layer.shadowOffset = CGSizeMake( 0.0f, 2.0f);
        layer.shadowOpacity = 0.5f;
        layer.shouldRasterize = YES;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake( 0.0f, containerView.frame.size.height - 4.0f, _containerView.frame.size.width, 4.0f)].CGPath;*/
    
    }
    return self;
}

-(void)setEvent:(PFObject *)event{
    
    _event = event;
    _user = [event objectForKey:kPlayEventUserKey];
    
    if(_user) {
        // user's avatar
        NSLog(@"!! YES _user in headerview is %@ for _event %@",_user, _event);
        
        [_user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            // Create avatar view
            // NSLog(@"_user in headerview is %@ for _event %@",_user, _event);
            
            PFFile *profilePictureSmall = [_user objectForKey:kPlayUserProfilePictureSmallKey];
            [self.avatarImageView setFile:profilePictureSmall];
            [self.avatarImageView.profileButton setEnabled:YES];

            
            NSString *authorName = [_user objectForKey:kPlayUserUsernameKey];
            [self.userButton setTitle:authorName forState:UIControlStateNormal];
            [self.userButton setEnabled:YES];
            
        }];
        
    }if (!_user) {
        NSLog(@"!! NO _user in headerview is %@ for _event %@",_user, _event);

        self.avatarImageView.profileImageView.image = [UIImage imageNamed:@"nocheckmark.png"];
        [self.avatarImageView.profileButton setEnabled:NO];
        
        [self.userButton setTitle:@"" forState:UIControlStateNormal];
        [self.userButton setEnabled:NO];
        
    }
    
    CGFloat constrainWidth = _containerView.bounds.size.width;
    
    if (self.buttons & PlayPhotoHeaderButtonsUser) {
        [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.avatarImageView.profileButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.buttons & PlayPhotoHeaderButtonsComment) {
        constrainWidth = self.commentButton.frame.origin.x;
        [self.commentButton addTarget:self action:@selector(didTapCommentOnEventButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.buttons & PlayPhotoHeaderButtonsLike) {
        constrainWidth = self.checkInButton.frame.origin.x;
        [self.checkInButton addTarget:self action:@selector(didTapCheckIntoEventButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // we resize the button to fit the user's name to avoid having a huge touch area
    CGPoint userButtonPoint = CGPointMake(xInsertForUsernameAndTime, yInsertForUsername);
    constrainWidth -= userButtonPoint.x;
    CGSize constrainSize = CGSizeMake(constrainWidth, _containerView.bounds.size.height - userButtonPoint.y*2.0f);
    CGSize userButtonSize = [self.userButton.titleLabel.text sizeWithFont:self.userButton.titleLabel.font constrainedToSize:constrainSize lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect userButtonFrame = CGRectMake(userButtonPoint.x, userButtonPoint.y, userButtonSize.width, userButtonSize.height);
    [self.userButton setFrame:userButtonFrame];
    
    NSTimeInterval timeInterval = [[self.event createdAt] timeIntervalSinceNow];
    NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
    [self.timestampLabel setText:timestamp];
    
    [self setNeedsDisplay];
    
}

- (void)shouldEnableCheckInButton:(BOOL)enable {
    if (enable) {
        [self.checkInButton removeTarget:self action:@selector(didTapCheckIntoEventButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.checkInButton addTarget:self action:@selector(didTapCheckIntoEventButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setCheckInStatus:(BOOL)checkedIn {
    [self.checkInButton setSelected:checkedIn];
    [self.checkInButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 25.0f, 7.0f, 0.0f)];

/*    if (checkedIn) {
        //[[self.checkInButton titleLabel] setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    } else {
       // [self.checkInButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 3.0f, 0.0f)];
        //[[self.checkInButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    }*/
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - ()

+ (void)validateButtons:(PlayPhotoHeaderButtons)buttons {
    if (buttons == PlayPhotoHeaderButtonsNone) {
        [NSException raise:NSInvalidArgumentException format:@"Buttons must be set before initializing EventFeed."];
    }
}

- (void)didTapUserButtonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(eventFeedHeaderView:didTapUserButton:user:)] && _user) {
        [_delegate eventFeedHeaderView:self didTapUserButton:sender user:[self.event objectForKey:kPlayEventUserKey]];
    }
}

- (void)didTapCheckIntoEventButtonAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(eventFeedHeaderView:didTapCheckIntoEventButton:event:)] && _user) {
        
        if([[NSDate date] compare:[_event objectForKey:kPlayEventEndTimeKey]] == NSOrderedDescending){
            [_delegate eventFeedHeaderView:self didTapCommentOnEventButton:button event:self.event];
        }else{
            [_delegate eventFeedHeaderView:self didTapCheckIntoEventButton:button event:self.event];
        }
    }
}

- (void)didTapCommentOnEventButtonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(eventFeedHeaderView:didTapCommentOnEventButton:event:)] && _user) {
        [_delegate eventFeedHeaderView:self didTapCommentOnEventButton:sender event:self.event];
    }
}

@end