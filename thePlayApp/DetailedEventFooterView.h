//
//  DetailedEventFooterView.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-01.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedEventFooterView : UIView

@property (nonatomic, strong) UITextField *commentField;
@property (nonatomic) BOOL hideDropShadow;
@property (nonatomic, strong) UIView *mainView;

+ (CGRect)rectForView;

@end
