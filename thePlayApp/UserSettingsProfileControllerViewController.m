//
//  UserSettingsProfileControllerViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-05-01.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "UserSettingsProfileControllerViewController.h"
#import "PlayConstants.h"
#import "SettingsCellTextField.h"
#import "EditProfileTableViewController.h"
#import "GAI.h"
#import "WebViewController.h"

@interface UserSettingsProfileControllerViewController ()

@end

@implementation UserSettingsProfileControllerViewController

@synthesize saveButton = _saveButton;
@synthesize currentUser = _currentUser;
@synthesize headerView = _headerView;
@synthesize footerView = _footerView;
@synthesize switchIsOn = _switchIsOn;
@synthesize push1IsOn = _push1IsOn;
@synthesize push2IsOn = _push2IsOn;
@synthesize push3IsOn = _push3IsOn;
@synthesize push4IsOn = _push4IsOn;
@synthesize push5IsOn = _push5IsOn;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        NSLog(@"in initWithStyle for EditUserSettings");
        
        _switchIsOn = [[[PFUser currentUser] objectForKey:kPlayUserLocationCheckInKey] boolValue];
        
        NSArray *pushSettingsArray = [[PFUser currentUser] objectForKey:kPlayUserPushArrayKey];
        
        if (!pushSettingsArray) {
            NSLog(@"in setUser - !pushSettingsArray");
            _push1IsOn = YES;
            _push2IsOn = YES;
            _push3IsOn = YES;
            _push4IsOn = YES;
            _push5IsOn = YES;
            
        }else{
            
            NSLog(@"in setUser - pushSettingsArray is not empty");
            
            _push1IsOn = [[pushSettingsArray objectAtIndex:(NSUInteger)kPlayPushSettingsWhenFollowKey] boolValue];
            _push2IsOn = [[pushSettingsArray objectAtIndex:(NSUInteger)kPlayPushSettingsWhenJoinsEventKey] boolValue];
            _push3IsOn = [[pushSettingsArray objectAtIndex:(NSUInteger)kPlayPushSettingsWhenInvitesToEventKey] boolValue];
            _push4IsOn = [[pushSettingsArray objectAtIndex:(NSUInteger)kPlayPushSettingsWhenEventEditedOrDeletedKey] boolValue];
            _push5IsOn = [[pushSettingsArray objectAtIndex:(NSUInteger)kPlayPushSettingsWhenSomeoneCommentsOnEventKey] boolValue];
        }
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*_saveButton = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonPressed:)];
    _saveButton.tintColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    
    [self.navigationItem setRightBarButtonItem:_saveButton];*/


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self setTitle:@"SETTINGS"];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"User Settings Screen"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    switch (section) {
        case 0: { //Account
            return 2;
        }
        case 1: { //Location
            return 1;
        }
        case 2: { //Help
            return 2;
        }
        case 3: { //Push Notifications
            return 5;
        }
        case 4: { //Privacy
            return 3;
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LogOutIdentifier = @"LogOutIdentifier";
    static NSString *EditProfileIdentifier = @"EditProfileIdentifier";
    static NSString *LocationCheckInIdentifier = @"LocationCheckInIdentifier";
    static NSString *TermsOfServiceIdentifier = @"TermsOfServiceIdentifier";
    static NSString *PrivacyPolicyIdentifier = @"PrivacyPolicyIdentifier";
    static NSString *CommunityGuidelinesIdentifier = @"CommunityGuidelinesIdentifier";
    static NSString *SupportLinkIdentifier = @"SupportLinkIdentifier";
    static NSString *EmailCEOIdentifier = @"EmailCEOIdentifier";
    static NSString *Push1Identifier = @"Push1Identifier";
    static NSString *Push2Identifier = @"Push2Identifier";
    static NSString *Push3Identifier = @"Push3Identifier";
    static NSString *Push4Identifier = @"Push4Identifier";
    static NSString *Push5Identifier = @"Push5Identifier";
    
    NSString *identityString = @"";
    switch ([indexPath section]) {
        case 0: {
            switch ([indexPath row]) {
                case 0: {
                    identityString = EditProfileIdentifier;
                    break;

                }
                case 1: {
                    identityString = LogOutIdentifier;
                    break;
                    
                }
                default:
                    break;
            }
            break;
        }
        case 1: {
            switch ([indexPath row]) {
                case 0: {
                    identityString = LocationCheckInIdentifier;
                    break;
                    
                }
                default:
                    break;
            }
            break;
        }case 2: {
            switch ([indexPath row]) {
                case 0: {
                    identityString = SupportLinkIdentifier;
                    break;
                    
                }
                case 1: {
                    identityString = EmailCEOIdentifier;
                    break;
                    
                }
                default:
                    break;
            }
            break;
        }case 3: {
            switch ([indexPath row]) {
                case 0: {
                    identityString = Push1Identifier;
                    break;
                    
                }
                case 1: {
                    identityString = Push2Identifier;
                    break;
                    
                }
                case 2: {
                    identityString = Push3Identifier;
                    break;
                    
                }
                case 3: {
                    identityString = Push4Identifier;
                    break;
                    
                }
                case 4: {
                    identityString = Push5Identifier;
                    break;
                    
                }
                default:
                    break;
            }
            break;
        }case 4: {
            switch ([indexPath row]) {
                case 0: {
                    identityString = TermsOfServiceIdentifier;
                    break;
                    
                }
                case 1: {
                    identityString = CommunityGuidelinesIdentifier;
                    break;
                    
                }
                case 2: {
                    identityString = PrivacyPolicyIdentifier;
                    break;
                    
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    NSLog(@"identityString is %@ in indexPath %@",identityString, indexPath);
    
    SettingsCellTextField *cell = [tableView dequeueReusableCellWithIdentifier:identityString];
    
    
    switch ([indexPath section]) {
        case 0: {
            switch ([indexPath row]) {
                case 0: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    
                    [cell.titleButton setTitle:@"Edit Profile" forState:UIControlStateNormal];                    break;
                }
                case 1: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    
                    [cell.titleButton setTitle:@"Log Out" forState:UIControlStateNormal];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }case 1: {
            switch ([indexPath row]) {
                case 0: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        [cell.switchButton setOn:_switchIsOn];
                        
                        NSNumber *switchBool = [NSNumber numberWithBool:_switchIsOn];
                        NSLog(@"_switchIsOn on load is here - %@",switchBool);
                        cell.switchButton.tag = 0;
                        [cell.switchButton addTarget:self action:@selector(switchToggled:) forControlEvents: UIControlEventValueChanged];

                    }
                    
                    [cell.titleButton setTitle:@"CheckIn" forState:UIControlStateNormal];
                    [cell.subTitleButton setTitle:@"Uses geofencing to locate when you get to an event you joined" forState:UIControlStateNormal];

                    break;
                }
                default:
                    break;
            }
            break;
        }case 2: {
            switch ([indexPath row]) {
                case 0: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    
                    [cell.titleButton setTitle:@"Support & Feedback" forState:UIControlStateNormal];                    break;
                }
                case 1: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    
                    [cell.titleButton setTitle:@"Email the CEO" forState:UIControlStateNormal];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }case 3: {
            switch ([indexPath row]) {
                case 0: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        [cell.switchButton setOn:_push1IsOn];
                        
                        NSNumber *switchBool5 = [NSNumber numberWithBool:_push1IsOn];
                        NSLog(@"_switchIsOn1 on load is here - %@",switchBool5);
                        cell.switchButton.tag = 1;
                        [cell.switchButton addTarget:self action:@selector(switchToggled:) forControlEvents: UIControlEventValueChanged];
                    }
                    
                    //[cell.titleButton setTitle:@"CheckIn" forState:UIControlStateNormal];
                    [cell.subTitleButton setTitle:@"Someone follows me" forState:UIControlStateNormal];
                    
                    break;
                }
                case 1: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        [cell.switchButton setOn:_push2IsOn];
                        
                        NSNumber *switchBool5 = [NSNumber numberWithBool:_push2IsOn];
                        NSLog(@"_switchIsOn2 on load is here - %@",switchBool5);
                        cell.switchButton.tag = 2;
                        [cell.switchButton addTarget:self action:@selector(switchToggled:) forControlEvents: UIControlEventValueChanged];
                    }
                    
                    //[cell.titleButton setTitle:@"CheckIn" forState:UIControlStateNormal];
                    [cell.subTitleButton setTitle:@"Someone joins my event" forState:UIControlStateNormal];
                    
                    break;
                }
                case 2: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        [cell.switchButton setOn:_push3IsOn];
                        
                        NSNumber *switchBool5 = [NSNumber numberWithBool:_push3IsOn];
                        NSLog(@"_switchIsOn3 on load is here - %@",switchBool5);
                        cell.switchButton.tag = 3;
                        [cell.switchButton addTarget:self action:@selector(switchToggled:) forControlEvents: UIControlEventValueChanged];
                    }
                    
                    //[cell.titleButton setTitle:@"CheckIn" forState:UIControlStateNormal];
                    [cell.subTitleButton setTitle:@"Someone invites me to an event" forState:UIControlStateNormal];
                    
                    break;
                }
                case 3: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        [cell.switchButton setOn:_push4IsOn];
                        
                        NSNumber *switchBool5 = [NSNumber numberWithBool:_push4IsOn];
                        NSLog(@"_switchIsOn4 on load is here - %@",switchBool5);
                        cell.switchButton.tag = 4;
                        [cell.switchButton addTarget:self action:@selector(switchToggled:) forControlEvents: UIControlEventValueChanged];
                    }
                    
                    //[cell.titleButton setTitle:@"CheckIn" forState:UIControlStateNormal];
                    [cell.subTitleButton setTitle:@"An event I'm attending gets editied/deleted" forState:UIControlStateNormal];
                    
                    break;
                }
                case 4: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        [cell.switchButton setOn:_push5IsOn];
                        
                        NSNumber *switchBool5 = [NSNumber numberWithBool:_push5IsOn];
                        NSLog(@"_switchIsOn5 on load is here - %@",switchBool5);
                        cell.switchButton.tag = 5;
                        [cell.switchButton addTarget:self action:@selector(switchToggled:) forControlEvents: UIControlEventValueChanged];
                        
                    }
                    
                    //[cell.titleButton setTitle:@"CheckIn" forState:UIControlStateNormal];
                    [cell.subTitleButton setTitle:@"Someone comments on an event I'm attending" forState:UIControlStateNormal];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }case 4: {
            switch ([indexPath row]) {
                case 0: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    
                    [cell.titleButton setTitle:@"Terms of Service" forState:UIControlStateNormal];                    break;
                }
                case 1: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    
                    [cell.titleButton setTitle:@"Community Guidelines" forState:UIControlStateNormal];
                    
                    break;
                }
                case 2: {
                    if (cell == nil) {
                        cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    
                    [cell.titleButton setTitle:@"Privacy Policy" forState:UIControlStateNormal];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(14.0f, 5.0f, self.tableView.bounds.size.width, 30.0f)];
    
    UIButton *headerLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerLabel setFrame:_headerView.frame];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [headerLabel setUserInteractionEnabled:NO];
    [headerLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [[headerLabel titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:13.0f]];
    [self.headerView addSubview:headerLabel];
    
    
    switch (section) {
        case 0: {
            [headerLabel setTitle:@"ACCOUNT" forState:UIControlStateNormal];
            break;
        }
        case 1: {
            [headerLabel setTitle:@"LOCATION" forState:UIControlStateNormal];
            break;
        }
        case 2: {
            [headerLabel setTitle:@"HELP" forState:UIControlStateNormal];
            break;
        }
        case 3: {
            [headerLabel setTitle:@"GET PUSH NOTIFICATIONS WHEN:" forState:UIControlStateNormal];
            break;
        }
        case 4: {
            [headerLabel setTitle:@"PRIVACY" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
    return _headerView;
}

/*-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 3) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(14.0f, 5.0f, self.tableView.bounds.size.width, 30.0f)];
        
        UIButton *headerLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerLabel setFrame:_headerView.frame];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [headerLabel setUserInteractionEnabled:NO];
        [headerLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [[headerLabel titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:11.0f]];
        [headerLabel setTitle:@"Lovingly made in Vancouver, Canada c ToyBox Media Inc" forState:UIControlStateNormal];
        [self.footerView addSubview:headerLabel];
    
        return _footerView;
    }else{
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
        return _footerView;
    }
}*/

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 3){
        return 10.0f;
    }else{
        return 0.0f;
    }
}

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
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"in heightForRowAtIndexPath");
    
    if ([indexPath section] == 1 && [indexPath row] == 0) {
        NSLog(@"in heightForRowAtIndexPath IF");

        return 65.0f;
    } else{
        NSLog(@"in heightForRowAtIndexPath ELSE");

        return 44.0f;

        
    }

    
}

-(void)setCurrentUser:(PFUser *)currentUser{
    
    [currentUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            
            NSLog(@"in setUser - currentUser is %@",currentUser);
            
            //[self.tableView reloadData];
            
            //NSLog(@"current user is %@,current user location setting is %@,current user BOOL is %@, _switchIsOn is %d",currentUser,[currentUser objectForKey:kPlayUserLocationCheckInKey], [NSNumber numberWithBool:[currentUser objectForKey:kPlayUserLocationCheckInKey]],_switchIsOn);
            
            
        }
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //SettingsCellTextField *cell = (SettingsCellTextField*)[tableView cellForRowAtIndexPath:indexPath];
    
    switch ([indexPath section]) {
        case 0: {
            switch ([indexPath row]) {
                case 0: {
                    [self openEditProfileView:tableView];
                    NSLog(@"in indexPath section 0 row 0");

                    break;
                    
                }
                case 1: {
                    [self logOutAction:tableView];
                    NSLog(@"in indexPath section 0 row 1");

                    break;
                    
                }
                default:
                    break;
            }
            break;
        }
        case 1: {
            switch ([indexPath row]) {
                case 0: {
                    //[cell.switchButton isOn];
                    break;
                    
                }
                default:
                    break;
            }
            break;
        }case 2: {
            switch ([indexPath row]) {
                case 0: {
                    [self openWebsite:[NSURL URLWithString:[NSString stringWithFormat:@"http://theplayapp.freshdesk.com/"]]];
                    break;
                    
                }
                case 1: {
                    [self pressedPostToEmailButton:tableView];
                    break;
                    
                }
                default:
                    break;
            }
            break;
        }case 3: {
            switch ([indexPath row]) {
                case 0: {
                    
                    break;
                    
                }
                case 1: {
                    
                    break;
                    
                }
                case 2: {
                    
                    break;
                    
                }
                case 3: {
                    
                    break;
                    
                }
                case 4: {
                    
                    break;
                    
                }
                default:
                    break;
            }
            break;
        }case 4: {
            switch ([indexPath row]) {
                case 0: {
                    [self openWebsite:[NSURL URLWithString:[NSString stringWithFormat:@"http://theplayapp.com/terms-of-service/"]]];
                    
                    break;
                    
                }
                case 1: {
                    [self openWebsite:[NSURL URLWithString:[NSString stringWithFormat:@"http://theplayapp.com/community-guidelines/"]]];
                    
                    break;
                    
                }
                case 2: {
                    [self openWebsite:[NSURL URLWithString:[NSString stringWithFormat:@"http://theplayapp.com/privacy-policy/"]]];
                    
                    break;
                    
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }

}


- (void)logOutAction:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayUtilityUserLogOffNotification object:[PFUser currentUser]];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)openEditProfileView:(id) sender{
    
    [self setTitle:@" "];
    EditProfileTableViewController *editViewController = [[EditProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [editViewController setCurrentUser:[PFUser currentUser]];
    [self.navigationController pushViewController:editViewController animated:YES];
    
}

- (void) switchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;

    NSMutableArray *pushSettingsArray = [[PFUser currentUser] objectForKey:kPlayUserPushArrayKey];
    
    if (!pushSettingsArray) {
        pushSettingsArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],nil];
    }
    
    switch (mySwitch.tag) {
        case 0:{
            [[PFUser currentUser] setObject:[NSNumber numberWithBool:[mySwitch isOn]] forKey:kPlayUserLocationCheckInKey];
            break;
        }
        case 1:{
            [pushSettingsArray replaceObjectAtIndex:(NSUInteger)kPlayPushSettingsWhenFollowKey withObject:[NSNumber numberWithInt:[mySwitch isOn]]];
            
            [[PFUser currentUser] setObject:pushSettingsArray forKey:kPlayUserPushArrayKey];
            break;
        }
        case 2:{
            
            [pushSettingsArray replaceObjectAtIndex:(NSUInteger)kPlayPushSettingsWhenJoinsEventKey withObject:[NSNumber numberWithInt:[mySwitch isOn]]];
            
            [[PFUser currentUser] setObject:pushSettingsArray forKey:kPlayUserPushArrayKey];
            break;
        }
        case 3:{
            
            [pushSettingsArray replaceObjectAtIndex:(NSUInteger)kPlayPushSettingsWhenInvitesToEventKey withObject:[NSNumber numberWithInt:[mySwitch isOn]]];
            
            [[PFUser currentUser] setObject:pushSettingsArray forKey:kPlayUserPushArrayKey];
            break;
        }
        case 4:{
            
            [pushSettingsArray replaceObjectAtIndex:(NSUInteger)kPlayPushSettingsWhenEventEditedOrDeletedKey withObject:[NSNumber numberWithInt:[mySwitch isOn]]];
            
            [[PFUser currentUser] setObject:pushSettingsArray forKey:kPlayUserPushArrayKey];
            break;
        }
        case 5:{
            
            [pushSettingsArray replaceObjectAtIndex:(NSUInteger)kPlayPushSettingsWhenSomeoneCommentsOnEventKey withObject:[NSNumber numberWithInt:[mySwitch isOn]]];
                        
            [[PFUser currentUser] setObject:pushSettingsArray forKey:kPlayUserPushArrayKey];
            break;
        }
        default:
            break;
    }

    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSLog(@"User Details saved");
            
        }else{
            NSLog(@"Error is saving User Details");

        }
    }];
    
}


- (void) openWebsite:(NSURL*)URL {
    
    [self setTitle:@" "];
    WebViewController *webController = [[WebViewController alloc] initwithURL:URL];
    [self.navigationController pushViewController:webController animated:YES];

}

#pragma mark -
#pragma mark MFMailComposerDelegate

- (void)pressedPostToEmailButton:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        [self setTitle:@" "];
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObject:@"dan@theplayapp.com"]];
        //[mailViewController setSubject:[NSString stringWithFormat:@"%@ is inviting you to an event",[PFUser currentUser].username]];
        //[mailViewController setMessageBody:[NSString stringWithFormat:@"%@ is inviting you to <br><br>Interested in joining? <a href=\"Download the free Play app\">http://</a>" isHTML:YES];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Device is currently unable to send email."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Dismiss",nil];
        [alert show];
    }
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:controller completion:nil];
}


@end
