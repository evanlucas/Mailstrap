//
//  BouncesViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
@class MGBounce;
@class MGDomain;
@interface BouncesViewController : ModalTableViewController
@property (nonatomic, strong) MGDomain *currentDomain;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@end
