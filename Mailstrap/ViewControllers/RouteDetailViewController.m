//
//  RouteDetailViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "RouteDetailViewController.h"
#import "RouteActionsViewController.h"
@interface RouteDetailViewController ()

@end

@implementation RouteDetailViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isNew) {
        self.textDescription.text = @"";
        self.textExpression.text = @"";
        self.textPriority.text = @"";
        self.routeActions = [NSMutableArray array];
        self.currentRoute = nil;
    } else {
        self.textDescription.text = self.currentRoute.description;
        self.textExpression.text = self.currentRoute.expression;
        self.textPriority.text = [NSString stringWithFormat:@"%@", self.currentRoute.priority];
        self.routeActions = [NSMutableArray arrayWithArray:self.currentRoute.actions];
    }
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    self.keyboardIsShown = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignTheFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Helpers
- (void)keyboardWillHide:(NSNotification *)n {
    //NSDictionary *userInfo = [n userInfo];
    CGRect svFrame = self.view.frame;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setFrame:svFrame];
    }];
    self.keyboardIsShown = NO;
    
}
- (void)keyboardWillShow:(NSNotification *)n {
    if (self.keyboardIsShown) {
        return;
    }
    
    NSDictionary *userInfo = [n userInfo];
    CGSize keyboardSize = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= keyboardSize.height;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setFrame:viewFrame];
    }];
    self.keyboardIsShown = YES;
}
#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_ROUTE_ACTIONS_PUSH]) {
        if (iPad) {
            RouteActionsViewController *vc = (RouteActionsViewController *)segue.destinationViewController;
            if (self.currentRoute) {
                vc.routeActions = [NSMutableArray arrayWithArray:self.currentRoute.actions];
            } else {
                vc.routeActions = self.routeActions;
            }
            
            vc.routeDelegate = self;
        } else {
            UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
            RouteActionsViewController *vc = (RouteActionsViewController *)nav.topViewController;
            if (self.currentRoute) {
                vc.routeActions = [NSMutableArray arrayWithArray:self.currentRoute.actions];
            } else {
                vc.routeActions = self.routeActions;
            }
            
            vc.routeDelegate = self;
        }
    }
}

- (BOOL)validateString:(NSString *)str {
    if ([str isEqualToString:@""] || !str) {
        return NO;
    }
    return YES;
}

- (IBAction)tappedSaveBtn:(id)sender {
    [self resignTheFirstResponder];
    NSString *exp = self.textExpression.text;
    if (![self validateString:exp]) {
        [Alerter showErrorWithTitle:@"Error" message:@"Please enter an expression"];
        return;
    }
    NSString *desc = self.textDescription.text;
    NSString *priority = self.textPriority.text;
    if (![self validateString:priority]) {
        [Alerter showErrorWithTitle:@"Error" message:@"Please enter a priority"];
        return;
    }
    id actions;
    if (self.routeActions.count == 1) {
        actions = self.routeActions[0];
    } else {
        actions = self.routeActions;
    }
    NSDictionary *params;
    if (self.routeActions.count == 0) {
        //params = @{@"expression" : exp, @"description": desc, @"priority": priority};
        [Alerter showErrorWithTitle:@"Error" message:@"Please enter at least one action"];
        return;
    } else {
        params = @{@"expression" : exp, @"action": actions, @"description": desc, @"priority": priority};
    }
    if (self.isNew) {
        [MGRoutes createRouteWithParams:params withRes:^(NSDictionary *res){
            log_detail(@"Update route: %@", res);
            [self.navigationController popViewControllerAnimated:YES];
        }err:^(NSDictionary *err){
            if (err) {
                if ([err isKindOfClass:[NSDictionary class]]) {
                    if (err[@"message"]) {
                        [Alerter showErrorWithTitle:@"Error creating route" message:err[@"message"]];
                    }
                }
            }
        }];
    } else {
        [MGRoutes updateRouteID:self.currentRoute.route_id params:params withRes:^(NSDictionary *res){
            log_detail(@"Create route: %@", res);
            [self.navigationController popViewControllerAnimated:YES];
        }err:^(NSDictionary *err){
            if (err) {
                if ([err isKindOfClass:[NSDictionary class]]) {
                    if (err[@"message"]) {
                        [Alerter showErrorWithTitle:@"Error updating route" message:err[@"message"]];
                    }
                }
            }
        }];
    }
}

#pragma mark - RouteActionsDelegate
- (void)didDismissWithActions:(NSMutableArray *)actions {
    log_detail(@"Dismissed with actions: %@", actions);
    if (!actions || actions.count == 0) {
        self.routeActions = [NSMutableArray array];
    } else {
        self.routeActions = [NSMutableArray arrayWithArray:actions];
    }
    if (!iPad) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}
@end
