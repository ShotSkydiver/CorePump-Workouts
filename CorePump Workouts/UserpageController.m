//
//  UserpageController.m
//  CorePump Workouts
//
//  Created by Conner Owen on 6/18/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import "UserpageController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <APAvatarImageView/APAvatarImageView.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <FBSDKCoreKit/FBSDKProfile.h>
#import "ViewController.h"
#import <KVNProgress/KVNProgress.h>
#import <AYVibrantButton/AYVibrantButton.h>

@interface UserpageController ()

@property (strong, nonatomic) IBOutlet UIImageView *blurredProfilePictureView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *userpageVisualEffectView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet APAvatarImageView *userAvatarImageView;
@property (nonatomic, strong) AYVibrantButton *vibrantLogoutButton;
@property (nonatomic, strong) AYVibrantButton *vibrantFBConnectButton;
@property (assign) BOOL hasViewAppeared;

@end

@implementation UserpageController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"UserpageController viewDidLoad");
    
    self.hasViewAppeared = NO;
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    self.vibrantLogoutButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(20, ((self.view.frame.size.height)-150), ((self.view.frame.size.width/2)-25), 33) style:AYVibrantButtonStyleInvert];
    self.vibrantLogoutButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.vibrantLogoutButton.text = @"Log Out";
    self.vibrantLogoutButton.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    [self.vibrantLogoutButton addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.vibrantFBConnectButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(((self.view.frame.size.width/2)+10), ((self.view.frame.size.height)-150), ((self.view.frame.size.width/2)-25), 33) style:AYVibrantButtonStyleInvert];
    self.vibrantFBConnectButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.vibrantFBConnectButton.text = @"Connect to Facebook";
    self.vibrantFBConnectButton.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:18.0];
    [self.vibrantFBConnectButton addTarget:self action:@selector(facebookConnectClick:) forControlEvents:UIControlEventTouchUpInside];


    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"UserpageController viewDidLoad: There is a Facebook account associated with this user");
        
    }
    else if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"UserpageController viewDidLoad: There is not a Facebook account associated with this user");
        
    }
}

-(void)facebookSetup {
    NSLog(@"UserpageController facebookSetup: setting up");
    [KVNProgress showWithStatus:@"Linking..."];
    
    // Make FB Graph request
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSString *facebookID = userData[@"id"];
            
            // Get user profile picture
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?height=350&width=350&return_ssl_resources=1", facebookID]];
            [[PFUser currentUser] setObject:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?height=350&width=350&return_ssl_resources=1", facebookID] forKey:@"FBProfilePicURL"];
            
            NSData *data = [NSData dataWithContentsOfURL:pictureURL];
            self.userAvatarImageView.image = [UIImage imageWithData:data];
            self.blurredProfilePictureView.image = [UIImage imageWithData:data];
            NSLog(@"facebookSetup: raw image dimensions: %f x %f", [UIImage imageWithData:data].size.width, [UIImage imageWithData:data].size.height);
            NSLog(@"facebookSetup: image dimensions: %f x %f", self.userAvatarImageView.image.size.width, self.userAvatarImageView.image.size.height);
            NSLog(@"facebookSetup: image frame dimensions: %f x %f", self.userAvatarImageView.frame.size.width, self.userAvatarImageView.frame.size.height);
            
            [[PFUser currentUser] saveEventually];
            self.vibrantFBConnectButton.text = @"Disconnect from Facebook";
            [KVNProgress showSuccessWithStatus:@"Facebook account linked!"];
            
        } else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"oneTimeFacebookSetup: The facebook session was invalidated");
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
        } else {
            NSLog(@"oneTimeFacebookSetup: Some other error: %@", error);
        }
        
    }];
}

-(void)setupPage {
    if (self.hasViewAppeared == NO) {
        NSLog(@"UserpageController setupPage: view appearing for first time");
        NSLog(@"user details: name: %@ email: %@", [[PFUser currentUser] objectForKey:@"name"], [[PFUser currentUser] objectForKey:@"username"]);
        [self.userpageVisualEffectView.contentView addSubview:self.vibrantLogoutButton];
        [self.userpageVisualEffectView.contentView addSubview:self.vibrantFBConnectButton];
        
        
        if (([[PFUser currentUser] objectForKey:@"FBProfilePicURL"] == nil) || (([NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"FBProfilePicURL"]]).length == 0)) {
            NSLog(@"No facebook profile pic found");
            PFFile *userImageFile = [[PFUser currentUser] objectForKey:@"profile_picture"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    self.userAvatarImageView.image = [UIImage imageWithData:imageData];
                    self.blurredProfilePictureView.image = [UIImage imageWithData:imageData];
                }
            }];
        }
        else {
            NSLog(@"Facebook profile pic found");
            NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"FBProfilePicURL"]];
            NSData *data = [NSData dataWithContentsOfURL:pictureURL];
            self.userAvatarImageView.image = [UIImage imageWithData:data];
            self.blurredProfilePictureView.image = [UIImage imageWithData:data];
        }
        
        self.userAvatarImageView.borderColor = [UIColor whiteColor];
        self.userAvatarImageView.borderWidth = 3.0;
        self.userAvatarImageView.layer.cornerRadius = self.userAvatarImageView.frame.size.width / 2;
        self.userAvatarImageView.clipsToBounds = YES;
        
        //self.fullNameField.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"name"]];
        //self.userNameField.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"username"]];
        //self.emailAddressField.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"email"]];
        self.userNameLabel.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"name"]];
        
        if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            NSLog(@"UserpageController: There is a Facebook account associated with this user");
            self.vibrantFBConnectButton.text = @"Disconnect from Facebook";
        }
        else if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            NSLog(@"UserpageController: There is not a Facebook account associated with this user");
            self.vibrantFBConnectButton.text = @"Connect to Facebook";
        }
        
        self.hasViewAppeared = YES;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"UserpageController viewWillAppear");
    [self setupPage];
    
}


-(void)logoutClick:(AYVibrantButton *)button{
    NSLog(@"UserpageController logoutClick");
    
    [KVNProgress showWithStatus:@"Logging out..."];
    
    [PFUser logOut];
    ViewController* viewController = (ViewController*)self.parentViewController;
    
    [viewController removeUserpageTab];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KVNProgress showSuccessWithStatus:@"Logged out!"];
    });
}

-(void)facebookConnectClick:(AYVibrantButton *)button{
    NSLog(@"UserpageController facebookConnectClick");
    
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        NSLog(@"facebookConnectClick: Connecting user account to Facebook account");
        [PFFacebookUtils linkUserInBackground:[PFUser currentUser] withReadPermissions:@[@"public_profile", @"email"] block:^(BOOL succeeded, NSError *error) {
            //[KVNProgress showWithStatus:@"Linking..."];
            if (succeeded) {
                [self facebookSetup];
                NSLog(@"facebookConnectClick: Woohoo, user is linked with Facebook!");
            }
            else if (!succeeded) {
                [KVNProgress showErrorWithStatus:[NSString stringWithFormat:@"%@", error]];
            }
        }];
    }
    else if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        NSLog(@"facebookConnectClick: Disconnecting Facebook account from user account");
        [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/permissions"
                                                   parameters:nil
                                                   HTTPMethod:@"DELETE"]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         [KVNProgress showWithStatus:@"Unlinking..."];
                         [[PFUser currentUser] setObject:@"" forKey:@"FBProfilePicURL"];
                         self.vibrantFBConnectButton.text = @"Connect to Facebook";
                         
                         [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                             PFFile *userImageFile = [[PFUser currentUser] objectForKey:@"profile_picture"];
                             [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                                 if (!error) {
                                     self.userAvatarImageView.image = [UIImage imageWithData:imageData];
                                     self.blurredProfilePictureView.image = [UIImage imageWithData:imageData];
                                     
                                     [KVNProgress showSuccessWithStatus:@"Facebook account unlinked!"];
                                 }
                             }];
                             
                             
                         }];
                         
                         NSLog(@"facebookConnectClick: The user is no longer associated with their Facebook account.");
                         
                     }
                     else{
                         NSLog(@"%@", [error localizedDescription]);
                         [KVNProgress showErrorWithStatus:[NSString stringWithFormat:@"%@", error]];
                     }
                 }];
            }
        }];
    }
}


@end
