//
//  InviteUsersFollowViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-04-09.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "InviteUsersFollowViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GAI.h"

@interface InviteUsersFollowViewController ()

@end

#define transitionDuration 0.3
#define transitionType kCATransitionFade

@implementation InviteUsersFollowViewController

@synthesize queryType = _queryType;
@synthesize invitedUsersSet = _invitedUsersSet;
@synthesize pushUsersSet = _pushUsersSet;
@synthesize delegate;
@synthesize inviteButton = _inviteButton;
@synthesize oldInvitedUsersSet = _oldInvitedUsersSet;
@synthesize oldPushUsersSet = _oldPushUsersSet;
//@synthesize searchBar = _searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
        self.outstandingFollowQueries = [NSMutableDictionary dictionary];
        self.outstandingCountQueries = [NSMutableDictionary dictionary];
        
        self.user = [PFUser currentUser];
        
        //self.selectedEmailAddress = @"";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 15;
        
        _invitedUsersSet = [NSMutableSet setWithCapacity:self.objects.count];
        _pushUsersSet = [NSMutableSet setWithCapacity:self.objects.count];
        
        // Used to determine Follow/Unfollow All button status
        //      self.followStatus = PAPFindFriendsFollowingSome;
        //      [self.tableView setSeparatorColor:[UIColor colorWithRed:210.0f/255.0f green:203.0f/255.0f blue:182.0f/255.0f alpha:1.0]];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage* image = [UIImage imageNamed:@"backarrow.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = item;
    
  /*  _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 320, 44)];
    //the search bar widht must be &gt; 1, the height must be at least 44
//     (the real size of the search bar)
    [_searchBar setTintColor:[UIColor colorWithRed:141.0f/255.0f green:141.0f/255.0f blue:141.0f/255.0f alpha:1.0f]];
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.delegate = self;
    
    //[self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)]];
    
    [[self tableView] setTableHeaderView:_searchBar];*/
        
    if(_invitedUsersSet.count > 0){
    
        _inviteButton = [[UIBarButtonItem alloc] initWithTitle:@"INVITE" style:UIBarButtonItemStyleBordered target:self action:@selector(inviteButton:)];
        
        _oldInvitedUsersSet = [NSSet setWithSet:_invitedUsersSet];
        _oldPushUsersSet = [NSSet setWithSet:_pushUsersSet];
        
        [self.navigationItem setRightBarButtonItem:_inviteButton];

    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self setTitle:@"INVITE FOLLOWERS"];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Invite Users Screen"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [query whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    if([_queryType isEqual:@"Followers"]){
        
        [query whereKey:kPlayActivityToUserKey equalTo:[PFUser currentUser]];
        [query includeKey:kPlayActivityFromUserKey];
    }
    
    if([_queryType isEqual:@"Following"]){
        
        [query whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];
        [query includeKey:kPlayActivityToUserKey];
    }
    
    [query orderByDescending:@"createdAt"];
    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
        
    static NSString *FriendCellIdentifier = @"FriendCell";
    
    PlayFindFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
    //if (cell == nil) {
        cell = [[PlayFindFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendCellIdentifier];
        [cell setDelegate:self];
    //}
        
    PFUser* friend = [PFUser user];
    if([_queryType isEqual:@"Following"]){
        friend = [object objectForKey:kPlayActivityToUserKey];
    }else{
        //Followed
        friend = [object objectForKey:kPlayActivityFromUserKey];
    }
    
    [friend fetchIfNeededInBackgroundWithBlock:^(PFObject *theFriend, NSError *error){
        if(!error){
            [cell setUserForInvitation:(PFUser*)theFriend];
            
            for(NSString *userID in _invitedUsersSet){
                if([userID isEqualToString:friend.objectId]){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }

        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cellCheck = [tableView
                                  cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == self.objects.count && self.paginationEnabled) {
        // Load More Cell
        NSLog(@"run [self loadNextPage]");
        [self loadNextPage];
        return;
    }
    
    PlayFindFriendsCell *playCell = (PlayFindFriendsCell*)cellCheck;
    
    NSLog(@"playCell is %@", playCell);
    
    NSString *privateChannelKey = [playCell.user objectForKey:kPlayUserPrivateChannelKey];
    
    if(playCell.accessoryType == UITableViewCellAccessoryCheckmark){
        playCell.accessoryType = UITableViewCellAccessoryNone;
        
        //univite
        [_invitedUsersSet removeObject:playCell.user.objectId];
        
        if (_invitedUsersSet.count == 0) {
            [self.navigationItem setRightBarButtonItem:nil];
        }
        
        //only some people pushed to uninvite
        if (privateChannelKey && privateChannelKey.length != 0) {
            [_pushUsersSet removeObject:privateChannelKey];
            
        }
        
    }else{
        playCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        //everyone invited
        [_invitedUsersSet addObject:playCell.user.objectId];
        
        if (_invitedUsersSet.count == 1) {
            
            _inviteButton = [[UIBarButtonItem alloc] initWithTitle:@"INVITE" style:UIBarButtonItemStyleBordered target:self action:@selector(inviteButton:)];
            _inviteButton.tintColor = [UIColor colorWithRed:141.0f/255.0f green:141.0f/255.0f blue:141.0f/255.0f alpha:1.0f];
            
            [self.navigationItem setRightBarButtonItem:_inviteButton];
        }
        
        //only some people invited
        if (privateChannelKey && privateChannelKey.length != 0) {
            [_pushUsersSet addObject:privateChannelKey];
            
        }
    }
    
}

- (void) inviteButton:(id) sender{ 
    
    NSLog(@"self.objects.count is %d, _invitedUserSet is %ld, _pushUserSet is %lu",self.objects.count,(unsigned long)_invitedUsersSet.count,(unsigned long)_pushUsersSet.count);
    
    if(delegate)
    {
        NSLog(@"in inviteButton if delegate");
        
        [delegate inviteFriendsController:self invitedUserSet:_invitedUsersSet pushUserSet:_pushUsersSet];
    }
    
    [self setTitle:@" "];
    CATransition* transition = [CATransition animation];
    transition.duration = transitionDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = transitionType;
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] popViewControllerAnimated:NO];
}


- (void)backButtonPressed:(id)sender {
        
    if(delegate)
    {        
        if (_oldInvitedUsersSet && _invitedUsersSet.count > 0) {
            [delegate inviteFriendsController:self invitedUserSet:_oldInvitedUsersSet pushUserSet:_oldPushUsersSet];
        }else{
            [delegate inviteFriendsController:self invitedUserSet:[NSSet set] pushUserSet:[NSSet set]];
        }
    }

    [self setTitle:@" "];
    CATransition* transition = [CATransition animation];
    transition.duration = transitionDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = transitionType;
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] popViewControllerAnimated:NO];

    
}


@end
