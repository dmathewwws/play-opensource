//
//  LoginViewController.m
//  Eventfully
//
//  Created by Daniel Mathews on 2012-11-20.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "LoginViewController.h"
#import "GAI.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize loginAvatar = _loginAvatar;
@synthesize backButton = _backButton;
@synthesize logInWithFB = _logInWithFB;
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize user1 = _user1;
@synthesize emailField = _emailField;
@synthesize forgotPassButton = _forgotPassButton;
@synthesize logInButton = _logInButton;
@synthesize deviceType = _deviceType;
@synthesize playLogo = _playLogo;
@synthesize emailLabel = _emailLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _user1 = [PFUser user];
    
    _deviceType = [PlayUtility setDeviceType];
    
    UIImageView *backgroundImageView = nil;
    
    if (self.view.bounds.size.height == 460) {
        backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountbgi4.png"]];
    }else{
        backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountbgi5.png"]];
    }
    
    [self.view addSubview:backgroundImageView];
    backgroundImageView.clipsToBounds = YES;
    
    
    _playLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *playLogo = [UIImage imageNamed:@"Login-PlayIcon.png"];
    
    [_playLogo setBackgroundImage:playLogo forState:UIControlStateNormal];
    _playLogo.userInteractionEnabled = NO;
    
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_playLogo setFrame:CGRectMake(119,75,playLogo.size.width,playLogo.size.height)];
    }else{
        [_playLogo setFrame:CGRectMake(119,117,playLogo.size.width,playLogo.size.height)];
    }
    [self.view addSubview:_playLogo];
    
    _usernameField = [[UITextField alloc] init];
    UIImage *fieldBoxImage = [UIImage imageNamed:@"SignUp-FieldBox.png"];
    [_usernameField setFrame:CGRectMake(32, self.view.bounds.size.height-235, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    
    _passwordField = [[UITextField alloc] init];
    [_passwordField setFrame:CGRectMake(32, self.view.bounds.size.height-179, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    
    _emailField = [[UITextField alloc] init];
    [_emailField setFrame:CGRectMake(32, self.view.bounds.size.height-90, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    
    UIView *usernameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _usernameField.frame.size.height)];
    _usernameField.leftView = usernameLeftView;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    
    _usernameField.background = fieldBoxImage;
    _usernameField.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    _usernameField.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    _usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameField.returnKeyType = UIReturnKeyNext;
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_usernameField.frame.origin.x, _usernameField.frame.origin.y - 28, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    usernameLabel.text = @"USERNAME";
    usernameLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    usernameLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:usernameLabel];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(_passwordField.frame.origin.x, _passwordField.frame.origin.y - 28, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    passwordLabel.text = @"PASSWORD";
    passwordLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    passwordLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:passwordLabel];
    
    _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_emailField.frame.origin.x, _emailField.frame.origin.y - 28, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    _emailLabel.text = @"EMAIL";
    _emailLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    _emailLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    _emailLabel.textAlignment = NSTextAlignmentCenter;
    _emailLabel.hidden = YES;
    [self.view addSubview:_emailLabel];
    
    [self.view addSubview:_usernameField];
    _usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _usernameField.delegate = self;
    
    UIView *passwordLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _passwordField.frame.size.height)];
    _passwordField.leftView = passwordLeftView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    _passwordField.background = fieldBoxImage;
    _passwordField.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    _passwordField.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordField.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:_passwordField];
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    
    
    UIView *emailLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _emailField.frame.size.height)];
    _emailField.leftView = emailLeftView;
    _emailField.leftViewMode = UITextFieldViewModeAlways;
    
    _emailField.background = fieldBoxImage;
    _emailField.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    _emailField.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    _emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _emailField.returnKeyType = UIReturnKeyDone;
    
    _emailField.hidden = YES;
    [self.view addSubview:_emailField];
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailField.delegate = self;

    
    //Back button
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *emailButton = [UIImage imageNamed:@"SignUp-EmailButton.png"];
    
    [_backButton setBackgroundImage:emailButton forState:UIControlStateNormal];
    
    [_backButton setTitle:@"BACK" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_backButton setFrame:CGRectMake(12,(self.view.bounds.size.height)-43,emailButton.size.width,emailButton.size.height)];
    }else{
        [_backButton setFrame:CGRectMake(12,(self.view.bounds.size.height)-43,emailButton.size.width,emailButton.size.height)];
    }
    
    [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    //Login button
    _logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *loginButton = [UIImage imageNamed:@"SignUp-LoginButton.png"];
    
    [_logInButton setBackgroundImage:loginButton forState:UIControlStateNormal];
    
    [_logInButton setTitle:@"PLAY" forState:UIControlStateNormal];
    [_logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _logInButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_logInButton setFrame:CGRectMake(163,(self.view.bounds.size.height)-43,loginButton.size.width,loginButton.size.height)];
    }else{
        [_logInButton setFrame:CGRectMake(163,(self.view.bounds.size.height)-43,loginButton.size.width,loginButton.size.height)];
    }
    
    [_logInButton addTarget:self action:@selector(loginwithFacebookButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logInButton];
    
    
    _forgotPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *forgotPassButton = [UIImage imageNamed:@"Login-ForgotPassButton.png"];

    [_forgotPassButton setBackgroundImage:forgotPassButton forState:UIControlStateNormal];
    
    [_forgotPassButton setTitle:@"I FORGOT MY PASSWORD" forState:UIControlStateNormal];
    [_forgotPassButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _forgotPassButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
    
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_forgotPassButton setFrame:CGRectMake((self.view.bounds.size.width/2)-(forgotPassButton.size.width/2),(self.view.bounds.size.height)-133,forgotPassButton.size.width,forgotPassButton.size.height)];
    }else{
        [_forgotPassButton setFrame:CGRectMake((self.view.bounds.size.width/2)-(forgotPassButton.size.width/2),(self.view.bounds.size.height)-133,forgotPassButton.size.width,forgotPassButton.size.height)];
    }
    
    [_forgotPassButton addTarget:self action:@selector(showEmail:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgotPassButton];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)]];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Login User Screen"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backButtonClicked:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark TextFields

- (void) dismissKeyboard:(id) sender {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_emailField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    if (textField == _usernameField) {
        [_usernameField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    }
    else if (textField == _passwordField) {
        [_passwordField resignFirstResponder];
        [self loginwithFacebookButton:textField];
    }
    else if (textField == _emailField) {
        [_emailField resignFirstResponder];
        [self forgotEmail:textField.text];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _backButton.userInteractionEnabled = NO;
    _logInButton.userInteractionEnabled = NO;
    [self animateTextField:textField up:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _usernameField) {
        _user1.username = textField.text;
    }
    else if (textField == _passwordField){
        _user1.password = textField.text;
    }
    else if (textField == _emailField){
        _user1.email = textField.text;
    }
    [self animateTextField:textField up:NO];
    _backButton.userInteractionEnabled = YES;
    _logInButton.userInteractionEnabled = YES;
    
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    if (textField == _emailField) {
        const int movementDistance = -165; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }else{
        const int movementDistance = -205; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark Main Part

- (void) loginwithFacebookButton:(id) sender {
    
    
    //Locally test username + password valid
    if(!_user1.username || !_user1.password || _user1.username.length == 0 || _user1.password.length == 0){
        NSMutableString *errorAlert = [[NSMutableString alloc] initWithString:@""];

        if(!_user1.username || _user1.username.length == 0){
            [errorAlert appendString:@"- Please enter a username\n"];
        }
        
        if(!_user1.password || _user1.password.length == 0){
            [errorAlert appendString:@"- Please enter a password\n"];
        }
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Error with entered username or password"
             properties:[NSDictionary dictionaryWithObjectsAndKeys:errorAlert, @"Error Alert", nil]];
        
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:errorAlert
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        [alertView show];
    
    
    }
        else{
        [PFUser logInWithUsernameInBackground:_user1.username password:_user1.password block:^(PFUser *user, NSError *error){
            if (user) {
                
                ViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                [self presentViewController:mapView animated:YES completion:nil];
                
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel identify:[user objectId]];
                [mixpanel.people identify:[user objectId]];
                [mixpanel track:@"User Logged in!"];

            }else{
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel track:@"Invalid login credentials"
                     properties:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",error],@"Error Code", nil]];
                
                UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Invalid login credentials"
                                                                   message:nil
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:@"Ok", nil];
                [alertView show];

            }
            
        }];
    
    }
}

- (void) showEmail:(id)sender{

    if(_emailField.hidden == NO){
        _emailField.hidden = YES;
        _emailLabel.hidden = YES;
        
    }else if (_emailField.hidden == YES){
        _emailField.hidden = NO;
        _emailLabel.hidden = NO;
    }
    [self.emailField setNeedsDisplay];
    [self.emailLabel setNeedsDisplay];

}

- (void)forgotEmail:(NSString*)email {
    
    [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Password reset email sent"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Ok", nil];
            [alertView show];
            [self showEmail:nil];
            
        }else{
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Invalid email"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Ok", nil];
            [alertView show];

        }
        
    }];
    
    /*Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NSNumber *currentPageNum = [[NSNumber alloc] initWithInt:_pageControl.currentPage];
    [mixpanel track:@"Clicked Play Now Button"
         properties:[NSDictionary dictionaryWithObjectsAndKeys:currentPageNum, @"Current Page in Tour", nil]];*/
}

@end
