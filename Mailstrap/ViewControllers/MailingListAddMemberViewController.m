//
//  MailingListAddMemberViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "MailingListAddMemberViewController.h"
#import "MGMLMember.h"
@interface MailingListAddMemberViewController ()

@end

@implementation MailingListAddMemberViewController


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
    [self resignTheFirstResponder];
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
- (void)viewDidUnload {
    [self setTextAddress:nil];
    [self setTextName:nil];
    [self setSwitchSubscribed:nil];
    [self setSwitchUpsert:nil];
    [super viewDidUnload];
}
- (IBAction)tappedSaveButton:(id)sender {
    if ([self.textAddress.text isEqualToString:@""]) {
        [Alerter showErrorWithTitle:@"Error" message:@"Please enter an address"];
        return;
    }
    [self resignTheFirstResponder];
    NSDictionary *params;
    if ([self.textName.text isEqualToString:@""]) {
        params = @{@"address" : self.textAddress.text, @"upsert": [self stringForBOOL:self.switchUpsert.isOn], @"subscribed": [self stringForBOOL:self.switchSubscribed.isOn]};
    } else {
        params = @{@"address" : self.textAddress.text, @"upsert": [self stringForBOOL:self.switchUpsert.isOn], @"subscribed": [self stringForBOOL:self.switchSubscribed.isOn], @"name": self.textName.text};
    }
    [MGMLMember addMemberForListWithAddress:self.listAddress params:params res:^(NSDictionary *res){
        log_detail(@"Res: %@", res);
        [self.navigationController popViewControllerAnimated:YES];
    }err:^(NSDictionary *error){
        if (error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (error[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error adding member" message:error[@"message"]];
                }
            }
        }
    }];
}
- (NSString *)stringForBOOL:(BOOL)theBool {
    return (theBool == YES) ? @"yes" : @"no";
}
@end
