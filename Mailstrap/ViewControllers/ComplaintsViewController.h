//
//  ComplaintsViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
@class MGDomain;
@interface ComplaintsViewController : ModalTableViewController
@property (nonatomic, strong) MGDomain *currentDomain;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@end
