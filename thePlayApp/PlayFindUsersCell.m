//
//  PlayFindUsersCell.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-05-03.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "PlayFindUsersCell.h"
#import "UIImage+AlphaAdditions.h"

@implementation PlayFindUsersCell

@synthesize delegate = _delegate;
@synthesize user = _user;
@synthesize followButton = _followButton;
@synthesize nameButton = _nameButton;
@synthesize avatarImageButton = _avatarImageButton;
@synthesize avatarImageView = _avatarImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundFindFriendsCell.png"]]];
        
        //NSLog(@"In friendcell Init");
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.avatarImageView = [[PlayProfileImageView alloc] initWithFrame:CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f)];
        [self.contentView addSubview:self.avatarImageView];
        
        self.avatarImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.avatarImageButton setBackgroundColor:[UIColor clearColor]];
        [self.avatarImageButton setFrame:CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f)];
        [self.avatarImageButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarImageButton];
        
        self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nameButton setBackgroundColor:[UIColor clearColor]];
        [_nameButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        _nameButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
        [self.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        //[self.nameButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.nameButton];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.followButton];
    }
    return self;
}

- (void)setUser:(PFUser *)aUser {
    _user = aUser;
    
    //NSLog(@"_user = %@",_user);
    
    // Configure the cell
    [_avatarImageView setFile:[self.user objectForKey:kPlayUserProfilePictureSmallKey]];
    
    CALayer * l = [_avatarImageView.profileImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:3.5];
    
    // Set name
    NSString *nameString = [self.user objectForKey:kPlayUserUsernameKey];
    
    CGSize nameSize = [nameString sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] forWidth:144.0f lineBreakMode:NSLineBreakByTruncatingTail];
    [_nameButton setTitle:nameString forState:UIControlStateNormal];
    [_nameButton setTitle:nameString forState:UIControlStateHighlighted];
    [_nameButton setContentVerticalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_nameButton setFrame:CGRectMake( 60.0f, 17.0f, nameSize.width, nameSize.height+12)];
        
    [self.followButton setBackgroundImage:[UIImage imageNamed:@"ownarrow.png"] forState:UIControlStateNormal];
    [self.followButton setBackgroundImage:[UIImage imageNamed:@"ownarrow.png"] forState:UIControlStateSelected];
    [self.followButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.followButton setTitle:@"" forState:UIControlStateNormal]; // space added for centering
    [self.followButton setTitle:@"" forState:UIControlStateSelected];
    [_followButton setFrame:CGRectMake( 208.0f, 20.0f, 103.0f, 32.0f)];
}

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        [self.delegate cell:self didTapUserButton:self.user];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)heightForCell {
    return 67.0f;
}

@end
