//
//  OnboardViewController.m
//  CorePump Workouts
//
//  Created by Conner Owen on 5/21/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import "OnboardViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Onboard/OnboardingContentViewController.h>
#import <Onboard/OnboardingViewController.h>
#import <FlatUIKit/UIFont+FlatUI.h>


@interface OnboardViewController ()

//@property (nonatomic, retain) CAGradientLayer *gradient;
@property (nonatomic, strong) OnboardingViewController *onboardingVC;

@end

@implementation OnboardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Welcome to CorePump Mobile" body:@"CorePump Mobile is your link to the CorePump world, and the best way to get started with your new CorePump machine." image:[UIImage imageNamed:@"coffee"] buttonText:@"" action:^{
        // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
    }];
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"Watch official CorePump workouts" body:@"CorePump Mobile gives you access to dozens of official workout videos, with more being added constantly, so you never get bored." image:[UIImage imageNamed:@"headphones"] buttonText:@"" action:^{
        // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
    }];
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Register for a CorePump account" body:@"Track your CorePump workout progress, share your profile with other users, and more." image:[UIImage imageNamed:@"testtube"] buttonText:@"Get Started" action:^{
        // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        [self dismissButton];
        //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        //[self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        //[self.view.window.rootViewController performSegueWithIdentifier:@"SegueMain" sender:self];
    }];
    
    self.onboardingVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"charcoal"] contents:@[firstPage, secondPage, thirdPage]];
    
    firstPage.titleLabel.font = [UIFont flatFontOfSize:18];
    firstPage.bodyLabel.font = [UIFont flatFontOfSize:16];
    firstPage.underIconPadding = 60;
    secondPage.titleLabel.font = [UIFont flatFontOfSize:18];
    secondPage.bodyLabel.font = [UIFont flatFontOfSize:16];
    secondPage.underIconPadding = 60;
    thirdPage.titleLabel.font = [UIFont flatFontOfSize:18];
    thirdPage.bodyLabel.font = [UIFont flatFontOfSize:16];
    thirdPage.actionButton.titleLabel.font = [UIFont flatFontOfSize:18];
    thirdPage.underIconPadding = 60;
    
    //[self presentViewController:onboardingVC animated:YES completion:nil];
    [self addChildViewController:self.onboardingVC];
    [self.view addSubview:self.onboardingVC.view];
    
    
    
    //thirdPage.buttonActionHandler = ^{[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];};
    
    //onboardingVC.view.frame = self.view.frame;

}

- (void)dismissButton {
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    //[self.onboardingVC.view removeFromSuperview];
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.onboardingVC.view.alpha = 0;
                     }completion:^(BOOL finished){
                         [self.onboardingVC.view removeFromSuperview];
                         [self.onboardingVC removeFromParentViewController];
                         [self performSegueWithIdentifier:@"SegueMain" sender:self];
                     }];
    
}

@end