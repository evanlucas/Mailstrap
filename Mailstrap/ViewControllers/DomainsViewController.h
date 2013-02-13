//
//  DomainsViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/20/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalTableViewController.h"
#import "IndeterminateProgressView.h"
@class MGDomain;
@interface DomainsViewController : ModalTableViewController 
- (IBAction)dismissMe:(id)sender;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) IndeterminateProgressView *progressView;
@property (nonatomic) BOOL isLoading;
@end
