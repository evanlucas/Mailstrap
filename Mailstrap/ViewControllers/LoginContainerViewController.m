//
//  LoginContainerViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/12/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "LoginContainerViewController.h"
#import "APIController.h"
@implementation LoginContainerViewController


#pragma mark View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginUsernameViewController = [self.storyboard instantiateViewControllerWithIdentifier:STORYBOARD_LOGIN_USERNAME];
    self.loginUsernameViewController.loginDelegate = self;
    self.loginUsernameViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.loginUsernameViewController.view];
    [self addChildViewController:self.loginUsernameViewController];
    [self.loginUsernameViewController didMoveToParentViewController:self];
    
    self.loginAPIViewController = [self.storyboard instantiateViewControllerWithIdentifier:STORYBOARD_LOGIN_API];
    [self.loginAPIViewController setLoginDelegate:self];
    self.loginAPIViewController.view.frame = self.containerView.bounds;
    [self addChildViewController:self.loginAPIViewController];
    [self.loginAPIViewController didMoveToParentViewController:self];
    CGFloat height = 44;
    CGFloat font = 15.0f;
    if (!iPad) {
        height = 30;
        font = 12.0f;
    }
    
    [self.segControlLoginType setBackgroundImage:[ImageUtil imageWithColor:[UIColor mailstrapBlueColor] size:CGSizeMake(100, height)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segControlLoginType setBackgroundImage:[ImageUtil imageWithColor:[UIColor mailstrapDarkBlueColor] size:CGSizeMake(100, height)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.segControlLoginType setBackgroundImage:[ImageUtil imageWithColor:[UIColor mailstrapDarkBlueColor] size:CGSizeMake(100, height)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self.segControlLoginType setDividerImage:[ImageUtil imageWithColor:[UIColor mailstrapDarkBlueColor] size:CGSizeMake(2, height)] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segControlLoginType setDividerImage:[ImageUtil imageWithColor:[UIColor mailstrapBlueColor] size:CGSizeMake(2, height)] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.segControlLoginType setDividerImage:[ImageUtil imageWithColor:[UIColor mailstrapDarkBlueColor] size:CGSizeMake(2, height)] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segControlLoginType setDividerImage:[ImageUtil imageWithColor:[UIColor mailstrapBlueColor] size:CGSizeMake(2, height)] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segControlLoginType setDividerImage:[ImageUtil imageWithColor:[UIColor mailstrapBlueColor] size:CGSizeMake(2, height)] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.segControlLoginType setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeFont: [UIFont boldSystemFontOfSize:font]} forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)changedLoginType:(id)sender {
    if (self.currentLoginType == CurrentLoginTypeAPIKey) {
        self.currentLoginType = CurrentLoginTypeUsername;
    } else {
        self.currentLoginType = CurrentLoginTypeAPIKey;
    }
    [self showLoginForType:self.currentLoginType];
}

- (void)dismissThis {
    if ([self.loginDelegate respondsToSelector:@selector(shouldDismissLogin)]) {
        [self.loginDelegate shouldDismissLogin];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)tappedDoneButton:(id)sender {
    [self dismissThis];
}

- (void)showLoginForType:(CurrentLoginType)loginType {
    if (self.currentLoginType == CurrentLoginTypeAPIKey) {
        // From VC is loginUsernameViewController
        // To VC is loginAPIKeyViewController
        if (!self.loginAPIViewController) {
            self.loginAPIViewController = [self.storyboard instantiateViewControllerWithIdentifier:STORYBOARD_LOGIN_API];
            self.loginAPIViewController.loginDelegate = self;
            
        }
        [self transitionFromViewController:self.loginUsernameViewController toViewController:self.loginAPIViewController duration:0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            [self.loginAPIViewController.view setFrame:self.containerView.bounds];
        }completion:^(BOOL finished){
            if (finished) {
                [self.loginAPIViewController.view setFrame:self.containerView.bounds];
                [self addChildViewController:self.loginAPIViewController];
                [self.loginAPIViewController didMoveToParentViewController:self];
            }
        }];
    } else {
        // From VC is loginAPIKeyViewController
        // To VC is loginUsernameViewController
        if (!self.loginUsernameViewController) {
            self.loginUsernameViewController = [self.storyboard instantiateViewControllerWithIdentifier:STORYBOARD_LOGIN_USERNAME];
            self.loginUsernameViewController.loginDelegate = self;
        }
        [self transitionFromViewController:self.loginAPIViewController toViewController:self.loginUsernameViewController duration:0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            
        }completion:^(BOOL finished){
            if (finished) {
                [self addChildViewController:self.loginUsernameViewController];
                [self.loginUsernameViewController didMoveToParentViewController:self];
            }
        }];
    }
}

- (void)showProgressView {
    CGFloat width = 280;
    CGFloat height = 20;
    if (iPad) {
        width = 400;
    }
    CGRect finalFrame = CGRectMake((self.view.frame.size.width - width)/2, 5, width, height);
    CGRect initialFrame = CGRectMake((self.view.frame.size.width - width)/2, -40, width, height);
    self.progressView = [[IndeterminateProgressView alloc] initWithFrame:initialFrame];
    [self.progressView setBorderRadius:height/2];
    [self.progressView startProgressing];
    [self.view addSubview:self.progressView];
    [UIView animateWithDuration:0.5 animations:^{
        [self.progressView setFrame:finalFrame];
    }];
}

- (void)hideProgressView {
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat width = 280;
        CGFloat height = 20;
        if (iPad) {
            width = 400;
        }
        CGRect initialFrame = CGRectMake((self.view.frame.size.width - width)/2, -40, width, height);
        [self.progressView setFrame:initialFrame];
    } completion:^(BOOL finished){
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }];
}
#pragma mark - LoginUsernameDelegate
- (void)finishedLoginWithError:(NSDictionary *)error {
    log_detail(@"Finished with error: %@", error);
    [self hideProgressView];
    [self.labelError setText:@"Error logging in. Please try again."];
    [self.labelError setTextColor:[UIColor redColor]];
}

- (void)finishedLoginWithResponse:(NSDictionary *)response {
    log_detail(@"Finished with response: %@", response);
    [self hideProgressView];
    [self.labelError setText:@"Login Successful"];
    [self.labelError setTextColor:[UIColor whiteColor]];
    if (response[@"key"] && ![response[@"key"] isEqualToString:@""]) {
        [[APIController sharedInstance] setApiKey:response[@"key"]];
        [self performSelector:@selector(dismissThis) withObject:nil afterDelay:0.3];
    }
    
}
#pragma mark - LoginAPIDelegate
- (void)finishedLoginWithErrorAPI:(NSDictionary *)error {
    log_detail(@"Finished with error: %@", error);
    [self hideProgressView];
    [self.labelError setText:@"Error logging in. Please try again."];
    [self.labelError setTextColor:[UIColor redColor]];
}

- (void)finishedLoginWithResponseAPI:(NSDictionary *)response {
    [self hideProgressView];
    [self.labelError setText:@"Login Successful"];
    [self.labelError setTextColor:[UIColor whiteColor]];
    if (response[@"key"] && ![response[@"key"] isEqualToString:@""]) {
        [[APIController sharedInstance] setApiKey:response[@"key"]];
        [self performSelector:@selector(dismissThis) withObject:nil afterDelay:0.3];
    }
}
- (void)beganLoggingIn {
    log_detail(@"Began logging in");
    [self showProgressView];
    [self.labelError setText:@""];
    [self.labelError setTextColor:[UIColor whiteColor]];
}
- (void)beganLoggingInAPI {
    log_detail(@"Began logging in API");
    [self showProgressView];
    [self.labelError setText:@""];
    [self.labelError setTextColor:[UIColor whiteColor]];
}
@end
