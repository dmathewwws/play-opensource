//
//  InstagramCollectionViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-14.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import "InstagramCollectionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GAI.h"

@interface InstagramCollectionViewController ()

@end

#define transitionDuration 0.3
#define transitionType kCATransitionFade

@implementation InstagramCollectionViewController

@synthesize instagramDataArray = _instagramDataArray;
@synthesize instagramDataDictionary = _instagramDataDictionary;
@synthesize delegate;
@synthesize instagramSearchTerm = _instagramSearchTerm;

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
    
    [self setTitle:[NSString stringWithFormat:@"#%@",[_instagramSearchTerm uppercaseString]]];
    
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
    [tracker sendView:@"Instagram Search Screen"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)instagramString:(NSString *)instagramURL {
    
    NSMutableURLRequest *instaRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:instagramURL]];
    
    dispatch_queue_t instaQueue;
    instaQueue = dispatch_queue_create("com.thePlayApp.instaQueue", NULL);
    dispatch_async(instaQueue, ^{
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSError *error2 = nil;
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Error connecting to Instagram, please try again later"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        
        NSData *data = [NSURLConnection sendSynchronousRequest:instaRequest
                                             returningResponse:&response
                                                         error:&error];
        if(!error){

            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error2];
            
            if (!error2) {
                _instagramDataArray = [json objectForKey:@"data"];
                NSLog(@"pieces of data: %d", [_instagramDataArray count]);
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    
                    [self.collectionView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^(){
                    
                    [alertView show];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                [alertView show];
            });
        }
    });
}

#pragma
#pragma mark - UICollectionView Datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"pieces of data in collectionview: %d", [_instagramDataArray count]);

    return [_instagramDataArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    InstagramCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"instagramCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        NSLog(@"cell is nil");
        cell = [[InstagramCollectionViewCell alloc] init];
    }else{
        //NSLog(@"cell is %@, cell.instagramImage = %@",cell.description, cell.instagramImage.description);

    }
    
    _instagramDataDictionary = [_instagramDataArray objectAtIndex:indexPath.row];
   
    NSDictionary* currentImageDictionary = [_instagramDataDictionary objectForKey:@"images"];
    NSDictionary* currentThumbnailDictionary = [currentImageDictionary objectForKey:@"low_resolution"];
    NSString *currentURL = [currentThumbnailDictionary objectForKey:@"url"];
    
    [cell.instagramImage setImage:[UIImage imageNamed:@"instabg.png"]];
    
    [cell.instagramImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentURL]]]];
    
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(delegate)
    {
        NSDictionary* currentIndexPath = [_instagramDataArray objectAtIndex:indexPath.row];
        NSDictionary* currentImageDictionary = [currentIndexPath objectForKey:@"images"];
        NSDictionary* currentThumbnailDictionary = [currentImageDictionary objectForKey:@"standard_resolution"];
        NSString *currentURL = [currentThumbnailDictionary objectForKey:@"url"];
        
        [delegate instaPickerController:self anImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentURL]]]];
    }
    
    CATransition* transition = [CATransition animation];
    transition.duration = transitionDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = transitionType;
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] popViewControllerAnimated:NO];
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