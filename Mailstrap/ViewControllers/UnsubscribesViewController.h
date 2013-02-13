//
//  ComplaintsViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
@class MGUnsubscribes;
@class MGDomain;
@interface UnsubscribesViewController : ModalTableViewController
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) MGDomain *currentDomain;
@end
