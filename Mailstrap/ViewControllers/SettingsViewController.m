//
//  SettingsViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "SettingsViewController.h"
#import "APIController.h"
#import "AppDelegate.h"
#import "BlockAlertView.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[APIController sharedInstance] apiKey]) {
        [self.textAPIKey setText:[[APIController sharedInstance] apiKey]];
    }
    [self.switchShowPostmaster setOn:[[APIController sharedInstance] shouldShowPostmaster]];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)tappedSaveAction:(id)sender {
    [[APIController sharedInstance] setApiKey:self.textAPIKey.text];
    [self.textAPIKey resignFirstResponder];
    
    [[APIController sharedInstance] setShouldShowPostmaster:self.switchShowPostmaster.isOn];

    [self.delegate dismissSettings];
    if ([AppDelegate is_iPhone]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)dismissMe:(id)sender {
    [self.delegate dismissSettings];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)tappedLogout:(id)sender {
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Warning" message:@"Are you sure you want to log out?"];
    [alert setDestructiveButtonWithTitle:@"Logout" block:^{
        self.textAPIKey.text = @"";
        [[APIController sharedInstance] setApiKey:@""];
        [self.delegate dismissSettings];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addButtonWithTitle:@"No, stay logged in" block:nil];
    [alert show];
}
@end
