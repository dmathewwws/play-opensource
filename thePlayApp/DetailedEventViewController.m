//
//  DetailedEventViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-30.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "DetailedEventViewController.h"
#import "PlayConstants.h"
#import "PlayCache.h"
#import "PlayActivityCell.h"
#import "PlayBaseTextCell.h"
#import "PlayLoadMoreCell.h"
#import "UserProfileTableViewController.h"
#import "PlayUtility.h"
#import "ShareDetailedViewController.h"
#import "GAI.h"

@interface DetailedEventViewController ()

@end

#define kPlayCellInsetWidth 10.0f

@implementation DetailedEventViewController

@synthesize eventImageView = _eventImageView;
@synthesize eventImage = _eventImage;
@synthesize eventTitle = _eventTitle;
@synthesize eventVenue = _eventVenue;
@synthesize eventStartTime = _eventStartTime;
@synthesize commentTextField = _commentTextField;
@synthesize event = _event;
@synthesize headerView = _headerView;
@synthesize footerView = _footerView;
@synthesize checkInQueryInProgress = _checkInQueryInProgress;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (id)initWithObject:(PFObject *)anObject{
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self){
        self.objectsPerPage = 10;
        
         _event= anObject;
        //_eventTitle.text = [anObject objectForKey:kPlayEventTypeKey];
        //NSArray *text = [anObject objectForKey:kPlayEventLocationKey];
        //NSLog(@"NSArray is %@",text);
        //_eventStartTime.text = [anObject objectForKey:kPlayEventTimeKey];
        
        NSLog(@"_event in DetailedViewController is %@",_event);
        
        _checkInQueryInProgress = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    
    //refreshControl.tintColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    // Call refreshControlValueChanged: when the user pulls the table view down.
    [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    PFUser *eventCreator = [_event objectForKey:kPlayEventUserKey];
    
    if ([[PFUser currentUser].objectId isEqualToString:eventCreator.objectId]) {
        UIImage* image = [UIImage imageNamed:@"settingicon.png"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
        [someButton setBackgroundImage:image forState:UIControlStateNormal];
        [someButton addTarget:self action:@selector(openSettingAlertView:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        [self.navigationItem setRightBarButtonItem:settingsBarButton];
    }else{
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"SHARE" style:UIBarButtonSystemItemCancel target:self action:@selector(openShareView)];
        leftBarButton.tintColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
        [self.navigationItem setRightBarButtonItem:leftBarButton];
    }
    

    // Set table header
    self.headerView = [[DetailedEventHeaderView alloc] initWithFrame:[DetailedEventHeaderView rectForView] event:_event];
    [self.headerView setDelegate:self];
    self.tableView.tableHeaderView = self.headerView;
    
    // Set table footer
    _footerView = [[DetailedEventFooterView alloc] initWithFrame:[DetailedEventFooterView rectForView]];
    _commentTextField = _footerView.commentField;
    [_commentTextField setDelegate:self];
    self.tableView.tableFooterView = _footerView;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCheckedInorUncheckedIntoEvent:) name:PlayUtilityUserCheckedInorUncheckedIntoEventNotification object:self.event];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.headerView reloadCheckInBar];
    
    [self setTitle:@"DETAILS"];
    
    // we will only hit the network if we have no cached data for this photo
    BOOL hasCachedCheckins = [[PlayCache sharedCache] getAttributesForEvent:self.event] != nil;
    if (!hasCachedCheckins) {
        [self loadCheckedInUsers];
        NSLog(@"View Did Appear is calling loadCheckedInUsers");
    }
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Detailed Event View Screen"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self setTitle:@" "];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PlayUtilityUserCheckedInorUncheckedIntoEventNotification object:self.event];
}

- (void)doneButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) dismissKeyboard:(id) sender {
    [_commentTextField resignFirstResponder];
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
        
    PFQuery *query = [PFQuery queryWithClassName:kPlayActivityClassKey];
    [query whereKey:kPlayActivityEventKey equalTo:_event];
    [query includeKey:kPlayActivityFromUserKey];
    [query whereKey:kPlayActivityTypeKey equalTo:kPlayActivityTypeIsComment];
    [query orderByAscending:@"createdAt"];

    [query setCachePolicy:kPFCachePolicyNetworkOnly];
        
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    /* If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }*/
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    [self.headerView reloadCheckInBar];
    [self loadCheckedInUsers];
    
    [self.refreshControl endRefreshing];

    NSLog(@"in objectsDIDLoad loadcheckedInUsers and reloadCheckInBar called");
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellID = @"CommentCell";
    
    // Try to dequeue a cell and create one if necessary
    PlayBaseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PlayBaseTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setCellInsetWidth:kPlayCellInsetWidth];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = selectionColor;
        [cell setDelegate:self];
    }
    [cell setUser:[object objectForKey:kPlayActivityFromUserKey]];
    [cell setContentText:[object objectForKey:kPlayActivityContentKey]];
    [cell setDate:[object createdAt]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    
    PlayLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PlayLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.cellInsetWidth = kPlayCellInsetWidth;
        cell.hideSeparatorTop = YES;
    }
    
    return cell;
}

#pragma mark -
#pragma mark TextFields

-(void)textFieldDidBeginEditing:(UITextField *)textField{

    _headerView.userInteractionEnabled = NO;
    //_footerView.
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _headerView.userInteractionEnabled = YES;
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -215; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *trimmedComment = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0 && [self.event objectForKey:kPlayEventUserKey]) {
        PFObject *comment = [PFObject objectWithClassName:kPlayActivityClassKey];
        [comment setValue:trimmedComment forKey:kPlayActivityContentKey]; // Set comment text
        [comment setValue:[self.event objectForKey:kPlayEventUserKey] forKey:kPlayActivityToUserKey]; // Set toUser
        [comment setValue:[PFUser currentUser] forKey:kPlayActivityFromUserKey]; // Set fromUser
        [comment setValue:kPlayActivityTypeIsComment forKey:kPlayActivityTypeKey];
        [comment setValue:self.event forKey:kPlayActivityEventKey];
        
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        [ACL setWriteAccess:YES forUser:[self.event objectForKey:kPlayEventUserKey]];
        comment.ACL = ACL;
        
        [[PlayCache sharedCache] incrementCommentCountForEvent:self.event];
         // Show HUD view
//        [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        
        /* If more than 5 seconds pass since we post a comment, stop waiting for the server to respond
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(handleCommentTimeout:) userInfo:[NSDictionary dictionaryWithObject:comment forKey:@"comment"] repeats:NO];*/
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
           // [timer invalidate];
            
            if (error && [error code] == kPFErrorObjectNotFound) {
                [[PlayCache sharedCache] decrementCommentCountForEvent:self.event];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not post comment" message:@"This event was deleted by its owner" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            } else if (succeeded) {
                
                // refresh cache
                
                //PUSH NOTIFICATION for all commenters
                /*NSMutableSet *channelSet = [NSMutableSet setWithCapacity:self.objects.count];
                
                // set up this push notification to be sent to all commenters, excluding the current  user
                for (PFObject *comment in self.objects) {
                    PFUser *author = [comment objectForKey:kPAPActivityFromUserKey];
                    NSString *privateChannelName = [author objectForKey:kPAPUserPrivateChannelKey];
                    if (privateChannelName && privateChannelName.length != 0 && ![[author objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                        [channelSet addObject:privateChannelName];
                    }
                }
                
                [channelSet addObject:[[self.photo objectForKey:kPAPPhotoUserKey] objectForKey: kPAPUserPrivateChannelKey]];
                
                if (channelSet.count > 0) {
                    NSString *alert = [NSString stringWithFormat:@"%@: %@", [PAPUtility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]], trimmedComment];
                    
                    // make sure to leave enough space for payload overhead
                    if (alert.length > 100) {
                        alert = [alert substringToIndex:99];
                        alert = [alert stringByAppendingString:@"…"];
                    }
                    
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                          alert, kAPNSAlertKey,
                                          kPAPPushPayloadPayloadTypeActivityKey, kPAPPushPayloadPayloadTypeKey,
                                          kPAPPushPayloadActivityCommentKey, kPAPPushPayloadActivityTypeKey,
                                          [[PFUser currentUser] objectId], kPAPPushPayloadFromUserObjectIdKey,
                                          [self.photo objectId], kPAPPushPayloadPhotoObjectIdKey,
                                          @"Increment",kAPNSBadgeKey,
                                          nil];
                    PFPush *push = [[PFPush alloc] init];
                    [push setChannels:[channelSet allObjects]];
                    [push setData:data];
                    [push sendPushInBackground];
                }*/
            }
            
            /*[[NSNotificationCenter defaultCenter] postNotificationName:PAPPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:self.photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.objects.count + 1] forKey:@"comments"]];*/
            
           // [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            [self loadObjects];
        }];
    }
    [textField setText:@""];
    return [textField resignFirstResponder];
}

- (void)userCheckedInorUncheckedIntoEvent:(NSNotification *)note {
    [self.headerView reloadCheckInBar];
}

#pragma mark - 
#pragma mark - PAPBaseTextCellDelegate

- (void)cell:(PlayBaseTextCell *)cellView didTapUserButton:(PFUser *)aUser {
    [self shouldPresentAccountViewForUser:aUser];
}

#pragma mark -
#pragma mark - Misc

- (void)shouldPresentAccountViewForUser:(PFUser *)user {
    
    [self setTitle:@" "];
    [_commentTextField resignFirstResponder];
    UserProfileTableViewController* accountViewController = [[UserProfileTableViewController alloc] initWithStyle:UITableViewStylePlain];
     [accountViewController setUser:user];
     [self.navigationController pushViewController:accountViewController animated:YES];
}

- (void)loadCheckedInUsers {
    if (self.checkInQueryInProgress) {
        return;
    }
    
    self.checkInQueryInProgress = YES;
    PFQuery *query = [PlayUtility queryForActivitiesOnEvent:self.event cachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.checkInQueryInProgress = NO;
        if (error) {
            [self.headerView reloadCheckInBar];
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
        
        [[PlayCache sharedCache] setAttributesForEvent:_event checkedInUsers:checkedInUsersDictionary commenters:commenters currentUserCheckedIn:currentUserCheckedIn locationCheckedIn:currentUserLocationCheckedIn];
        
        [self.headerView reloadCheckInBar];
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) { // A comment row
        
        BOOL hasActivityImage = NO;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        if (object) {
            if ([[object objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsCheckIn] || [[object objectForKey:kPlayActivityTypeKey] isEqualToString:kPlayActivityTypeIsComment]) {
                hasActivityImage = YES;
            }
            
            NSString *commentString = [[self.objects objectAtIndex:indexPath.row] objectForKey:kPlayActivityContentKey];
            
            PFUser *commentAuthor = (PFUser *)[object objectForKey:kPlayActivityFromUserKey];
            
            NSString *nameString = @"";
            if (commentAuthor) {
                nameString = [commentAuthor objectForKey:kPlayUserUsernameKey];
            }
            
            return [PlayBaseTextCell heightForCellWithName:nameString contentString:commentString cellInsetWidth:kPlayCellInsetWidth];
        }
    }
    
    // The pagination row
    return 44.0f;
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    // The user just pulled down the table view. Start loading data.
    [self loadObjects];
}

#pragma mark -
#pragma mark - DetailedEventHeaderViewDelegate

-(void)photoDetailsHeaderView:(DetailedEventHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PFUser *)user{
    [self shouldPresentAccountViewForUser:user];
}

-(void)photoDetailsHeaderView:(DetailedEventHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PFUser *)user event:(PFObject *)event{
    
    [self setTitle:@" "];
    UserFollowViewController *followView = [[UserFollowViewController alloc] initWithStyle:UITableViewStylePlain];
    [followView setEvent:event];
    [followView setUser:user];
    [followView setQueryType:@"CheckIns"];    
    [self.navigationController pushViewController:followView animated:YES];
    
}
//Share
-(void)openShareView{
    
    [self setTitle:@" "];
    ShareDetailedViewController *shareView = [[ShareDetailedViewController alloc] init];
    [shareView setEvent:_event];
    
    NSDateFormatter *dateFormatterForTime = [[NSDateFormatter alloc] init];
    dateFormatterForTime.locale = [NSLocale currentLocale];
    [dateFormatterForTime setTimeStyle: NSDateFormatterShortStyle];
    [dateFormatterForTime setDateStyle: NSDateFormatterMediumStyle];
    
    NSString *displayTime = [dateFormatterForTime stringFromDate:[_event objectForKey:kPlayEventTimeKey]];
    
    [shareView setDateString:displayTime];
    
    NSArray *locationArray = [_event objectForKey:kPlayEventLocationKey];
    NSString *locationTitle = [locationArray objectAtIndex:1];
    
    [shareView setEventCaptionString:[NSString stringWithFormat:@"%@ @ %@ %@",[_event objectForKey:kPlayEventTypeKey],locationTitle,[PlayUtility returnTimeUntilEvent:[_event objectForKey:kPlayEventTimeKey] displayTime:displayTime]]];

    [self.navigationController pushViewController:shareView animated:YES];
    
}

#pragma mark -
#pragma mark ActionSheet

- (void) openSettingAlertView:(id) sender {
    
    UIActionSheet *eventAlertSheet1 = [[UIActionSheet alloc]
                                       initWithTitle:@" " delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       destructiveButtonTitle:@"Delete Event"
                                       otherButtonTitles:@"Share Event", nil];
    eventAlertSheet1.actionSheetStyle = UIActionSheetStyleDefault;
    [eventAlertSheet1 showInView:self.view];
    eventAlertSheet1.tag = 1;
    return;

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            //Delete Event
            NSLog(@"in buttonIndex == 0");
            [PlayUtility queryForActivitiesOnEventForDelete:_event];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if (buttonIndex == 1){
            //Share Event
            NSLog(@"in buttonIndex == 1");
            [self openShareView];
        }
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end