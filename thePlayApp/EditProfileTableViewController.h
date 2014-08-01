//
//  EditProfileTableViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-04-29.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditProfileTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) NSArray *genderArray;
@property (nonatomic, retain) NSArray *ageArray;
@property (nonatomic, retain) NSString *bioString;
@property (nonatomic, assign) NSInteger selectedIndexOfGender;
@property (nonatomic, assign) NSInteger selectedIndexOfAge;
@property (nonatomic, assign) PFUser *currentUser;
@property (nonatomic, assign) UIButton *bioStringCount;

- (void)selectAGender:(UIControl *)sender;
- (void)genderWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)selectAnAge:(UIControl *)sender;
- (void)ageWasSelected:(NSNumber *)selectedIndex element:(id)element;

- (void)actionPickerCancelled:(id)sender;

@end
