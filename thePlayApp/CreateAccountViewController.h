//
//  ViewController.h
//  Create Account
//
//  Created by Daniel Mathews on 2012-10-07.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "PlayConstants.h"
#import "SVProgressHUD.h"

@interface CreateAccountViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImageView *addAvatarImage;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *fbButton;
@property (strong, nonatomic) UIButton *chooseAPhoto;
@property (strong, nonatomic) UIButton *createAccountButton;
@property (strong, nonatomic) UITextView *loginOption;
@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) UITextField *email;
@property (strong, nonatomic) NSString *deviceType;
@property (strong, nonatomic) NSString *signupType;
@property (nonatomic) BOOL *backButtonNeeded;

@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) PFFile *userMediumAvatar;
@property (strong, nonatomic) PFFile *userSmallAvatar;
@property (strong, nonatomic) PFUser *user1;

- (void) dismissKeyboard:(id) sender;
- (void) backButtonClicked:(id) sender;
- (void) loadAddAvatarPic:(id) sender;
- (void) animateTextField:(UITextField*)textField up:(BOOL)up;
- (BOOL) uploadImage:(UIImage *)anImage;
- (void) createAccountButton:(id) sender;
- (BOOL) NSStringIsValidEmail:(NSString *)checkString;
- (void) aTimer:(NSTimer *)timer;

@end