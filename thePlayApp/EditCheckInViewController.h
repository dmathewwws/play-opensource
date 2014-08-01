//
//  EditCheckInViewController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-05-29.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "CheckInViewController.h"

@interface EditCheckInViewController : CheckInViewController

@property (nonatomic,strong) PFObject *event;
@property (strong, nonatomic) PFImageView *addEventImage;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *eventCaptionString;

@end