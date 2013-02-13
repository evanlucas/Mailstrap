//
//  MailboxesViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/23/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalTableViewController.h"
#import "IndeterminateProgressView.h"
@class MGDomain;
@class MGMailbox;
@interface MailboxesViewController : ModalTableViewController
@property (nonatomic, strong) MGDomain *currentDomain;
@property (nonatomic, strong) MGMailbox *currentMailbox;
@property (nonatomic, strong) IndeterminateProgressView *progressView;
@property (nonatomic, strong) NSIndexPath *currentIndex;
- (IBAction)dismissMe:(id)sender;
@end
