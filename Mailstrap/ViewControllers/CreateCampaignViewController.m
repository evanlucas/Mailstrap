//
//  CreateCampaignViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "CreateCampaignViewController.h"
#import "MGCampaign.h"
#import "MGDomain.h"
@interface CreateCampaignViewController ()

@end

@implementation CreateCampaignViewController


#pragma mark View lifecycla
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
}
#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
- (IBAction)tappedSaveButton:(id)sender {
    if ([self.textName.text isEqualToString:@""]) {
        [Alerter showErrorWithTitle:@"Error" message:@"A campaign must have a name"];
        return;
    }
    NSDictionary *params;
    if (![self.textCampaignID.text isEqualToString:@""]) {
        params = @{@"name" : self.textName.text, @"id": self.textCampaignID.text};
    } else {
        params = @{@"name" : self.textName.text};
    }

    [MGCampaign createCampaignForDomain:self.currentDomain.name params:params withRes:^(NSDictionary *res){
        log_detail(@"Created Campaign with response: %@", res);
        [self.navigationController popViewControllerAnimated:YES];
    }err:^(NSDictionary *err){
        if (err) {
            if ([err isKindOfClass:[NSDictionary class]]) {
                if (err[@"message"]) {
                    log_detail(@"Error creating campaign: %@", err[@"message"]);
                    [Alerter showErrorWithTitle:@"Error creating campaign" message:err[@"message"]];
                    // Todo show alert with error message
                }
            }
        }
    }];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
