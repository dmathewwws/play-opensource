//
//  ShareDetailedViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-04-24.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "CheckInViewController.h"

@interface ShareDetailedViewController : CheckInViewController

@property (nonatomic,strong) PFObject *event;
@property (strong, nonatomic) PFImageView *addEventImage;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *eventCaptionString;


@end
