//
//  DomainSelectionViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
#import "IndeterminateProgressView.h"
@class MGDomain;
@interface DomainSelectionViewController : ModalTableViewController
@property (nonatomic, strong) IndeterminateProgressView *progressView;
@property (nonatomic, strong) NSString *destinationName;
@property (nonatomic, strong) MGDomain *selectedDomain;
- (IBAction)dismissMe:(id)sender;
@end
