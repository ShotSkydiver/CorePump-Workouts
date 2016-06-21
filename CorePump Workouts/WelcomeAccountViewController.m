//
//  WelcomeAccountViewController.m
//  CorePump Workouts
//
//  Created by Conner Owen on 6/9/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import "WelcomeAccountViewController.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>
#import <AYVibrantButton/AYVibrantButton.h>
#import "VibrantTextField.h"
#import <KVNProgress/KVNProgress.h>

@interface WelcomeAccountViewController ()

//@property (weak, nonatomic) IBOutlet ImageCardView *firstCardView;
@property (weak, nonatomic) IBOutlet UIImageView *blurredBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *welcomeVisualEffectView;
@property (nonatomic, strong) AYVibrantButton *vibrantLoginButton;
@property (nonatomic, strong) AYVibrantButton *vibrantRegisterButton;
@property (nonatomic, strong) AYVibrantButton *vibrantCloseButton;
@property (assign) BOOL closeButtonVisible;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *createLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@property (assign) BOOL hasViewAppeared;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *welcomeViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *welcomeViewTopConstraint;
@property (assign) BOOL keyboardIsShowing;
//Login stuff
@property (strong, nonatomic) VibrantTextField *emailField;
@property (strong, nonatomic) VibrantTextField *passwordField;
@property (nonatomic, strong) AYVibrantButton *vibrantLoginActionButton;
@property (assign) BOOL loginFieldsVisible;

// Register stuff
@property (strong, nonatomic) VibrantTextField *registerNameField;
@property (strong, nonatomic) VibrantTextField *registerEmailField;
//@property (strong, nonatomic) IBOutlet VibrantTextField *registerUsernameField;
@property (strong, nonatomic) VibrantTextField *registerPasswordField;
@property (strong, nonatomic) VibrantTextField *registerSerialField;
@property (nonatomic, strong) AYVibrantButton *vibrantSerialLocationButton;
@property (nonatomic, strong) AYVibrantButton *vibrantRegisterActionButton;
@property (assign) BOOL registerFieldsVisible;

@end

@implementation WelcomeAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"WelcomeAccountViewController viewDidLoad");
    
    self.welcomeViewTopConstraint.constant = (self.view.frame.size.height-362);
    
    self.hasViewAppeared = NO;
    self.keyboardIsShowing = NO;
    
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    //configuration.statusColor = [UIColor whiteColor];
    configuration.statusFont = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    //configuration.circleStrokeForegroundColor = [UIColor whiteColor];
    //configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    //configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    //configuration.backgroundFillColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.9f];
    //configuration.backgroundTintColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:1.0f];
    //configuration.successColor = [UIColor whiteColor];
    //configuration.errorColor = [UIColor whiteColor];
    //configuration.stopColor = [UIColor whiteColor];
    //configuration.circleSize = 110.0f;
    //configuration.lineWidth = 1.0f;
    configuration.fullScreen = YES;
    configuration.showStop = NO;
    //configuration.stopRelativeHeight = 0.4f;
    
    [KVNProgress setConfiguration:configuration];
    
    /*
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    */
    
    NSLog(@"WelcomeAccountViewController: frame size: %f x %f", self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"WelcomeAccountViewController: frame size: %f x %f", self.welcomeVisualEffectView.frame.size.width, self.welcomeVisualEffectView.frame.size.height);
    
    self.vibrantLoginButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(20, 245, ((self.view.frame.size.width/2)-25), 33) style:AYVibrantButtonStyleInvert];
    self.vibrantLoginButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.vibrantLoginButton.text = @"Log In";
    self.vibrantLoginButton.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    [self.vibrantLoginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.vibrantRegisterButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(((self.view.frame.size.width/2)+10), 245, ((self.view.frame.size.width/2)-25), 33) style:AYVibrantButtonStyleInvert];
    self.vibrantRegisterButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.vibrantRegisterButton.text = @"Register";
    self.vibrantRegisterButton.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    [self.vibrantRegisterButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
    
    self.vibrantCloseButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(20, 325, ((self.view.frame.size.width/2)-25), 33) style:AYVibrantButtonStyleInvert];
    self.vibrantCloseButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.vibrantCloseButton.text = @"Close";
    self.vibrantCloseButton.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    [self.vibrantCloseButton addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    self.closeButtonVisible = NO;
    
    //UIKeyboardDidHideNotification when keyboard is fully hidden
    //name:UIKeyboardWillHideNotification when keyboard is going to be hidden
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // Login stuff
    self.emailField = [[VibrantTextField alloc] initWithFrame:CGRectMake(40, 220, (self.view.frame.size.width*0.80), 35) style:VibrantTextFieldStyleInvert];
    self.emailField.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.emailField.placeholder = @"Email Address";
    self.emailField.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    //[self.emailField addTarget:self action:@selector(adjustForKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    
    self.passwordField = [[VibrantTextField alloc] initWithFrame:CGRectMake(40, 270, (self.view.frame.size.width*0.80), 35) style:VibrantTextFieldStyleInvert];
    self.passwordField.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    //[self.passwordField addTarget:self action:@selector(adjustForKeyboard:) forControlEvents:UIControlEvent];
    
    
    self.vibrantLoginActionButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(((self.view.frame.size.width/2)+10), 325, ((self.view.frame.size.width/2)-25), 33) style:AYVibrantButtonStyleInvert];
    self.vibrantLoginActionButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.vibrantLoginActionButton.text = @"Log In";
    self.vibrantLoginActionButton.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    [self.vibrantLoginActionButton addTarget:self action:@selector(loginActionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginFieldsVisible = NO;
    
    // Register stuff
    self.registerNameField = [[VibrantTextField alloc] initWithFrame:CGRectMake(40, 225, (self.view.frame.size.width*0.80), 35) style:VibrantTextFieldStyleInvert];
    self.registerNameField.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.registerNameField.placeholder = @"Full Name";
    self.registerNameField.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    
    self.registerEmailField = [[VibrantTextField alloc] initWithFrame:CGRectMake(40, 265, (self.view.frame.size.width*0.80), 35) style:VibrantTextFieldStyleInvert]; // +10
    self.registerEmailField.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.registerEmailField.placeholder = @"Email Address";
    self.registerEmailField.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    
    self.registerPasswordField = [[VibrantTextField alloc] initWithFrame:CGRectMake(40, 305, (self.view.frame.size.width*0.80), 35) style:VibrantTextFieldStyleInvert];
    self.registerPasswordField.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.registerPasswordField.placeholder = @"Password";
    self.registerPasswordField.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    
    self.registerSerialField = [[VibrantTextField alloc] initWithFrame:CGRectMake(40, 345, (self.view.frame.size.width*0.80), 35) style:VibrantTextFieldStyleInvert];
    self.registerSerialField.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.registerSerialField.placeholder = @"CorePump Serial Number";
    self.registerSerialField.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    
    self.vibrantSerialLocationButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(40, 385, (self.view.frame.size.width*0.80), 30) style:AYVibrantButtonStyleInvert];
    self.vibrantSerialLocationButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.vibrantSerialLocationButton.text = @"Where is my serial number?";
    self.vibrantSerialLocationButton.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:16.0];
    [self.vibrantSerialLocationButton addTarget:self action:@selector(serialLocationClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.vibrantRegisterActionButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(((self.view.frame.size.width/2)+10), 415, ((self.view.frame.size.width/2)-25), 33) style:AYVibrantButtonStyleInvert];
    self.vibrantRegisterActionButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.vibrantRegisterActionButton.text = @"Register";
    self.vibrantRegisterActionButton.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    [self.vibrantRegisterActionButton addTarget:self action:@selector(registerActionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerFieldsVisible = NO;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    NSLog(@"handleSingleTap: tap detected");
    [self.view endEditing:YES];
}
/*
- (BOOL)textFieldShouldReturn:(VibrantTextField *)textField {
    if (textField == self.emailField) {
        NSLog(@"textFieldShouldReturn: email field");
        [textField resignFirstResponder];
    }
    return YES;
}*/



-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"WelcomeAccountViewController viewWillAppear");
    
    if (self.hasViewAppeared == NO) {
        NSLog(@"WelcomeAccountViewController viewWillAppear: view appearing for first time");
        [self.welcomeVisualEffectView.contentView addSubview:self.vibrantLoginButton];
        [self.welcomeVisualEffectView.contentView addSubview:self.vibrantRegisterButton];
        [self.welcomeVisualEffectView.contentView addSubview:self.vibrantCloseButton];
        
        [self.vibrantCloseButton setAlpha:0.0f];
        
        [self.welcomeVisualEffectView.contentView addSubview:self.emailField];
        [self.welcomeVisualEffectView.contentView addSubview:self.passwordField];
        [self.welcomeVisualEffectView.contentView addSubview:self.vibrantLoginActionButton];
        
        [self.emailField setAlpha:0.0f];
        [self.passwordField setAlpha:0.0f];
        [self.vibrantLoginActionButton setAlpha:0.0f];
        
        [self.welcomeVisualEffectView.contentView addSubview:self.registerNameField];
        [self.welcomeVisualEffectView.contentView addSubview:self.registerEmailField];
        [self.welcomeVisualEffectView.contentView addSubview:self.registerPasswordField];
        [self.welcomeVisualEffectView.contentView addSubview:self.registerSerialField];
        [self.welcomeVisualEffectView.contentView addSubview:self.vibrantSerialLocationButton];
        [self.welcomeVisualEffectView.contentView addSubview:self.vibrantRegisterActionButton];
        
        [self.registerNameField setAlpha:0.0f];
        [self.registerEmailField setAlpha:0.0f];
        [self.registerPasswordField setAlpha:0.0f];
        [self.registerSerialField setAlpha:0.0f];
        [self.vibrantSerialLocationButton setAlpha:0.0f];
        [self.vibrantRegisterActionButton setAlpha:0.0f];
        
        
        
        self.hasViewAppeared = YES;
    }
}

-(void)onKeyboardShow:(NSNotification *)notification
{
    NSLog(@"onKeyboardShow: keyboard will show");
    self.keyboardIsShowing = YES;
    
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"onKeyboardShow: keyboard end frame size: %f x %f", keyboardEndFrame.size.width, keyboardEndFrame.size.height);
    NSLog(@"onKeyboardShow: frame size: %f x %f", self.welcomeVisualEffectView.frame.size.width, self.welcomeVisualEffectView.frame.size.height);

    [self.view layoutIfNeeded];
    self.welcomeViewTopConstraint.constant = 0;
    self.welcomeViewHeight.constant = ((self.view.frame.size.height) - (keyboardEndFrame.size.height));
    NSLog(@"onKeyboardShow: new height: %f", ((self.view.frame.size.height) - (keyboardEndFrame.size.height)));
    
    self.vibrantCloseButton.frame = CGRectMake(20, (((self.view.frame.size.height) - (keyboardEndFrame.size.height))-70), ((self.view.frame.size.width/2)-25), 33);
    self.vibrantRegisterActionButton.frame = CGRectMake(((self.view.frame.size.width/2)+10), (((self.view.frame.size.height) - (keyboardEndFrame.size.height))-70), ((self.view.frame.size.width/2)-25), 33);
    self.vibrantLoginActionButton.frame = CGRectMake(((self.view.frame.size.width/2)+10), (((self.view.frame.size.height) - (keyboardEndFrame.size.height)) - 70), ((self.view.frame.size.width/2)-25), 33);

    
    [UIView animateWithDuration:0.6
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view layoutIfNeeded];
                         //[self.welcomeViewHeight setConstant:(self.view.frame.size.height-50)];
                         //[self.descriptionLabel setAlpha:0.0f];

                     }
                     completion:^(BOOL finished) {
                         //[modalView.view removeFromSuperview];
                         NSLog(@"WelcomeAccountViewController aimation done");
                         
                     }];
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    NSLog(@"WelcomeAccountViewController keyboard will hide");
    self.keyboardIsShowing = NO;
    
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"onKeyboardHide: keyboard frame size: %f x %f", keyboardEndFrame.size.width, keyboardEndFrame.size.height);
    
    
    

    if (self.closeButtonVisible == YES) {
        NSLog(@"onKeyboardHide: close button not clicked");

        [self.view layoutIfNeeded];
        
        if (self.registerFieldsVisible == YES) {
            NSLog(@"onKeyboardHide: register fields visible");
            self.welcomeViewHeight.constant = (self.view.frame.size.height - 200); //536
            self.welcomeViewTopConstraint.constant = (self.view.frame.size.height - (self.view.frame.size.height - 200));
            self.vibrantCloseButton.frame = CGRectMake(20, ((self.view.frame.size.height - 200)-100), ((self.view.frame.size.width/2)-25), 33);
            self.vibrantRegisterActionButton.frame = CGRectMake(((self.view.frame.size.width/2)+10), ((self.view.frame.size.height - 200)-10), ((self.view.frame.size.width/2)-25), 33);
        }
        else if (self.loginFieldsVisible == YES) {
            NSLog(@"onKeyboardHide: login fields visible");
            self.welcomeViewHeight.constant = (self.view.frame.size.height - 300); //436
            self.welcomeViewTopConstraint.constant = (self.view.frame.size.height - (self.view.frame.size.height - 300));
            self.vibrantCloseButton.frame = CGRectMake(20, ((self.view.frame.size.height - 300)-100), ((self.view.frame.size.width/2)-25), 33);
            self.vibrantLoginActionButton.frame = CGRectMake(((self.view.frame.size.width/2)+10), ((self.view.frame.size.height - 300)-100), ((self.view.frame.size.width/2)-25), 33);
        }
        
        [UIView animateWithDuration:0.6
                              delay: 0.0
                            usingSpringWithDamping:0.8
                            initialSpringVelocity:0.3
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self.view layoutIfNeeded];
                             //[self.welcomeViewHeight setConstant:(self.view.frame.size.height-50)];
                             //[self.descriptionLabel setAlpha:0.0f];
                             
                         }
                         completion:^(BOOL finished) {
                             //[modalView.view removeFromSuperview];
                             NSLog(@"WelcomeAccountViewController aimation done");
                             
                         }];
    }
    else if (self.closeButtonVisible == NO) {
        NSLog(@"onKeyboardHide: close button was clicked");
        
    }
    
    
}

-(void)keyboardFrameWillChange:(NSNotification *)notification
{
    NSLog(@"WelcomeAccountViewController keyboard frame change");
    /*
    if (self.keyboardIsShowing == YES) {
        CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"onKeyboardShow: keyboard frame size: %f x %f", keyboardEndFrame.size.width, keyboardEndFrame.size.height);
        CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
        
        
        [self.view layoutIfNeeded];
        //self.welcomeViewTopConstraint.constant = 0;
        self.welcomeViewHeight.constant = ((self.view.frame.size.height) - (keyboardEndFrame.size.height));
        NSLog(@"onKeyboardShow: new height: %f", ((self.view.frame.size.height) - (keyboardEndFrame.size.height)));
        //[self.welcomeVisualEffectView addConstraint:welcomeViewTopConstraint];
        
        [UIView animateWithDuration:animationDuration
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self.view layoutIfNeeded];
                             //[self.welcomeViewHeight setConstant:(self.view.frame.size.height-50)];
                             //[self.descriptionLabel setAlpha:0.0f];
                             
                         }
                         completion:^(BOOL finished) {
                             //[modalView.view removeFromSuperview];
                             NSLog(@"WelcomeAccountViewController aimation done");
                             
                         }];
    }
    */
}

-(void)registerClick:(AYVibrantButton *)button{
    NSLog(@"WelcomeAccountViewController registerButtonClick");
    
    
    
    [self.view layoutIfNeeded];
    self.welcomeViewHeight.constant = (self.view.frame.size.height - 200); //536
    self.welcomeViewTopConstraint.constant = (self.view.frame.size.height - (self.view.frame.size.height - 200));
    
    CATransition *transitionAnimation = [CATransition animation];
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:0.4f];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeBoth];
    [self.createLabel.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
    //[transitionAnimation setRemovedOnCompletion:NO];
    [self.createLabel setText:@"Create your"];
    
    self.vibrantRegisterActionButton.frame = CGRectMake(((self.view.frame.size.width/2)+10), ((self.view.frame.size.height - 200)-100), ((self.view.frame.size.width/2)-25), 33);
    self.vibrantCloseButton.frame = CGRectMake(20, ((self.view.frame.size.height - 200)-100), ((self.view.frame.size.width/2)-25), 33);
    
    [UIView animateWithDuration:0.6
                    delay: 0.0
                    usingSpringWithDamping:0.8
                    initialSpringVelocity:0.3
                    options: UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        [self.view layoutIfNeeded];
                        //[self.welcomeViewHeight setConstant:(self.view.frame.size.height-50)];
                        [self.vibrantLoginButton setAlpha:0.0f];
                        [self.vibrantRegisterButton setAlpha:0.0f];
                        [self.vibrantCloseButton setAlpha:1.0f];
                     
                        [self.registerNameField setAlpha:1.0f];
                        [self.registerEmailField setAlpha:1.0f];
                        [self.registerPasswordField setAlpha:1.0f];
                        [self.registerSerialField setAlpha:1.0f];
                        [self.vibrantSerialLocationButton setAlpha:1.0f];
                        [self.vibrantRegisterActionButton setAlpha:1.0f];
                        
                        
                     
                     }
                     completion:^(BOOL finished) {
                         //[modalView.view removeFromSuperview];
                         NSLog(@"WelcomeAccountViewController aimation done");
                         self.closeButtonVisible = YES;
                         self.registerFieldsVisible = YES;
                     }];
    
    
    
}

-(void)loginClick:(AYVibrantButton *)button{
    NSLog(@"WelcomeAccountViewController loginButtonClick");
    
    
    
    [self.view layoutIfNeeded];
    self.welcomeViewHeight.constant = (self.view.frame.size.height - 300); //436
    self.welcomeViewTopConstraint.constant = (self.view.frame.size.height - (self.view.frame.size.height - 300));
    
    NSLog(@"loginClick: welcome view frame size: %f x %f", self.welcomeVisualEffectView.frame.size.width, self.welcomeVisualEffectView.frame.size.height);

    CATransition *transitionAnimation = [CATransition animation];
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:0.4f];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeBoth];
    [self.createLabel.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
    //[transitionAnimation setRemovedOnCompletion:NO];
    [self.createLabel setText:@"Login to your"];
    
    self.vibrantLoginActionButton.frame = CGRectMake(((self.view.frame.size.width/2)+10), ((self.view.frame.size.height - 300)-100), ((self.view.frame.size.width/2)-25), 33);
    self.vibrantCloseButton.frame = CGRectMake(20, ((self.view.frame.size.height - 300)-100), ((self.view.frame.size.width/2)-25), 33);
    
    [UIView animateWithDuration:0.6
                    delay: 0.0
                    usingSpringWithDamping:0.8
                    initialSpringVelocity:0.3
                    options: UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        [self.view layoutIfNeeded];
                        //[self.welcomeViewHeight setConstant:(self.view.frame.size.height-50)];
                        [self.vibrantLoginButton setAlpha:0.0f];
                        [self.vibrantRegisterButton setAlpha:0.0f];
                        [self.vibrantCloseButton setAlpha:1.0f];
                        
                        [self.emailField setAlpha:1.0f];
                        [self.passwordField setAlpha:1.0f];
                        [self.vibrantLoginActionButton setAlpha:1.0f];
                        
                        
                    }
                     completion:^(BOOL finished) {
                         //[modalView.view removeFromSuperview];
                         NSLog(@"WelcomeAccountViewController aimation done");
                         self.closeButtonVisible = YES;
                         self.loginFieldsVisible = YES;
                         
                         [self.view layoutIfNeeded];
                         
                     }];
    
}

-(void)closeClick:(AYVibrantButton *)button{
    NSLog(@"WelcomeAccountViewController closeButtonClick");
    if (self.closeButtonVisible == YES) {
        self.closeButtonVisible = NO;
        [self.view endEditing:YES];
        
        [self.view layoutIfNeeded];
        self.welcomeViewHeight.constant = 362.0;
        self.welcomeViewTopConstraint.constant = (self.view.frame.size.height-362);
        
        CATransition *transitionAnimation = [CATransition animation];
        [transitionAnimation setType:kCATransitionFade];
        [transitionAnimation setDuration:0.4f];
        [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transitionAnimation setFillMode:kCAFillModeBoth];
        [self.createLabel.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
        //[transitionAnimation setRemovedOnCompletion:NO];
        [self.createLabel setText:@"Your"];
        
        if (self.loginFieldsVisible == YES) {
            NSLog(@"Hiding login fields");
            
            [UIView animateWithDuration:0.6
                                  delay: 0.0
                 usingSpringWithDamping:0.8
                  initialSpringVelocity:0.3
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 //[self.welcomeViewHeight setConstant:(self.view.frame.size.height-50)];
                                 [self.view layoutIfNeeded];
                                 [self.vibrantLoginButton setAlpha:1.0f];
                                 [self.vibrantRegisterButton setAlpha:1.0f];
                                 [self.vibrantCloseButton setAlpha:0.0f];
                                 
                                 [self.emailField setAlpha:0.0f];
                                 [self.passwordField setAlpha:0.0f];
                                 [self.vibrantLoginActionButton setAlpha:0.0f];
                                 
                                 self.vibrantLoginActionButton.frame = CGRectMake(((self.view.frame.size.width/2)+10), (self.welcomeVisualEffectView.frame.size.height-50), ((self.view.frame.size.width/2)-25), 33);
                                 self.vibrantCloseButton.frame = CGRectMake(20, (self.welcomeVisualEffectView.frame.size.height-50), ((self.view.frame.size.width/2)-25), 33);
                             }
                             completion:^(BOOL finished) {
                                 //[modalView.view removeFromSuperview];
                                 NSLog(@"WelcomeAccountViewController aimation done");
                                 self.loginFieldsVisible = NO;
                                 
                             }];
        }
        
        else if (self.registerFieldsVisible == YES) {
            NSLog(@"Hiding register fields");
            
            [UIView animateWithDuration:1.0
                                  delay: 0.0
                 usingSpringWithDamping:0.8
                  initialSpringVelocity:0.3
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 //[self.welcomeViewHeight setConstant:(self.view.frame.size.height-50)];
                                 [self.view layoutIfNeeded];
                                 [self.vibrantLoginButton setAlpha:1.0f];
                                 [self.vibrantRegisterButton setAlpha:1.0f];
                                 [self.vibrantCloseButton setAlpha:0.0f];
                                 
                                 [self.registerNameField setAlpha:0.0f];
                                 [self.registerEmailField setAlpha:0.0f];
                                 [self.registerPasswordField setAlpha:0.0f];
                                 [self.registerSerialField setAlpha:0.0f];
                                 [self.vibrantSerialLocationButton setAlpha:0.0f];
                                 [self.vibrantRegisterActionButton setAlpha:0.0f];
                                 
                                 self.vibrantRegisterActionButton.frame = CGRectMake(((self.view.frame.size.width/2)+10), (self.welcomeVisualEffectView.frame.size.height-50), ((self.view.frame.size.width/2)-25), 33);
                                 self.vibrantCloseButton.frame = CGRectMake(20, (self.welcomeVisualEffectView.frame.size.height-50), ((self.view.frame.size.width/2)-25), 33);
                             }
                             completion:^(BOOL finished) {
                                 //[modalView.view removeFromSuperview];
                                 NSLog(@"WelcomeAccountViewController aimation done");
                                 self.registerFieldsVisible = NO;
                                 self.closeButtonVisible = NO;
                             }];
        }
        
    }
}

-(void)loginActionClick:(AYVibrantButton *)button{
    NSLog(@"WelcomeAccountViewController loginActionButtonClick");
    [self.view endEditing:YES];
    //[self.view layoutIfNeeded];
    //self.welcomeViewHeight.constant = (self.view.frame.size.height - 150);
    [KVNProgress showWithStatus:@"Loading..."];
    
    if (!self.emailField.text || self.emailField.text.length == 0) {
        //informationComplete = NO;
        [KVNProgress showErrorWithStatus:@"Please enter a valid email address!"];
        return;
    }
    if (!self.passwordField.text || self.passwordField.text.length == 0) {
        //informationComplete = NO;
        [KVNProgress showErrorWithStatus:@"Please enter a password!"];
        return;
    }
    // Logging in user, show progress HUD
    
    
    
    
    [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"Login successful!");
                                            // PFUser CurrentUser is now set
                                            ViewController* viewController = (ViewController*)self.parentViewController;
                                            [viewController removeLoginTab];
                                            // Setup userpage view here
                                            [KVNProgress showSuccessWithStatus:@"Success"];
                                            
                                            //[self dismissViewControllerAnimated:YES completion:nil];
                                        } else {
                                            // The login failed. Check error to see why.
                                            //Errors
                                            NSLog(@"Error logging in user: %@", error);
                                            [KVNProgress showErrorWithStatus:[NSString stringWithFormat:@"%@", error]];
                                        }
                                    }];
    
    
}

-(void)serialLocationClick:(AYVibrantButton *)button{
    NSLog(@"WelcomeAccountViewController serialLocationClick");
    
    // Make popup window with serial info
}

-(void)registerActionClick:(AYVibrantButton *)button{
    NSLog(@"WelcomeAccountViewController registerActionButtonClick");
    [self.view endEditing:YES];
    if (!self.registerEmailField.text || self.registerEmailField.text.length == 0) {
        //informationComplete = NO;
        NSLog(@"Email not filled in!");
        return;
    }
    if (!self.registerPasswordField.text || self.registerPasswordField.text.length == 0) {
        //informationComplete = NO;
        NSLog(@"Password not filled in!");
        return;
    }
    
    // Registering user, show progress HUD
    
    [KVNProgress showWithStatus:@"Loading..."];
    
    PFUser *user = [PFUser user];
    user.username = self.registerEmailField.text;
    user.password = self.registerPasswordField.text;
    user.email = self.registerEmailField.text;
    user[@"name"] = self.registerNameField.text;
    
    
    NSString *userSerial = self.registerSerialField.text;
    
    PFQuery *query = [PFQuery queryWithClassName:@"SerialNumbers"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            
            NSLog(@"Successfully retrieved %lu serials.", (unsigned long)objects.count);
            BOOL foundSerialNumber = NO;
            for (PFObject *object in objects) {
                // Do something with the found objects
                
                NSString *serialNumber = object[@"SerialNumber"];
                BOOL isInUse = [object[@"isInUse"] boolValue];
                
                if ([userSerial isEqualToString:serialNumber]) {
                    NSLog(@"CustomParseSignUpStepTwo: found serial match");
                    NSLog(@"number found: %@", serialNumber);
                    if (isInUse) {
                        NSLog(@"registerActionClick: serial is already in use!");
                        [KVNProgress showErrorWithStatus:@"The serial you entered is already in use!"];
                        return;
                    }
                    else if (!isInUse) {
                        NSLog(@"registerActionClick: serial not in use");
                        foundSerialNumber = YES;
                        [user setObject:object forKey:@"serial_number"];
                        //[[PFUser currentUser] saveEventually];
                        
                        
                        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                NSLog(@"Registration successful!");
                                object[@"registeredTo"] = user;
                                object[@"isInUse"] = [NSNumber numberWithBool:YES];
                                [object saveInBackground];
                                ViewController* viewController = (ViewController*)self.parentViewController;
                                [viewController removeLoginTab];
                                // Setup userpage view here
                                [KVNProgress showSuccessWithStatus:@"Successfully registered!"];
                            } else {
                                //NSString *errorString = [error userInfo][@"error"];
                                [KVNProgress showErrorWithStatus:[NSString stringWithFormat:@"%@", error]];
                                return;
                            }
                        }];
                    }
                }
            }
            if (foundSerialNumber == NO) {
                [KVNProgress showErrorWithStatus:@"Invalid serial number entered!"];
                return;
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [KVNProgress showErrorWithStatus:[NSString stringWithFormat:@"%@", error]];
            return;
        }
    }];
    
    
}

@end
