//
//  FindUsersViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-05-03.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "FindUsersViewController.h"
#import "GAI.h"

@interface FindUsersViewController ()

@end

@implementation FindUsersViewController

@synthesize searchBar = _searchBar;
@synthesize user = _user;
@synthesize event = _event;
@synthesize headerView = _headerView;
@synthesize outstandingFollowQueries = _outstandingFollowQueries;
@synthesize outstandingCountQueries = _outstandingCountQueries;
@synthesize queryType = _queryType;
//@synthesize searchDisplayControl = _searchDisplayControl;

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
        
        NSLog(@"in initWithStyle for FindUsersController");
        
        self.outstandingFollowQueries = [NSMutableDictionary dictionary];
        self.outstandingCountQueries = [NSMutableDictionary dictionary];
        
        //self.selectedEmailAddress = @"";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 15;
        
        // Used to determine Follow/Unfollow All button status
        // self.followStatus = PAPFindFriendsFollowingSome;
        // [self.tableView setSeparatorColor:[UIColor colorWithRed:210.0f/255.0f green:203.0f/255.0f blue:182.0f/255.0f alpha:1.0]];
        
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 320, 44)];
    /*the search bar widht must be &gt; 1, the height must be at least 44
     (the real size of the search bar)*/
    [_searchBar setTintColor:[UIColor colorWithRed:141.0f/255.0f green:141.0f/255.0f blue:141.0f/255.0f alpha:1.0f]];
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.delegate = self;

    //[self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)]];

    [[self tableView] setTableHeaderView:_searchBar];
    //_searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    /*contents controller is the UITableViewController, this let you to reuse
     the same TableViewController Delegate method used for the main table.*/

}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self setTitle:@"FIND USERS"];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Find Users Screen"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [PlayFindUsersCell heightForCell];
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"in didSelectRowAtIndexPath");
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (indexPath.row == self.objects.count && self.paginationEnabled) {
        // Load More Cell
        NSLog(@"run [self loadNextPage]");
        [self loadNextPage];
    }
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFUser query];
    //[query whereKey:kPlayUserUsernameKey matchesRegex:@"\d{5,10}"];
    [query whereKey:kPlayUserUsernameKey containsString:_queryType];
    [query whereKeyExists:kPlayUserProfilePictureSmallKey];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query orderByDescending:@"createdAt"];
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *FriendCellIdentifier = @"UserCell";
    
    PlayFindUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
    if (cell == nil) {
        cell = [[PlayFindUsersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendCellIdentifier];
        [cell setDelegate:self];
    }
    
    cell.followButton.userInteractionEnabled = YES;
    cell.tag = indexPath.row;
    [cell setUser:(PFUser*)object];
    
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
    
    NSLog(@"indexPath is %@", indexPath);
    
    return cell;
}

#pragma mark - PAPFindFriendsCellDelegate

- (void)cell:(PlayFindUsersCell *)cellView didTapUserButton:(PFUser *)aUser {
    // Push account view controller
    
    [self setTitle:@" "];
    UserProfileTableViewController *accountViewController = [[UserProfileTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [accountViewController setUser:aUser];
    [self.navigationController pushViewController:accountViewController animated:YES];
}

- (void)cell:(PlayFindUsersCell *)cellView didTapFollowButton:(PFUser *)aUser {
    [self shouldToggleFollowFriendForCell:cellView];
}

- (void)shouldToggleFollowFriendForCell:(PlayFindUsersCell*)cell {
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    _queryType = searchBar.text;
    [self loadObjects];
    NSLog(@"_queryType is %@", _queryType);
}

- (void) dismissKeyboard:(id) sender {
    [_searchBar resignFirstResponder];
}

@end