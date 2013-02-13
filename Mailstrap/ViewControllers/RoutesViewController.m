//
//  RoutesViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "RoutesViewController.h"
#import "ISRefreshControl.h"
#import "MGRoutes.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
#import "AppDelegate.h"
#import "ISRefreshControl.h"
#import "EmptyTableCell.h"
#import "RouteDetailViewController.h"
#import "LoadingTableViewDatasource.h"
#import "ProgressTableCell.h"
#import "EmptyTableViewDatasource.h"
#import "BlockAlertView.h"
@interface RoutesViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation RoutesViewController
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
    
    [self loadRoutes];
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
- (void)loadRoutes {
    [MGRoutes getRoutesWithBlock:^(NSArray *routes, NSDictionary *error) {
        if (routes && routes.count != 0) {
            self.datasource = [[NSMutableArray alloc] initWithArray:routes];
        }
        
        if (error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (error[@"message"]) {
                    [Alerter showErrorWithTitle:@"Error loading routes" message:error[@"message"]];
                }
            }
        }
        
        [self useOwnDatasource];
        
        if (!routes || routes.count == 0) {
            [self useEmptyDatasource];
        }
        
        [self.refreshControl endRefreshing];
    }];
}
- (void)doReload {
    [self loadRoutes];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ROUTES_TABLE_CELL];
    MGRoutes *r = self.datasource[indexPath.row];
    if ([r.description isEqualToString:@""]) {
        cell.textLabel.text = @"There is no description for this route";
    } else {
        cell.textLabel.text = r.description;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", r.priority];
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:cell.bounds];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.currentIndex = indexPath;
        MGRoutes *currentRoute = self.datasource[indexPath.row];
        [self deleteRoute:currentRoute];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentRoute = self.datasource[indexPath.row];
    [self performSegueWithIdentifier:SHOW_ROUTE_DETAIL_PUSH sender:self];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}

#pragma mark - Helpers
- (void)deleteRoute:(MGRoutes *)route {
    self.currentRoute = route;
    NSString *msg = [NSString stringWithFormat:@"This action cannot be undone.\nAre you sure you want to delete the mailing list with expression %@?", self.currentRoute.expression];
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Warning!" message:msg];
    [alert addButtonWithTitle:@"Cancel" block:nil];
    [alert setDestructiveButtonWithTitle:@"Delete" block:^{
        [MGRoutes deleteRouteID:self.currentRoute.route_id withRes:^(NSDictionary *res){
            [self.tableView beginUpdates];
            [self.datasource removeObject:self.currentRoute];
            [self.tableView deleteRowsAtIndexPaths:@[self.currentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            if (self.datasource.count == 0) {
                [self useEmptyDatasource];
            }
         
        }err:^(NSDictionary *err){
            if (err) {
                if ([err isKindOfClass:[NSDictionary class]]) {
                    if (err[@"message"]) {
                        [Alerter showErrorWithTitle:@"Error deleting route" message:err[@"message"]];
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
    if ([segue.identifier isEqualToString:SHOW_ROUTE_DETAIL_PUSH]) {
        RouteDetailViewController *vc = (RouteDetailViewController *)segue.destinationViewController;
        vc.currentRoute = self.currentRoute;
        vc.isNew = NO;
    } else if ([segue.identifier isEqualToString:SHOW_ADD_ROUTE_PUSH]) {
        RouteDetailViewController *vc = (RouteDetailViewController *)segue.destinationViewController;
        vc.isNew = YES;
    }
}

#pragma mark - IBActions
- (IBAction)tappedAddBtn:(id)sender {
    [self performSegueWithIdentifier:SHOW_ADD_ROUTE_PUSH sender:self];
}

- (IBAction)dismissMe:(id)sender {
    [self.routesDelegate shouldDismissRoutesViewController];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
