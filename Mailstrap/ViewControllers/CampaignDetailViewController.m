//
//  CampaignDetailViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "CampaignDetailViewController.h"
#import "MGCampaign.h"
#import "MGDomain.h"
#import "TableCellBackgroundView.h"
#import "ISRefreshControl.h"
@interface CampaignDetailViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation CampaignDetailViewController


#pragma mark - View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(doReload) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark - Data loading
- (void)doReload {
    [MGCampaign getCampaignID:self.currentCampaign.campaign_id forDomain:self.currentDomain.name withRes:^(NSDictionary *res){
        MGCampaign *c = [[MGCampaign alloc] initWithAttributes:res];
        self.currentCampaign = c;
    }err:^(NSDictionary *err){
        if (err) {
            if ([err isKindOfClass:[NSDictionary class]]) {
                if (err[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error fetching campaign details" message:err[@"message"]];
                }
            }
        }
    }];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}
#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - UITableViewDatasource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    MGCampaign *campaign = self.currentCampaign;
    if (campaign) {
        NSInteger c = [[campaign dictValue] count];
        return c;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CAMPAIGN_DETAIL_TABLE_CELL];
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    //cell.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
    MGCampaign *campaign = self.currentCampaign;
    NSNumber *submitted = [campaign submitted_count];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = [campaign name];
            break;
        case 1:
            cell.textLabel.text = @"ID";
            cell.detailTextLabel.text = [campaign campaign_id];
            break;
        case 2:
            cell.textLabel.text = @"Created";
            cell.detailTextLabel.text = [campaign created_at];
            break;
        case 3:
            cell.textLabel.text = @"Submitted";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[campaign submitted_count]];
            break;
        case 4:
            cell.textLabel.text = @"Clicked";
            cell.detailTextLabel.text = [self valueWithNumber:campaign.clicked_count submitted:submitted];
            break;
        case 5:
            cell.textLabel.text = @"Opened";
            cell.detailTextLabel.text = [self valueWithNumber:campaign.opened_count submitted:submitted];
            break;
        case 6:
            cell.textLabel.text = @"Delivered";
            cell.detailTextLabel.text = [self valueWithNumber:campaign.delivered_count submitted:submitted];
            break;
        case 7:
            cell.textLabel.text = @"Bounced";
            cell.detailTextLabel.text = [self valueWithNumber:campaign.bounced_count submitted:submitted];
            break;
        case 8:
            cell.textLabel.text = @"Complained";
            cell.detailTextLabel.text = [self valueWithNumber:campaign.complained_count submitted:submitted];
            break;
        case 9:
            cell.textLabel.text = @"Unsubscribed";
            cell.detailTextLabel.text = [self valueWithNumber:campaign.unsubscribed_count submitted:submitted];
            break;
        case 10:
            cell.textLabel.text = @"Dropped";
            cell.detailTextLabel.text = [self valueWithNumber:campaign.dropped_count submitted:submitted];
            break;
        default:
            break;
    }
    
    return cell;

}
- (NSString *)valueWithNumber:(NSNumber *)c submitted:(NSNumber *)submitted {
    // C is current count
    // submitted is the submitted count
    // percent is c / submitted
    if (submitted == @0) {
        return [NSString stringWithFormat:@"%@ - %@ / %@", @"0%", @0, @0];
    }
    NSString *cs = [NSString stringWithFormat:@"%@", c];
    NSString *ss = [NSString stringWithFormat:@"%@", submitted];
    NSDecimalNumber *cdec = [NSDecimalNumber decimalNumberWithString:cs];
    NSDecimalNumber *sdec = [NSDecimalNumber decimalNumberWithString:ss];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterPercentStyle];
    NSDecimalNumber *d = [cdec decimalNumberByDividingBy:sdec];
    return [NSString stringWithFormat:@"%@ - %@ / %@", [nf stringFromNumber:d], c, submitted];
}
@end
