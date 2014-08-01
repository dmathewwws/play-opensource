//
//  UserSettingsProfileControllerViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-05-01.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface UserSettingsProfileControllerViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, assign) PFUser *currentUser;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic) BOOL switchIsOn;
@property (nonatomic) BOOL push1IsOn;
@property (nonatomic) BOOL push2IsOn;
@property (nonatomic) BOOL push3IsOn;
@property (nonatomic) BOOL push4IsOn;
@property (nonatomic) BOOL push5IsOn;

- (void)logOutAction:(id)sender;
- (void)openEditProfileView:(id) sender;
- (void) switchToggled:(id)sender;
- (void) openWebsite:(NSURL*)URL;
- (void)pressedPostToEmailButton:(id)sender;


@end
