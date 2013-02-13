//
//  AboutViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/7/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalTableViewController.h"
@protocol AboutDelegate
- (void)shouldDismissAboutViewController;
@end
@interface AboutViewController : ModalTableViewController
@property (nonatomic, assign) id<AboutDelegate> aboutDelegate;
@property (strong, nonatomic) IBOutlet UITextView *textViewAttributes;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)dismissMe:(id)sender;
@end
