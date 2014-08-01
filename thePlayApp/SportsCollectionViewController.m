//
//  SportsCollectionViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-01-30.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "SportsCollectionViewController.h"
#import "PlayConstants.h"
#import <QuartzCore/QuartzCore.h>

#define numberofSports 12
#define transitionDuration 0.3
#define transitionType kCATransitionFade

@interface SportsCollectionViewController ()

@end

@implementation SportsCollectionViewController

@synthesize delegate;
@synthesize hasSportPicked = _hasSportPicked;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    
    self
}*/

- (void)setBackground:(UIImage*)bkgdImage{
    UIColor *background = [[UIColor alloc] initWithPatternImage:bkgdImage];
    [self.collectionView setBackgroundColor:background];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle:@"CREATE AN ACTIVITY"];
    
    UIImage* image = [UIImage imageNamed:@"backarrow.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return numberofSports;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SportsPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SportsCell" forIndexPath:indexPath];
    [cell setImage:indexPath.row];
    return cell;
}

/*-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
}*/

#pragma mark -
#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(delegate)
    {
        [delegate sportPickerController:self indexRow:indexPath.row];
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

    if(!_hasSportPicked){
        NSLog(@"in HERE");
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSLog(@"OR in HERE");
        CATransition* transition = [CATransition animation];
        transition.duration = transitionDuration;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = transitionType;
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] popViewControllerAnimated:NO];

    }
    
}


@end
