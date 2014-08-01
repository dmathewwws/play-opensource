//
//  EventFeedCell.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-07.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <Parse/Parse.h>

@interface EventFeedCell : PFTableViewCell

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UILabel *iconTypeLabel;
@property (nonatomic, strong) UIButton *iconTypeButton;

@property (nonatomic, strong) UIButton *iconLocationButton;
@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UIButton *iconTimeButton;
@property (nonatomic, strong) UILabel *timeLabel;

@end