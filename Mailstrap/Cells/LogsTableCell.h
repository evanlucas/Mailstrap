//
//  LogsTableCell.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/9/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGLog;
@interface LogsTableCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *labelHap;
@property (nonatomic, strong) IBOutlet UILabel *labelCreatedAt;
@property (nonatomic, strong) IBOutlet UILabel *message;
@property (nonatomic, strong) IBOutlet UILabel *message_id;
@property (nonatomic, strong) IBOutlet UILabel *log_type;
@property (nonatomic, strong) MGLog *log;
- (id)initWithLog:(MGLog *)log;
- (CGFloat)cellHeight;
@end
