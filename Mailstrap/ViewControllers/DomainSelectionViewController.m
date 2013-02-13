//
//  DomainSelectionViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "DomainSelectionViewController.h"
#import "MGDomain.h"
#import "AppDelegate.h"
#import "ISRefreshControl.h"
#import "DomainTableCell.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
#import "MailboxesViewController.h"
#import "LogsViewController.h"
#import "LoadingTableViewDatasource.h"
#import "ProgressTableCell.h"
#import "ComplaintsViewController.h"
#import "EmptyTableCell.h"
#import "EmptyTableViewDatasource.h"
#import "BlockAlertView.h"
#import "UnsubscribesViewController.h"
#import "BouncesViewController.h"
#import "CampaignsViewController.h"
@interface DomainSelectionViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation DomainSelectionViewController

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
    if ([AppDelegate is_iPhone]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [self loadDomains];
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
                } else {
                    log_detail(@"no error[@message]");
                }
            } else {
                log_detail(@"error is not a dictionary");
            }
        } else {
            log_detail(@"No error exists");
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DomainTableCell *cell = (DomainTableCell *)[self.tableView dequeueReusableCellWithIdentifier:DOMAIN_TABLE_CELL];
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
    MGDomain *d = self.datasource[indexPath.row];
    cell.titleLabel.text = d.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedDomain = self.datasource[indexPath.row];
    if ([self.destinationName isEqualToString:DEST_MAILBOXES]) {
        [self performSegueWithIdentifier:SHOW_MAILBOXES_PUSH sender:self];
    } else if ([self.destinationName isEqualToString:DEST_LOGS]) {
        [self performSegueWithIdentifier:SHOW_LOGS_PUSH sender:self];
    } else if ([self.destinationName isEqualToString:DEST_COMPLAINTS]) {
        [self performSegueWithIdentifier:SHOW_COMPLAINTS_PUSH sender:self];
    } else if ([self.destinationName isEqualToString:DEST_UNSUBSCRIBES]) {
        [self performSegueWithIdentifier:SHOW_UNSUBSCRIBES_PUSH sender:self];
    } else if ([self.destinationName isEqualToString:DEST_BOUNCES]) {
        [self performSegueWithIdentifier:SHOW_BOUNCES_PUSH sender:self];
    } else if ([self.destinationName isEqualToString:DEST_CAMPAIGNS]) {
        [self performSegueWithIdentifier:SHOW_CAMPAIGNS_PUSH sender:self];
    }
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_MAILBOXES_PUSH]) {
        MailboxesViewController *vc = (MailboxesViewController *)segue.destinationViewController;
        vc.currentDomain = self.selectedDomain;
    } else if ([segue.identifier isEqualToString:SHOW_LOGS_PUSH]) {
        LogsViewController *vc = (LogsViewController *)segue.destinationViewController;
        vc.currentDomain = self.selectedDomain;
    } else if ([segue.identifier isEqualToString:SHOW_COMPLAINTS_PUSH]) {
        ComplaintsViewController *vc = (ComplaintsViewController *)segue.destinationViewController;
        vc.currentDomain = self.selectedDomain;
    } else if ([segue.identifier isEqualToString:SHOW_UNSUBSCRIBES_PUSH]) {
        UnsubscribesViewController *vc = (UnsubscribesViewController *)segue.destinationViewController;
        vc.currentDomain = self.selectedDomain;
    } else if ([segue.identifier isEqualToString:SHOW_BOUNCES_PUSH]) {
        BouncesViewController *vc = (BouncesViewController *)segue.destinationViewController;
        vc.currentDomain = self.selectedDomain;
    } else if ([segue.identifier isEqualToString:SHOW_CAMPAIGNS_PUSH]) {
        CampaignsViewController *vc = (CampaignsViewController *)segue.destinationViewController;
        vc.currentDomain = self.selectedDomain;
    }
}

#pragma mark IBActions
- (IBAction)dismissMe:(id)sender {
    [self.delegate shouldDismissWithItemName:@"Domains"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
