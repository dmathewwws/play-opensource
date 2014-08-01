//
//  FindUsersViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-05-03.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <Parse/Parse.h>
#import "PlayFindUsersCell.h"
#import "PlayCache.h"
#import "PlayUtility.h"
#import "PlayLoadMoreCell.h"
#import "UserProfileTableViewController.h"

@interface FindUsersViewController : PFQueryTableViewController <PlayFindUsersCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
//@property (nonatomic, strong) UISearchDisplayController *searchDisplayControl;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFObject *event;
@property (nonatomic, strong) NSString *queryType;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableDictionary *outstandingFollowQueries;
@property (nonatomic, strong) NSMutableDictionary *outstandingCountQueries;

- (void) dismissKeyboard:(id) sender;


@end
