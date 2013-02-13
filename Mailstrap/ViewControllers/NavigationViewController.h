//
//  NavigationViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/19/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationItemView.h"
#import "ModalTableViewController.h"
#import "SettingsViewController.h"
@interface NavigationViewController : UIViewController <NavigationDelegate, ModalDelegate, SettingsDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) NSString *destinationName;
@end
