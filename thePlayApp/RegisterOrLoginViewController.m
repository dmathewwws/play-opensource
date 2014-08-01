//
//  RegisterOrLoginViewController.m
//  Eventfully
//
//  Created by Daniel Mathews on 2012-11-20.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "RegisterOrLoginViewController.h"
#import "PlayUtility.h"
#import "Mixpanel.h"
#import "LoginViewController.h"
#import "GAI.h"

@interface RegisterOrLoginViewController ()

@end

#define MIXPANEL_TOKEN @"36b6f1dd74fab834f24dcdfac9a21b80"

//
#define numofPagesinTour 3.0f

//startbutton

#define startButtonheightfrombottom 20.0f
#define tourbuttonheightfromTop 98.0f

@implementation RegisterOrLoginViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageControlIsChangingPage;
@synthesize startButton = _startButton;
@synthesize connectwithTwitterButton = _connectwithTwitterButton;
@synthesize signupWithEmailButton = _signupWithEmailButton;
@synthesize loginWithEmailButton = _loginWithEmailButton;
@synthesize deviceType = _deviceType;
@synthesize signUpInfoButton = _signUpInfoButton;

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
	// Do any additional setup after loading the view.
    
    _scrollView.delegate = self;
    
    //[_scrollView setFrame:CGRectMake(0,0,iphonewidth*numofPagesinTour,iphoneheight)];
    //[_backgroundScrollView setFrame:CGRectMake(0,0,iphonewidth,iphoneheight)];
     
    //[self.scrollView setBackgroundColor:[UIColor blackColor]];
	[_scrollView setCanCancelContentTouches:NO];
    
	_scrollView.clipsToBounds = YES;
	_scrollView.scrollEnabled = YES;
	_scrollView.pagingEnabled = YES;
    
    _deviceType = [PlayUtility setDeviceType];

    UIImageView *backgroundImageView = nil;
    
    if (self.view.bounds.size.height == 460) {
       backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignUp-bgi4.png"]];
    }else{
        backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignUp-bgi5.png"]];
    }
    
    CGRect rect = self.view.frame;
    rect.size.height = self.view.bounds.size.height;
    rect.size.width = self.view.bounds.size.width;
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    self.view.frame = rect;
    
   [self.view addSubview:backgroundImageView];
    backgroundImageView.clipsToBounds = YES;
    
    float imagetourheight = 0.0;
    
	NSUInteger nimages = 0;
	for (; ; nimages++) {
		NSString *imageName = [NSString stringWithFormat:@"slide%d.png", (nimages + 1)];
        
		UIImage *image = [UIImage imageNamed:imageName];
        		
        if (image == nil) {
			break;
		}
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                
        if (self.view.bounds.size.height == 460) {
            [imageView setFrame:CGRectMake(self.view.bounds.size.width*nimages+(self.view.bounds.size.width/2)-(image.size.width/2),190.0f,image.size.width,image.size.height)];
        }else{
            [imageView setFrame:CGRectMake(self.view.bounds.size.width*nimages+(self.view.bounds.size.width/2)-(image.size.width/2),140.0f,image.size.width,image.size.height)];
        }
        
        imagetourheight = image.size.height;
        
        [_scrollView addSubview:imageView];
        
	}
        
    //[_scrollView setContentMode:UIViewContentModeBottomLeft];
    [_scrollView setContentSize:CGSizeMake(nimages*self.view.bounds.size.width,10)];
    //[_backgroundScrollView setContentSize:CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height)];
    
	self.pageControl.numberOfPages = nimages;
    
    //Connect with Facebook Button
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *fbImage = [UIImage imageNamed:@"SignUp-FBButton.png"];
    [_startButton setBackgroundImage:fbImage forState:UIControlStateNormal];
//    [_startButton setBackgroundImage:[UIImage imageNamed:@"SignUp-FBButton-Selected.png"] forState:UIControlStateHighlighted];

    
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_startButton setFrame:CGRectMake(84,(self.view.bounds.size.height)-164,fbImage.size.width,fbImage.size.height)];
    }else{
        [_startButton setFrame:CGRectMake(84,(self.view.bounds.size.height)-164,fbImage.size.width,fbImage.size.height)];
    }
    
    NSLog(@"facebook.size.width = %f, facebook.size.height = %f", fbImage.size.width,fbImage.size.height);
    
    [_startButton addTarget:self action:@selector(registerButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
    //Connect with Twitter Button
    _connectwithTwitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *twitterImage = [UIImage imageNamed:@"SignUp-TwitterButton.png"];
    
    [_connectwithTwitterButton setBackgroundImage:twitterImage forState:UIControlStateNormal];
    //[_connectwithTwitterButton setBackgroundImage:[UIImage imageNamed:@"SignUp-TwitterButton-Selected.png"] forState:UIControlStateHighlighted];

    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_connectwithTwitterButton setFrame:CGRectMake(168,(self.view.bounds.size.height)-164,twitterImage.size.width,twitterImage.size.height)];
    }else{
        [_connectwithTwitterButton setFrame:CGRectMake(168,(self.view.bounds.size.height)-164,twitterImage.size.width,twitterImage.size.height)];
    }
    
    [_connectwithTwitterButton addTarget:self action:@selector(registerWithTwitterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectwithTwitterButton];
    
    
    //SignUp Button
    _signUpInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *signupButton = [UIImage imageNamed:@"SignUp-Banner.png"];
    
    [_signUpInfoButton setBackgroundImage:signupButton forState:UIControlStateNormal];
    [_signUpInfoButton setTitle:@"SIGN UP WITH" forState:UIControlStateNormal];
    [_signUpInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signUpInfoButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    [_signUpInfoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 6, 0)];
    
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_signUpInfoButton setFrame:CGRectMake(70,(self.view.bounds.size.height)-216,signupButton.size.width,signupButton.size.height)];
    }else{
        [_signUpInfoButton setFrame:CGRectMake(70,(self.view.bounds.size.height)-216,signupButton.size.width,signupButton.size.height)];
    }
    [self.view addSubview:_signUpInfoButton];
    
    //Signup with Email button
    _signupWithEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *emailButton = [UIImage imageNamed:@"SignUp-EmailButton.png"];
    
    [_signupWithEmailButton setBackgroundImage:emailButton forState:UIControlStateNormal];
    
    [_signupWithEmailButton setTitle:@"SIGN UP WITH EMAIL" forState:UIControlStateNormal];
    [_signupWithEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signupWithEmailButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:12.0f];
    
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_signupWithEmailButton setFrame:CGRectMake(12,(self.view.bounds.size.height)-43,emailButton.size.width,emailButton.size.height)];
    }else{
        [_signupWithEmailButton setFrame:CGRectMake(12,(self.view.bounds.size.height)-43,emailButton.size.width,emailButton.size.height)];
    }

    [_signupWithEmailButton addTarget:self action:@selector(registerWithEmailButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signupWithEmailButton];
    
    //Login with Email button
    _loginWithEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *loginButton = [UIImage imageNamed:@"SignUp-LoginButton.png"];
    
    [_loginWithEmailButton setBackgroundImage:loginButton forState:UIControlStateNormal];
    
    [_loginWithEmailButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [_loginWithEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginWithEmailButton.titleLabel.font = [UIFont fontWithName:kPlayFontName size:15.0f];
    
    if ([_deviceType rangeOfString:@"iPhone 5"].location == NSNotFound) {
        [_loginWithEmailButton setFrame:CGRectMake(163,(self.view.bounds.size.height)-43,loginButton.size.width,loginButton.size.height)];
    }else{
        [_loginWithEmailButton setFrame:CGRectMake(163,(self.view.bounds.size.height)-43,loginButton.size.width,loginButton.size.height)];
    }
    
    [_loginWithEmailButton addTarget:self action:@selector(logInButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginWithEmailButton];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-[_pageControl sizeForNumberOfPages:numofPagesinTour].width,(self.view.bounds.size.height)-236, [_pageControl sizeForNumberOfPages:numofPagesinTour].width , [_pageControl sizeForNumberOfPages:numofPagesinTour].height)];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.0f/255.0f green:178.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    _pageControl.numberOfPages = numofPagesinTour;
    [_pageControl addTarget:self action:@selector(tourPageControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    //[_backgroundScrollView bringSubviewToFront:_startButton];
   // [self.view bringSubviewToFront:_pageControl];
    [self.view bringSubviewToFront:_scrollView];
    _scrollView.bounces = YES;
     
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Register User Screen"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerButton:(id)sender {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Clicked Signup with Facebook"];
    
    // The permissions requested from the user
    NSArray *permissionsArray = @[@"email"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
                
        if (!user) {
            
            [SVProgressHUD dismiss];
            
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                [mixpanel track:@"User cancelled the Facebook login"];
                
            } else {
                if (error.code == 2){
                    NSLog(@"Uh oh. An error occurred: %@ Code:%d", error, error.code);

                    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Please go to your iOS Settings > Facebook > Turn on access to Play through your Facebook account"]
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:@"Ok", nil];
                    [alertView show];
                    
                }else{
                    NSLog(@"Uh oh. An error occurred: %@ Code:%d", error, error.code);
                    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error accessing facebook, please try again or pick a different signup option"]
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:@"Ok", nil];
                    [alertView show];
                }
                
                NSNumber *errorCode = [NSNumber numberWithInt:error.code];
                
                [mixpanel track:@"Error! Accessing Facebook information" properties:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@",error], @"error", errorCode ,@"Error Code" ,nil]];
                
            }
        }
        else if (user.isNew) {
            
            NSLog(@"New User with facebook signed up and logged in!");
            [self facebookInit:@""];
        } else {
            
            [SVProgressHUD dismiss];

            NSLog(@"Facebook User already registered - Will open map - no need to sign up!");

            if(![user objectForKey:kPlayUserProfilePictureSmallKey]){
                CreateAccountViewController *createView = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
                [createView setSignupType:kFacebookViewType];
                [self presentViewController:createView animated:YES completion:nil];
                
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel identify:[[PFUser currentUser] objectId]];
                [mixpanel.people identify:[[PFUser currentUser] objectId]];
                [mixpanel track:@"Success! - User Login, but load username and avatar page!"];
                
            }else{
                ViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                [self presentViewController:mapView animated:NO completion:nil];
                
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel identify:[[PFUser currentUser] objectId]];
                [mixpanel.people identify:[[PFUser currentUser] objectId]];
                [mixpanel track:@"Success! - User Login!"];
            }
        }
    }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self
                                   selector:@selector(aTimer:) userInfo:nil repeats:NO];

}

- (void)registerWithTwitterButton:(id)sender {
            
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
                
        if (!user) {
            
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Twitter login.");
                                
            } else {
                NSLog(@"Uh oh. An error occurred: %@ Code:%d", error, error.code);
                    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error accessing Twitter, please try again or pick a different signup option"]
                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alertView show];
                }
                
                /*NSNumber *errorCode = [NSNumber numberWithInt:error.code];
                
                [mixpanel track:@"Error! Accessing Facebook information" properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                     [NSString stringWithFormat:@"%@",error], @"error", errorCode ,@"Error Code" ,nil]];*/
            
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self twitterInit:@""];
        } else {
            NSLog(@"User logged in with Twitter - Will open map - no need to sign up!");
            
            if(![user objectForKey:kPlayUserProfilePictureSmallKey]){
                CreateAccountViewController *createView = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
                [createView setSignupType:kTwitterViewType];
                [self presentViewController:createView animated:YES completion:nil];
                
                /*Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel identify:[[PFUser currentUser] objectId]];
                [mixpanel.people identify:[[PFUser currentUser] objectId]];
                [mixpanel track:@"Success! - User Login, but load username and avatar page!"];*/
                
            }else{
            
                ViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                [self presentViewController:mapView animated:NO completion:nil];
                
                /*Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel identify:[[PFUser currentUser] objectId]];
                [mixpanel.people identify:[[PFUser currentUser] objectId]];
                [mixpanel track:@"Success! - User Login!"];*/
            }
        }     
    }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                   selector:@selector(aTimer:) userInfo:nil repeats:NO];


}

-(void)aTimer:(NSTimer *)timer{
    // Dismiss your view
    [SVProgressHUD dismiss];
}

- (void)logInButton:(id)sender {
    
    LoginViewController *createView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:createView animated:YES completion:nil];

}

- (void) facebookInit:(NSString*) permissions{
    
    // Create request for user's Facebook data
    NSString *requestPath = @"me/?fields=email,name,gender";
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForGraphPath:requestPath];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            PFUser *currentUser = [PFUser currentUser];
            
            NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary

            NSLog(@"userData in facebookInit is %@", userData);
            
            NSString *fBid = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *email = userData[@"email"];
            NSString *gender = userData[@"gender"];
            
            // add FB data to Parse db
            [currentUser setObject:name forKey:@"name"];
            [currentUser setObject:email forKey:@"email"];
            [currentUser setObject:gender forKey:@"fBgender"];
            [currentUser setObject:fBid forKey:@"fBId"];
            
            [currentUser setObject:[PlayUtility setDeviceType] forKey:@"deviceType"];
            
            NSString *userlocation = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
            NSString *userlanguage = [[NSLocale currentLocale] localeIdentifier];
            
            [currentUser setObject:userlocation forKey:@"country"];
            [currentUser setObject:userlanguage forKey:@"language"];
            
            NSString *createAccountType = [[NSString alloc] initWithFormat:@"facebook"];
            
            [currentUser setObject:createAccountType forKey:kPlayUserSignupTypeKey];
            
            // save local data to Parse DB
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [SVProgressHUD dismiss];
                
                if (!error) {
                    // Hooray! Let them use the app now.
                    
                    CreateAccountViewController *createView = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
                    [createView setSignupType:kFacebookViewType];
                    [self presentViewController:createView animated:YES completion:nil];
                    
                    [mixpanel identify:[currentUser objectId]];
                    [mixpanel.people identify:[currentUser objectId]];
                    [mixpanel track:@"Horray! - New Signup!"
                         properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                     gender, @"gender",
                                     userlocation, @"country",
                                     userlanguage, @"language", nil]];
                    [mixpanel.people set:[NSDictionary dictionaryWithObjectsAndKeys:
                                          currentUser.username, @"$username",
                                          name, @"$name",
                                          gender, @"gender",
                                          userlocation, @"country",
                                          userlanguage, @"language", nil]];
                    
 
                }
                else {
                    
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    NSLog(@"errorString on created account = %@", errorString);
                    
                    NSString *currentUserObjectID = [[PFUser currentUser] objectId];
                    [PFUser logOut];
                    
                    [mixpanel identify:currentUserObjectID];
                    [mixpanel.people identify:currentUserObjectID];
                    [mixpanel track:@"Error! Saving new user to Parse DB!" properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                       errorString, @"Error Code", nil]];
                    
                 //   [SVProgressHUD dismiss];
                    
                    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error! %@",errorString]
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:@"Ok", nil];
                    [alertView show];
                }
            }];
            
        }else{
            
            [SVProgressHUD dismiss];

            
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"errorString on created account = %@", errorString);
            
            NSString *currentUserObjectID = [[PFUser currentUser] objectId];
            [PFUser logOut];
            
            [mixpanel identify:currentUserObjectID];
            [mixpanel.people identify:currentUserObjectID];
            [mixpanel track:@"Error! Getting your information from Facebook!" properties:[NSDictionary dictionaryWithObjectsAndKeys:errorString, @"Error Code", nil]];
          
          //  [SVProgressHUD dismiss];
            
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error! %@",errorString]
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Ok", nil];
            [alertView show];
            
            
        }
    }];
        
    [NSTimer scheduledTimerWithTimeInterval:6 target:self
                                   selector:@selector(aTimer:) userInfo:nil repeats:NO];
}


- (void)twitterInit:(NSString *)permissions {
    // Construct the parameters string. The value of "status" is percent-escaped.
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
    NSMutableURLRequest *tweetRequest = [NSMutableURLRequest requestWithURL:url];
    
    [[PFTwitterUtils twitter] signRequest:tweetRequest];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    // Post status synchronously.
    NSData *data = [NSURLConnection sendSynchronousRequest:tweetRequest
                                         returningResponse:&response
                                                     error:&error];
    
    NSError* error2;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error2];
    
    // Handle response.
    if (!error && !error2) {
        PFUser *currentUser = [PFUser currentUser];

        NSString *twitterId = [json objectForKey:@"id"];
        NSString *name = [json objectForKey:@"name"];
        
        // add FB data to Parse db
        [currentUser setObject:name forKey:@"name"];
        [currentUser setObject:twitterId forKey:@"twitterId"];
        
        [currentUser setObject:[PlayUtility setDeviceType] forKey:@"deviceType"];
        
        NSString *userlocation = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
        NSString *userlanguage = [[NSLocale currentLocale] localeIdentifier];
        
        [currentUser setObject:userlocation forKey:@"country"];
        [currentUser setObject:userlanguage forKey:@"language"];
        
        NSString *createAccountType = [[NSString alloc] initWithFormat:@"twitter"];
        [currentUser setObject:createAccountType forKey:kPlayUserSignupTypeKey];
        
        // save local data to Parse DB
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (!error) {
                // Hooray! Let them use the app now.
                
                CreateAccountViewController *createView = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
                [createView setSignupType:kTwitterViewType];
                [self presentViewController:createView animated:YES completion:nil];
                
                /*[mixpanel identify:[currentUser objectId]];
                [mixpanel.people identify:[currentUser objectId]];
                [mixpanel track:@"Horray! - New Signup!"
                     properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                 gender, @"gender",
                                 userlocation, @"country",
                                 userlanguage, @"language", nil]];
                [mixpanel.people set:[NSDictionary dictionaryWithObjectsAndKeys:
                                      currentUser.username, @"$username",
                                      name, @"$name",
                                      gender, @"gender",
                                      userlocation, @"country",
                                      userlanguage, @"language", nil]];*/
                
                //  [SVProgressHUD dismiss];
            }else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                NSLog(@"errorString on created account = %@", errorString);
                
                //NSString *currentUserObjectID = [[PFUser currentUser] objectId];
                [PFUser logOut];
                
               /* [mixpanel identify:currentUserObjectID];
                [mixpanel.people identify:currentUserObjectID];
                [mixpanel track:@"Error! Saving new user to Parse DB!" properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                   errorString, @"Error Code", nil]];*/
                
                //   [SVProgressHUD dismiss];
                
                UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error! %@",errorString]
                                                                   message:nil
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:@"Ok", nil];
                [alertView show];
                
            }
        }];
    }else {
        
        NSLog(@"Error: %@ or Error2: %@", error, error2);
    }
    
}

- (void)registerWithEmailButton:(id)sender {
    
    CreateAccountViewController *createView = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
    [createView setSignupType:kEmailViewType];
    [self presentViewController:createView animated:YES completion:nil];
    
    }

#pragma mark -
#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (pageControlIsChangingPage) {
        return;
    }
    
	/*
	 *	We switch page at 50% across
	 */

    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark UIPageControl

- (void)tourPageControl:(id)sender{
    
    /*
	 *	Change the scroll view
	 */
    CGRect frame = _scrollView.frame;
    
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
	
    [_scrollView scrollRectToVisible:frame animated:YES];
    
	/*
	 *	When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 */
    pageControlIsChangingPage = YES;
}

@end
