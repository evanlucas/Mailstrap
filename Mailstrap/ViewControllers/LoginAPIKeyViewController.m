//
//  LoginAPIKeyViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/12/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "LoginAPIKeyViewController.h"
#import "LoginSingleTableCell.h"
#import "SingleCellBackgroundView.h"
#import "SingleCellSelectedBackgroundView.h"
#import "LoginBottomTableCell.h"
#import "SingleTableCell.h"
#import "APIController.h"
@implementation LoginAPIKeyViewController


#pragma mark View lifecycla
- (void)viewDidLoad {
  [super viewDidLoad];
  //self.view.opaque = NO;
  //self.view.backgroundColor = [UIColor clearColor];
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
  return 1;
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
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    SingleTableCell *cell = (SingleTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"SingleTableCell"];
    cell.backgroundView = [[SingleCellBackgroundView alloc] initWithFrame:cell.bounds];
    [cell.textfield setSecureTextEntry:NO];
    if (self.apikey) {
      cell.textfield.text = self.apikey;
    }
    return cell;
  } else {
    LoginSingleTableCell *cell = (LoginSingleTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"LoginSingleTableCell"];
    cell.backgroundView = [[SingleCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView = [[SingleCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
    return cell;
  }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    SingleTableCell *cell = (SingleTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textfield becomeFirstResponder];
    
    return;
  }
  [self deselectRows];
  [self resignTheFirstResponder];
  if (!self.apikey) {
    [Alerter showErrorWithTitle:@"Error" message:@"Please enter your API Key"];
    [self deselectRows];
    return;
  }
  [self.loginDelegate beganLoggingInAPI];
  [[APIController sharedInstance] loginWithAPIKey:self.apikey res:^(NSDictionary *res){
    [self.loginDelegate finishedLoginWithResponseAPI:res];
  }err:^(NSDictionary *err){
    [self.loginDelegate finishedLoginWithErrorAPI:err];
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
  if (textField.tag == 72) {
    self.apikey = textField.text;
  }
  [textField resignFirstResponder];
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

@end
