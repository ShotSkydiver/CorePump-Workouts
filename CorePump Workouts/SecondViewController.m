//
//  SecondViewController.m
//  Test
//
//  Created by Conner Owen on 5/21/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import "SecondViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "FUIButton.h"
#import "FUISwitch.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"
#import "UIPopoverController+FlatUI.h"
#import "NSString+Icons.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet FUITextField *nameField;
@property (weak, nonatomic) IBOutlet FUITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.emailLabel.font = [UIFont flatFontOfSize:16];
    
    self.nameField.font = [UIFont flatFontOfSize:14];
    self.nameField.backgroundColor = [UIColor cloudsColor];
    self.nameField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.nameField.textFieldColor = [UIColor asbestosColor];
    self.nameField.borderColor = [UIColor midnightBlueColor];
    self.nameField.borderWidth = 3.0f;
    self.nameField.cornerRadius = 3.0f;
    
    self.emailField.font = [UIFont flatFontOfSize:14];
    self.emailField.backgroundColor = [UIColor cloudsColor];
    self.emailField.edgeInsets = UIEdgeInsetsMake(14.0f, 15.0f, 14.0f, 15.0f);
    self.emailField.textFieldColor = [UIColor asbestosColor];
    self.emailField.borderColor = [UIColor midnightBlueColor];
    self.emailField.borderWidth = 3.0f;
    self.emailField.cornerRadius = 2.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
