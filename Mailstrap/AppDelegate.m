//
//  AppDelegate.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/19/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "AppDelegate.h"
#import "APIController.h"
#import <TargetConditionals.h>
#import "BlockAlertView.h"
@implementation AppDelegate
#pragma mark - Helpers
+ (UIInterfaceOrientation)orientation {
    return [[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] interfaceOrientation];
}
+ (BOOL)is_iOS6 {
    return ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] == 6);
}
+ (BOOL)is_iOS7 {
  return ([[[[UIDevice currentDevice] systemName] componentsSeparatedByString:@"."][0] intValue] == 7);
}
+ (BOOL)is_iPhone {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}
- (UIImage *)segControlSelected {
    UIGraphicsBeginImageContext(CGSizeMake(93, 30));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *mscolor = [UIColor colorWithRed:6.0/255.0 green:101.0/255.0 blue:139.0/255.0 alpha:1.0];
    CGContextSetFillColorWithColor(ctx, mscolor.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, 93, 30));
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}
- (UIImage *)segControlHighlighted {
    UIGraphicsBeginImageContext(CGSizeMake(93, 30));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *mscolor = [UIColor colorWithRed:6.0/255.0 green:101.0/255.0 blue:179.0/255.0 alpha:1.0];
    CGContextSetFillColorWithColor(ctx, mscolor.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, 93, 30));
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}
- (UIImage *)segControlUnselected {
    UIGraphicsBeginImageContext(CGSizeMake(93, 30));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *mscolor = [UIColor colorWithRed:6.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:1.0];
    CGContextSetFillColorWithColor(ctx, mscolor.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, 93, 30));
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}
#pragma mark - Application Lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIColor *mscolor = [UIColor colorWithRed:6.0/255.0 green:101.0/255.0 blue:149.0/255.0 alpha:1.0];
    [[UINavigationBar appearance] setTintColor:mscolor];
//    [[APIController sharedInstance] login];
    
#ifdef TARGET_IPHONE_SIMULATOR
    
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeAlert)];
#endif
    /*
    [[UISwitch appearance] setThumbTintColor:[UIColor colorWithWhite:0.05 alpha:1.0]];
    [[UISwitch appearance] setOnTintColor:[UIColor colorWithWhite:0.18 alpha:0.8]];
    [[UISwitch appearance] setTintColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    */
    [[APIController sharedInstance] checkFirstRun];
    
    return YES;
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    log_detail(@"Failed to get token: %@", error);
    [Alerter showErrorWithTitle:@"Error" message:@"There was an error connecting to the push server."];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    log_detail(@"Token: %@", deviceToken);
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[APIController sharedInstance] sendToken:newToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    log_detail(@"Received note: %@", userInfo);
    [Alerter showErrorWithTitle:userInfo[@"title"] message:userInfo[@"aps"][@"alert"]];
    
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
