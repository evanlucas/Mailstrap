//
//  RoutesViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "IndeterminateProgressView.h"
#import "ModalTableViewController.h"
#import "LargeTextField.h"
#import "LargeTextView.h"
#import "MGRoutes.h"
@protocol RoutesDelegate
- (void)shouldDismissRoutesViewController;
@end
@interface RoutesViewController : ModalTableViewController
@property (nonatomic, strong) IndeterminateProgressView *progressView;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) MGRoutes *currentRoute;
@property (nonatomic, assign) id<RoutesDelegate> routesDelegate;
- (IBAction)tappedAddBtn:(id)sender;
- (IBAction)dismissMe:(id)sender;



@end
