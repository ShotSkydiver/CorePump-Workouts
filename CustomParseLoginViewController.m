//
//  CustomParseLoginViewController.m
//  CorePump Workouts
//
//  Created by Conner Owen on 6/9/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import "CustomParseLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>
#import "HyTransitions.h"
#import "HyLoglnButton.h"




@interface CustomParseLoginViewController () <UIViewControllerTransitioningDelegate>

//@property (weak, nonatomic) IBOutlet ImageCardView *firstCardView;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
//@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *emailField;
//@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *passwordFIeld;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;



@end



@implementation CustomParseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CustomParseLoginViewController viewDidLoad");
    //self.mz_formSheetPresentingPresentationController.presentationController.shouldApplyBackgroundBlurEffect = YES;
    [self createPresentControllerButton];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)createPresentControllerButton{
    //initWithFrame:CGRectMake(0, 0, 0, 0)];
    HyLoglnButton *log = [[HyLoglnButton alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.bounds) - (40 + 80), [UIScreen mainScreen].bounds.size.width - 40, 40)];
    //HyLoglnButton *log = [[HyLoglnButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [log setBackgroundColor:[UIColor colorWithRed:1 green:0.f/255.0f blue:128.0f/255.0f alpha:1]];
    [self.view addSubview:log];
    [log setTitle:@"Login" forState:UIControlStateNormal];
    [log addTarget:self action:@selector(PresentViewController:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)PresentViewController:(HyLoglnButton *)button{
    
    typeof(self) __weak weak = self;
    //do all the login setup stuff
    /*
    NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self.parentViewController.tabBarController viewControllers]];
    [tabbarViewControllers removeObjectAtIndex:3];
    [self.parentViewController.tabBarController setViewControllers: tabbarViewControllers ];
    [self.parentViewController.tabBarController setSelectedIndex:0];
    */
    //NSString *email = self.emailField.text;
    //NSString *password = self.passwordFIeld.text;

    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Running login display view");
        [weak LoginButton:button];
    });
}

-(void)LoginButton:(HyLoglnButton *)button
{
    typeof(self) __weak weak = self;
    /*
    NSString *email = self.emailField.text;
    NSString *password = self.passwordFIeld.text;
    
    [PFUser logInWithUsernameInBackground:email password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"CustomParseLoginViewController login successful");
                                            [self.dismissDelegate successfulLogin];
                                            //No Errors
                                            [button ExitAnimationCompletion:^{
                                                
                                                    [weak didPresentControllerButtonTouch];
                                            }];

                                            //[self dismissViewControllerAnimated:YES completion:nil];
                                        } else {
                                            // The login failed. Check error to see why.
                                            //Errors
                                            [button ErrorRevertAnimationCompletion:^{
 
                                                    [weak didPresentControllerButtonTouch];
                                            }];
                                        }
                                    }];
     */
}

- (void)didPresentControllerButtonTouch
{
    [self dismissViewControllerAnimated:YES completion:nil];
    /*
    UIViewController *controller = [SecondViewController new];
    
    controller.transitioningDelegate = self;
    
    UINavigationController *nai = [[UINavigationController alloc] initWithRootViewController:controller];
    nai.transitioningDelegate = self;
    
    [self presentViewController:nai animated:YES completion:nil];
     */
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isBOOL:true];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.8f isBOOL:false];
}

- (IBAction)dismissButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
