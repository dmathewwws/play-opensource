//
//  PlayProfileImageView.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-30.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "PlayProfileImageView.h"

@implementation PlayProfileImageView

@synthesize profileButton = _profileButton;
@synthesize profileImageView = _profileImageView;
@synthesize locationCheckInImageview = _locationCheckInImageview;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
        self.profileImageView = [[PFImageView alloc] initWithFrame:frame];
        [self addSubview:self.profileImageView];

        self.locationCheckInImageview = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.locationCheckInImageview];
        
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.profileButton];
    
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.profileImageView.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.locationCheckInImageview.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.profileButton.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
}

- (void)setFile:(PFFile *)file{
    if (!file) {
        return;
    }
    
    self.profileImageView.image = [UIImage imageNamed:@"defaultprofile.png"];
    self.profileImageView.file = file;
    [self.profileImageView loadInBackground];

}

- (void)setFile:(PFFile *)file isLocationCheckedIn:(BOOL)isLocationCheckedIn{
    if (!file) {
        return;
    }
    
    self.profileImageView.image = [UIImage imageNamed:@"defaultprofile.png"];
    self.profileImageView.file = file;
    [self.profileImageView loadInBackground];
    
    if (isLocationCheckedIn) {
        self.locationCheckInImageview.image = [UIImage imageNamed:@"checkmark.png"];
    }else{
        self.locationCheckInImageview.image = [UIImage imageNamed:@"nocheckmark.png"];
    }
    
}

@end
