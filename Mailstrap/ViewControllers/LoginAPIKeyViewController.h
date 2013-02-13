//
//  LoginAPIKeyViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/12/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
#import "LargeTextField.h"
@protocol LoginAPIDelegate <NSObject>
- (void)finishedLoginWithResponseAPI:(NSDictionary *)response;
- (void)finishedLoginWithErrorAPI:(NSDictionary *)error;
- (void)beganLoggingInAPI;
@end
@interface LoginAPIKeyViewController : ModalTableViewController <UITextFieldDelegate>
@property (nonatomic, assign) id<LoginAPIDelegate> loginDelegate;
@property (nonatomic, strong) NSString *apikey;
@end
