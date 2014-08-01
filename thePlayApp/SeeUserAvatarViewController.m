//
//  SeeUserAvatarViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-04-08.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "SeeUserAvatarViewController.h"
#import "PlayConstants.h"
#import "GAI.h"

@interface SeeUserAvatarViewController ()


@end

@implementation SeeUserAvatarViewController

@synthesize profileImageView = _profileImageView;

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
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissScreen:)]];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"See Users Avatar Screen"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setFile:(PFFile *)file{
    if (!file) {
        return;
    }
    
    self.profileImageView = [[PFImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-kPlayAvatarLargeSize/2,self.view.frame.size.height/2-kPlayAvatarLargeSize/2,kPlayAvatarLargeSize,kPlayAvatarLargeSize)];
    self.profileImageView.image = [UIImage imageNamed:@"defaultprofile.png"];
    self.profileImageView.file = file;
    [self.profileImageView loadInBackground];
    [self.view addSubview:self.profileImageView];
}

- (void) dismissScreen:(id) sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
