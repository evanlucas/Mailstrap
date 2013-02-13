//
//  LoadingTableViewDatasource.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingTableViewDatasource : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
+ (LoadingTableViewDatasource *)sharedInstanceWithMessage:(NSString *)message;
+ (LoadingTableViewDatasource *)sharedInstance;
@property (nonatomic, strong) NSString *message;
@property (nonatomic) NSInteger rowCount;
@end
