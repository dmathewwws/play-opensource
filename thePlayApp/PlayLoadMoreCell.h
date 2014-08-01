//
//  PlayLoadMoreCell.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-31.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PlayLoadMoreCell : UITableViewCell

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *separatorImageTop;
@property (nonatomic, strong) UIImageView *separatorImageBottom;
@property (nonatomic, strong) UIImageView *loadMoreImageView;
@property (nonatomic, strong) UIButton *loadMoreButton;

@property (nonatomic, assign) BOOL hideSeparatorTop;
@property (nonatomic, assign) BOOL hideSeparatorBottom;

@property (nonatomic) CGFloat cellInsetWidth;

@end