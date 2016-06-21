//
//  FBLoginViewController.m
//  CorePump Workouts
//
//  Created by Conner Owen on 5/24/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomUserContainer.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <FBSDKCoreKit/FBSDKProfile.h>
#import "AppDelegate.h"

#import "ViewController.h"
#import <APAvatarImageView/APAvatarImageView.h>

//@import AvatarView;


@interface CustomUserContainer () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) UIViewController *currentViewController;


//@property (strong, nonatomic) CustomLogInViewController *customLogInVC;
@property (weak, nonatomic) IBOutlet UILabel *userLabelNew;
@property (weak, nonatomic) IBOutlet UIButton *logoutButtonNew;
@property (weak, nonatomic) IBOutlet UIButton *connectFBButton;
@property (weak, nonatomic) IBOutlet APAvatarImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blurredProfileImageView;
//@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *fullNameField;
//@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *userNameField;
//@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *emailAddressField;
@property (assign) BOOL isViewDisplayed;
@property (assign) NSString *userEmail;
@property (assign) NSString *userFullName;
@property (assign) NSString *corepumpModel;
@property (assign) NSString *profilePictureURL;

@property (weak, nonatomic) UIImage *userProfilePicture;
@property (assign) BOOL isFBRequestComplete;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageWidth;

@end

@implementation CustomUserContainer

- (void)viewDidLoad {
    [super viewDidLoad];

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];

    self.isViewDisplayed = NO;
    self.isFBRequestComplete = NO;
    
    self.userEmail = @"Email";
    self.userFullName = @"Name";
    self.corepumpModel = @"Red";
    self.profilePictureURL = @"URL";
    
    [self shouldHideElements:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.userContainer = self;
    
    
    //self.blurredProfileImageView.image = [UIImage imageNamed:@"logohires"];
    
    
    /*
    self.customLogInVC = [[CustomLogInViewController alloc] init];
    self.customLogInVC.fields = (PFLogInFieldsUsernameAndPassword
                         | PFLogInFieldsLogInButton
                         | PFLogInFieldsPasswordForgotten
                         //| PFLogInFieldsFacebook
                         | PFLogInFieldsSignUpButton
                         | PFLogInFieldsDismissButton);
    self.customLogInVC.delegate = self;
    
    //self.customLogInVC.facebookPermissions = @[@"public_profile", @"email"];
    
    // Customize the Sign Up View Controller
    CustomSignUpViewController *signUpViewController = [[CustomSignUpViewController alloc] init];
    signUpViewController.fields = (PFSignUpFieldsUsernameAndPassword
                                   | PFSignUpFieldsEmail
                                   | PFSignUpFieldsAdditional
                                   | PFSignUpFieldsDismissButton
                                   | PFSignUpFieldsSignUpButton);
    signUpViewController.delegate = self;
    self.customLogInVC.signUpController = signUpViewController;
    
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Your CorePump Account" body:@"Registering a CorePump Account lets you unlock more CorePump workout videos, track your CorePump workout progress across devices, share your progress with other users, and more." image:[UIImage imageNamed:@"loginimage"] buttonText:@"Login or Register" action:^{
        // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        [self logInButton];
    }];
    
    self.loginInfoVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"onboard_2"] contents:@[firstPage]];
    
    self.loginInfoVC.shouldBlurBackground = YES;
    self.loginInfoVC.shouldMaskBackground = YES;
    self.loginInfoVC.shouldFadeTransitions = YES;
    
    
    firstPage.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    firstPage.titleLabel.textColor = [UIColor groupTableViewBackgroundColor];
    firstPage.bodyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    firstPage.bodyLabel.textColor = [UIColor groupTableViewBackgroundColor];
    firstPage.topPadding = 70;
    firstPage.underIconPadding = 50;
    firstPage.underTitlePadding = 45;
    firstPage.bottomPadding = 60;
    firstPage.actionButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    [self addChildViewController:self.loginInfoVC];
     */
    
    if ([PFUser currentUser]) {
        NSLog(@"CustomViewContainer viewDidLoad: User is logged in");
        if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            NSLog(@"CustomViewContainer viewDidLoad: There is a Facebook account associated with this user");
            [self oneTimeFacebookSetup];
        }
        else if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            NSLog(@"CustomViewContainer viewDidLoad: There is not a Facebook account associated with this user");
            [self updateUserPage];
        }
        
    }
    else if (![PFUser currentUser]) {
        NSLog(@"CustomViewContainer viewDidLoad: No user logged in");
        //[self shouldHideElements:YES];
    }

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([PFUser currentUser]) {
        NSLog(@"CustomViewContainer viewWillAppear: User logged in, presenting userpage");
        
    }
    else if (![PFUser currentUser]) {
        NSLog(@"CustomViewContainer viewWillAppear: No user logged in, presenting log in view");
        
        if (self.isViewDisplayed == NO) {
            NSLog(@"CustomViewContainer viewWillAppear: isviewdisplayed is no");
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [self.view.layer addAnimation:transition forKey:nil];

            self.isViewDisplayed = YES;
        }
        else if (self.isViewDisplayed == YES) {
            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"CustomViewContainer viewDidAppear");
}

- (void)logInButton {
    
    //[self presentViewController:self.customLogInVC animated:YES completion:nil];
}

- (IBAction)logoutButtonNewClick:(id)sender {
    NSLog(@"logoutButtonNewClick: Logging out user");
    [PFUser logOut];
    /*
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:transition forKey:nil];
    [self.view addSubview:self.loginInfoVC.view];
    self.isViewDisplayed = YES;
    */
    // switch to welcome account tab, remove me tab
    ViewController* viewController = (ViewController*)self.parentViewController;
    
    [viewController removeUserpageTab];
}

- (IBAction)connectFBButtonClick:(id)sender {
    
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"connectFBButtonClick: Connecting user account to Facebook account");
        [PFFacebookUtils linkUserInBackground:[PFUser currentUser] withReadPermissions:@[@"public_profile", @"email"] block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self oneTimeFacebookSetup];
                NSLog(@"connectFBButtonClick: Woohoo, user is linked with Facebook!");
                //[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"Facebook connection success! In the future, if you need to log in to your CorePump account again, you can either continue using your previous username and password, or use the 'Login with Facebook' option.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            }
        }];
    }
    else if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"connectFBButtonClick: Disconnecting Facebook account from user account");
        [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/permissions"
                                                   parameters:nil
                                                   HTTPMethod:@"DELETE"]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         [self updateUserPage];
                         NSLog(@"connectFBButtonClick: The user is no longer associated with their Facebook account.");
                         
                     }
                     else{
                         NSLog(@"%@", [error localizedDescription]);
                     }
                 }];
                //[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"Your account has successfully been disconnected from your Facebook account. Now you can only log in with your username and password, but you can reconnect your Facebook at any time with the 'Connect to Facebook' button.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            }
        }];
    }
    
}

-(void)oneTimeFacebookSetup {
    NSLog(@"oneTimeFacebookSetup: Linking Facebook to the user account");
    
    PFUser *currentUser = [PFUser currentUser];
    
    // Make FB Graph request
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSString *facebookID = userData[@"id"];
            
            // Get user profile picture
            //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?height=350&width=350&return_ssl_resources=1", facebookID]];
            [[PFUser currentUser] setObject:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID] forKey:@"FBProfilePicURL"];

            NSData *data = [NSData dataWithContentsOfURL:pictureURL];
            //self.userProfilePicture = [UIImage imageWithData:data];
            self.profileImageView.image = [UIImage imageWithData:data];
            NSLog(@"oneTimeFacebookSetup: raw image dimensions: %f x %f", [UIImage imageWithData:data].size.width, [UIImage imageWithData:data].size.height);
            NSLog(@"oneTimeFacebookSetup: image dimensions: %f x %f", self.profileImageView.image.size.width, self.profileImageView.image.size.height);
            NSLog(@"oneTimeFacebookSetup: image frame dimensions: %f x %f", self.profileImageView.frame.size.width, self.profileImageView.frame.size.height);
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
            self.profileImageView.clipsToBounds = YES;
            self.profileImageView.layer.borderWidth = 3.0f;
            self.profileImageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            
            self.blurredProfileImageView.image = [UIImage imageWithData:data];
            UIVisualEffect *blurEffect;
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *visualEffectView;
            visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            visualEffectView.frame = self.blurredProfileImageView.bounds;
            [self.blurredProfileImageView addSubview:visualEffectView];
            
            /*
            self.userEmail = [NSString stringWithFormat:@"%@", userData[@"email"]];
            NSLog(@"oneTimeFacebookSetup: Email: %@", self.userEmail);
            [[PFUser currentUser] setObject:[NSString stringWithFormat:@"%@", userData[@"email"]] forKey:@"email"];
            
            self.userFullName = [NSString stringWithFormat:@"%@", userData[@"name"]];
            NSLog(@"oneTimeFacebookSetup: Name: %@", self.userFullName);
            [[PFUser currentUser] setObject:[NSString stringWithFormat:@"%@", userData[@"name"]] forKey:@"name"];
             */
            
            [PFUser currentUser][@"isUsingDefaultPicture"] = @(NO);
            
            [[PFUser currentUser] saveEventually];
            

            self.isFBRequestComplete = YES;
            [self updateUserPage];
            
        } else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"oneTimeFacebookSetup: The facebook session was invalidated");
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
        } else {
            NSLog(@"oneTimeFacebookSetup: Some other error: %@", error);
        }
        
    }];
    
    
}

-(void) appDelegateTest {
    NSLog(@"appDelegateTest: Method called from app delegate");
    
}


-(void) updateUserPage {
    // Configure elements to be displayed on user page
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"updateUserPage: There is a Facebook account associated with this user");
        self.connectFBButton.titleLabel.text = (@"Disconnect from Facebook");
        
    }
    else if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"updateUserPage: No Facebook account associated with this user");
        self.connectFBButton.titleLabel.text = (@"Connect to Facebook");
    }
    
    self.userLabelNew.text = [[PFUser currentUser] objectForKey:@"name"];
    
    PFFile *userImageFile = [[PFUser currentUser] objectForKey:@"profile_picture"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.profileImageView.image = [UIImage imageWithData:imageData];
            self.blurredProfileImageView.image = [UIImage imageWithData:imageData];
        }
    }];
    
    //self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    //self.profileImageView.clipsToBounds = YES;
    //self.profileImageView.layer.borderWidth = 3.0f;
    //self.profileImageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.profileImageView.borderColor = [UIColor groupTableViewBackgroundColor];
    self.profileImageView.borderWidth = 3.0;
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.blurredProfileImageView.bounds;
    [self.blurredProfileImageView addSubview:visualEffectView];
    
    //avatarView = AvatarView(image: UIImage(named: "avatar")!)
    //avatarView.center = view.center
    //view.addSubview(avatarView)
    
    // User profile fields
    //self.fullNameField.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"name"]];
    //self.userNameField.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"username"]];
    //self.emailAddressField.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"email"]];
    
    [self shouldHideElements:NO];
    
}

-(void) shouldHideElements:(BOOL) hide {
    /*
    if (hide) {
        NSLog(@"shouldHideElements: Hiding elements");
        //self.userLabelNew.hidden = YES;
        [self.userLabelNew setAlpha:0.0f];
        //self.logoutButtonNew.hidden = YES;
        [self.logoutButtonNew setAlpha:0.0f];
        //self.connectFBButton.hidden = YES;
        [self.connectFBButton setAlpha:0.0f];
        //self.fullNameField.hidden = YES;
        [self.fullNameField setAlpha:0.0f];
        //self.userNameField.hidden = YES;
        [self.userNameField setAlpha:0.0f];
        //self.emailAddressField.hidden = YES;
        [self.emailAddressField setAlpha:0.0f];
        //self.profileImageView.hidden = YES;
        [self.profileImageView setAlpha:0.0f];
        //self.blurredProfileImageView.hidden = YES;
        [self.blurredProfileImageView setAlpha:0.0f];
        //[self.userInfoCardView setAlpha:0.0f];
    }
    else if (!hide) {
        NSLog(@"shouldHideElements: Showing elements");
        //fade in
        [UIView animateWithDuration:0.5f animations:^{
            
            //self.userLabelNew.hidden = NO;
            [self.userLabelNew setAlpha:1.0f];
            NSLog(@"shouldHideElements: userlabelnew shown");
            //[self.userInfoCardView setAlpha:1.0f];
            //self.logoutButtonNew.hidden = NO;
            [self.logoutButtonNew setAlpha:1.0f];
            NSLog(@"shouldHideElements: loginbutton shown");
            //self.connectFBButton.hidden = NO;
            [self.connectFBButton setAlpha:1.0f];
            NSLog(@"shouldHideElements: fbbuton shown");
            //self.fullNameField.hidden = NO;
            [self.fullNameField setAlpha:1.0f];
            NSLog(@"shouldHideElements: fullnanmefined shown");
            //self.userNameField.hidden = NO;
            [self.userNameField setAlpha:1.0f];
            NSLog(@"shouldHideElements: usernamefield shown");
            //self.emailAddressField.hidden = NO;
            [self.emailAddressField setAlpha:1.0f];
            NSLog(@"shouldHideElements: emaiuladdressfield shown");
            //self.profileImageView.hidden = NO;
            [self.profileImageView setAlpha:1.0f];
            NSLog(@"shouldHideElements: profileimagevbiew shown");
            //self.blurredProfileImageView.hidden = NO;
            [self.blurredProfileImageView setAlpha:1.0f];
            NSLog(@"shouldHideElements: blurprifileimagedview shown");
            
        } completion:^(BOOL finished) {
            NSLog(@"shouldHideElements: Elements visible");
    
        }];
        
    }
     */
    
}



#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)firstViewController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)firstViewController didLogInUser:(PFUser *)user {
    NSLog(@"logInViewController: User logged in");

    if (([PFFacebookUtils isLinkedWithUser:user]) && ([user isNew])) {
        NSLog(@"logInViewController: User created an account by logging into Facebook");
        
        [self oneTimeFacebookSetup];

    }
    else if ([PFFacebookUtils isLinkedWithUser:user]) {
        NSLog(@"logInViewController: User logged in and has a Facebook account connected");
        [self oneTimeFacebookSetup];
    }
    else {
        NSLog(@"logInViewController: User logged in normally");
        [self updateUserPage];
    }
    

    // Dismiss the loginViewController
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)firstViewController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)firstViewController {
    NSLog(@"User dismissed the logInViewController");
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    // Check user-entered serial number against database for validity
    
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    // Create additional fields in user object
    
    NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"toppipestyleone.png", @"toppipestyletwo.png", @"toppipestylethree.png", @"toppipestylefour.png", @"toppipestylefive.png", nil];
    UIImage *randomUserPicture = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
    //self.profileImageView.image = randomUserPicture;
    //self.blurredProfileImageView.image = randomUserPicture;
    [user addObject:randomUserPicture forKey:@"profile_picture"];

    NSLog(@"signUpViewController: New user successfully created!");
    


    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"signUpViewController: Fields successfully saved to user object");
            [self updateUserPage];
            [self dismissViewControllerAnimated:YES completion:NULL];
        } else {
            NSLog(@"signUpViewController: Error saving user: %@", error);
        }
    }];
    
    
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
