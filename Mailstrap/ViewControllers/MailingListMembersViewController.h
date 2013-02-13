//
//  MailingListMembersViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
#import "IndeterminateProgressView.h"
@class MGDomain;
@class MGMailingList;
@interface MailingListMembersViewController : ModalTableViewController
@property (nonatomic, strong) NSString *listAddress;
@property (nonatomic, strong) IndeterminateProgressView *progressView;
@end
