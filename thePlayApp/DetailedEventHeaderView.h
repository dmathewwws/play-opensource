//
//  DetailedEventHeaderView.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-01.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@protocol DetailedEventHeaderViewDelegate;

@interface DetailedEventHeaderView : UIView <MKMapViewDelegate, UIAlertViewDelegate>

/*! @name Managing View Properties */

/// The photo displayed in the view
@property (nonatomic, strong) PFObject *event;
/// The user that took the photo
@property (nonatomic, strong) PFUser *createdUser;
/// Array of the users that checked-in the photo
@property (nonatomic, strong) NSDictionary *checkedInUsers;
@property (nonatomic, strong) NSArray *sortedCheckedInArray;

/// Play button
@property (nonatomic, strong) UIButton *checkedInButton;

/*! @name Delegate */
@property (nonatomic, strong) id<DetailedEventHeaderViewDelegate> delegate;

// View components
@property (nonatomic, strong) UIView *nameHeaderView;
@property (nonatomic, strong) PFImageView *photoImageView;
@property (nonatomic, strong) UIImageView *sportIconImageView;
@property (nonatomic, strong) UIButton *locationTextView;
@property (nonatomic, strong) UIButton *planTextView;
@property (strong, nonatomic) CLLocation *eventLocation;
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) UIView *checkedInBarView;
@property (nonatomic, strong) NSMutableArray *currentCheckedInAvatars;
@property (strong,nonatomic) NSDateFormatter *dateFormatterForTime;

@property (strong, nonatomic) UIButton *headerButton;
@property (strong, nonatomic) UIButton *footerButton;

+ (CGRect)rectForView;
- (void)createView;

- (id)initWithFrame:(CGRect)frame event:(PFObject*)anEvent;
- (id)initWithFrame:(CGRect)frame event:(PFObject*)anEvent createdUser:(PFUser*)acreatedUser checkedInUsers:(NSDictionary*)checkedInUsers;

- (void)setCheckedInButtonState:(BOOL)selected;
- (void)reloadCheckInBar;
- (void)openMaps:(id)sender;

@end

/*!
 The protocol defines methods a delegate of a PAPPhotoDetailsHeaderView should implement.
 */
@protocol DetailedEventHeaderViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the photgrapher's name/avatar is tapped
 @param button the tapped UIButton
 @param user the PFUser for the photograper
 */
- (void)photoDetailsHeaderView:(DetailedEventHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PFUser *)user;
- (void)photoDetailsHeaderView:(DetailedEventHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PFUser *)user event:(PFObject*)event;

- (void)didTapCheckIntoEventButtonAction:(UIButton *)button;
- (void)didTapUserNameButtonAction:(UIButton *)button;
- (void)didTapSeeMoreUsersButtonAction:(UIButton *)button;



@end
