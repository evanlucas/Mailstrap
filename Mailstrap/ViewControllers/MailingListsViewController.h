//
//  MailingListsViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
#import "IndeterminateProgressView.h"
#import "MGMailingList.h"
@protocol MailingListDelegate
- (void)shouldDismissMailingListViewController;
@end
@interface MailingListsViewController : ModalTableViewController
@property (nonatomic, strong) IndeterminateProgressView *progressView;
@property (nonatomic, strong) MGMailingList *currentMailingList;
@property (nonatomic, assign) id<MailingListDelegate> mailingListDelegate;
- (IBAction)tappedAddButton:(id)sender;
- (IBAction)dismissMe:(id)sender;
@end
