// IMPORTANT - basic transitions like flip and curl are local, they reside only in animation block. Core animations however,
// once assigned to the layer, stay until changed or reset (by assigning nil as layer animation property)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    CustomViewAnimationTransitionNone,
    CustomViewAnimationTransitionFlipFromLeft,
    CustomViewAnimationTransitionFlipFromRight,
    CustomViewAnimationTransitionCurlUp,
    CustomViewAnimationTransitionCurlDown,
    CustomViewAnimationTransitionFadeIn,
    CustomViewAnimationTransitionMoveIn,
    CustomViewAnimationTransitionPush,
    CustomViewAnimationTransitionReveal
} CustomViewAnimationTransition;

#define CustomViewAnimationSubtypeFromRight kCATransitionFromRight
#define CustomViewAnimationSubtypeFromLeft kCATransitionFromLeft
#define CustomViewAnimationSubtypeFromTop kCATransitionFromTop
#define CustomViewAnimationSubtypeFromBottom kCATransitionFromBottom

@interface UINavigationController(Additions)

- (void)pushViewController:(UIViewController *)viewController withCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype;

- (void)popViewControllerWithCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype;
- (void)popToRootViewControllerWithCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype;
- (void)popToViewController:(UIViewController *)viewController withCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype;

@end