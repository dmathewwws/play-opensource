//
//  WebViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-05-08.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;

-(id)initwithURL:(NSURL*)url;

@end
