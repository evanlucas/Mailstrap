//
//  ProgressTableCell.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndeterminateProgressView.h"
@interface ProgressTableCell : UITableViewCell
@property (nonatomic, strong) IndeterminateProgressView *progressView;
@property (nonatomic, strong) NSString *message;

- (void)startProgressing;
- (void)stopProgressing;
@end
