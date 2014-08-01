//
//  EventFeedCell.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-07.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "EventFeedCell.h"
#import "PlayConstants.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventFeedCell

@synthesize photoButton = _photoButton;
@synthesize iconTypeLabel = _iconTypeLabel;
@synthesize locationLabel = _locationLabel;
@synthesize timeLabel = _timeLabel;
@synthesize iconTypeButton = _iconTypeButton;
@synthesize iconLocationButton = _iconLocationButton;
@synthesize iconTimeButton = _iconTimeButton;

#define xInsert 4.0f
#define yInsert 4.0f
#define widthofEventImage 100.0f
#define heightofEventImage 100.0f
#define xInsertForIcon 26.0f
#define yInsertForIcon 2.0f
#define xSpaceBetweenIconAndText 4.0f
#define squareForEventInfoImages 20.0f

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
       /* UIView *dropshadowView = [[UIView alloc] init];
        dropshadowView.backgroundColor = [UIColor whiteColor];
        dropshadowView.frame = CGRectMake( 20.0f, -44.0f, 280.0f, 322.0f);
        [self.contentView addSubview:dropshadowView];*/
        
        /*CALayer *layer = dropshadowView.layer;
        layer.masksToBounds = NO;
        layer.shadowRadius = 3.0f;
        layer.shadowOpacity = 0.5f;
        layer.shadowOffset = CGSizeMake( 0.0f, 1.0f);
        layer.shouldRasterize = YES;*/
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"infocardbody.png"]];
        
        [self.contentView addSubview:backgroundImageView];
        backgroundImageView.clipsToBounds = YES;
        
        //self.imageView.frame = CGRectMake(xInsert+xSmallInsert, yInsert, widthofEventImage, heightofEventImage);
        //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CALayer * l = [self.imageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:3.5];
        
        //Sport Icon Button
        _iconTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *sportIconImage = [UIImage imageNamed:@"sport11minig.png"];
        //[_iconTypeButton setFrame:CGRectMake(xInsert+widthofEventImage+xSmallInsert,yInsert,squareForEventInfoImages,squareForEventInfoImages)];
        [_iconTypeButton setBackgroundImage:sportIconImage forState:UIControlStateNormal];
        _iconTypeButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_iconTypeButton];
        
        NSLog(@"self.contentView.frame.size.width is %f",self.contentView.frame.size.width);
        
        self.iconTypeLabel = [[UILabel alloc] init];
        self.iconTypeLabel.font = [UIFont fontWithName:kPlayFontName size:11.0f];
        self.iconTypeLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
        [self.iconTypeLabel setBackgroundColor:[UIColor clearColor]];
        self.iconTypeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.iconTypeLabel];
        
        //Location Icon Button
        _iconLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *locationIconImage = [UIImage imageNamed:@"infocardlocation.png"];
        //[_iconLocationButton setFrame:CGRectMake(xInsert+widthofEventImage+xSmallInsert,_iconTypeButton.frame.origin.y+_iconTypeButton.frame.size.height+yInsert,squareForEventInfoImages,squareForEventInfoImages)];
        [_iconLocationButton setBackgroundImage:locationIconImage forState:UIControlStateNormal];
        _iconLocationButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_iconLocationButton];
        
        self.locationLabel = [[UILabel alloc] init];
        self.locationLabel.font = [UIFont fontWithName:kPlayFontName size:11.0f];
        self.locationLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
        self.locationLabel.textAlignment = NSTextAlignmentCenter;
        [self.locationLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.locationLabel];
        
        //Time Icon Button
        _iconTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *timeIconImage = [UIImage imageNamed:@"infocardtime.png"];
        //[_iconTimeButton setFrame:CGRectMake(xInsert+widthofEventImage+xSmallInsert,_iconLocationButton.frame.origin.y+_iconLocationButton.frame.size.height+yInsert,squareForEventInfoImages,squareForEventInfoImages)];
        [_iconTimeButton setBackgroundImage:timeIconImage forState:UIControlStateNormal];
        _iconTimeButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_iconTimeButton];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont fontWithName:kPlayFontName size:11.0f];
        self.timeLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.timeLabel];
        
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.photoButton];
        
        [self.contentView bringSubviewToFront:self.imageView];
        

    }
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(xInsert, yInsert, self.frame.size.width, self.frame.size.height);
    self.imageView.frame = CGRectMake(self.contentView.frame.origin.x+9, self.contentView.frame.origin.y+6, widthofEventImage, heightofEventImage);
    self.photoButton.frame = self.contentView.frame;
    self.iconTypeButton.frame = CGRectMake(xInsert+widthofEventImage+xInsertForIcon,8,squareForEventInfoImages,squareForEventInfoImages);
    self.iconTypeLabel.frame = CGRectMake(_iconTypeButton.frame.origin.x+squareForEventInfoImages+xSpaceBetweenIconAndText,_iconTypeButton.frame.origin.y,self.contentView.frame.size.width-(_iconTypeButton.frame.origin.x+squareForEventInfoImages+xSpaceBetweenIconAndText)-(xInsert*4),squareForEventInfoImages);
    self.iconLocationButton.frame = CGRectMake(xInsert+widthofEventImage+xInsertForIcon,_iconTypeButton.frame.origin.y+_iconTypeButton.frame.size.height+(7*3)+1,squareForEventInfoImages,squareForEventInfoImages);
    self.locationLabel.frame = CGRectMake(_iconLocationButton.frame.origin.x+squareForEventInfoImages+xSpaceBetweenIconAndText,_iconLocationButton.frame.origin.y,self.contentView.frame.size.width-(_iconLocationButton.frame.origin.x+squareForEventInfoImages+xSpaceBetweenIconAndText)-(xInsert*4),squareForEventInfoImages);
    self.iconTimeButton.frame = CGRectMake(xInsert+widthofEventImage+xInsertForIcon,_iconLocationButton.frame.origin.y+_iconLocationButton.frame.size.height+(7*3)+1,squareForEventInfoImages,squareForEventInfoImages);
    self.timeLabel.frame = CGRectMake(_iconTimeButton.frame.origin.x+squareForEventInfoImages+xSpaceBetweenIconAndText,_iconTimeButton.frame.origin.y,self.contentView.frame.size.width-(_iconTimeButton.frame.origin.x+squareForEventInfoImages+xSpaceBetweenIconAndText)-(xInsert*4),squareForEventInfoImages);
    
}

@end
