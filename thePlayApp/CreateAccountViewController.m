//
//  ViewController.m
//  Create Account
//
//  Created by Daniel Mathews on 2012-10-07
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "GAI.h"

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

#define firstFollowerStringName @"ZbX006Acm8"

@synthesize username = _username;
@synthesize password = _password;
@synthesize email = _email;
@synthesize createAccountButton = _createAccountButton;
@synthesize user1 = _user1;
@synthesize addAvatarImage = _addAvatarImage;
@synthesize picker =_picker;
@synthesize loginOption = _loginOption;
@synthesize userMediumAvatar = _userMediumAvatar;
@synthesize userSmallAvatar = _userSmallAvatar;
@synthesize backButtonNeeded = _backButtonNeeded;
@synthesize fbButton = _fbButton;
@synthesize deviceType = _deviceType;
@synthesize signupType = _signupType;
@synthesize chooseAPhoto = _chooseAPhoto;

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
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([PFUser currentUser]) {
        _user1 = [PFUser currentUser];
    }else{
        _user1 = [PFUser user];
    }
    
    _deviceType = [PlayUtility setDeviceType];
    
    UIImageView *backgroundImageView = nil;
    
    if (self.view.bounds.size.height == 460) {
        backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountbgi4.png"]];
    }else{
        backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountbgi5.png"]];
    }
    
    [self.view addSubview:backgroundImageView];
    backgroundImageView.clipsToBounds = YES;
    
    
    UIImage *avatarImage = [UIImage imageNamed:@"SignUp-PhotoButton.png"];
    self.addAvatarImage = [[UIImageView alloc] initWithImage:avatarImage];
    
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_addAvatarImage setFrame:CGRectMake(103,73,avatarImage.size.width,avatarImage.size.height)];
    }else{
        [_addAvatarImage setFrame:CGRectMake(103,103,avatarImage.size.width,avatarImage.size.height)];
    }
    _addAvatarImage.userInteractionEnabled = YES;
    [self.view addSubview:_addAvatarImage];
    //[_addAvatarImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadAddAvatarPic:)]];
    
    _chooseAPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chooseAPhoto.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_chooseAPhoto.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_chooseAPhoto setTitle:@"CHOOSE\nA\nPHOTO" forState:UIControlStateNormal];
    [_chooseAPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _chooseAPhoto.titleLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    [_chooseAPhoto setFrame:_addAvatarImage.frame];
    [_chooseAPhoto addTarget:self action:@selector(loadAddAvatarPic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseAPhoto];
    
    _username = [[UITextField alloc] init];
    UIImage *fieldBoxImage = [UIImage imageNamed:@"SignUp-FieldBox.png"];
    [_username setFrame:CGRectMake(32, self.view.bounds.size.height-235, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    
    _password = [[UITextField alloc] init];
    [_password setFrame:CGRectMake(32, self.view.bounds.size.height-179, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    
    _email = [[UITextField alloc] init];
    [_email setFrame:CGRectMake(32, self.view.bounds.size.height-123, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    
    UIView *usernameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _username.frame.size.height)];
    _username.leftView = usernameLeftView;
    _username.leftViewMode = UITextFieldViewModeAlways;
    
    _username.background = fieldBoxImage;
    _username.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    _username.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    _username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _username.returnKeyType = UIReturnKeyNext;

    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_username.frame.origin.x, _username.frame.origin.y - 28, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    usernameLabel.text = @"USERNAME";
    usernameLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    usernameLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:usernameLabel];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(_password.frame.origin.x, _password.frame.origin.y - 28, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    passwordLabel.text = @"PASSWORD";
    passwordLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    passwordLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:passwordLabel];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_email.frame.origin.x, _email.frame.origin.y - 28, fieldBoxImage.size.width, fieldBoxImage.size.height)];
    emailLabel.text = @"EMAIL";
    emailLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    emailLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    emailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:emailLabel];
    
    [self.view addSubview:_username];
    _username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _username.autocorrectionType = UITextAutocorrectionTypeNo;
    _username.delegate = self;
    
    UIView *passwordLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _password.frame.size.height)];
    _password.leftView = passwordLeftView;
    _password.leftViewMode = UITextFieldViewModeAlways;
    
    _password.background = fieldBoxImage;
    _password.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    _password.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _password.returnKeyType = UIReturnKeyNext;
    
    [self.view addSubview:_password];
    _password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _password.autocorrectionType = UITextAutocorrectionTypeNo;
    _password.secureTextEntry = YES;
    _password.delegate = self;
    
    UIView *emailLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _email.frame.size.height)];
    _email.leftView = emailLeftView;
    _email.leftViewMode = UITextFieldViewModeAlways;
    
    _email.background = fieldBoxImage;
    _email.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    _email.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _email.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:_email];
    _email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _email.autocorrectionType = UITextAutocorrectionTypeNo;
    _email.delegate = self;
    
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
    
    //Signup button
    _createAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *loginButton = [UIImage imageNamed:@"SignUp-LoginButton.png"];
    
    [_createAccountButton setBackgroundImage:loginButton forState:UIControlStateNormal];
    
    [_createAccountButton setTitle:@"PLAY" forState:UIControlStateNormal];
    [_createAccountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _createAccountButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_createAccountButton setFrame:CGRectMake(163,(self.view.bounds.size.height)-43,loginButton.size.width,loginButton.size.height)];
    }else{
        [_createAccountButton setFrame:CGRectMake(163,(self.view.bounds.size.height)-43,loginButton.size.width,loginButton.size.height)];
    }
    
    [_createAccountButton addTarget:self action:@selector(createAccountButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createAccountButton];
    
    UIImage *fbImage = nil;
    if ([_signupType isEqualToString:kTwitterViewType]) {
        fbImage = [UIImage imageNamed:@"Twitter-icon.png"];
        NSLog(@"_signupType is %@",_signupType);
    }else if ([_signupType isEqualToString:kFacebookViewType]) {
        fbImage = [UIImage imageNamed:@"Facebook-icon.png"];
        NSLog(@"_signupType is %@",_signupType);
        _email.text = [PFUser currentUser].email;
        _user1.email = [PFUser currentUser].email;
    }else if ([_signupType isEqualToString:kEmailViewType]) {
        fbImage = [UIImage imageNamed:@"SignUp-EmailIcon.png"];
    }
    
    self.fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fbButton setBackgroundImage:fbImage forState:UIControlStateNormal];
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_fbButton setFrame:CGRectMake(24,24,fbImage.size.width,fbImage.size.height)];
    }else{
        [_fbButton setFrame:CGRectMake(24,24,fbImage.size.width,fbImage.size.height)];
    }
    _fbButton.userInteractionEnabled = NO;
    [self.view addSubview:_fbButton];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)]];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Create User Screen"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Touch events - Dismiss Keyboard, Load Login Screen Back Button

- (void) dismissKeyboard:(id) sender {
    [_username resignFirstResponder];
    [_email resignFirstResponder];
    [_password resignFirstResponder];
}

- (void) backButtonClicked:(id) sender {
    
    if ([_signupType isEqualToString:kTwitterViewType]) {
        [PFTwitterUtils unlinkUserInBackground:_user1];
        //[PFUser logOut];
        NSLog(@"in PFTwitterUtils unlink user");
    }else if ([_signupType isEqualToString:kFacebookViewType]) {
        [PFFacebookUtils unlinkUserInBackground:_user1];
        //[PFUser logOut];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) backButton:(id) sender {
    //This is when you exit the image picker
    //[PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark TextFields

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _username) {
        [_username resignFirstResponder];
        [_password becomeFirstResponder];
    }
    else if (textField == _password) {
        [_password resignFirstResponder];
        [_email becomeFirstResponder];
    }
    else if (textField == _email) {
        [_email resignFirstResponder];
    }
    //make sure you can choose image unless you are done typing
    //_addAvatarImage.userInteractionEnabled = YES;
    return YES;

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _addAvatarImage.userInteractionEnabled = NO;
    _backButton.userInteractionEnabled = NO;
    _createAccountButton.userInteractionEnabled = NO;
    [self animateTextField:textField up:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _username) {
        _user1.username = textField.text;
    }
    if (textField == _email) {
        _user1.email = textField.text;
    }
    if (textField == _password) {
        _user1.password = textField.text;
    }
    [self animateTextField:textField up:NO];
    _addAvatarImage.userInteractionEnabled = YES;
    _backButton.userInteractionEnabled = YES;
    _createAccountButton.userInteractionEnabled = YES;
    
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -205; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Touch events - Avatar Picker

- (void) loadAddAvatarPic:(id) sender {
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // If User can use Camera or Choose from Photo Library
        UIActionSheet *avatarAlertSheet = [[UIActionSheet alloc]
                                           initWithTitle:@"Choose an Avatar" delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:@"Take A Photo", @"Choose An Existing Photo", nil];
        avatarAlertSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [avatarAlertSheet showInView:self.view];
        return ;
    }else if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // If User can only Choose from Photo Library
        [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // If User can only use Camera
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        NSArray *cameraTypeArray = [UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceFront];
        
        for (NSNumber *cameraNumber in cameraTypeArray){
            if (cameraNumber == [NSNumber numberWithInt:UIImagePickerControllerCameraDeviceFront]) {
                [_picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            }
        }
    }
    
    [_picker setAllowsEditing:YES];
    [self presentViewController:_picker animated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        //User to Take a Photo
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        NSArray *cameraTypeArray = [UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceFront];
        
        for (NSNumber *cameraNumber in cameraTypeArray){
            if (cameraNumber == [NSNumber numberWithInt:UIImagePickerControllerCameraDeviceFront]) {
                [_picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            }
        }
    }
        
    else if (buttonIndex == 1){
        //User to Choose an Exisiting Photo
        [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else {
        //hit cancel
        return;
    }

    [_picker setAllowsEditing:YES];
    [self presentViewController:_picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    _addAvatarImage.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_chooseAPhoto setTitle:@"" forState:UIControlStateNormal];
    [self uploadImage:_addAvatarImage.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Create Account

- (void) createAccountButton:(id) sender {
    
    PFUser *currentUser = nil;

    if([PFUser currentUser]){
        currentUser = [PFUser currentUser];
    }else{
        currentUser = [PFUser user];
    }
    
    BOOL alphanumBool = NO;
    BOOL passwordBOOL = NO;
    BOOL emailBOOL = NO;
    
    if(_user1.username){
        NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
        alphaSet = [alphaSet invertedSet];
        
        NSRange r = [_user1.username rangeOfCharacterFromSet:alphaSet];
        if (r.location != NSNotFound) {
            alphanumBool = YES;
        }
    }
    if(_user1.password){
        NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
        alphaSet = [alphaSet invertedSet];
        
        NSRange r = [_user1.password rangeOfCharacterFromSet:alphaSet];
        if (r.location != NSNotFound) {
            passwordBOOL = YES;
            NSLog(@"passwordBOOL set to YES");
        }
    }
    if(_user1.email){
        emailBOOL = ![self NSStringIsValidEmail:_user1.email];
    }else{
        emailBOOL = YES;
    }
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Clicked Signup with Facebook"];
    
    //Locally test username + password valid
    if(!_user1.username || _user1.username.length == 0 || _user1.username.length > 15 || !_user1.password || _user1.password.length < 4 || alphanumBool || !_userMediumAvatar || !_userSmallAvatar || emailBOOL || passwordBOOL){
        NSMutableString *errorAlert = [[NSMutableString alloc] initWithString:@""];
        if (!_userMediumAvatar || !_userSmallAvatar) {
            [errorAlert appendString:@"- Please add an avatar photo\n"];
        }
        if(!_user1.username || _user1.username.length == 0){
            [errorAlert appendString:@"- Please enter a username\n"];
        }
        if(!_user1.password || _user1.password.length == 0){
            [errorAlert appendString:@"- Please enter a password\n"];
        }else if (_user1.password.length < 4)
        {
            [errorAlert appendString:@"- Password must be longer than 4 characters\n"];

        }
        if(_user1.username.length > 15){
            [errorAlert appendString:@"- Username is over the 15 character limit\n"];
        }
        if (alphanumBool) {
            [errorAlert appendString:@"- Username can only contains alphabets or numbers\n"];
        }
        if (passwordBOOL) {
            [errorAlert appendString:@"- Password can only contains alphabets or numbers\n"];
        }
        if (emailBOOL) {
            [errorAlert appendString:@"- Please enter valid email address\n"];
        }
        
        [mixpanel track:@"Error with entered username or avatar"
             properties:[NSDictionary dictionaryWithObjectsAndKeys:errorAlert, @"Error Alert", nil]];
        
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:errorAlert
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        [alertView show];
        
    }
    else{
        // [SVProgressHUD show];
        
        BOOL alreadyAUser = NO;
        NSLog(@"currentUser.username is %@", currentUser.username);
        if (currentUser.username) {
            alreadyAUser = YES;
        }
        
        // save local form data
        currentUser.username = _user1.username;
        currentUser.password = _user1.password;
        currentUser.email = _user1.email;
        
        if (_userMediumAvatar && _userSmallAvatar) {
            [currentUser setObject:_userMediumAvatar forKey:kPlayUserProfilePictureMediumKey];
            [currentUser setObject:_userSmallAvatar forKey:kPlayUserProfilePictureSmallKey];
        }
                
        NSLog(@"currentUser is, %@",currentUser);
        
        if ([_signupType isEqualToString:kEmailViewType]) {
            
            [currentUser setObject:[PlayUtility setDeviceType] forKey:@"deviceType"];
            
            NSString *userlocation = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
            NSString *userlanguage = [[NSLocale currentLocale] localeIdentifier];
            
            [currentUser setObject:userlocation forKey:@"country"];
            [currentUser setObject:userlanguage forKey:@"language"];
            
            [currentUser setObject:kEmailViewType forKey:kPlayUserSignupTypeKey];
            
            if(alreadyAUser){
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    [SVProgressHUD dismiss];
                    
                    if (!error) {
                        // Hooray! Let them use the app now.
                        
                        NSLog(@"in currentUser saveinbackgorund - load Mapview");
                        
                        
                        PFUser *firstFollower = [PFUser objectWithoutDataWithObjectId:firstFollowerStringName];
                        
                        [firstFollower fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                            if(!error){
                                [PlayUtility setFirstFollowerEventually:firstFollower block:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Dannylm is followed");
                                    } else {
                                        NSLog(@"ERROR - Dannylm is not followed");
                                    }
                                }];
                            }
                        }];
                        
                        ViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                        [self presentViewController:mapView animated:NO completion:nil];
                        
                        [mixpanel identify:[currentUser objectId]];
                        [mixpanel.people identify:[currentUser objectId]];
                        [mixpanel track:@"Horray! - New Signup!"];
                        
                        //[SVProgressHUD dismiss];
                    }
                    else {
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        NSLog(@"errorString on created account = %@", errorString);
                        
                        NSString *currentUserObjectID = [[PFUser currentUser] objectId];
                        
                        [mixpanel identify:currentUserObjectID];
                        [mixpanel.people identify:currentUserObjectID];
                        [mixpanel track:@"Error! Saving new user to Parse DB!" properties:[NSDictionary dictionaryWithObjectsAndKeys:errorString, @"Error Code", nil]];
                        
                        //  [SVProgressHUD dismiss];
                        
                        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error! %@",errorString]
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"Ok", nil];
                        [alertView show];
                        
                    }
                }];
                
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                
                [NSTimer scheduledTimerWithTimeInterval:5 target:self
                                               selector:@selector(aTimer:) userInfo:nil repeats:NO];
                
            }else{
            
                [currentUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    [SVProgressHUD dismiss];
                    
                    if (!error) {
                        // Hooray! Let them use the app now.
                        
                        NSLog(@"in currentUser saveinbackgorund - load Mapview");
                        
                        PFUser *firstFollower = [PFUser objectWithoutDataWithObjectId:firstFollowerStringName];
                        
                        [firstFollower fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                            if(!error){
                                [PlayUtility setFirstFollowerEventually:firstFollower block:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Dannylm is followed");
                                    } else {
                                        NSLog(@"ERROR - Dannylm is not followed");
                                    }
                                }];
                            }
                        }];

                        ViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                        [self presentViewController:mapView animated:NO completion:nil];
                        
                        [mixpanel identify:[currentUser objectId]];
                        [mixpanel.people identify:[currentUser objectId]];
                        [mixpanel track:@"Horray! - New Signup!"];
                        
                        //[SVProgressHUD dismiss];
                    }else {
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        NSLog(@"errorString on created account = %@", errorString);
                        
                        NSString *currentUserObjectID = [[PFUser currentUser] objectId];
                        
                        [mixpanel identify:currentUserObjectID];
                        [mixpanel.people identify:currentUserObjectID];
                        [mixpanel track:@"Error! Saving new user to Parse DB!" properties:[NSDictionary dictionaryWithObjectsAndKeys:errorString, @"Error Code", nil]];
                        
                        //  [SVProgressHUD dismiss];
                        
                        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error! %@",errorString]
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"Ok", nil];
                        [alertView show];
                        
                    }
                }];
                
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                
                [NSTimer scheduledTimerWithTimeInterval:5 target:self
                                               selector:@selector(aTimer:) userInfo:nil repeats:NO];
                
            }
            
        }else{
        
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               
                [SVProgressHUD dismiss];
                
                if (!error) {
                    // Hooray! Let them use the app now.
                    
                    NSLog(@"in currentUser saveinbackgorund - load Mapview");
                    
                    ViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                    [self presentViewController:mapView animated:NO completion:nil];
                    
                    [mixpanel identify:[currentUser objectId]];
                    [mixpanel.people identify:[currentUser objectId]];
                    [mixpanel track:@"Horray! - New Signup!"];
                    
                    //[SVProgressHUD dismiss];
                }
                else {
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    NSLog(@"errorString on created account = %@", errorString);
                    
                    NSString *currentUserObjectID = [[PFUser currentUser] objectId];
                    
                    [mixpanel identify:currentUserObjectID];
                    [mixpanel.people identify:currentUserObjectID];
                    [mixpanel track:@"Error! Saving new user to Parse DB!" properties:[NSDictionary dictionaryWithObjectsAndKeys:errorString, @"Error Code", nil]];
                    
                    //  [SVProgressHUD dismiss];
                    
                    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error! %@",errorString]
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:@"Ok", nil];
                    [alertView show];
                    
                }
            }];
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            
            [NSTimer scheduledTimerWithTimeInterval:5 target:self
                                           selector:@selector(aTimer:) userInfo:nil repeats:NO];
            
        }
    }
}

- (BOOL) uploadImage:(UIImage *)anImage{
    
    // Resize the image to be square (what is shown in the preview)
    UIImage *resizedImage = [anImage thumbnailImage:kPlayAvatarLargeSize
                                  transparentBorder:0.0f
                                       cornerRadius:0.0f
                               interpolationQuality:kCGInterpolationHigh];
    // Create a thumbnail and add a corner radius for use in table views
    UIImage *thumbnailImage = [anImage thumbnailImage:kPlayAvatarSmallSize
                                    transparentBorder:0.0f
                                         cornerRadius:0.0f
                                 interpolationQuality:kCGInterpolationDefault];
    
    //set display image
    _addAvatarImage.image = resizedImage;
    
    // Get an NSData representation of our images. We use JPEG for the larger image
    // for better compression and PNG for the thumbnail to keep the corner radius transparency
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 1.0f);
    NSData *thumbnailImageData = UIImageJPEGRepresentation(thumbnailImage, 0.8f);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    _userMediumAvatar = [PFFile fileWithData:imageData];
    _userSmallAvatar = [PFFile fileWithData:thumbnailImageData];
    
    // Save the files
    [_userMediumAvatar saveInBackground];
    [_userSmallAvatar saveInBackground];
    
    return YES;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
        
        UINavigationBar *bar = navigationController.navigationBar;
        UINavigationItem *top = bar.topItem;
        
        //[top setHidesBackButton:YES];
        
        UIImage* image = [UIImage imageNamed:@"backarrow.png"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
        [someButton setBackgroundImage:image forState:UIControlStateNormal];
        [someButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        
        [top setTitle:@" "];
        [top setLeftBarButtonItem:leftBarButton];
        [top setRightBarButtonItem:nil];
        
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


-(void)aTimer:(NSTimer *)timer{
    // Dismiss your view
    [SVProgressHUD dismiss];
}

@end
