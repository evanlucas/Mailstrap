//
//  AddComplaintViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "AddComplaintViewController.h"
#import "MGDomain.h"
#import "MGComplaints.h"

@interface AddComplaintViewController ()

@end

@implementation AddComplaintViewController


#pragma mark - View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignTheFirstResponder];
}
#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - IBActions
- (IBAction)tappedSaveBtn:(id)sender {
    [self resignTheFirstResponder];
    if (![self.textAddress.text isEqualToString:@""]) {
        [MGComplaints addComplaintForAddress:self.textAddress.text forDomain:self.currentDomain.name withRes:^(NSDictionary *res){
            [self.navigationController popViewControllerAnimated:YES];
        }withErr:^(NSDictionary *err){
            log_detail(@"Error: %@", err);
            if (err) {
                if ([err isKindOfClass:[NSDictionary class]]) {
                    if (err[@"message"]) {
                        log_detail(@"Error Message: %@", err[@"message"]);
                        [Alerter showErrorWithTitle:@"Error adding complaint" message:err[@"message"]];
                        // Todo show alert with error message
                    }
                }
            }

        }];
    } else {
        [Alerter showErrorWithTitle:@"Error" message:@"Sorry, but we can't add a blank address."];
    }
}

@end
