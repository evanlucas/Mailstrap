//
//  LogsViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/9/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
#import "IndeterminateProgressView.h"
@class MGLog;
@class MGDomain;
@interface LogsViewController : ModalTableViewController
@property (nonatomic, strong) IndeterminateProgressView *progressView;
@property (nonatomic) NSInteger currentSkip;
@property (nonatomic) NSInteger currentLimit;
@property (nonatomic, strong) MGDomain *currentDomain;
@end
