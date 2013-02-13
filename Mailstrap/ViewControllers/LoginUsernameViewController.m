//
//  LoginUsernameViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/12/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "LoginUsernameViewController.h"
#import "LoginTopTableCell.h"
#import "LoginBottomTableCell.h"
#import "LoginSingleTableCell.h"
#import "TopCellBackgroungView.h"
#import "BottomCellBackgroundView.h"
#import "SingleCellBackgroundView.h"
#import "SingleCellSelectedBackgroundView.h"
#import "APIController.h"
@interface LoginUsernameViewController ()

@end

@implementation LoginUsernameViewController


#pragma mark View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 2 : 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LoginTopTableCell *cell = (LoginTopTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"LoginTopTableCell"];
            cell.backgroundView = [[TopCellBackgroungView alloc] initWithFrame:cell.bounds];
            if (self.username) {
                cell.textfield.text = self.username;
            }
            PRINT_RECT(@"Top Table Cell", cell.frame);
            return cell;
        } else {
            LoginBottomTableCell *cell = (LoginBottomTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"LoginBottomTableCell"];
            cell.backgroundView = [[BottomCellBackgroundView alloc] initWithFrame:cell.bounds];
            [cell.textfield setSecureTextEntry:YES];
            if (self.password) {
                cell.textfield.text = self.password;
            }
            return cell;
        }
    } else {
        LoginSingleTableCell *cell = (LoginSingleTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"LoginSingleTableCell"];
        cell.backgroundView = [[SingleCellBackgroundView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[SingleCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LoginTopTableCell *cell = (LoginTopTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.textfield becomeFirstResponder];
        } else {
            LoginBottomTableCell *cell = (LoginBottomTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.textfield becomeFirstResponder];
        }
        return;
    }
    [self deselectRows];
    [self resignTheFirstResponder];
    if (!self.username) {
        [Alerter showErrorWithTitle:@"Error" message:@"Please enter your username"];
        [self deselectRows];
        return;
    }
    if (!self.password) {
        [Alerter showErrorWithTitle:@"Error" message:@"Please enter your password"];
        [self deselectRows];
        return;
    }
    [self.loginDelegate beganLoggingIn];
    [[APIController sharedInstance] loginWithUsername:self.username password:self.password res:^(NSDictionary *res){
        [self.loginDelegate finishedLoginWithResponse:res];
    }err:^(NSDictionary *err){
        [self.loginDelegate finishedLoginWithError:err];
    }];
}
- (void)deselectRows {
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:ip animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // Username tag is 70
    // Password tag is 71
    if (textField.tag == 70) {
        self.username = textField.text;
    }
    if (textField.tag == 71) {
        self.password = textField.text;
    }
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
