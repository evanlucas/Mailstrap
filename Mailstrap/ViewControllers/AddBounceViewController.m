//
//  AddBounceViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "AddBounceViewController.h"
#import "MGBounce.h"
#import "MGDomain.h"
@interface AddBounceViewController ()

@end

@implementation AddBounceViewController


#pragma mark View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (IBAction)tappedSaveBtn:(id)sender {
    [self resignTheFirstResponder];
    NSString *address = ([self.textAddress.text isEqualToString:@""]) ? @"" : self.textAddress.text;
    NSString *code = ([self.textCode.text isEqualToString:@""]) ? @"" : self.textCode.text;
    NSString *error = ([self.textError.text isEqualToString:@""]) ? @"" : self.textError.text;
    NSDictionary *params = @{@"address" : address, @"code": code, @"error": error};
    [MGBounce createBounceForDomain:self.currentDomain.name params:params withRes:^(NSDictionary *res){
        log_detail(@"Created Bounce with response: %@", res);
        [self.navigationController popViewControllerAnimated:YES];
    }err:^(NSDictionary *err){
        if (err) {
            if ([err isKindOfClass:[NSDictionary class]]) {
                if (err[@"message"]) {
                    log_detail(@"Error creating bounce: %@", err[@"message"]);
                    [Alerter showErrorWithTitle:@"Error creating bounce" message:err[@"message"]];
                    // Todo show alert with error message
                }
            }
        }
    }];
    
}
@end
