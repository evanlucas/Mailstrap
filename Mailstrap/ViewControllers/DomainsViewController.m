//
//  DomainsViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/20/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "DomainsViewController.h"
#import "MGDomain.h"
#import "APIController.h"
#import "DomainTableCell.h"
#import "AppDelegate.h"
#import "TableCellBackgroundView.h"
#import "TableViewBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
#import "ISRefreshControl.h"
#import "EmptyTableCell.h"
#import "BlockAlertView.h"
#import "ProgressTableCell.h"
#import "LoadingTableViewDatasource.h"
#import "EmptyTableViewDatasource.h"
#import "BlockAlertView.h"
@interface DomainsViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation DomainsViewController

#pragma mark - View lifecycle
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
    [self loadDomains];
}

#pragma mark - External UITableViewDatasource/Delegate
- (void)useProgressDatasource {
    log_f();
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
    log_f();
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
- (void)loadDomains {
    
    [MGDomain getDomainsWithBlock:^(NSArray *domains, NSDictionary *error) {
        if (domains && domains.count != 0) {
            self.datasource = [[NSMutableArray alloc] initWithArray:domains];
        }
        
        if (error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (error[@"message"]) {
                    NSString *m = error[@"message"];
                    if ([m rangeOfString:@"Forbidden"].location != NSNotFound) {
                        [Alerter showForbiddenError];
                    } else {
                        [Alerter showErrorWithTitle:@"Error loading domains" message:error[@"message"]];
                    }
                }
            }
        }

        [self useOwnDatasource];
        if (!domains || domains.count == 0) {
            [self useEmptyDatasource];
        }
        [self.refreshControl endRefreshing];
    }];
}
- (void)doReload {
    [self loadDomains];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DomainTableCell *cell = (DomainTableCell *)[self.tableView dequeueReusableCellWithIdentifier:DOMAIN_TABLE_CELL];
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    //cell.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MGDomain *d = self.datasource[indexPath.row];
    cell.titleLabel.text = d.name;
    return cell;
    
}

#pragma mark - Table view delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.currentIndex = indexPath;
        MGDomain *domain = self.datasource[self.currentIndex.row];
        NSString *message = [NSString stringWithFormat:@"This action cannot be undone.\nAre you sure you want to delete %@?", domain.name];
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Warning!" message:message];
        [alert addButtonWithTitle:@"Cancel" block:nil];
        [alert setDestructiveButtonWithTitle:@"Delete" block:^{
            [self deleteDomain];
        }];
        [alert show];
    }
}

#pragma mark - IBActions
- (IBAction)dismissMe:(id)sender {
    [self.delegate shouldDismissWithItemName:@"Domains"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers
- (void)deleteDomain {
    MGDomain *currentDomain = self.datasource[self.currentIndex.row];
    [MGDomain deleteDomain:currentDomain.name withRes:^(NSDictionary *res){
        [self.tableView beginUpdates];
        [self.datasource removeObject:currentDomain];
        [self.tableView deleteRowsAtIndexPaths:@[self.currentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        if (self.datasource.count == 0) {
            [self useEmptyDatasource];
        }
    }err:^(NSDictionary *err){
        if (err) {
            if ([err isKindOfClass:[NSDictionary class]]) {
                if (err[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error deleting domain" message:err[@"message"]];
                }
            }
        }
        if (self.datasource.count == 0) {
            [self useEmptyDatasource];
        }
    }];

}

@end
