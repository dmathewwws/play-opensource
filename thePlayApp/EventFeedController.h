//
//  EventFeedController.h
//  thePlayApp
//
//  Created by Daniel Mathews on 2012-12-22.
//  Copyright (c) 2012 com.theplayapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "EventFeedHeaderView.h"

@interface EventFeedController : PFQueryTableViewController <EventFeedHeaderViewDelegate>

- (EventFeedHeaderView *)dequeueReusableSectionHeaderView;

@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, assign) BOOL shouldScrollToTopView;
@property (nonatomic, assign) BOOL shouldSegmentChangeScrollToTopView;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) PFGeoPoint *point;
@property (strong,nonatomic) NSDateFormatter *dateFormatterForTime;
//@property (nonatomic, strong) UIView *headerViewAtTop;


- (void)doneButton:(id)sender;
- (void)addUsersButton:(id)sender;
- (void)userDidCheckInOrUncheckIntoEvent:(NSNotification *)note;
- (void)userDidPublishEvent:(NSNotification *)note;
- (void)userDidDeleteEvent:(NSNotification *)note;
- (void)userDidCommentOnEvent:(NSNotification *)note;
- (void) segmentChanged:(id)sender;
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl;

@end