//
//  Alerter.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Alerter : NSObject
+ (void)showErrorWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showForbiddenError;
+ (void)showNotConnectedError;
@end
