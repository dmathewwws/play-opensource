//
//  UserFollowViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-02-08.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "UserFollowViewController.h"
#import "GAI.h"

@interface UserFollowViewController ()

@end

@implementation UserFollowViewController

@synthesize user = _user;
@synthesize event = _event;
@synthesize headerView = _headerView;
@synthesize outstandingFollowQueries = _outstandingFollowQueries;
@synthesize outstandingCountQueries = _outstandingCountQueries;
@synthesize queryType = _queryType;

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
        
//      self.selectedEmailAddress = @"";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 15;
        
        // Used to determine Follow/Unfollow All button status
//      self.followStatus = PAPFindFriendsFollowingSome;
//      [self.tableView setSeparatorColor:[UIColor colorWithRed:210.0f/255.0f green:203.0f/255.0f blue:182.0f/255.0f alpha:1.0]];
        
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self setTitle:@" "];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Follow Users Screen"];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [PlayFindFriendsCell heightForCell];
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == self.objects.count && self.paginationEnabled) {
        // Load More Cell
        [self loadNextPage];
    }
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    if([_queryType isEqual:@"Followers"]){
        
        [query whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
        [query whereKey:kPlayActivityToUserKey equalTo:self.user];
        [query includeKey:kPlayActivityFromUserKey];

    }
    
    if([_queryType isEqual:@"Following"]){
        [query whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
        [query whereKey:kPlayActivityFromUserKey equalTo:self.user];
        [query includeKey:kPlayActivityToUserKey];

    }
    
    if([_queryType isEqual:@"Following"]){
        [query whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
        [query whereKey:kPlayActivityFromUserKey equalTo:self.user];
        [query includeKey:kPlayActivityToUserKey];
        
    }
    
    if([_queryType isEqual:@"CheckIns"]){
        [query whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsCheckIn];
        [query whereKey:kPlayActivityEventKey equalTo:self.event];
        [query includeKey:kPlayActivityToUserKey];
        
    }
    
    [query orderByDescending:@"createdAt"];
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *FriendCellIdentifier = @"FriendCell";
    
    PlayFindFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
    if (cell == nil) {
        cell = [[PlayFindFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendCellIdentifier];
        [cell setDelegate:self];
    }
    
    cell.followButton.selected = NO;
    cell.followButton.userInteractionEnabled = NO;
    cell.tag = indexPath.row;
    
    PFUser* friend = [PFUser user];
    if([_queryType isEqual:@"Following"]){
        friend = [object objectForKey:kPlayActivityToUserKey];
    }else{
        //Followed
        friend = [object objectForKey:kPlayActivityFromUserKey];
    }
    
    [friend fetchIfNeededInBackgroundWithBlock:^(PFObject *theFriend, NSError *error){
        if(!error){
            [cell setUser:(PFUser*)theFriend];
            
            NSDictionary *attributes = [[PlayCache sharedCache] attributesForUser:(PFUser *)theFriend];
                        
            if (attributes) {
                cell.followButton.userInteractionEnabled = YES;
                [cell.followButton setSelected:[[PlayCache sharedCache] followStatusForUser:(PFUser *)theFriend]];
            } else {
                @synchronized(self) {
                    NSNumber *outstandingQuery = [self.outstandingFollowQueries objectForKey:indexPath];
                    if (!outstandingQuery) {
                        [self.outstandingFollowQueries setObject:[NSNumber numberWithBool:YES] forKey:indexPath];
                        PFQuery *isFollowingQuery = [PFQuery queryWithClassName:kPlayActivityClassKey];
                        [isFollowingQuery whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];
                        [isFollowingQuery whereKey:kPlayActivityToUserKey equalTo:(PFUser*)theFriend];
                        [isFollowingQuery whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
                        [isFollowingQuery setCachePolicy:kPFCachePolicyNetworkOnly];
                        
                        [isFollowingQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                            @synchronized(self) {
                                [self.outstandingFollowQueries removeObjectForKey:indexPath];
                                cell.followButton.userInteractionEnabled = YES;
                                [[PlayCache sharedCache] setFollowStatus:(!error && number > 0) user:(PFUser *)theFriend];
                            }
                            if (cell.tag == indexPath.row) {
                                [cell.followButton setSelected:(!error && number > 0)];
                            }
                        }];
                    }
                }
            }
        }
    }];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *NextPageCellIdentifier = @"NextPageCell";
    
    PlayLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NextPageCellIdentifier];
    
    if (cell == nil) {
        cell = [[PlayLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NextPageCellIdentifier];
        //[cell.mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundFindFriendsCell.png"]]];
        //cell.hideSeparatorBottom = YES;
        //cell.hideSeparatorTop = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


#pragma mark - PAPFindFriendsCellDelegate

- (void)cell:(PlayFindFriendsCell *)cellView didTapUserButton:(PFUser *)aUser {
    // Push account view controller
    
    [self setTitle:@" "];
    UserProfileTableViewController *accountViewController = [[UserProfileTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [accountViewController setUser:aUser];
    [self.navigationController pushViewController:accountViewController animated:YES];
}

- (void)cell:(PlayFindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser {
    [self shouldToggleFollowFriendForCell:cellView];
}

- (void)shouldToggleFollowFriendForCell:(PlayFindFriendsCell*)cell {
    PFUser *cellUser = cell.user;
    if ([cell.followButton isSelected]) {
        // Unfollow
        cell.followButton.selected = NO;
        [PlayUtility unfollowUserEventually:cellUser block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //[[NSNotificationCenter defaultCenter] postNotificationName:PlayUtilityFollowingCountChanged object:nil];
            } else {
                cell.followButton.selected = YES;
            }
        }];
    } else {
        // Follow
        cell.followButton.selected = YES;
        [PlayUtility followUserEventually:cellUser block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //[[NSNotificationCenter defaultCenter] postNotificationName:PlayUtilityFollowingCountChanged object:nil];
            } else {
                cell.followButton.selected = NO;
            }
        }];
    }
}

@end