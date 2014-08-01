#import "UINavigationController+Additions.h"

@interface UINavigationController()

- (void)standardAnimationWithController:(UIViewController*)viewController
                               duration:(NSTimeInterval)duration
                                options:(UIViewAnimationOptions)options
                           changesBlock:(void (^)(void))block;
- (void)coreAnimationWithController:(UIViewController*)viewController
                           duration:(NSTimeInterval)duration
                               type:(NSString*)type
                            subtype:(NSString*)subtype
                       changesBlock:(void (^)(void))block;
@end

@implementation UINavigationController(Additions)

#pragma mark -
#pragma mark pushing

- (void)pushViewController:(UIViewController *)viewController withCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype {
    switch (transition) {
        case CustomViewAnimationTransitionNone:{
            [self standardAnimationWithController:viewController duration:.5 options:UIViewAnimationOptionTransitionNone
                                     changesBlock:^{
                                         [self pushViewController:viewController animated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFlipFromLeft:{
            [self standardAnimationWithController:viewController duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft
                                     changesBlock:^{
                                         [self pushViewController:viewController animated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFlipFromRight:{
            [self standardAnimationWithController:viewController duration:.5 options:UIViewAnimationOptionTransitionFlipFromRight
                                     changesBlock:^{
                                         [self pushViewController:viewController animated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionCurlUp:{
            [self standardAnimationWithController:viewController duration:.5 options:UIViewAnimationOptionTransitionCurlUp
                                     changesBlock:^{
                                         [self pushViewController:viewController animated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionCurlDown:{
            [self standardAnimationWithController:viewController duration:.5 options:UIViewAnimationOptionTransitionCurlDown
                                     changesBlock:^{
                                         [self pushViewController:viewController animated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFadeIn:{
            [self coreAnimationWithController:viewController duration:.5 type:kCATransitionFade subtype:nil
                                 changesBlock:^{
                                     [self pushViewController:viewController animated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionMoveIn:{
            [self coreAnimationWithController:viewController duration:.5 type:kCATransitionMoveIn subtype:subtype
                                 changesBlock:^{
                                     [self pushViewController:viewController animated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionPush:{
            [self coreAnimationWithController:viewController duration:.5 type:kCATransitionPush subtype:subtype
                                 changesBlock:^{
                                     [self pushViewController:viewController animated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionReveal:{
            [self coreAnimationWithController:viewController duration:.5 type:kCATransitionReveal subtype:subtype
                                 changesBlock:^{
                                     [self pushViewController:viewController animated:NO];
                                 }];
            break;}
        default:{
            break;}
    }
}

#pragma mark -
#pragma mark popping

- (void)popViewControllerWithCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype {
    switch (transition) {
        case CustomViewAnimationTransitionNone:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionNone
                                     changesBlock:^{
                                         [self popViewControllerAnimated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFlipFromLeft:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft
                                     changesBlock:^{
                                         [self popViewControllerAnimated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFlipFromRight:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionFlipFromRight
                                     changesBlock:^{
                                         [self popViewControllerAnimated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionCurlUp:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionCurlUp
                                     changesBlock:^{
                                         [self popViewControllerAnimated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionCurlDown:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionCurlDown
                                     changesBlock:^{
                                         [self popViewControllerAnimated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFadeIn:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionFade subtype:nil
                                 changesBlock:^{
                                     [self popViewControllerAnimated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionMoveIn:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionMoveIn subtype:subtype
                                 changesBlock:^{
                                     [self popViewControllerAnimated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionPush:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionPush subtype:subtype
                                 changesBlock:^{
                                     [self popViewControllerAnimated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionReveal:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionReveal subtype:subtype
                                 changesBlock:^{
                                     [self popViewControllerAnimated:NO];
                                 }];
            break;}
        default:{
            break;}
    }
}

- (void)popToRootViewControllerWithCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype {
    switch (transition) {
        case CustomViewAnimationTransitionNone:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionNone
                                     changesBlock:^{
                                         [self popToRootViewControllerAnimated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFlipFromLeft:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft
                                     changesBlock:^{
                                         [self popToRootViewControllerAnimated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFlipFromRight:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionFlipFromRight
                                     changesBlock:^{
                                         [self popToRootViewControllerAnimated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionCurlUp:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionCurlUp
                                     changesBlock:^{
                                         [self popToRootViewControllerAnimated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionCurlDown:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionCurlDown
                                     changesBlock:^{
                                         [self popToRootViewControllerAnimated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFadeIn:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionFade subtype:nil
                                 changesBlock:^{
                                     [self popToRootViewControllerAnimated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionMoveIn:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionMoveIn subtype:subtype
                                 changesBlock:^{
                                     [self popToRootViewControllerAnimated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionPush:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionPush subtype:subtype
                                 changesBlock:^{
                                     [self popToRootViewControllerAnimated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionReveal:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionReveal subtype:subtype
                                 changesBlock:^{
                                     [self popToRootViewControllerAnimated:NO];
                                 }];
            break;}
        default:{
            break;}
    }
}

- (void)popToViewController:(UIViewController *)viewController withCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype {
    switch (transition) {
        case CustomViewAnimationTransitionNone:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionNone
                                     changesBlock:^{
                                         [self popToViewController:viewController animated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFlipFromLeft:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft
                                     changesBlock:^{
                                         [self popToViewController:viewController animated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFlipFromRight:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionFlipFromRight
                                     changesBlock:^{
                                         [self popToViewController:viewController animated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionCurlUp:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionCurlUp
                                     changesBlock:^{
                                         [self popToViewController:viewController animated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionCurlDown:{
            [self standardAnimationWithController:nil duration:.5 options:UIViewAnimationOptionTransitionCurlDown
                                     changesBlock:^{
                                         [self popToViewController:viewController animated:NO];
                                     }];
            break;}
        case CustomViewAnimationTransitionFadeIn:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionFade subtype:nil
                                 changesBlock:^{
                                     [self popToViewController:viewController animated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionMoveIn:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionMoveIn subtype:subtype
                                 changesBlock:^{
                                     [self popToViewController:viewController animated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionPush:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionPush subtype:subtype
                                 changesBlock:^{
                                     [self popToViewController:viewController animated:NO];
                                 }];
            break;}
        case CustomViewAnimationTransitionReveal:{
            [self coreAnimationWithController:nil duration:.5 type:kCATransitionReveal subtype:subtype
                                 changesBlock:^{
                                     [self popToViewController:viewController animated:NO];
                                 }];
            break;}
        default:{
            break;}
    }
}

#pragma mark -
#pragma mark private

- (void)standardAnimationWithController:(UIViewController*)viewController
                               duration:(NSTimeInterval)duration
                                options:(UIViewAnimationOptions)options
                           changesBlock:(void (^)(void))block {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView transitionWithView:self.view duration:duration options:options animations:block completion:NULL];
    [UIView commitAnimations];
}

- (void)coreAnimationWithController:(UIViewController*)viewController
                           duration:(NSTimeInterval)duration
                               type:(NSString*)type
                            subtype:(NSString*)subtype
                       changesBlock:(void (^)(void))block {
    CATransition* trans = [CATransition animation];
    [trans setDuration:duration];
    [trans setType:type];
    [trans setSubtype:subtype];
    [self.view.layer addAnimation:trans forKey:kCATransition];
    block();
}

@end