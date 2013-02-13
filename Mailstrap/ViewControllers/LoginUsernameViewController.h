//
//  LoginUsernameViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/12/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
#import "LargeTextField.h"
@protocol LoginUsernameDelegate
- (void)finishedLoginWithResponse:(NSDictionary *)response;
- (void)finishedLoginWithError:(NSDictionary *)error;
- (void)beganLoggingIn;
@end
@interface LoginUsernameViewController : ModalTableViewController <UITextFieldDelegate>
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) id<LoginUsernameDelegate> loginDelegate;
@end
