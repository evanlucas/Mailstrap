//
//  AppDelegate.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/19/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (UIInterfaceOrientation)orientation;
+ (BOOL)is_iOS6;
+ (BOOL)is_iPhone;

@end
