//
//  UserFollowViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-02-08.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <Parse/Parse.h>
#import "PlayFindFriendsCell.h"
#import "PlayCache.h"
#import "PlayUtility.h"
#import "PlayLoadMoreCell.h"
#import "UserProfileTableViewController.h"

@interface UserFollowViewController : PFQueryTableViewController <PlayFindFriendsCellDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFObject *event;
@property (nonatomic, strong) NSString *queryType;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableDictionary *outstandingFollowQueries;
@property (nonatomic, strong) NSMutableDictionary *outstandingCountQueries;

//- (void) dismissKeyboard:(id) sender;

@end
