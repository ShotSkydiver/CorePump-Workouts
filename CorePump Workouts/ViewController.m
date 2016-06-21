//
//  ViewController.m
//  CorePump Workouts
//
//  Created by Conner Owen on 5/20/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Parse/Parse.h>
#import "SKSplashView.h"
#import "SKSplashIcon.h"


@interface ViewController () <UITabBarControllerDelegate, SKSplashDelegate, SKSplashIconDelegate>

@property (nonatomic, strong) NSMutableArray *tabViewControllersLoggedIn;
@property (nonatomic, strong) NSMutableArray *tabViewControllersNoUser;
@property (strong, nonatomic) SKSplashView *splashView;
@property (strong, nonatomic) SKSplashIcon *twitterSplashIcon;
@property (assign) BOOL hasAppearedOnce;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startSplashView];

    // #ff0044   255 0 68
    //[[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:255 green:0 blue:68 alpha:1]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:68.0f/255.0f alpha:1.0f]];

    self.delegate = self;
    
}

-(void) appSetup {
    NSMutableArray *tabbarViewControllers1 = [NSMutableArray arrayWithArray: [self viewControllers]];
    NSMutableArray *tabbarViewControllers2 = [NSMutableArray arrayWithArray: [self viewControllers]];
    
    [tabbarViewControllers1 removeObjectAtIndex: 4];
    [tabbarViewControllers1 removeObjectAtIndex: 2];
    [tabbarViewControllers1 removeObjectAtIndex: 0];
    self.tabViewControllersLoggedIn = tabbarViewControllers1;
    
    [tabbarViewControllers2 removeObjectAtIndex: 5];
    [tabbarViewControllers2 removeObjectAtIndex: 3];
    [tabbarViewControllers2 removeObjectAtIndex: 1];
    self.tabViewControllersNoUser = tabbarViewControllers2;
    
    //NSMutableArray *tabViewControllersNoLogin = [self.viewControllers mutableCopy];
    
    // 0: Welcome
    // 1: CorePump
    // 2: Calendar
    // 3: Upcoming
    // 4: Login
    // 5: Userpage
    if ([PFUser currentUser]) {
        NSLog(@"ViewController viewDidLoad: User logged in, removing login tab");
        // remove login tab
        /*
         [tabbarViewControllers removeObjectAtIndex: 5];
         [tabbarViewControllers removeObjectAtIndex: 3];
         [tabbarViewControllers removeObjectAtIndex: 0];
         self.tabViewControllersLoggedIn = tabbarViewControllers;
         */
        [self setViewControllers: self.tabViewControllersLoggedIn ];
    }
    else if (![PFUser currentUser]) {
        NSLog(@"ViewController viewDidLoad: No user logged in, removing userpage tab");
        // remove userpage tab
        /*
         [tabbarViewControllers removeObjectAtIndex: 4];
         [tabbarViewControllers removeObjectAtIndex: 2];
         [tabbarViewControllers removeObjectAtIndex: 1];
         self.tabViewControllersNoUser = tabbarViewControllers;
         */
        [self setViewControllers: self.tabViewControllersNoUser ];
    }
}

#pragma mark - Ping Example

- (void) startSplashView
{
    //UIImage *origLogo = [UIImage imageNamed:@"cp_logo_nocircle_hires.png"];
    UIImage *tintedLogo = [[UIImage imageNamed:@"splashlogo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    CABasicAnimation *anAnimation = [CABasicAnimation animationWithKeyPath:@"tintColor"];
    anAnimation.duration = 1.00;
    anAnimation.repeatCount = HUGE_VALF;
    anAnimation.autoreverses = YES;
    anAnimation.fromValue = [NSNumber numberWithFloat:1.0]; // [NSNumber numberWithFloat:1.0];
    anAnimation.toValue = [NSNumber numberWithFloat:0.0]; //[NSNumber numberWithFloat:0.10];
    //[self.layer addAnimation:anAnimation forKey:@"backgroundColor"];
    
    self.hasAppearedOnce = NO;
    SKSplashIcon *twitter2 = [[SKSplashIcon alloc] initWithImage:tintedLogo animationType:SKIconAnimationTypeCustom];
    [twitter2 setCustomAnimation:anAnimation];
    
    UIColor *twitterColor2 = [UIColor colorWithRed:0.25098 green:0.6 blue:1.0 alpha:1.0];
    SKSplashView *splash2 = [[SKSplashView alloc] initWithSplashIcon:twitter2 backgroundColor:twitterColor2 animationType:SKSplashAnimationTypeNone];
    splash2.delegate = self; //Optional -> if you want to receive updates on animation beginning/end
    splash2.animationDuration = 5; //Optional -> set animation duration. Default: 1s
    [self.view addSubview:splash2];
    twitter2.delegate = self;
    [splash2 startAnimation];
    
}


#pragma mark - Delegate methods

- (void) splashView:(SKSplashView *)splashView didBeginAnimatingWithDuration:(float)duration
{
    NSLog(@"Started animating from delegate");
    //To start activity animation when splash animation starts
    //[_indicatorView startAnimating];
}

- (void) splashViewDidEndAnimating:(SKSplashView *)splashView
{
    NSLog(@"Stopped animating from delegate");
    //To stop activity animation when splash animation ends
    //[_indicatorView stopAnimating];
}


- (void) splashIconView:(SKSplashIcon *)splashIconView didBeginAnimatingWithDuration:(float)duration
{
    NSLog(@"Started animating icon from delegate");
    //To start activity animation when splash animation starts
    [self appSetup];
    NSLog(@"app setup complete");
}

- (void) splashIconViewDidEndAnimating:(SKSplashIcon *)splashIconView
{
    if (self.hasAppearedOnce == NO) {
        self.hasAppearedOnce = YES;
        NSLog(@"Stopped animating icon from delegate");
        self.twitterSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"cp_logo_nocircle_hires.png"] animationType:SKIconAnimationTypeGrow];
        UIColor *twitterColor = [UIColor colorWithRed:0.25098 green:0.6 blue:1.0 alpha:1.0];
        self.splashView = [[SKSplashView alloc] initWithSplashIcon:self.twitterSplashIcon backgroundColor:twitterColor animationType:SKSplashAnimationTypeZoom];
        //self.splashView.delegate = self; //Optional -> if you want to receive updates on animation beginning/end
        self.splashView.animationDuration = 1; //Optional -> set animation duration. Default: 1s
        [self.view addSubview:self.splashView];
        [self.splashView startAnimation];
    }
    
}

-(void) removeLoginTab {
    // user is now logged in
    /*
    CustomUserContainer *userView = [self.storyboard instantiateViewControllerWithIdentifier:@"userpageView"];
    NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self viewControllers]];
    [tabbarViewControllers removeObjectAtIndex: 4];
    [tabbarViewControllers addObject:userView];
    [self setViewControllers: tabbarViewControllers ];
    [self setSelectedIndex:4];
     */
    [self setViewControllers: self.tabViewControllersLoggedIn ];
    [self setSelectedIndex:2];
}

-(void) removeUserpageTab {
    // no user is logged in
    /*
    WelcomeAccountViewController *userView = [self.storyboard instantiateViewControllerWithIdentifier:@"welcomeAccountView"];
    NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self viewControllers]];
    [tabbarViewControllers removeObjectAtIndex: 4];
    [tabbarViewControllers addObject:userView];
    [self setViewControllers: tabbarViewControllers ];
    [self setSelectedIndex:4];
    */
    [self setViewControllers: self.tabViewControllersNoUser ];
    [self setSelectedIndex:2];
}

/*
- (BOOL)  tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController {
    
    NSUInteger controllerIndex = [self.viewControllers indexOfObject:viewController];
    
    if (controllerIndex == tabBarController.selectedIndex) {
        return NO;
    }
    
    // Get the views.
    UIView *fromView = tabBarController.selectedViewController.view;
    UIView *toView = [tabBarController.viewControllers[controllerIndex] view];
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = controllerIndex > tabBarController.selectedIndex;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    toView.frame = CGRectMake((scrollRight ? screenWidth : -screenWidth), viewSize.origin.y, screenWidth, viewSize.size.height);
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame = CGRectMake((scrollRight ? -screenWidth : screenWidth), viewSize.origin.y, screenWidth, viewSize.size.height);
                         toView.frame = CGRectMake(0, viewSize.origin.y, screenWidth, viewSize.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             tabBarController.selectedIndex = controllerIndex;
                         }
                     }];
    
    return NO;
}
*/

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
    
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.splashView startAnimation];
    });
     */
}


@end
