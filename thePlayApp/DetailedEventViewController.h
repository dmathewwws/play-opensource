//
//  DetailedEventViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-30.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <Parse/Parse.h>
#import "DetailedEventHeaderView.h"
#import "DetailedEventFooterView.h"

@interface DetailedEventViewController : PFQueryTableViewController <DetailedEventHeaderViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) PFObject *event;
@property (strong, nonatomic) UIImageView *eventImageView;
@property (strong, nonatomic) UIImage *eventImage;
@property (weak, nonatomic) UILabel *eventTitle;
@property (weak, nonatomic) UILabel *eventVenue;
@property (weak, nonatomic) UILabel *eventStartTime;

@property (nonatomic, strong) DetailedEventHeaderView *headerView;
@property (nonatomic, strong) DetailedEventFooterView *footerView;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, assign) BOOL checkInQueryInProgress;

- (void) dismissKeyboard:(id) sender;
- (id)initWithObject:(PFObject *)anObject;
- (void)doneButton:(id)sender;
- (void)shouldPresentAccountViewForUser:(PFUser *)user;
- (void)userCheckedInorUncheckedIntoEvent:(NSNotification *)note;
- (void)animateTextField:(UITextField*)textField up:(BOOL)up;
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl;


@end
