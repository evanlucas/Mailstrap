//
//  RouteActionsViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
#import "MGRoutes.h"
@protocol RouteActionsDelegate
- (void)didDismissWithActions:(NSMutableArray *)actions;
@end
@interface RouteActionsViewController : ModalTableViewController
@property (nonatomic, strong) NSMutableArray *routeActions;
- (IBAction)tappedAddButton:(id)sender;
@property (nonatomic, assign) id<RouteActionsDelegate> routeDelegate;
- (IBAction)tappedDoneButton:(id)sender;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@end
