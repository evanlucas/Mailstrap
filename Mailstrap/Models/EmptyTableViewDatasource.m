//
//  EmptyTableViewDatasource.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "EmptyTableViewDatasource.h"
#import "EmptyTableCell.h"
#import "TableCellBackgroundView.h"
@implementation EmptyTableViewDatasource
static EmptyTableViewDatasource *ds = nil;

+ (EmptyTableViewDatasource *)sharedInstance {
    @synchronized(self){
        if (ds == nil) {
            ds = [[EmptyTableViewDatasource alloc] init];
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
    EmptyTableCell *cell = (EmptyTableCell *)[tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
    if (cell == nil) {
        cell = [[EmptyTableCell alloc] initWithFrame:CGRectMake(0, 0, 320, 65.0f)];
    }
    cell.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:cell.bounds];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.message) {
        cell.titleLabel.text = self.message;
    } else {
        cell.titleLabel.text = @"There are no records to display";
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}
@end
