//
//  CampaignsViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "CampaignsViewController.h"
#import "LoadingTableViewDatasource.h"
#import "EmptyTableCell.h"
#import "EmptyTableViewDatasource.h"
#import "ProgressTableCell.h"
#import "MGDomain.h"
#import "MGCampaign.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
#import "BlockAlertView.h"
#import "ISRefreshControl.h"
#import "CampaignDetailViewController.h"
#import "CreateCampaignViewController.h"
@interface CampaignsViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation CampaignsViewController


#pragma mark View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(doReload) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0]];
    [self useProgressDatasource];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self loadCampaigns];
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
- (void)loadCampaigns {
    [MGCampaign getCampaignsForDomain:self.currentDomain.name params:@{@"limit" : @"100", @"skip": @"0"} block:^(NSArray *campaigns, NSDictionary *error) {
        if (campaigns && campaigns.count !=0) {
            self.datasource = [[NSMutableArray alloc] initWithArray:campaigns];
        }
        if (error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (error[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error fetching campaigns" message:error[@"message"]];
                } else {
                    [Alerter showErrorWithTitle:@"Error fetching campaigns" message:@""];
                }
            } else {
                [Alerter showErrorWithTitle:@"Error fetching campaigns" message:@""];
            }
        }
        [self useOwnDatasource];
        
        if (!campaigns || campaigns.count == 0) {
            [self useEmptyDatasource];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)doReload {
    [self loadCampaigns];
}

#pragma mark - UITableViewDatasource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CAMPAIGN_NAME_CELL];
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
    MGCampaign *campaign = self.datasource[indexPath.row];
    
    // clicked_count
    // opened_count
    // submitted_count
    // unsubscribed_count
    // bounced_count
    // id
    // name
    // created_at
    // delivered_count
    // complained_count
    // dropped_count
    cell.textLabel.text = campaign.name;
    cell.detailTextLabel.text = campaign.campaign_id;
    return cell;
}
- (NSString *)valueWithNumber:(NSNumber *)c submitted:(NSNumber *)submitted {
    return [NSString stringWithFormat:@"%@/%@", c, submitted];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.currentIndex = indexPath;
        self.selectedCampaign = self.datasource[self.currentIndex.row];
        log_detail(@"Current Campaign: %@", self.selectedCampaign.name);
        NSString *message = [NSString stringWithFormat:@"This action cannot be undone.\nAre you sure you want to delete the campaign named %@?", self.selectedCampaign.name];
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Warning!" message:message];
        [alert addButtonWithTitle:@"Cancel" block:nil];
        [alert setDestructiveButtonWithTitle:@"Delete" block:^{
            [MGCampaign deleteCampaignID:self.selectedCampaign.campaign_id forDomain:self.currentDomain.name withRes:^(NSDictionary *res){
                [self.tableView beginUpdates];
                [self.datasource removeObject:self.selectedCampaign];
                [self.tableView deleteRowsAtIndexPaths:@[self.currentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
                if (self.datasource.count == 0) {
                    [self useEmptyDatasource];
                }
            }err:^(NSDictionary *err){
                if (err) {
                    if ([err isKindOfClass:[NSDictionary class]]) {
                        if (err[@"message"]) {
                            [Alerter showErrorWithTitle:@"Error deleting campaign" message:err[@"message"]];
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
    self.selectedCampaign = self.datasource[indexPath.row];
    [self performSegueWithIdentifier:SHOW_CAMPAIGN_DETAILS_PUSH sender:self];
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_CAMPAIGN_DETAILS_PUSH]) {
        CampaignDetailViewController *vc = (CampaignDetailViewController *)segue.destinationViewController;
        vc.currentDomain = self.currentDomain;
        vc.currentCampaign = self.selectedCampaign;
    } else if ([segue.identifier isEqualToString:SHOW_CREATE_CAMPAIGN_PUSH]) {
        CreateCampaignViewController *vc = (CreateCampaignViewController *)segue.destinationViewController;
        vc.currentDomain = self.currentDomain;
    }
}

#pragma mark - IBActions
- (IBAction)dismissMe:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
