//
//  AddMailboxViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "AddMailboxViewController.h"
#import "LargeTextField.h"
#import "MGMailbox.h"
#import "MGDomain.h"
@interface AddMailboxViewController ()

@end

@implementation AddMailboxViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.editMode == YES) {
        self.textMailbox.text = self.currentMailbox.mailbox;
        self.textMailbox.enabled = NO;
        self.title = @"Edit Mailbox";
    } else {
        self.textMailbox.enabled = YES;
        self.title = @"Add Mailbox";
    }
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignTheFirstResponder];
}
#pragma mark - IBActions
- (IBAction)tappedSave:(id)sender {
    [self resignTheFirstResponder];
    if (![self.textMailbox.text isEqualToString:@""] && ![self.textPassword.text isEqualToString:@""]) {
        [self.textMailbox resignFirstResponder];
        [self.textPassword resignFirstResponder];
        if (self.editMode) {
            if (self.currentDomain) {
                [MGMailbox updateMailbox:self.currentMailbox.mailbox forDomain:self.currentDomain.name params:@{@"password" : self.textPassword.text} withRes:^(NSDictionary *res){
                    NSLog(@"Response: %@", res);
                    [self.navigationController popViewControllerAnimated:YES];
                }err:^(NSDictionary *err){
                    if (err) {
                        if ([err isKindOfClass:[NSDictionary class]]) {
                            if (err[@"message"]) {
                                NSLog(@"Error Message: %@", err[@"message"]);
                                [Alerter showErrorWithTitle:@"Error updating mailbox" message:err[@"message"]];
                                // Todo show alert with error message
                            }
                        }
                    }
                }];
            }
        } else {
        if (self.currentDomain) {
            NSDictionary *data = @{@"mailbox" : self.textMailbox.text, @"password": self.textPassword.text};
            [MGMailbox createMailboxForDomain:self.currentDomain.name params:data withRes:^(NSDictionary *res){
                log_detail(@"Response: %@", res);
                [self.navigationController popViewControllerAnimated:YES];
            }err:^(NSDictionary *err){
                NSLog(@"Error: %@", err);
                if (err) {
                    if ([err isKindOfClass:[NSDictionary class]]) {
                        if (err[@"message"]) {
                            NSLog(@"Error Message: %@", err[@"message"]);
                            [Alerter showErrorWithTitle:@"Error creating mailbox" message:err[@"message"]];
                            // Todo show alert with error message
                        }
                    }
                }
            }];
        }
        }
    } else {
        [Alerter showErrorWithTitle:@"Error" message:@"Please make sure that both the username and password fields are filled."];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
