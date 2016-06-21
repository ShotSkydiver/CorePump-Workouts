//
//  AppDelegate.h
//  CorePump Workouts
//
//  Created by Conner Owen on 5/20/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUserContainer.h"

@class CustomUserContainer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) CustomUserContainer *userContainer;

@end

