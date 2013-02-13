//
//  ModalTableViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
#import "TableCellBackgroundView.h"
#import "TableViewBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
#import "APIController.h"
#import "ISRefreshControl.h"
@interface ModalTableViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation ModalTableViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.refreshControl setTintColor:[UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0]];
    TableViewBackgroundView *bg = [[TableViewBackgroundView alloc] initWithFrame:self.view.bounds];
    [bg setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.tableView.backgroundView = bg;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.datasource.count;
}
*/

@end
