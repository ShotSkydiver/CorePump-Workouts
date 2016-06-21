//
//  WelcomeCalendarViewController.m
//  CorePump Workouts
//
//  Created by Conner Owen on 6/15/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import "WelcomeCalendarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <AYVibrantButton/AYVibrantButton.h>

@interface WelcomeCalendarViewController ()

@property (nonatomic, strong) AYVibrantButton *calendarButton;
//@property (nonatomic, strong) AYVibrantButton *vibrantButtonTwo;
@property (strong, nonatomic) IBOutlet UIImageView *blurredBackgroundImageView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *welcomeVisualEffectView;

@property (assign) BOOL hasViewAppeared;

@end

@implementation WelcomeCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"WelcomeCalendarViewController viewDidLoad");
    
    self.hasViewAppeared = NO;
    
    NSLog(@"WelcomeCalendarViewController: frame size: %f x %f", self.view.frame.size.width, self.view.frame.size.height);
    self.calendarButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(20, 245, ((self.view.frame.size.width/2)-25), 33) style:AYVibrantButtonStyleInvert];
    self.calendarButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    self.calendarButton.text = @"View Calendar";
    self.calendarButton.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];

}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"WelcomeCalendarViewController viewWillAppear");
    
    if (self.hasViewAppeared == NO) {
        NSLog(@"WelcomeCalendarViewController viewWillAppear: view appearing for the first time");
        [self.welcomeVisualEffectView.contentView addSubview:self.calendarButton];
        [self.welcomeVisualEffectView.contentView addSubview:self.calendarButton];
        self.hasViewAppeared = YES;
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}


@end