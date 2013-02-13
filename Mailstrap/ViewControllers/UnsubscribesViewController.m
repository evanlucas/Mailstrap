//
//  ComplaintsViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "UnsubscribesViewController.h"
#import "LoadingTableViewDatasource.h"
#import "ProgressTableCell.h"
#import "TableCellBackgroundView.h"
#import "MGComplaints.h"
#import "MGDomain.h"
#import "ISRefreshControl.h"
#import "ComplaintsTableCell.h"
#import "EmptyTableCell.h"
#import "AddUnsubscribeViewController.h"
#import "BlockAlertView.h"
#import "MGUnsubscribes.h"
#import "EmptyTableViewDatasource.h"
#import "UnsubscribesTableCell.h"
@interface UnsubscribesViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation UnsubscribesViewController


#pragma mark View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0]];
    [self.refreshControl addTarget:self action:@selector(doReload) forControlEvents:UIControlEventValueChanged];
    [self useProgressDatasource];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self loadUnsubscribes];
}

#pragma mark - Data loading
- (void)loadUnsubscribes {
    [MGUnsubscribes getUnsubscribesForDomain:self.currentDomain.name withLimit:100 skip:0 block:^(NSArray *unsubscribes, NSDictionary *error){
        if (unsubscribes && unsubscribes.count != 0) {
            self.datasource = [[NSMutableArray alloc] initWithArray:unsubscribes];
        }
        
        if (error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (error[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error loading unsubscribes" message:error[@"message"]];
                }
            } else {
                [Alerter showErrorWithTitle:@"Error" message:@"An unknown error has occurred. Please try again."];
            }
        }
        [self useOwnDatasource];
        if (!unsubscribes || unsubscribes.count == 0) {
            [self useEmptyDatasource];
        }
        [self.refreshControl endRefreshing];
    }];

}
- (void)doReload {
    [self loadUnsubscribes];
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

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_ADD_UNSUBSCRIBES_PUSH]) {
        AddUnsubscribeViewController *vc = (AddUnsubscribeViewController *)segue.destinationViewController;
        vc.currentDomain = self.currentDomain;
    }
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGUnsubscribes *subs = self.datasource[indexPath.row];
    UnsubscribesTableCell *cell = (UnsubscribesTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"UnsubscribesTableCell"];
    if (cell == nil) {
        cell = [[UnsubscribesTableCell alloc] initWithUnsubscribes:subs];
    } else {
        [cell setUnsubscribe:subs];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.currentIndex = indexPath;
        MGUnsubscribes *subs = self.datasource[indexPath.row];
        NSString *msg = [NSString stringWithFormat:@"Are you sure you want to delete the unsubscribe for %@?\nThis action cannot be undone.", subs.address];
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Warning!" message:msg];
        [alert addButtonWithTitle:@"Cancel" block:nil];
        [alert setDestructiveButtonWithTitle:@"Delete" block:^{
            [self deleteUnsubscribe:subs];
        }];
        [alert show];
    }
}

#pragma mark Deletion
- (void)deleteUnsubscribe:(MGUnsubscribes *)unsub {
    [MGUnsubscribes deleteUnsubscribeForID:unsub.mg_id forDomain:self.currentDomain.name withRes:^(NSDictionary *res){
        [self.tableView beginUpdates];
        [self.datasource removeObject:unsub];
        [self.tableView deleteRowsAtIndexPaths:@[self.currentIndex] withRowAnimation:UITableViewRowAnimationTop];
        if (self.datasource.count == 0) {
            [self useEmptyDatasource];
        }
        [self.tableView endUpdates];
    }err:^(NSDictionary *err){
        if (err) {
            if ([err isKindOfClass:[NSDictionary class]]) {
                if (err[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error deleting unsubscribe" message:err[@"message"]];
                }
            }
        }
        if (self.datasource.count == 0) {
            [self useEmptyDatasource];
        }
    }];
}

@end
