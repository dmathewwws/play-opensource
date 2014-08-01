//
//  EventFeedController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-22.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "EventFeedController.h"
#import "DetailedEventViewController.h"
#import "UserProfileTableViewController.h"
#import "PlayConstants.h"
#import "PlayUtility.h"
#import "PlayCache.h"
#import "EventFeedCell.h"
#import "PlayLoadMoreCell.h"
#import "AppDelegate.h"
#import "TTTTimeIntervalFormatter.h"
#import "ODRefreshControl.h"
#import "OLGhostAlertView.h"
#import "GAI.h"
#import "FindUsersViewController.h"

@interface EventFeedController ()
@property (strong,nonatomic) CLLocation *currentLocation;

@end

#define kSelectedIndexisFollowing 0
#define kSelectedIndexisLocal 1
#define kSelectedIndexisWorldwide 2

@implementation EventFeedController
@synthesize reusableSectionHeaderViews = _reusableSectionHeaderViews;
@synthesize outstandingSectionHeaderQueries = _outstandingSectionHeaderQueries;
@synthesize shouldReloadOnAppear = _shouldReloadOnAppear;
@synthesize currentLocation = _currentLocation;
@synthesize segmentedControl = _segmentedControl;
@synthesize point = _point;
@synthesize shouldScrollToTopView = _shouldScrollToTopView;
@synthesize shouldSegmentChangeScrollToTopView = _shouldSegmentChangeScrollToTopView;
@synthesize dateFormatterForTime = _dateFormatterForTime;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PlayUtilityUserCheckedInorUncheckedIntoEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CheckInControllerDidFinishEditingEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DetailedViewControllerUserDeletedEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DetailedViewControllerUserCheckedInorUncheckedIntoEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DetailedViewControllerUserCommentedOnEventNotification object:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        NSLog(@"inside eventfeedcontroller initWithStyle");
        
        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 15;
                
        self.shouldReloadOnAppear = YES;
        
        self.shouldScrollToTopView = NO;
        
        self.shouldSegmentChangeScrollToTopView = NO;
        
        // Improve scrolling performance by reusing UITableView section headers
        self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
        
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        [appDelegate startLocationManager];
        
        _currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
        
        _point = [PFGeoPoint geoPointWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        
        NSLog(@"in initWithStyle _point.latitude is %f _point.longtitude is %f",_point.latitude,_point.longitude);
        
        //UIsegmentController
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"FOLLOWING", @"LOCAL", nil]];
            
        [_segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        
        [_segmentedControl addTarget:self
                              action:@selector(segmentChanged:)
                    forControlEvents:UIControlEventValueChanged];
        
        NSDictionary *segmentAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:kPlayFontName size:10] forKey:UITextAttributeFont];
        [_segmentedControl setTitleTextAttributes:segmentAttributes forState:UIControlStateNormal];
        [_segmentedControl setTintColor:[UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:1.0f]];
        _segmentedControl.selectedSegmentIndex = kSelectedIndexisLocal;
        self.navigationItem.titleView = _segmentedControl;

    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; // PFQueryTableViewController reads this in viewDidLoad -- would prefer to throw this in init, but didn't work
    
    [super viewDidLoad];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    
    //refreshControl.tintColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    // Call refreshControlValueChanged: when the user pulls the table view down.
    [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _dateFormatterForTime = [[NSDateFormatter alloc] init];
    _dateFormatterForTime.locale = [NSLocale currentLocale];
    [_dateFormatterForTime setTimeStyle: NSDateFormatterShortStyle];
    [_dateFormatterForTime setDateStyle: NSDateFormatterMediumStyle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCheckInOrUncheckIntoEvent:) name:PlayUtilityUserCheckedInorUncheckedIntoEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPublishEvent:) name:CheckInControllerDidFinishEditingEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidDeleteEvent:) name:DetailedViewControllerUserDeletedEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCheckInOrUncheckIntoEvent:) name:DetailedViewControllerUserCheckedInorUncheckedIntoEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCommentOnEvent:) name:DetailedViewControllerUserCommentedOnEventNotification object:nil];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowingChanged:) name:PAPUtilityUserFollowingChangedNotification object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTitle:@" "];
        
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"EventFeed Screen"];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    [self.refreshControl endRefreshing];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
        
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:kPlayEventClassKey];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *photosFromAllUserQuery = [PFQuery queryWithClassName:kPlayEventClassKey];
    PFQuery *invitedUserQuery = [PFQuery queryWithClassName:kPlayEventClassKey];
    PFQuery *followingUsersQuery = [PFQuery queryWithClassName:kPlayActivityClassKey];
    PFQuery *query = [PFQuery queryWithClassName:kPlayEventClassKey];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        photosFromAllUserQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        followingUsersQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        invitedUserQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;

    }
    
    switch (_segmentedControl.selectedSegmentIndex) {
        case kSelectedIndexisFollowing:
            
            [followingUsersQuery whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsFollow];
            [followingUsersQuery whereKey:kPlayActivityFromUserKey equalTo:[PFUser currentUser]];
            followingUsersQuery.cachePolicy = kPFCachePolicyNetworkOnly;

            [photosFromAllUserQuery whereKey:kPlayEventUserKey matchesKey:kPlayActivityToUserKey inQuery:followingUsersQuery];
            [photosFromAllUserQuery whereKeyExists:kPlayEventPictureKey];
            [photosFromAllUserQuery whereKey:kPlayEventTimeKey greaterThanOrEqualTo:[[NSDate date]dateByAddingTimeInterval:(-60*60*3)]];
            [photosFromAllUserQuery whereKey:kPLayEventIsPrivate equalTo:[NSNumber numberWithBool:FALSE]];
            
            // A pull-to-refresh should always trigger a network request.
            [photosFromAllUserQuery setCachePolicy:kPFCachePolicyNetworkOnly];
            [invitedUserQuery setCachePolicy:kPFCachePolicyNetworkOnly];
            [query setCachePolicy:kPFCachePolicyNetworkOnly];

            [invitedUserQuery whereKey:kPlayEventUserKey matchesKey:kPlayActivityToUserKey inQuery:followingUsersQuery];
            [invitedUserQuery whereKeyExists:kPlayEventPictureKey];
            [invitedUserQuery whereKey:kPlayEventTimeKey greaterThan:[[NSDate date]dateByAddingTimeInterval:(-60*60*3)]];
            [invitedUserQuery whereKey:kPLayEventIsPrivate equalTo:[NSNumber numberWithBool:TRUE]];
            [invitedUserQuery whereKey:kPLayEventInvitedUsers equalTo:[PFUser currentUser]];
            
            query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromAllUserQuery,invitedUserQuery,nil]];

            [query orderByAscending:kPlayEventTimeKey];
            [query includeKey:kPlayEventUserKey];
            
            return query;
            
            break;
        case kSelectedIndexisLocal:
            
            NSLog(@"in queryForTable _point.latitude is %f _point.longtitude is %f",_point.latitude,_point.longitude);
            
            [photosFromAllUserQuery whereKey:kPlayEventCoordinatesKey nearGeoPoint:_point withinKilometers:kPlayMaximumSearchDistanceForFeed];
            [photosFromAllUserQuery whereKeyExists:kPlayEventPictureKey];
            [photosFromAllUserQuery whereKey:kPlayEventTimeKey greaterThanOrEqualTo:[[NSDate date]dateByAddingTimeInterval:(-60*60*3)]];
            [photosFromAllUserQuery whereKey:kPLayEventIsPrivate equalTo:[NSNumber numberWithBool:FALSE]];
            
            // A pull-to-refresh should always trigger a network request.
            [photosFromAllUserQuery setCachePolicy:kPFCachePolicyNetworkOnly];
            [invitedUserQuery setCachePolicy:kPFCachePolicyNetworkOnly];
            [query setCachePolicy:kPFCachePolicyNetworkOnly];
            
            [invitedUserQuery whereKey:kPlayEventCoordinatesKey nearGeoPoint:_point withinKilometers:kPlayMaximumSearchDistanceForFeed];
            [invitedUserQuery whereKeyExists:kPlayEventPictureKey];
            [invitedUserQuery whereKey:kPlayEventTimeKey greaterThan:[[NSDate date]dateByAddingTimeInterval:(-60*60*3)]];
            [invitedUserQuery whereKey:kPLayEventIsPrivate equalTo:[NSNumber numberWithBool:TRUE]];
            [invitedUserQuery whereKey:kPLayEventInvitedUsers equalTo:[PFUser currentUser]];
            
            query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromAllUserQuery,invitedUserQuery,nil]];
            
            [query orderByAscending:kPlayEventTimeKey];
            [query includeKey:kPlayEventUserKey];
            
            return query;
            
            break;
/*        case kSelectedIndexisWorldwide:
           
            [photosFromAllUserQuery whereKeyExists:kPlayEventPictureKey];
            [photosFromAllUserQuery includeKey:kPlayEventUserKey];
            [photosFromAllUserQuery whereKey:kPlayEventTimeKey greaterThanOrEqualTo:[[NSDate date]dateByAddingTimeInterval:(-60*60*3)]];
            [photosFromAllUserQuery orderByAscending:kPlayEventTimeKey];
            
            // A pull-to-refresh should always trigger a network request.
            [photosFromAllUserQuery setCachePolicy:kPFCachePolicyNetworkOnly];
            
            return photosFromAllUserQuery;
            break;*/
            
        default:
            [photosFromAllUserQuery whereKey:kPlayEventCoordinatesKey nearGeoPoint:_point withinKilometers:kPlayMaximumSearchDistanceForFeed];
            [photosFromAllUserQuery whereKeyExists:kPlayEventPictureKey];
            [photosFromAllUserQuery whereKey:kPlayEventTimeKey greaterThanOrEqualTo:[[NSDate date]dateByAddingTimeInterval:(-60*60*3)]];
            [photosFromAllUserQuery whereKey:kPLayEventIsPrivate equalTo:[NSNumber numberWithBool:FALSE]];
            
            // A pull-to-refresh should always trigger a network request.
            [photosFromAllUserQuery setCachePolicy:kPFCachePolicyNetworkOnly];
            [invitedUserQuery setCachePolicy:kPFCachePolicyNetworkOnly];
            [query setCachePolicy:kPFCachePolicyNetworkOnly];
            
            [invitedUserQuery whereKey:kPlayEventCoordinatesKey nearGeoPoint:_point withinKilometers:kPlayMaximumSearchDistanceForFeed];
            [invitedUserQuery whereKeyExists:kPlayEventPictureKey];
            [invitedUserQuery whereKey:kPlayEventTimeKey greaterThan:[[NSDate date]dateByAddingTimeInterval:(-60*60*24*3)]];
            [invitedUserQuery whereKey:kPLayEventIsPrivate equalTo:[NSNumber numberWithBool:TRUE]];
            [invitedUserQuery whereKey:kPLayEventInvitedUsers equalTo:[PFUser currentUser]];
            
            query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromAllUserQuery,invitedUserQuery,nil]];
            
            [query orderByAscending:kPlayEventTimeKey];
            [query includeKey:kPlayEventUserKey];
            
            return query;
            break;

    }
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    // overridden, since we want to implement sections
    if (indexPath.section < self.objects.count) {
        return [self.objects objectAtIndex:indexPath.section];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.section == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
    } else {
        
        EventFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[EventFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.photoButton addTarget:self action:@selector(didTapOnEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.photoButton.tag = indexPath.section;
        cell.imageView.image = [UIImage imageNamed:@"infocardeventimage.png"];
        
        if (object) {
            cell.imageView.file = [object objectForKey:kPlayEventPictureKey];
            
            // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
            if ([cell.imageView.file isDataAvailable]) {
                [cell.imageView loadInBackground];
            }
            
            if ([PlayUtility returnShouldImageBeGray:[object objectForKey:kPlayEventTimeKey]]) {
                [cell.iconTypeButton setBackgroundImage:[PlayUtility greyFeedImageForEventType:[object objectForKey:kPlayEventIconTypeKey]] forState:UIControlStateNormal];
            }else{
                [cell.iconTypeButton setBackgroundImage:[PlayUtility imageFeedIconForEventType:[object objectForKey:kPlayEventIconTypeKey]] forState:UIControlStateNormal];
                [cell.iconLocationButton setBackgroundImage:[UIImage imageNamed:@"infocardlocationgreen.png"] forState:UIControlStateNormal];
                [cell.iconTimeButton setBackgroundImage:[UIImage imageNamed:@"infocardtimegreen.png"] forState:UIControlStateNormal];
            }
   
            cell.iconTypeLabel.text = [object objectForKey:kPlayEventTypeKey];
            
            NSString *displayTime = [_dateFormatterForTime stringFromDate:[object objectForKey:kPlayEventTimeKey]];
            NSString *timeTillNow = [PlayUtility returnTimeUntilEvent:[object objectForKey:kPlayEventTimeKey] displayTime:displayTime];
            
            NSString *displayedTimeTillNow = [timeTillNow isEqualToString:@""]?@"In Progress":timeTillNow;
            
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",displayedTimeTillNow];
            cell.locationLabel.text = [[object objectForKey:kPlayEventLocationKey] objectAtIndex:1];
        
        }
        
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    PlayLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[PlayLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    //    cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
    //    cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}



/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.objects.count) {
        return 0.0f;
    }
    return kPlayEventFeedHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 16.0f)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.objects.count) {
        return 0.0f;
    }
    return 16.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.objects.count) {
        // Load More Section
        return kPlayEventFeedHeaderHeight;
    }
    return 122.0f;
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
 
#pragma mark - UIButtons

- (void)doneButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)addUsersButton:(id)sender{
    [self setTitle:@" "];
    
    FindUsersViewController *followView  = [[FindUsersViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:followView animated:YES];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = self.objects.count;
    if (self.paginationEnabled && sections != 0)
        sections++;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == self.objects.count) {
        // Load More section
        return nil;
    }
    
    EventFeedHeaderView *headerView = [self dequeueReusableSectionHeaderView];
    
    if (!headerView) {
        headerView = [[EventFeedHeaderView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:PlayPhotoHeaderButtonsDefault];
        headerView.delegate = self;
        [self.reusableSectionHeaderViews addObject:headerView];
    }
    
    PFObject *event = [self.objects objectAtIndex:section];
    [headerView setEvent:event];
    headerView.tag = section;
    [headerView.checkInButton setTag:section];
    
    NSLog(@"in viewForHeaderInSection _event is %@, section is %ld",event, (long)section);
    
    NSDictionary *attributesForPhoto = [[PlayCache sharedCache] getAttributesForEvent:event];
    
    if (attributesForPhoto) {
        
        NSLog(@"inside attributesForPhoto");
        
        [headerView setCheckInStatus:[[PlayCache sharedCache] isCurrentUserCheckedIntoEvent:event]];
        [headerView.checkInButton setTitle:[[[PlayCache sharedCache] checkInCountForEvent:event] description] forState:UIControlStateNormal];
        [headerView.commentButton setTitle:[[[PlayCache sharedCache] commentCountForEvent:event] description] forState:UIControlStateNormal];
        
        if (headerView.checkInButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
            [UIView animateWithDuration:0.200f animations:^{
                headerView.checkInButton.alpha = 1.0f;
                headerView.commentButton.alpha = 1.0f;
            }];
        }
    } else {
        
        NSLog(@"do not have any saved attributesForPhoto");
        
        headerView.checkInButton.alpha = 0.0f;
        headerView.commentButton.alpha = 0.0f;
        
        @synchronized(self) {
            // check if we can update the cache
            NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:[NSNumber numberWithInt:section]];
            if (!outstandingSectionHeaderQueryStatus) {
                
            PFQuery *query = [PlayUtility queryForActivitiesOnEvent:event cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    @synchronized(self) {
                        [self.outstandingSectionHeaderQueries removeObjectForKey:[NSNumber numberWithInt:section]];
                        
                        if (error) {
                            return;
                        }
                        
                        NSMutableArray *checkedInUsers = [NSMutableArray array];
                        NSMutableArray *locationCheckedInUsers = [NSMutableArray array];
                        NSMutableArray *commenters = [NSMutableArray array];
                        
                        BOOL currentUserCheckedIn = NO;
                        BOOL currentUserLocationCheckedIn = NO;
                        
                        for (PFObject *activity in objects) {
                            if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsCheckIn] && [activity objectForKey:kPlayActivityFromUserKey]) {
                                [checkedInUsers addObject:[activity objectForKey:kPlayActivityFromUserKey]];
                            } else if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsComment] && [activity objectForKey:kPlayActivityFromUserKey]) {
                                [commenters addObject:[activity objectForKey:kPlayActivityFromUserKey]];
                            }else if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsLocationCheckIn] && [activity objectForKey:kPlayActivityFromUserKey]) {
                                [locationCheckedInUsers addObject:[activity objectForKey:kPlayActivityFromUserKey]];
                            }
                            
                            if ([[[activity objectForKey:kPlayActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsCheckIn]) {
                                    currentUserCheckedIn = YES;
                                }
                                if ([[activity objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsLocationCheckIn]) {
                                    currentUserLocationCheckedIn = YES;
                                }
                            }
                        }
                        
                        NSArray *checkedInUsersFinal = [checkedInUsers copy];
                        NSArray *locationCheckedInUsersFinal = [locationCheckedInUsers copy];
                        
                        NSDictionary *checkedInUsersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:checkedInUsersFinal,kPlayEventAttributesCheckedInUsersUserArrayKey,locationCheckedInUsersFinal,kPlayEventAttributesLocationCheckedInUsersArrayKey, nil];
                        
                        [[PlayCache sharedCache] setAttributesForEvent:event checkedInUsers:checkedInUsersDictionary commenters:commenters currentUserCheckedIn:currentUserCheckedIn locationCheckedIn:currentUserLocationCheckedIn];
                        
                        if (headerView.tag != section) {
                            return;
                        }
                        
                        [headerView setCheckInStatus:[[PlayCache sharedCache] isCurrentUserCheckedIntoEvent:event]];
                        [headerView.checkInButton setTitle:[[[PlayCache sharedCache] checkInCountForEvent:event] description] forState:UIControlStateNormal];
                        [headerView.commentButton setTitle:[[[PlayCache sharedCache] commentCountForEvent:event] description] forState:UIControlStateNormal];
                        
                        if (headerView.checkInButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
                            [UIView animateWithDuration:0.200f animations:^{
                                headerView.checkInButton.alpha = 1.0f;
                                headerView.commentButton.alpha = 1.0f;
                            }];
                        }
                    }
                }];
            }
        }
    }
    
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = kPlayEventFeedHeaderHeight;
   // NSLog(@"in scrollViewDidScroll contentOffset.y = %f",scrollView.contentOffset.y);
    if(_shouldScrollToTopView){
        
    }else if (_shouldSegmentChangeScrollToTopView){
        if (scrollView.contentOffset.y == 0) {
            _shouldSegmentChangeScrollToTopView = NO;
        }
    }
    else if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
                
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"in scrollViewShouldScrollToTop");
    _shouldScrollToTopView = YES;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"in scrollViewDidScrollToTop");
    _shouldScrollToTopView = NO;
}

#pragma mark - EventFeedHeaderDelegate

- (EventFeedHeaderView *)dequeueReusableSectionHeaderView {
    for (EventFeedHeaderView *sectionHeaderView in self.reusableSectionHeaderViews) {
        if (!sectionHeaderView.superview) {
            // we found a section header that is no longer visible
            return sectionHeaderView;
        }else{
            NSLog(@"in dequeueReusableSectionHeaderView sectionHeaderView.superview is TRUE");
        }
    }
    return nil;
}

-(void)eventFeedHeaderView:(EventFeedHeaderView *)eventFeedHeaderView didTapUserButton:(UIButton *)button user:(PFUser *)user{
    
    UserProfileTableViewController *accountViewController = [[UserProfileTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
    
}

-(void)eventFeedHeaderView:(EventFeedHeaderView *)eventFeedHeaderView didTapCheckIntoEventButton:(UIButton *)button event:(PFObject *)event{
    
    [eventFeedHeaderView shouldEnableCheckInButton:NO];
    
    // CheckIn Button wasnt selected, therefore you werent checkedIn but want to check in
    BOOL checkedIn = !button.selected;
    [eventFeedHeaderView setCheckInStatus:checkedIn];
    
    NSString *originalButtonTitle = button.titleLabel.text;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSNumber *checkedInCount = [numberFormatter numberFromString:button.titleLabel.text];
    if (checkedIn) {
        checkedInCount = [NSNumber numberWithInt:[checkedInCount intValue] + 1];
        OLGhostAlertView *alert = [[OLGhostAlertView alloc] initWithTitle:@"Joined" message:nil timeout:1 dismissible:NO];
        [alert show];
        
        [[PlayCache sharedCache] incrementCheckinCountForEvent:event];
    } else {
        if ([checkedInCount intValue] > 0) {
            checkedInCount = [NSNumber numberWithInt:[checkedInCount intValue] - 1];
        }
        OLGhostAlertView *alert = [[OLGhostAlertView alloc] initWithTitle:@"Left Event" message:nil timeout:1 dismissible:NO];
        [alert show];
        [[PlayCache sharedCache] decrementCheckinCountForEvent:event];
    }
    
    BOOL locationCheckedIn = NO;
    
    locationCheckedIn = [PlayUtility islocationCheckInTrue:event currentLocation:_currentLocation];
    
    [[PlayCache sharedCache] setCurrentUserIsCheckedIntoEvent:event checkedIn:checkedIn locationCheckedIn:locationCheckedIn];
    
    [button setTitle:[numberFormatter stringFromNumber:checkedInCount] forState:UIControlStateNormal];
    
    if (checkedIn) {
        [PlayUtility checkIntoEventInBackground:event locationCheckIn:locationCheckedIn block:^(BOOL succeeded, NSError *error) {
         
            EventFeedHeaderView *actualHeaderView = (EventFeedHeaderView *)[self tableView:self.tableView viewForHeaderInSection:button.tag];
            [actualHeaderView shouldEnableCheckInButton:YES];
            [actualHeaderView setCheckInStatus:succeeded];
            
            if (!succeeded) {
                [actualHeaderView.checkInButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
        }];
    } else {
        [PlayUtility uncheckIntoEventInBackground:event block:^(BOOL succeeded, NSError *error) {
            EventFeedHeaderView *actualHeaderView = (EventFeedHeaderView *)[self tableView:self.tableView viewForHeaderInSection:button.tag];
            [actualHeaderView shouldEnableCheckInButton:YES];
            [actualHeaderView setCheckInStatus:!succeeded];
            
            if (!succeeded) {
                [actualHeaderView.checkInButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
        }];
    }
}

-(void)eventFeedHeaderView:(EventFeedHeaderView *)eventFeedHeaderView didTapCommentOnEventButton:(UIButton *)button event:(PFObject *)event{
    
    DetailedEventViewController *photoDetailsVC = [[DetailedEventViewController alloc] initWithObject:event];
    [self.navigationController pushViewController:photoDetailsVC animated:YES];
}

#pragma mark - Other

- (NSIndexPath *)indexPathForObject:(PFObject *)targetObject {
    for (int i = 0; i < self.objects.count; i++) {
        PFObject *object = [self.objects objectAtIndex:i];
        if ([[object objectId] isEqualToString:[targetObject objectId]]) {
            return [NSIndexPath indexPathForRow:0 inSection:i];
        }
    }
    return nil;
}

- (void)didTapOnEvent:(UIButton *)sender {
    PFObject *event = [self.objects objectAtIndex:sender.tag];
    if (event) {
        DetailedEventViewController *photoDetailsVC = [[DetailedEventViewController alloc] initWithObject:event];
        [self.navigationController pushViewController:photoDetailsVC animated:YES];
    }
}

- (void)userDidCheckInOrUncheckIntoEvent:(NSNotification *)note {
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidPublishEvent:(NSNotification *)note {
    if (self.objects.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidDeleteEvent:(NSNotification *)note {
    [self performSelector:@selector(loadObjects) withObject:nil afterDelay:1.0f];
}

- (void)userDidCommentOnEvent:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void) segmentChanged:(id)sender{
   
    if (self.objects.count > 0) {
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }
    
    [self performSelectorOnMainThread:@selector(loadObjects) withObject:nil waitUntilDone:YES];
    
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    // The user just pulled down the table view. Start loading data.
    [self loadObjects];
}


@end