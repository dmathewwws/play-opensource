//
//  WebViewController.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-05-08.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initwithURL:(NSURL*)url{
    if (self) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
