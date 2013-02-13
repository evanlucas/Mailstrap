//
//  BouncesViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "BouncesViewController.h"
#import "LoadingTableViewDatasource.h"
#import "EmptyTableViewDatasource.h"
#import "ProgressTableCell.h"
#import "EmptyTableCell.h"
#import "AddBounceViewController.h"
#import "MGDomain.h"
#import "MGBounce.h"
#import "ISRefreshControl.h"
#import "BlockAlertView.h"
#import "BouncesTableCell.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
@interface BouncesViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation BouncesViewController


#pragma mark View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0]];
    [self.refreshControl addTarget:self action:@selector(doReload) forControlEvents:UIControlEventValueChanged];
    self.tableView.sectionFooterHeight = 0;
    [self useProgressDatasource];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self loadBounces];
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

#pragma mark - Data loading
- (void)loadBounces {
    [MGBounce getBouncesForDomain:self.currentDomain.name params:@{@"skip": @"0", @"limit": @"100"} block:^(NSArray *bounces, NSDictionary *error) {
        if (bounces && bounces.count != 0) {
            self.datasource = [[NSMutableArray alloc] initWithArray:bounces];
        }
        
        if (error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (error[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error loading bounces" message:error[@"message"]];
                }
            } else {
                [Alerter showErrorWithTitle:@"Error" message:@"An unknown error has occurred. Please try again."];
            }
        }
        [self useOwnDatasource];
        
        if (!bounces || bounces.count == 0) {
            [self useEmptyDatasource];
        }
        [self.refreshControl endRefreshing];
    }];
}
- (void)doReload {
    [self loadBounces];
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGBounce *bounce = self.datasource[indexPath.row];
    BouncesTableCell *cell = (BouncesTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"BouncesTableCell"];
    if (cell == nil) {
        cell = [[BouncesTableCell alloc] initWithBounce:bounce];
    } else {
        [cell setBounce:bounce];
    }
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
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
    MGBounce *bounce = self.datasource[indexPath.row];
    CGFloat labelWidth = MODAL_WIDTH - (MODAL_MARGIN * 2);
    return [bounce cellHeightForWidth:labelWidth];
}

#pragma mark UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.currentIndex = indexPath;
        MGBounce *currentBounce = self.datasource[indexPath.row];
        [self deleteBounce:currentBounce];
    }
}


#pragma mark - Deletion
- (void)deleteBounce:(MGBounce *)bounce {
    NSString *msg = [NSString stringWithFormat:@"This action cannot be undone.\nAre you sure you want to delete the bounce at address %@", bounce.address];
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Warning!" message:msg];
    [alert addButtonWithTitle:@"Cancel" block:nil];
    [alert setDestructiveButtonWithTitle:@"Delete" block:^{
        [MGBounce deleteBounceAtAddress:bounce.address domain:self.currentDomain.name withRes:^(NSDictionary *res){
            [self.tableView beginUpdates];
            [self.datasource removeObject:bounce];
            [self.tableView deleteRowsAtIndexPaths:@[self.currentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            if (self.datasource.count == 0) {
                [self useEmptyDatasource];
            }
        }err:^(NSDictionary *err){
            if (err) {
                if ([err isKindOfClass:[NSDictionary class]]) {
                    if (err[@"message"]) {
                        [Alerter showErrorWithTitle:@"Error deleting bounce" message:err[@"message"]];
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

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_ADD_BOUNCES_PUSH]) {
        AddBounceViewController *vc = (AddBounceViewController *)segue.destinationViewController;
        vc.currentDomain = self.currentDomain;
    }
}
@end
