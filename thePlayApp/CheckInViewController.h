//
//  CheckInViewController.h
//  Eventfully
//
//  Created by Daniel Mathews on 2012-11-07.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "SportsCollectionViewController.h"
#import "InstagramCollectionViewController.h"
#import "ActionSheetDatePicker.h"
#import "LocationPickerController.h"
#import "UIImage+ResizeAdditions.h"
#import "PlayConstants.h"
#import "PlayCache.h"
#import "PlayUtility.h"
#import "InviteUsersFollowViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface CheckInViewController : UIViewController <UIScrollViewDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, MKMapViewDelegate, UINavigationControllerDelegate, UITextViewDelegate, LocationPickerControllerDelegate, SportsCollectionViewControllerDelegate, InstagramCollectionViewControllerDelegate, MFMailComposeViewControllerDelegate, InviteUsersFollowViewControllerDelegate>

@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PlayProfileImageView *profilePictureImageView;
@property (strong, nonatomic) UITextView *eventCaption;
@property (strong, nonatomic) UIButton *timeTextView;
@property (strong, nonatomic) UIButton *locationTextView;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) ActionSheetDatePicker *actionSheetDatePicker;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong,nonatomic) CLLocation *currentLocation;
@property (strong,nonatomic) CLLocation *userCurrentLocation;
@property (strong, nonatomic) UIButton *createEventButton;
@property (strong, nonatomic) UIButton *chooseAPhoto;
@property (nonatomic, assign) UIButton *bioStringCount;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSNumber *segmentControlNumber;

@property (strong, nonatomic) UIButton *facebookPost;
@property (nonatomic) BOOL *shouldPostToFacebook;
@property (strong, nonatomic) UIButton *twitterPost;
@property (nonatomic) BOOL *shouldPostTwitter;
@property (strong, nonatomic) UIButton *emailPost;
@property (strong, nonatomic) UIButton *inviteFriends;

@property (strong, nonatomic) NSString *timeTillEvent;
@property (strong, nonatomic) NSMutableArray *locationInfo;
@property (strong, nonatomic) NSNumber *eventIconType;
@property (strong, nonatomic) NSString *eventType;
@property (strong, nonatomic) NSString *searchTerm;
@property (nonatomic, strong) SportsCollectionViewController *sportsCollectionController;
@property (nonatomic, strong) InstagramCollectionViewController *instaCollectionController;
@property (nonatomic, strong) LocationPickerController *locationPickerController;
@property (nonatomic, strong) InviteUsersFollowViewController *inviteUsersController;

@property (strong, nonatomic) UIImageView *addEventImage;
@property (strong, nonatomic) UIImageView *addSportImage;
@property (strong, nonatomic) UIImagePickerController *picker;

@property (strong,nonatomic) NSDateFormatter *dateFormatterForTime;
@property (strong, nonatomic) NSDate *timeofEvent;
@property (strong, nonatomic) NSDate *endtimeofEvent;
@property (nonatomic, assign) int utcOffset;
@property (strong, nonatomic) NSDate *displayStartTimeofEvent;

@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;

@property (nonatomic, strong) NSMutableSet *invitedUsersSet;
@property (nonatomic, strong) NSMutableSet *pushUsersSet;

- (void) loadAddEventPic:(id) sender;
- (BOOL) uploadImage:(UIImage *)anImage;
- (void) createEvent:(id)sender;
- (void) backButton:(id)sender;

- (void)setBackground:(UIImage*)bkgdImage;
- (void) animateTextField:(UITextView*)textField up:(BOOL)up;
- (void) getVenueData4sq:(NSArray *)venueArray index:(NSInteger)index;
- (void) showTime;
- (void) initiateMap:(CLLocation*)location;
- (void) setMap:(CLLocation*)location;
- (void) openLocationPicker:(id)sender;
- (void) launchInstagram;

- (void)pressedPostToFacebookButton:(UIButton*)sender;
- (void)pressedPostToTwitterButton:(UIButton*)sender;
- (void)pressedPostToEmailButton:(UIButton*)sender;

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;
- (void)selectADate:(UIControl *)sender;
- (void)dateButtonTapped:(UIBarButtonItem *)sender;

- (void)pressedInviteFriends:(UIButton*)sender;
- (void) segmentChanged:(id)sender;

@end