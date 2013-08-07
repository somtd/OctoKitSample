//
//  ViewController.m
//  OctoKitSample
//
//  Created by SOMTD on 2013/08/01.
//  Copyright (c) 2013年 SOMTD. All rights reserved.
//

#import "ViewController.h"
#import "OctoKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Check credential
    BOOL isLogin = NO;
    if (!isLogin) {
        //Add SDLoginKit
        SDLoginViewController *loginViewController = [[SDLoginViewController alloc] init];
        [loginViewController setDelegate:self];
        [loginViewController setLogoImage:[UIImage imageNamed:@"logo"]];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navController animated:YES completion:nil];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SDLoginViewControllerDelegate

- (void)loginViewController:(SDLoginViewController*)loginViewController authenticateWithCredential:(NSURLCredential*)credential{
    
    OCTUser *user = [OCTUser userWithLogin:@"somtd" server:OCTServer.dotComServer];
    //password無し
    OCTClient *client = [OCTClient unauthenticatedClientWithUser:user];

    //password付き
    OCTClient *client = [OCTClient authenticatedClientWithUser:user
                                                      password:@"password"];
    
	[[[client fetchUserRepositories] logAll] subscribeNext:^(id subscribe) {
		dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"info:%@",[subscribe description]);
		});
	}];
    
    //if success
    [loginViewController loginViewControllerDidAuthenticate];
    
    //if failure
    //Pass Error with userInfoDictionary key set to message
    // NSString *message = @"Don't Forget to override authenticateWithCredential";
    //NSDictionary *userInfoDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:message, NSLocalizedRecoverySuggestionErrorKey , nil];
    //[loginViewController loginViewControllerFailedToAuthenticateWithError: [NSError errorWithDomain:@"SDLoginKit" code:nil userInfo:userInfoDictionary]];
    
}

- (void)signUpViewController:(SDSignUpViewController*)signUpViewController signUpWithCredentials:(NSDictionary*)credentials{
    
    //if success
    [signUpViewController signUpViewControllerDidSignUp];
    
    
    //if failure
    //Pass Error with userInfoDictionary key set to message
    // NSString *message = @"Don't Forget to override signUpWithCredentials";
    //NSDictionary *userInfoDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:message, NSLocalizedRecoverySuggestionErrorKey , nil];
    //[loginViewController loginViewControllerFailedToAuthenticateWithError: [NSError errorWithDomain:@"SDLoginKit" code:nil userInfo:userInfoDictionary]];
    
}

- (void)passwordResetViewController:(SDPasswordResetViewController *)passwordResetViewController resetPasswordWithEmail:(NSString *)email{
    
    [passwordResetViewController passwordResetViewControllerDidResetPassword];
    
}

@end
