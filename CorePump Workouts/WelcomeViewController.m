//
//  WelcomeViewController.m
//  CorePump Workouts
//
//  Created by Conner Owen on 6/9/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import "WelcomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <AYVibrantButton/AYVibrantButton.h>

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *blurredBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *welcomeVisualEffectView;
@property (nonatomic, strong) AYVibrantButton *vibrantButtonOne;
@property (nonatomic, strong) AYVibrantButton *vibrantButtonTwo;
@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (assign) BOOL hasViewAppeared;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"WelcomeViewController viewDidLoad");
    
    self.hasViewAppeared = NO;

    NSLog(@"WelcomeAccountViewController: frame size: %f x %f", self.view.frame.size.width, self.view.frame.size.height);
    self.vibrantButtonOne = [[AYVibrantButton alloc] initWithFrame:CGRectMake(20, 245, ((self.view.frame.size.width/2)-25), 33) style:AYVibrantButtonStyleInvert];
    self.vibrantButtonOne.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    self.vibrantButtonOne.text = @"Button One";
    self.vibrantButtonOne.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    
    self.vibrantButtonTwo = [[AYVibrantButton alloc] initWithFrame:CGRectMake(((self.view.frame.size.width/2)+10), 245, ((self.view.frame.size.width/2)-25), 33) style:AYVibrantButtonStyleInvert];
    self.vibrantButtonTwo.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.vibrantButtonTwo.text = @"Button Two";
    self.vibrantButtonTwo.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"WelcomeViewController viewWillAppear");
    
    if (self.hasViewAppeared == NO) {
        NSLog(@"WelcomeViewController viewWillAppear: view appearing for the first time");
        [self.welcomeVisualEffectView.contentView addSubview:self.vibrantButtonOne];
        [self.welcomeVisualEffectView.contentView addSubview:self.vibrantButtonTwo];
        self.hasViewAppeared = YES;
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}


@end
