//
//  CustomParseLoginViewController.h
//  CorePump Workouts
//
//  Created by Conner Owen on 6/9/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewDelegate <NSObject>

- (void)successfulLogin;

@end

@interface CustomParseLoginViewController : UIViewController

@property (weak, nonatomic) id<ModalViewDelegate> dismissDelegate;

@end


