//
//  ComplaintsViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ComplaintsViewController.h"
#import "LoadingTableViewDatasource.h"
#import "ProgressTableCell.h"
#import "TableCellBackgroundView.h"
#import "MGComplaints.h"
#import "MGDomain.h"
#import "ISRefreshControl.h"
#import "ComplaintsTableCell.h"
#import "EmptyTableCell.h"
#import "AddComplaintViewController.h"
#import "BlockAlertView.h"
#import "EmptyTableViewDatasource.h"
@interface ComplaintsViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation ComplaintsViewController


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
    [self loadComplaints];
}

#pragma mark - Data loading
- (void)loadComplaints {
    [MGComplaints getComplaintsForDomain:self.currentDomain.name withLimit:100 skip:0 block:^(NSArray *complaints, NSDictionary *error) {
        if (complaints && complaints.count != 0) {
            self.datasource = [[NSMutableArray alloc] initWithArray:complaints];
        }
        
        if (error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (error[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error loading complaints" message:error[@"message"]];
                }
            } else {
                [Alerter showErrorWithTitle:@"Error" message:@"An unknown error has occurred. Please try again."];
            }
        }
        
        [self useOwnDatasource];
        if (!complaints || complaints.count == 0) {
            [self useEmptyDatasource];
        }
        [self.refreshControl endRefreshing];
    }];
}
- (void)doReload {
    [self loadComplaints];
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
    if ([segue.identifier isEqualToString:SHOW_ADD_COMPLAINT_PUSH]) {
        AddComplaintViewController *vc = (AddComplaintViewController *)segue.destinationViewController;
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
    return 80.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGComplaints *complaint = self.datasource[indexPath.row];
    ComplaintsTableCell *cell = (ComplaintsTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ComplaintsTableCell"];
    if (cell == nil) {
        cell = [[ComplaintsTableCell alloc] initWithComplaints:complaint];
    } else {
        [cell setComplaint:complaint];
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
        MGComplaints *complaint = self.datasource[indexPath.row];
        NSString *msg = [NSString stringWithFormat:@"Are you sure you want to delete the complaint for %@?\nThis action cannot be undone.", complaint.address];
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Warning!" message:msg];
        [alert addButtonWithTitle:@"Cancel" block:nil];
        [alert setDestructiveButtonWithTitle:@"Delete" block:^{
            [self deleteComplaint:complaint];
        }];
        [alert show];
    }
}

#pragma mark Deletion
- (void)deleteComplaint:(MGComplaints *)complaint {
    [MGComplaints deleteComplaintForAddress:complaint.address forDomain:self.currentDomain.name withRes:^(NSDictionary *res){
        [self.tableView beginUpdates];
        [self.datasource removeObject:complaint];
        [self.tableView deleteRowsAtIndexPaths:@[self.currentIndex] withRowAnimation:UITableViewRowAnimationTop];
        if (self.datasource.count == 0) {
            [self useEmptyDatasource];
        }
        [self.tableView endUpdates];
    }withErr:^(NSDictionary *err){
        if (err) {
            if ([err isKindOfClass:[NSDictionary class]]) {
                if (err[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error deleting complaint" message:err[@"message"]];
                }
            }
        }
        if (self.datasource.count == 0) {
            [self useEmptyDatasource];
        }
    }];

}
@end
