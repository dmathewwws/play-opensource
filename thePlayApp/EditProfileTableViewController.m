//
//  EditProfileTableViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-04-29.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "EditProfileTableViewController.h"
#import "PlayConstants.h"
#import "SettingsCellTextField.h"
#import "ActionSheetStringPicker.h"
#import "GAI.h"

@interface EditProfileTableViewController ()

@end

@implementation EditProfileTableViewController

#define charLimitBio 120

@synthesize headerView = _headerView;
@synthesize genderArray = _genderArray;
@synthesize ageArray = _ageArray;
@synthesize selectedIndexOfGender = _selectedIndexOfGender;
@synthesize saveButton = _saveButton;
@synthesize bioString = _bioString;
@synthesize bioStringCount = _bioStringCount;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        _genderArray = [[NSArray alloc] initWithObjects:@"-",@"Male",@"Female", nil];
        _ageArray = [[NSArray alloc] initWithObjects:@"-",@"Under 18",@"18-25",@"26-35",@"36-50",@"51-65",@"66+", nil];
        _bioString = @" ";
        _selectedIndexOfAge = 0;
        _selectedIndexOfGender = 0;
        
        _bioStringCount = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bioStringCount setFrame:CGRectMake(self.view.frame.size.width - 45.0f - 5.0f, self.view.frame.size.height - 216.0f - 75.0f, 45.0f, 25.0f)];
        [_bioStringCount setBackgroundColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f]];
        [_bioStringCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bioStringCount setUserInteractionEnabled:NO];
        //[_bioStringCount setTitle:@"Hi" forState:UIControlStateNormal];
        [[_bioStringCount titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:12.0f]];
        _bioStringCount.hidden = YES;
        [self.view addSubview:_bioStringCount];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonPressed:)];
    _saveButton.tintColor = [UIColor colorWithRed:141.0f/255.0f green:141.0f/255.0f blue:141.0f/255.0f alpha:1.0f];
    
    [self.navigationItem setRightBarButtonItem:_saveButton];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Edit Profile Screen"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *Cell0Identifier = @"Cell0";
    static NSString *Cell1Identifier = @"Cell1";
    static NSString *Cell2Identifier = @"Cell2";
    NSString *identityString = @"";
    switch ([indexPath row]) {
        case 0: {
            identityString = Cell0Identifier;
            break;
        }
        case 1: {
            identityString = Cell1Identifier;
            break;
        }
        case 2: {
            identityString = Cell2Identifier;
            break;
        }
            
        default:
            break;
    }
    
    SettingsCellTextField *cell = [tableView dequeueReusableCellWithIdentifier:identityString];
    
    if ([indexPath row] == 0) {
        
        if (cell == nil) {
            cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textField.delegate = self;
        }
        
        [cell.titleButton setTitle:@"BIO:" forState:UIControlStateNormal];
        cell.textField.text = _bioString;
        
    }
    
    else if ([indexPath row] == 1) {
        
        if (cell == nil) {
            cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        [cell.titleButton setTitle:@"GENDER:" forState:UIControlStateNormal];
        NSLog(@"self.selectedIndexOfGender is %d",self.selectedIndexOfGender);
        [cell.subTitleButton setTitle:[self.genderArray objectAtIndex:self.selectedIndexOfGender] forState:UIControlStateNormal];
    }
    
    else {
        
        if (cell == nil) {
            cell = [[SettingsCellTextField alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityString];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        [cell.titleButton setTitle:@"AGE:" forState:UIControlStateNormal];
        [cell.subTitleButton setTitle:[self.ageArray objectAtIndex:self.selectedIndexOfAge] forState:UIControlStateNormal];

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
    [headerLabel setTitle:@"ABOUT ME" forState:UIControlStateNormal];
    [headerLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [[headerLabel titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:13.0f]];
    [self.headerView addSubview:headerLabel];
    
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0f;
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

-(void)setCurrentUser:(PFUser *)currentUser{
    
    [currentUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            
            NSArray *ageArray = [currentUser objectForKey:kPlayUserPlayAgeKey];
            NSNumber *indexofAge = [ageArray objectAtIndex:1];
            
            NSArray *genderArray = [currentUser objectForKey:kPlayUserPlayGenderKey];
            NSNumber *indexofGender = [genderArray objectAtIndex:1];
            
            if(indexofGender){
                _selectedIndexOfGender = [indexofGender intValue];
            }
            if(indexofAge){
                _selectedIndexOfAge = [indexofAge intValue];
            }
            _bioString = [currentUser objectForKey:kPlayUserPlayBioKey];
        }
    
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    SettingsCellTextField *cell = (SettingsCellTextField*)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([indexPath row] == 0) {
        [cell.textField becomeFirstResponder];
        
    }else if ([indexPath row] == 1) {
        
        [self selectAGender:cell];
    }else{
    
        [self selectAnAge:cell];
    }
    
}

- (void)selectAGender:(UIControl *)sender {
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Gender" rows:self.genderArray initialSelection:self.selectedIndexOfGender target:self successAction:@selector(genderWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
}

- (void)genderWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndexOfGender = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    //self.animalTextField.text = [self.genderArray objectAtIndex:self.selectedIndexOfGender];
    
    SettingsCellTextField *cell = (SettingsCellTextField*) element;
    
    [cell.subTitleButton setTitle:[self.genderArray objectAtIndex:self.selectedIndexOfGender] forState:UIControlStateNormal];
 }

- (void)selectAnAge:(UIControl *)sender {
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Age" rows:self.ageArray initialSelection:self.selectedIndexOfAge target:self successAction:@selector(ageWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (void)ageWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndexOfAge = [selectedIndex intValue];
        
    SettingsCellTextField *cell = (SettingsCellTextField*) element;
    
    [cell.subTitleButton setTitle:[self.ageArray objectAtIndex:self.selectedIndexOfAge] forState:UIControlStateNormal];
}

- (void)actionPickerCancelled:(id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

- (void)saveButtonPressed:(id)sender {
    
    if (_bioString.length > 120) {
        
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Your Bio cannot be longer than 120 characters. Please write a shorter Bio."
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        [alertView show];
    }else{
        
        NSArray *ageArray = [NSArray arrayWithObjects:[self.ageArray objectAtIndex:self.selectedIndexOfAge],[NSNumber numberWithInteger:self.selectedIndexOfAge], nil];
        NSArray *genderArray = [NSArray arrayWithObjects:[self.genderArray objectAtIndex:self.selectedIndexOfGender],[NSNumber numberWithInteger:self.selectedIndexOfGender], nil];
        
        if (!_bioString) {
            _bioString= @"";
        }
        
        [[PFUser currentUser] setObject:_bioString forKey:kPlayUserPlayBioKey];
        [[PFUser currentUser] setObject:ageArray forKey:kPlayUserPlayAgeKey];
        [[PFUser currentUser] setObject:genderArray forKey:kPlayUserPlayGenderKey];
        
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                NSLog(@"User Details saved");
                [[NSNotificationCenter defaultCenter] postNotificationName:PlayEditProfileChanged object:nil];

            }
            
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark TextFields

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    //make sure you can choose image unless you are done typing
    //_addAvatarImage.userInteractionEnabled = YES;*/
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _bioStringCount.hidden = NO;
    NSInteger textLength = 0;
    textLength = [textField.text length];
    [_bioStringCount setTitle:[NSString stringWithFormat:@"%d",charLimitBio-textLength] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:nil];

}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    _bioString = textField.text;
    _bioStringCount.hidden = YES;
    _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonPressed:)];
    _saveButton.tintColor = [UIColor colorWithRed:141.0f/255.0f green:141.0f/255.0f blue:141.0f/255.0f alpha:1.0f];

    
    [self.navigationItem setRightBarButtonItem:_saveButton];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger textLength = 0;
    textLength = [textField.text length] + [string length] - range.length;
    [_bioStringCount setTitle:[NSString stringWithFormat:@"%d",charLimitBio-textLength] forState:UIControlStateNormal];
    
//    NSLog(@"Length: %d", textLength);
    return YES;
}

/*-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -205; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}*/



@end
