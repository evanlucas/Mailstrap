//
//  AddComplaintViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "AddUnsubscribeViewController.h"
#import "MGDomain.h"
#import "MGUnsubscribes.h"

@interface AddUnsubscribeViewController ()

@end

@implementation AddUnsubscribeViewController


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
    NSString *t = ([self.textTag.text isEqualToString:@""]) ? @"*" : self.textTag.text;
    if (![self.textAddress.text isEqualToString:@""]) {
        [MGUnsubscribes addUnsubscribeToDomain:self.currentDomain.name params:@{@"address" : self.textAddress.text, @"tag": t} withRes:^(NSDictionary *res){
            [self.navigationController popViewControllerAnimated:YES];
        }err:^(NSDictionary *err){
            if (err) {
                if ([err isKindOfClass:[NSDictionary class]]) {
                    if (err[@"message"]) {
                        log_detail(@"Error Message: %@", err[@"message"]);
                        [Alerter showErrorWithTitle:@"Error adding unsubscribe" message:err[@"message"]];
                    }
                }
            }
        }];
    } else {
        [Alerter showErrorWithTitle:@"Error" message:@"Sorry, but we can't add a blank address or a blank tag."];
    }
}

@end
