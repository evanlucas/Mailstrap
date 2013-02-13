//
//  MailingListsViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "MailingListsViewController.h"
#import "MGMailingList.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
#import "ISRefreshControl.h"
#import "AppDelegate.h"
#import "MailingListTableCell.h"
#import "EditMailingListViewController.h"
#import "LoadingTableViewDatasource.h"
#import "ProgressTableCell.h"
#import "EmptyTableViewDatasource.h"
#import "BlockAlertView.h"
@interface MailingListsViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@end

@implementation MailingListsViewController
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0]];
    [self.refreshControl addTarget:self action:@selector(doReload) forControlEvents:UIControlEventValueChanged];
    self.tableView.sectionFooterHeight = 0;
    [self useProgressDatasource];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([AppDelegate is_iPhone]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [self loadMailingLists];
}

#pragma mark External UITableViewDatasource/Delegate
- (void)useProgressDatasource {
    [self.tableView setRowHeight:80];
    self.tableView.dataSource = [LoadingTableViewDatasource sharedInstance];
    self.tableView.delegate = [LoadingTableViewDatasource sharedInstance];
    if ([[LoadingTableViewDatasource sharedInstance] rowCount] == 0) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationBottom];
        [[LoadingTableViewDatasource sharedInstance] setRowCount:1];
        [self.tableView endUpdates];
    }
    [self.tableView reloadData];
}
- (void)useOwnDatasource {
    // We only have one cell for sure at this point
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
    if ([cell isKindOfClass:[ProgressTableCell class]]) {
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationTop];
        [[LoadingTableViewDatasource sharedInstance] setRowCount:0];
        [self.tableView endUpdates];
    }
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

#pragma mark Data loading
- (void)loadMailingLists {
    [MGMailingList getMailingListsWithBlock:^(NSArray *lists, NSDictionary *error) {
        if (lists && lists.count != 0) {
            self.datasource = [[NSMutableArray alloc] initWithArray:lists];
        }
        
        if (error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (error[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error loading mailing lists" message:error[@"message"]];
                }
            } else {
                [Alerter showErrorWithTitle:@"Error" message:@"An unknown error has occurred. Please try again."];
            }
        }
        [self useOwnDatasource];
        
        if (!lists || lists.count == 0) {
            [self useEmptyDatasource];
        }
        [self.refreshControl endRefreshing];
        
    }];
}
- (void)doReload {
    [self loadMailingLists];
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGMailingList *list = self.datasource[indexPath.row];
    MailingListTableCell *cell = (MailingListTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"MLTC"];
    if (cell == nil) {
        cell = [[MailingListTableCell alloc] initWithMailingList:list];
    } else {
        [cell setMailingList:list];
    }
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGMailingList *list = self.datasource[indexPath.row];
    CGFloat labelWidth = MODAL_WIDTH - (MODAL_MARGIN * 2);
    return [list cellHeightForWidth:labelWidth];
}

#pragma mark UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.currentIndex = indexPath;
        MGMailingList *currentList = self.datasource[indexPath.row];
        [self deleteMailingList:currentList];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    MGMailingList *selectedList = self.datasource[indexPath.row];
    [self editMailingList:selectedList];
}

#pragma mark Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:EDIT_MAILING_LIST_PUSH]) {
        EditMailingListViewController *vc = (EditMailingListViewController *)segue.destinationViewController;
        vc.mailingList = self.currentMailingList;
    } else if ([segue.identifier isEqualToString:ADD_MAILING_LIST_PUSH]) {
        EditMailingListViewController *vc = (EditMailingListViewController *)segue.destinationViewController;
        vc.addMode = YES;
    }
}

#pragma mark Helper Methods
- (CGFloat)heightForLabelWithText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width {
    CGFloat height = [text textHeightForFontSize:fontSize width:width];
    return (height < 20) ? height + 40 : height;
}
- (void)editMailingList:(MGMailingList *)mailingList {
    self.currentMailingList = mailingList;
    [self performSegueWithIdentifier:EDIT_MAILING_LIST_PUSH sender:self];
}
- (void)deleteMailingList:(MGMailingList *)mailingList {
    self.currentMailingList = mailingList;
    NSString *msg = [NSString stringWithFormat:@"This action cannot be undone.\nAre you sure you want to delete the mailing list named %@?", self.currentMailingList.name];
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Warning!" message:msg];
    [alert addButtonWithTitle:@"Cancel" block:nil];
    [alert setDestructiveButtonWithTitle:@"Delete" block:^{
        [MGMailingList deleteMailingList:self.currentMailingList.name withRes:^(NSDictionary *res){
            [self.tableView beginUpdates];
            [self.datasource removeObject:self.currentMailingList];
            [self.tableView deleteRowsAtIndexPaths:@[self.currentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            if (self.datasource.count == 0) {
                [self useEmptyDatasource];
            }
        }err:^(NSDictionary *err){
            if (err) {
                if ([err isKindOfClass:[NSDictionary class]]) {
                    if (err[@"message"]) {
                        [Alerter showErrorWithTitle:@"Error deleting mailing list" message:err[@"message"]];
                    }
                }
            }
            if (self.datasource.count == 0) {
                [self useEmptyDatasource];
            }
        }];

        
    }];
    [alert show];
}

#pragma mark IBActions
- (IBAction)tappedAddButton:(id)sender {
    [self performSegueWithIdentifier:ADD_MAILING_LIST_PUSH sender:self];
}

- (IBAction)dismissMe:(id)sender {
    [self.mailingListDelegate shouldDismissMailingListViewController];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
