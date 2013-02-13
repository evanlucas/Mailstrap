//
//  ComplaintsTableCell.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGComplaints;
@interface ComplaintsTableCell : UITableViewCell
- (id)initWithComplaints:(MGComplaints *)complaint;
@property (nonatomic, strong) MGComplaints *complaint;
@end
