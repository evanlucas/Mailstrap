//
//  LogsViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/9/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "LogsViewController.h"
#import "MGLog.h"
#import "MGDomain.h"
#import "ISRefreshControl.h"
#import "LogsTableCell.h"
#import "TableCellBackgroundView.h"
#import "TableCellBackgroundViewAlt.h"
#import "TableCellSelectedBackgroundView.h"
#import "LoadingTableViewDatasource.h"
#import "EmptyTableViewDatasource.h"
#import "ProgressTableCell.h"
@interface LogsViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation LogsViewController

#pragma mark View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0]];
    [self.refreshControl addTarget:self action:@selector(doReload) forControlEvents:UIControlEventValueChanged];
    self.currentSkip = 0;
    self.currentLimit = 25;
    [self useProgressDatasource];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    [self loadLogs];
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
- (void)loadLogs {
    [MGLog getLogsForDomain:self.currentDomain.name withLimit:self.currentLimit skip:self.currentSkip block:^(NSArray *logs, NSDictionary *error){
        if (logs) {
            // OK, we have logs to load
            // We need to see how many we have loaded in our datasource, and then compare that to the skip and limit we have set
            self.datasource = [[NSMutableArray alloc] initWithArray:logs];
        }
        
        if (error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (error[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error loading logs" message:error[@"message"]];
                }
            } else {
                [Alerter showErrorWithTitle:@"Error" message:@"An unknown error has occurred. Please try again."];
            }
        }
        
        [self useOwnDatasource];
        
        if (!logs || logs.count == 0) {
            [self useEmptyDatasource];
        }
        [self.refreshControl endRefreshing];
    }];
}
- (void)doReload {
    [self loadLogs];
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGLog *log = self.datasource[indexPath.row];
    LogsTableCell *cell = (LogsTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Test"];
    if (!cell) {
        cell = [[LogsTableCell alloc] initWithLog:log];
    } else {
        [cell setLog:log];
    }
    if (indexPath.row % 2 == 0) {
        cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    } else {
        cell.backgroundView = [[TableCellBackgroundViewAlt alloc] initWithFrame:cell.bounds];
    }
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
    MGLog *log = self.datasource[indexPath.row];
    CGFloat labelWidth = MODAL_WIDTH - (MODAL_MARGIN * 2);
    return [log cellHeightForWidth:labelWidth];
}
- (CGFloat)heightForLabelWithText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width {
    CGFloat height = [text textHeightForFontSize:fontSize width:width];
    return (height < 60) ? height + 40 : height;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
