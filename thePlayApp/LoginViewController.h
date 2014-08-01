//
//  LoginViewController.h
//  Eventfully
//
//  Created by Daniel Mathews on 2012-11-20.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Mixpanel.h"
#import "ViewController.h"

@interface LoginViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate>

@property (strong, nonatomic)  UIImageView *loginAvatar;
@property (strong, nonatomic)  UIButton *backButton;
@property (strong, nonatomic)  UIImageView *logInWithFB;
@property (strong, nonatomic)  UITextField *usernameField;
@property (strong, nonatomic)  UITextField *passwordField;
@property (strong, nonatomic)  UITextField *emailField;
@property (strong, nonatomic)  UILabel *emailLabel;
@property (strong, nonatomic)  NSString *deviceType;
@property (strong, nonatomic) PFUser *user1;
@property (strong, nonatomic)  UIButton *forgotPassButton;
@property (strong, nonatomic)  UIButton *logInButton;
@property (strong, nonatomic)  UIButton *playLogo;

- (void) backButtonClicked:(id) sender;
- (void) loginwithFacebookButton:(id) sender;
- (void) showEmail:(id)sender;
- (void)forgotEmail:(NSString*)email;


- (void) dismissKeyboard:(id) sender;
- (void)animateTextField:(UITextField*)textField up:(BOOL)up;

@end
