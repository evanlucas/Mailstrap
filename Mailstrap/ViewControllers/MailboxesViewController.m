//
//  MailboxesViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/23/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "MailboxesViewController.h"
#import "ISRefreshControl.h"
#import "MGDomain.h"
#import "MGMailbox.h"
#import "MailboxTableCell.h"
#import "AppDelegate.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
#import "AddMailboxViewController.h"
#import "EmptyTableCell.h"
#import "LoadingTableViewDatasource.h"
#import "ProgressTableCell.h"
#import "EmptyTableViewDatasource.h"
#import "BlockAlertView.h"
@interface MailboxesViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation MailboxesViewController

#pragma mark - View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0]];
    [self.refreshControl addTarget:self action:@selector(doReload) forControlEvents:UIControlEventValueChanged];
    [self useProgressDatasource];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([AppDelegate is_iPhone]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.currentMailbox = nil;
    [self loadMailboxes];
}

#pragma mark - External UITableViewDatasource/Delegate
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

#pragma mark - UITableViewDatasource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MailboxTableCell *cell = (MailboxTableCell *)[self.tableView dequeueReusableCellWithIdentifier:MAILBOX_TABLE_CELL];
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
    MGMailbox *m = self.datasource[indexPath.row];
    cell.titleLabel.text = m.mailbox;
    cell.sizeLabel.text = m.size_bytes;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.currentIndex = indexPath;
        self.currentMailbox = self.datasource[self.currentIndex.row];
        log_detail(@"Current mailbox: %@", self.currentMailbox.mailbox);
        NSString *message = [NSString stringWithFormat:@"This action cannot be undone.\nAre you sure you want to delete %@?", self.currentMailbox.mailbox];
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Warning!" message:message];
        [alert addButtonWithTitle:@"Cancel" block:nil];
        [alert setDestructiveButtonWithTitle:@"Delete" block:^{
            [MGMailbox deleteMailbox:self.currentMailbox.mailbox forDomain:self.currentDomain.name withRes:^(NSDictionary *res){
                [self.tableView beginUpdates];
                [self.datasource removeObject:self.currentMailbox];
                [self.tableView deleteRowsAtIndexPaths:@[self.currentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
                if (self.datasource.count == 0) {
                    [self useEmptyDatasource];
                }
            }err:^(NSDictionary *err){
                if (err) {
                    if ([err isKindOfClass:[NSDictionary class]]) {
                        if (err[@"message"]) {
                            [Alerter showErrorWithTitle:@"Error deleting mailbox" message:err[@"message"]];
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentMailbox = self.datasource[indexPath.row];
    [self performSegueWithIdentifier:SHOW_EDIT_MAILBOX_PUSH sender:self];
}

#pragma mark - IBActions
- (IBAction)dismissMe:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data loading
- (void)loadMailboxes {
    if (!self.currentDomain) {
        log_detail(@"Error: Must have current domain set");
        return;
    }
    [MGMailbox getMailboxesForDomain:self.currentDomain.name withBlock:^(NSArray *mailboxes, NSDictionary *error){
        if (mailboxes && mailboxes.count != 0) {
            self.datasource = [[NSMutableArray alloc] initWithArray:mailboxes];
        }
        
        if (error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (error[@"message"]) {
                    NSString *m = error[@"message"];
                    if ([m rangeOfString:@"Forbidden"].location != NSNotFound) {
                        [Alerter showForbiddenError];
                    } else {
                        [Alerter showErrorWithTitle:@"Error loading mailboxes" message:error[@"message"]];
                    }
                }
            }
        }
        [self useOwnDatasource];
        
        if (!mailboxes || mailboxes.count == 0) {
            [self useEmptyDatasource];
        }
        [self.refreshControl endRefreshing];
    }];
}
- (void)doReload {
    [self loadMailboxes];
}

#pragma mark Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_ADD_MAILBOX_PUSH]) {
        AddMailboxViewController *vc = (AddMailboxViewController *)segue.destinationViewController;
        vc.currentDomain = self.currentDomain;
    } else if ([segue.identifier isEqualToString:SHOW_EDIT_MAILBOX_PUSH]) {
        AddMailboxViewController *vc = (AddMailboxViewController *)segue.destinationViewController;
        vc.currentDomain = self.currentDomain;
        vc.editMode = YES;
        vc.currentMailbox = self.currentMailbox;
    }
}

@end
