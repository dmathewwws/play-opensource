//
//  LocationPickerController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-02-21.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "LocationPickerController.h"
#import "AppDelegate.h"
#import "GAI.h"
//#import "UINavigationController+Additions.h"

@interface LocationPickerController ()

@end

@implementation LocationPickerController

#define zoominMapArea 2100
#define transitionDuration 0.3
#define transitionType kCATransitionFade

@synthesize mapView = _mapView;
@synthesize currentLocation = _currentLocation;
@synthesize theEventAnnotation = _theEventAnnotation;
@synthesize locationFinderButton = _locationFinderButton;
@synthesize delegate;
@synthesize foursquareResponses = _foursquareResponses;
@synthesize venueArray = _venueArray;
@synthesize touchLocation = _touchLocation;
@synthesize eventIconType = _eventIconType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle:@"PICK LOCATION"];
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);

    [_mapView setRegion:adjustedRegion animated:YES];
    

    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.1; //user needs to press for 1 second
    [self.mapView addGestureRecognizer:lpgr];
    
    //Center Button
    _locationFinderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *locationCenterImage = [UIImage imageNamed:@"locationbutton.png"];
    [_locationFinderButton setFrame:CGRectMake(260,7,locationCenterImage.size.width,locationCenterImage.size.height)];
    [_locationFinderButton addTarget:self action:@selector(centerMap) forControlEvents:UIControlEventTouchUpInside];
    [_locationFinderButton setBackgroundImage:locationCenterImage forState:UIControlStateNormal];
    [self.view addSubview:_locationFinderButton];
    
    [self sTouchLocation:_currentLocation];
    
    
    //remove Legal from Map
    UIView *legalView = nil;
    for (UIView *subview in self.mapView.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            legalView = subview;
            break;
        }
    }
    if (legalView) {
        [legalView removeFromSuperview];
    }
    
    UIButton *poweredby4sq = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *poweredby4sqImage = [UIImage imageNamed:@"poweredByFoursquare_gray.png"];
    [poweredby4sq setFrame:CGRectMake((self.mapView.frame.size.width/2)-(poweredby4sqImage.size.width/2),self.mapView.frame.size.height-85,poweredby4sqImage.size.width,poweredby4sqImage.size.height)];
    [poweredby4sq setUserInteractionEnabled:NO];
    [poweredby4sq setBackgroundImage:poweredby4sqImage forState:UIControlStateNormal];
    [self.mapView addSubview:poweredby4sq];
    
    UIImage* image = [UIImage imageNamed:@"backarrow.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];

}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Location Picker Screen"];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    CLLocation *touchLocation = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [self sTouchLocation:touchLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) centerMap {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [appDelegate startLocationManager];
    
    _currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
    [_mapView setRegion:adjustedRegion animated:YES];
    
}


- (void) sTouchLocation:(CLLocation *)touchLocation{
    
    if (_theEventAnnotation) {
        [self.mapView removeAnnotation:_theEventAnnotation];
    }
    
    CLLocationCoordinate2D touchCoordinate = CLLocationCoordinate2DMake(touchLocation.coordinate.latitude, touchLocation.coordinate.longitude);
    
    Event *eventAnnotation = [[Event alloc] initWithCoordinate:touchCoordinate andTitle:nil andSubtitle:nil];
    _theEventAnnotation = eventAnnotation;
    [self.mapView addAnnotation:eventAnnotation];
    
    [PlayUtility responseFrom4sq:touchLocation limit:@"5" block:^(NSArray *locationDictionary, NSError *error) {
                
        if (!error){
            _venueArray = locationDictionary;
            
            [_foursquareResponses performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
        }
    }];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [_venueArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *firstVenue = [_venueArray objectAtIndex:indexPath.row];
    
    // Configure the cell... setting the text of our cell's label
    NSString *venueName = [firstVenue objectForKey:@"name"];
    
    cell.textLabel.text = [venueName uppercaseString];
    [cell.textLabel setFont:[UIFont fontWithName:kPlayFontName size:12]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f]];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // If you want to push another view upon tapping one of the cells on your table.
    
    if(delegate && _theEventAnnotation){
        
        CLLocation *chooseLocation = [[CLLocation alloc] initWithLatitude:_theEventAnnotation.coordinate.latitude longitude:_theEventAnnotation.coordinate.longitude];
        
        [delegate locationPickerController:self currentLocation:chooseLocation venueArray:_venueArray indexArray:indexPath.row];
    }else if (delegate){
        
        [delegate locationPickerController:self currentLocation:_currentLocation venueArray:_venueArray indexArray:indexPath.row];

    }
    
    CATransition* transition = [CATransition animation];
    transition.duration = transitionDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = transitionType; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] popToRootViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark PinAnnotations

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    
    NSLog(@"inside viewForAnnotation");
    
    static NSString *identifier = @"Event";
    if ([annotation isKindOfClass:[Event class]]) {
                
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.image = [PlayUtility imageForEventType:_eventIconType];
        annotationView.enabled = NO;
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }
    return nil;
}

- (void)backButtonPressed:(id)sender {
    
        CATransition* transition = [CATransition animation];
        transition.duration = transitionDuration;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = transitionType;
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] popViewControllerAnimated:NO];
    
}

@end
