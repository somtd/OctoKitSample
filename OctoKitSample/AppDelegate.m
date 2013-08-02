//
//  AppDelegate.m
//  OctoKitSample
//
//  Created by SOMTD on 2013/08/01.
//  Copyright (c) 2013年 SOMTD. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "OctoKit.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //Check credential
    BOOL isLogin = NO;
    if (!isLogin) {
        //Add SDLoginKit
        SDLoginViewController *loginViewController = [[SDLoginViewController alloc] init];
        [loginViewController setDelegate:self];
        [loginViewController setLogoImage:[UIImage imageNamed:@"logo"]];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self.viewController presentViewController:navController animated:YES completion:nil];
    }
    
    return YES;
}

#pragma mark - SDLoginViewControllerDelegate

- (void)loginViewController:(SDLoginViewController*)loginViewController authenticateWithCredential:(NSURLCredential*)credential{
    
    OCTUser *user = [OCTUser userWithLogin:@"somtd" server:OCTServer.dotComServer];
	OCTClient *client = [OCTClient unauthenticatedClientWithUser:user];
    
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


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
