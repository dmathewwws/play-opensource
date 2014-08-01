//
//  RegisterOrLoginViewController.h
//  Eventfully
//
//  Created by Daniel Mathews on 2012-11-20.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateAccountViewController.h"
#import "UIDeviceHardware.h"
#import "PlayConstants.h"

@interface RegisterOrLoginViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *connectwithTwitterButton;
@property (strong, nonatomic) UIButton *signupWithEmailButton;
@property (strong, nonatomic) UIButton *loginWithEmailButton;
@property (strong, nonatomic) UIButton *signUpInfoButton;
@property (strong, nonatomic) NSString *deviceType;
@property (nonatomic) BOOL pageControlIsChangingPage;

-(void)aTimer:(NSTimer*)timer;
- (void)registerButton:(id)sender;
- (void)tourPageControl:(id)sender;
- (void)registerWithTwitterButton:(id)sender;
- (void)registerWithEmailButton:(id)sender;
- (void)logInButton:(id)sender;
- (void)twitterInit:(NSString *)permissions;
- (void)facebookInit:(NSString*) permissions;

@end