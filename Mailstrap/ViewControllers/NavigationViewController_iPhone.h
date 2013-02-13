//
//  NavigationViewController_iPhone.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/26/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationItemView.h"
#import "ModalTableViewController.h"
#import "SettingsViewController.h"
#import "RoutesViewController.h"
#import "MailingListsViewController.h"
#import "AboutViewController.h"
#import "LoginContainerViewController.h"
#import <MessageUI/MessageUI.h>
@interface NavigationViewController_iPhone : UIViewController <NavigationDelegate, ModalDelegate, SettingsDelegate, RoutesDelegate, MailingListDelegate, AboutDelegate, LoginDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) NSString *destinationName;
@property (nonatomic, strong) LoginContainerViewController *loginViewController;
@end
