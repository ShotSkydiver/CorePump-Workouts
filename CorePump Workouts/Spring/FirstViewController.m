//
//  FirstViewController.m
//  Test
//
//  Created by Conner Owen on 5/21/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import "FirstViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <FlatUIKit/FUIButton.h>
#import <FlatUIKit/FUISwitch.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import <FlatUIKit/FUIAlertView.h>
#import <FlatUIKit/UIPopoverController+FlatUI.h>
#import <Material/ImageCardView.swift>

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet ImageCardView *firstCardView;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*self.playBut.buttonColor = [UIColor lightGrayColor];
    self.playBut.shadowColor = [UIColor darkGrayColor];
    self.playBut.shadowHeight = 3.0f;
    self.playBut.cornerRadius = 6.0f;
    self.playBut.titleLabel.font = [UIFont flatFontOfSize:16];
    [self.playBut setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.playBut setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    self.moreButton.buttonColor = [UIColor lightGrayColor];
    self.moreButton.shadowColor = [UIColor darkGrayColor];
    self.moreButton.shadowHeight = 3.0f;
    self.moreButton.cornerRadius = 6.0f;
    self.moreButton.titleLabel.font = [UIFont flatFontOfSize:15];
    [self.moreButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.moreButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    
    CGRect frame = CGRectMake(30, 230, 260, 50);
    HTPressableButton *roundedRectButton = [[HTPressableButton alloc] initWithFrame:frame buttonStyle:HTPressableButtonStyleRounded];
    roundedRectButton.buttonColor = [UIColor ht_cloudsColor];
    roundedRectButton.shadowColor = [UIColor ht_silverColor];
    [roundedRectButton setTitle:@"THE BASICS" forState:UIControlStateNormal];
    [self.view addSubview:roundedRectButton];
     */
    
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)playButtonClicked:(id)sender {
    // when play button is tapped
    NSURL *videoURL = [[NSBundle mainBundle]URLForResource:@"mobile" withExtension:@"mov"];
    
    // create an AVPlayer
    //AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    
    AVPlayerItem *video = [[AVPlayerItem alloc] initWithURL:videoURL];
    AVQueuePlayer *queue = [[AVQueuePlayer alloc] initWithItems:@[video]];
    video = [[AVPlayerItem alloc] initWithURL:videoURL];
    [queue insertItem:video afterItem:nil];
    
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    //controller.player = player;
    controller.player = queue;
    //[player play];
    
    
    // show the view controller
    //[self addChildViewController:controller];
    //[self.view addSubview:controller.view];
    [self presentViewController:controller animated:YES completion:nil];
    controller.view.frame = self.view.frame;
    [controller.player play];
    
    NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
    [noteCenter addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification *note) {
                            AVPlayerItem *video = [[AVPlayerItem alloc] initWithURL:videoURL];
                            [queue insertItem:video afterItem:nil];
                        }];
}

- (IBAction)moreButtonClicked:(id)sender {
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"CorePump Workouts"
                                                          message:@"Soon you'll be able to pay a small fee to unlock more workout videos within this app."
                                                         delegate:nil cancelButtonTitle:@"Dismiss"
                                                otherButtonTitles:@"Do Something", nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:15];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}
*/

@end
