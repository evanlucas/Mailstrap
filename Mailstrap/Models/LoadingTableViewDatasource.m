//
//  LoadingTableViewDatasource.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "LoadingTableViewDatasource.h"
#import "ProgressTableCell.h"
#import "TableCellBackgroundView.h"
@implementation LoadingTableViewDatasource
static LoadingTableViewDatasource *ds = nil;
+ (LoadingTableViewDatasource *)sharedInstanceWithMessage:(NSString *)message {
    @synchronized(self){
        if (ds == nil) {
            ds = [[LoadingTableViewDatasource alloc] init];
            ds.message = message;
        }
    }
    return ds;
}
+ (LoadingTableViewDatasource *)sharedInstance {
    @synchronized(self){
        if (ds == nil) {
            ds = [[LoadingTableViewDatasource alloc] init];
        }
    }
    return ds;
}
- (id)init {
    if (self = [super init]) {
        self.rowCount = 1;
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowCount;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgressTableCell *cell = (ProgressTableCell *)[tableView dequeueReusableCellWithIdentifier:@"ProgressCell"];
    if (cell == nil) {
        cell = [[ProgressTableCell alloc] initWithFrame:CGRectMake(0, 0, 320, 65.0f)];
    }
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.message) {
        cell.message = self.message;
    } else {
        cell.message = @"Loading...";
    }
    [cell startProgressing];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}
@end
