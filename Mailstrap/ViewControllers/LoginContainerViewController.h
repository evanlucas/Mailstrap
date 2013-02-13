//
//  LoginContainerViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/12/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginUsernameViewController.h"
#import "LoginAPIKeyViewController.h"
#import "IndeterminateProgressView.h"
typedef enum CurrentLoginType {
    CurrentLoginTypeUsername = 0,
    CurrentLoginTypeAPIKey
}CurrentLoginType;

@protocol LoginDelegate <NSObject>
@optional
- (void)shouldDismissLogin;
@end
@interface LoginContainerViewController : UIViewController <LoginUsernameDelegate, LoginAPIDelegate>
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControlLoginType;
@property (nonatomic, strong) LoginAPIKeyViewController *loginAPIViewController;
@property (nonatomic, strong) LoginUsernameViewController *loginUsernameViewController;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) CurrentLoginType currentLoginType;
@property (nonatomic, strong) IndeterminateProgressView *progressView;
- (IBAction)changedLoginType:(id)sender;
- (IBAction)tappedDoneButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelError;
@property (nonatomic, assign) id<LoginDelegate> loginDelegate;

@end
