//
//  AppDelegate.h
//  OctoKitSample
//
//  Created by SOMTD on 2013/08/01.
//  Copyright (c) 2013年 SOMTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLoginKit.h"

@class ViewController;

@interface AppDelegate : UIResponder
<UIApplicationDelegate,
 SDLoginViewControllerDelelgate,
 SDSignUpViewControllerDelegate,
 SDPasswordResetViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
