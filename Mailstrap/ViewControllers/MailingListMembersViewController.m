//
//  MailingListMembersViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "MailingListMembersViewController.h"
#import "MGMLMember.h"
#import "ISRefreshControl.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
#import "LoadingTableViewDatasource.h"
#import "EmptyTableViewDatasource.h"
#import "ProgressTableCell.h"
#import "MailingListAddMemberViewController.h"
@interface MailingListMembersViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation MailingListMembersViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0]];
    [self.refreshControl addTarget:self action:@selector(doReload) forControlEvents:UIControlEventValueChanged];
    [self useProgressDatasource];

	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadMembers];
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

#pragma mark - Data loading
- (void)loadMembers {
    if (self.listAddress) {
        [MGMLMember getMembersForListAddress:self.listAddress withBlock:^(NSArray *members, NSDictionary *error) {
            if (members && members.count != 0) {
                self.datasource = [[NSMutableArray alloc] initWithArray:members];
            }
            
            if (error) {
                if ([error isKindOfClass:[NSDictionary class]]) {
                    if (error[@"message"]) {
                        [Alerter showErrorWithTitle:@"Error loading members" message:error[@"message"]];
                    }
                }
            }
         
            [self useOwnDatasource];
            if (!members || members.count == 0) {
                [self useEmptyDatasource];
            }
         [self.refreshControl endRefreshing];
            log_detail(@"Done loading members");
        }];
    } else {
        log_detail(@"List address doesn't exist");
    }
}
- (void)doReload {
    [self loadMembers];
}

#pragma mark - UITableViewDatasource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MAILING_LIST_MEMBERS_TABLE_CELL];
    MGMLMember *member = self.datasource[indexPath.row];
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
    cell.textLabel.text = member.address;
    if (member.subscribed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_MAILING_LIST_ADD_MEMBER]) {
        MailingListAddMemberViewController *vc = (MailingListAddMemberViewController *)segue.destinationViewController;
        vc.listAddress = self.listAddress;
    }
}
@end
