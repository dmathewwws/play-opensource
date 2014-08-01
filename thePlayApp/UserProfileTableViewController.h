//
//  UserProfileTableViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-02-08.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "EventFeedHeaderView.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserProfileTableViewController : PFQueryTableViewController <EventFeedHeaderViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

//taken from EventFeedController

- (EventFeedHeaderView *)dequeueReusableSectionHeaderView;

@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, assign) BOOL shouldScrollToTopView;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic) BOOL shouldSegmentChangeScrollToTopView;

- (void)doneButton:(id)sender;
- (void)userDidCheckInOrUncheckIntoEvent:(NSNotification *)note;
- (void)userDidPublishEvent:(NSNotification *)note;
- (void)userDidDeleteEvent:(NSNotification *)note;
- (void)userDidCommentOnEvent:(NSNotification *)note;
- (void) segmentChanged:(id)sender;
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl;

//exculsive to UserProfile

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PlayProfileImageView *profilePictureImageView;
@property (nonatomic, strong) UIButton *followerCountLabel;
@property (nonatomic, strong) UIButton *followingCountLabel;
@property (nonatomic) int userfollowingCount;
@property (nonatomic, strong) UILabel *userDisplayNameLabel;
@property (nonatomic, strong) UIButton *planLabel;
@property (nonatomic, strong) UIButton *planCountLabel;
@property (nonatomic, strong) UIButton *followersLabel;
@property (nonatomic, strong) UIButton *followingLabel;
@property (nonatomic, strong) UIButton *followUserButton;
@property (nonatomic, strong) UIButton *bioTitleButton;
@property (nonatomic, strong) UIButton *genderTitleButton;
@property (nonatomic, strong) UIButton *ageTitleButton;
@property (nonatomic, strong) UIButton *topSport1Button;
@property (nonatomic, strong) UIButton *topSport2Button;
@property (nonatomic, strong) UIButton *topSport3Button;
@property (nonatomic, strong) UIButton *bioBigTitleButton;
@property (nonatomic, strong) UIButton *genderBigTitleButton;
@property (nonatomic, strong) UIButton *ageBigTitleButton;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) PFFile *userMediumAvatar;
@property (strong, nonatomic) PFFile *userSmallAvatar;
@property (strong,nonatomic) NSDateFormatter *dateFormatterForTime;


- (void) configureFollowButton;
- (void) configureUnfollowButton;
- (void) followButtonAction:(id)sender;
- (void) unfollowButtonAction:(id)sender;
- (BOOL) uploadImage:(UIImage *)anImage;
- (void) seeUsersAvatarPic:(id) sender;
- (void) loadAddAvatarPic:(id) sender;
- (void) openEditProfileView:(id) sender;
- (void) updateProfileBio:(NSNotification *)note;
- (void) updateFollowingCount:(NSNotification *)note;
- (void)openProfileSettings:(id)sender;

@end