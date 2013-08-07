//
//  ViewController.h
//  OctoKitSample
//
//  Created by SOMTD on 2013/08/01.
//  Copyright (c) 2013年 SOMTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLoginKit.h"

@interface ViewController : UIViewController
<SDLoginViewControllerDelelgate,
 SDSignUpViewControllerDelegate,
 SDPasswordResetViewControllerDelegate>

@end
