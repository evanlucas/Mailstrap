//
//  AddDomainViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "AddDomainViewController.h"
#import "LargeTextField.h"
#import "MGDomain.h"
#import "AppDelegate.h"
@interface AddDomainViewController ()

@end

@implementation AddDomainViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)tappedSaveButton:(id)sender {
    [self resignTheFirstResponder];
    if (![self.textDomain.text isEqualToString:@""]) {
        [self.textDomain resignFirstResponder];
        [MGDomain createDomain:self.textDomain.text withRes:^(NSDictionary *res){
            log_detail(@"Response: %@", res);
            [self.navigationController popViewControllerAnimated:YES];
        }err:^(NSDictionary *error){
            if (error) {
                if ([error isKindOfClass:[NSDictionary class]]) {
                    if (error[@"message"]) {
                        [Alerter showErrorWithTitle:@"Error creating domain" message:error[@"message"]];
                    }
                }
            }
        }];
    } else {
        [Alerter showErrorWithTitle:@"Error" message:@"Please enter a domain name"];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
