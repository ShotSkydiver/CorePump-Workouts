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
#import "FUIButton.h"
#import "FUISwitch.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"
#import "UIPopoverController+FlatUI.h"
#import "NSString+Icons.h"
#import "CBZSplashView.h"
#import "CBZRasterSplashView.h"
#import "UIColor+HexString.h"
#import "UIBezierPath+Shapes.h"
#import "OnboardingContentViewController.h"
#import "OnboardingViewController.h"

@interface ViewController ()


@property (nonatomic, strong) CBZSplashView *splashView;
//@property (nonatomic, retain) CAGradientLayer *gradient;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIBezierPath *bezier = [UIBezierPath corepumpShape];
    UIColor *color = [UIColor colorWithHexString:@"59595c"];
    CBZSplashView *splashView = [CBZSplashView splashViewWithBezierPath:bezier backgroundColor:color];
    // customize duration, icon size, or icon color here;
    splashView.animationDuration = 0.5;
    [self.view addSubview:splashView];
    self.splashView = splashView;
    
    
    self.title = @"CorePump";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.splashView startAnimation];
    });
}


@end
