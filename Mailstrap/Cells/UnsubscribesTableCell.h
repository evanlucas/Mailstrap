//
//  UnsubscribesTableCell.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUnsubscribes;
@interface UnsubscribesTableCell : UITableViewCell
- (id)initWithUnsubscribes:(MGUnsubscribes *)unsubscribe;
@property (nonatomic, strong) MGUnsubscribes *unsubscribe;
@end
