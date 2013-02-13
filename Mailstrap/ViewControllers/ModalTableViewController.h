//
//  ModalTableViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ModalDelegate
- (void)shouldDismissWithItemName:(NSString *)name;
@end
@interface ModalTableViewController : UITableViewController
@property (nonatomic, assign) id<ModalDelegate> delegate;
@end
