//
//  RouteActionsViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "RouteActionsViewController.h"
#import "BlockTextPromptAlertView.h"
#import "AppDelegate.h"
#import "LargeTextField.h"
#import "EmptyTableViewDatasource.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
@implementation RouteActionsViewController

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
    [self.routeDelegate didDismissWithActions:self.routeActions];
}

#pragma mark - External UITableViewDatasource/Delegate
- (void)useOwnDatasource {
    // We only have one cell for sure at this point
    [self.tableView setRowHeight:44];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}
- (void)useEmptyDatasource {
    [self.tableView setRowHeight:65.0f];
    self.tableView.dataSource = [EmptyTableViewDatasource sharedInstance];
    self.tableView.delegate = [EmptyTableViewDatasource sharedInstance];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationBottom];
    [[EmptyTableViewDatasource sharedInstance] setRowCount:1];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDatasource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.routeActions.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RouteActionTableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RouteActionTableCell"];
    }
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
    cell.textLabel.text = self.routeActions[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *action = self.routeActions[indexPath.row];
    self.currentIndex = indexPath;
    [self showEditAlertWithText:action];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.routeActions removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - IBActions
- (IBAction)tappedAddButton:(id)sender {
    [self showNewAlert];
}
- (IBAction)tappedDoneButton:(id)sender {
    [self.routeDelegate didDismissWithActions:self.routeActions];
}
- (void)showEditAlertWithText:(NSString *)text {
    __block LargeTextField *theTextfield;
    __block BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"Edit Action" message:@"Edit the action below." defaultText:text block:^(BlockTextPromptAlertView *a) {
        theTextfield = (LargeTextField *)a.textField;
        [a.textField resignFirstResponder];
        return YES;
    }];
    [alert addButtonWithTitle:@"Save" block:^{
        if (![alert.textField.text isEqualToString:@""]) {
            NSString *t = alert.textField.text;
            [self.routeActions replaceObjectAtIndex:self.currentIndex.row withObject:t];
            [self.tableView reloadRowsAtIndexPaths:@[self.currentIndex] withRowAnimation:UITableViewRowAnimationRight];
            [self deselectSelectedRow];
        }

    }];
    
    [alert setCancelButtonWithTitle:@"Cancel" block:^{
        [self deselectSelectedRow];
    }];
    
    [alert show];
}
- (void)showNewAlert {
    LargeTextField *theTextfield;
    __block BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"New Action" message:@"Enter a new action below." textField:&theTextfield block:^(BlockTextPromptAlertView *a){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert addButtonWithTitle:@"Save" block:^{
        if (![alert.textField.text isEqualToString:@""]) {
            [self addAction:alert.textField.text];
        }
    }];
    
    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
    
    [alert show];
}

- (void)addAction:(NSString *)action {
    [self.tableView beginUpdates];
    [self.routeActions addObject:action];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:self.routeActions.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
}

- (void)deselectSelectedRow {
    [self.tableView deselectRowAtIndexPath:self.currentIndex animated:YES];
}
@end
