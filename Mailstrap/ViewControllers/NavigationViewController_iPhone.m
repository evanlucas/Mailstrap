//
//  NavigationViewController_iPhone.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/26/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "NavigationViewController_iPhone.h"
#import "AppDelegate.h"
#import "DomainSelectionViewController.h"
#import "DomainsViewController.h"
#import "MailboxesViewController.h"
#import "MailingListsViewController.h"
#import "RoutesViewController.h"
#import "LogsViewController.h"
#import "CampaignsViewController.h"
#import "BouncesViewController.h"
#import "ComplaintsViewController.h"
#import "UnsubscribesViewController.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"
#ifdef NO_CAMPAIGNS
#import "BlockAlertView.h"
#endif
@interface NavigationViewController_iPhone ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation NavigationViewController_iPhone

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildDatasource];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutIconsWithDuration:0];
    self.destinationName = @"";
}

#pragma mark - Helpers
- (void)buildDatasource {
    NSArray *a = @[
    @{@"name": @"Domains", @"icon": @"Domains", @"icon_selected": @"Domains_Selected"},
    @{@"name" : @"Mailboxes", @"icon": @"Mailboxes", @"icon_selected": @"Mailboxes_Selected"},
    @{@"name": @"Mailing Lists", @"icon": @"MailingLists", @"icon_selected": @"MailingLists_Selected"},
    @{@"name": @"Routes", @"icon": @"Routes", @"icon_selected": @"Routes_Selected"},
    @{@"name" : @"Logs", @"icon": @"Logs", @"icon_selected": @"Logs_Selected"},
    @{@"name" : @"Campaigns", @"icon": @"Campaigns", @"icon_selected": @"Campaigns_Selected"},
    @{@"name": @"Bounces", @"icon": @"Bounces", @"icon_selected": @"Bounces_Selected"},
    @{@"name" : @"Complaints", @"icon": @"Complaints", @"icon_selected": @"Complaints_Selected"},
    @{@"name" : @"Unsubscribes", @"icon": @"Unsubscribes", @"icon_selected": @"Unsubscribes_Selected"},
    @{@"name" : @"Settings", @"icon": @"Settings", @"icon_selected": @"Settings_Selected"},
    @{@"name" : @"About", @"icon": @"About", @"icon_selected": @"About_Selected"},
    @{@"name" : @"Support", @"icon": @"Support", @"icon_selected": @"Support_Selected"}
    ];
    [self buildViewsFromArray:a];
}
- (void)buildViewsFromArray:(NSArray *)a {
    self.datasource = [@[] mutableCopy];
    for (int i=0; i<a.count; i++) {
        NSDictionary *d = a[i];
        NavigationItemView *v = [[NavigationItemView alloc] initWithTitle:d[@"name"] icon:d[@"icon"] iconSelected:d[@"icon_selected"]];
        [self.datasource addObject:v];
    }
    UIInterfaceOrientation o = [AppDelegate orientation];
    
    
    
    for (int i=0; i<[self maxColumnsForOrientation:o]; i++) {
        for (int j=0; j<[self maxRowsForOrientation:o]; j++) {
            CGPoint origin = [self originForIconAtX:i Y:j orientation:o];
            int index = j * [self maxColumnsForOrientation:o] + i;
            if (index >= self.datasource.count) {
                continue;
            }
            NavigationItemView *v = (NavigationItemView *)self.datasource[index];
            [v setDelegate:self];
            [v setFrame:CGRectMake(origin.x, origin.y, ITEM_WIDTH, ITEM_HEIGHT)];
            [self.mainScrollView addSubview:v];
        }
    }
}
- (NSInteger)maxColumnsForOrientation:(UIInterfaceOrientation)orientation {
    if (iPad) {
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            return 3;
        }
        return 4;
    }
    return 2;
}
- (NSInteger)maxColumns {
    return [self maxColumnsForOrientation:[AppDelegate orientation]];
}
- (NSInteger)maxRowsForOrientation:(UIInterfaceOrientation)orientation {
    if (iPad) {
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            return 4;
        }
        return 3;
    }
    return 8;
}
- (NSInteger)maxRows {
    return [self maxRowsForOrientation:[AppDelegate orientation]];
}
- (CGFloat)horizontalMarginForOrientation:(UIInterfaceOrientation)orientation {
    CGFloat width = 320;
    if (iPad) {
        width = 1024;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            width = 768;
        }
    }
    CGFloat cols = [self maxColumnsForOrientation:orientation];
    CGFloat totalSpace = width - (cols * ITEM_WIDTH);
    return totalSpace / (cols + 1);
}
- (CGFloat)horizontalMargin {
    return [self horizontalMarginForOrientation:[AppDelegate orientation]];
}
- (CGFloat)verticalMarginForOrientation:(UIInterfaceOrientation)orientation {
    if (iPad) {
        CGFloat height = 704;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            height = 960;
        }
        CGFloat rows = [self maxRowsForOrientation:orientation];
        CGFloat totalSpace = height - (rows * ITEM_HEIGHT);
        return totalSpace / (rows + 1);
    }
    return 8.0f;
}
- (CGFloat)verticalMargin {
    return [self verticalMarginForOrientation:[AppDelegate orientation]];
}
- (CGPoint)originForIconAtX:(int)x Y:(int)y orientation:(UIInterfaceOrientation)o {
    CGPoint origin;
    CGFloat hMargin = [self horizontalMarginForOrientation:o];
    CGFloat vMargin = [self verticalMarginForOrientation:o];
    origin.x = ((hMargin + ITEM_WIDTH) * x) + hMargin;
    origin.y = ((vMargin + ITEM_HEIGHT) * y) + vMargin;
    return origin;
}
- (CGPoint)originForIconAtX:(int)x Y:(int)y {
    return [self originForIconAtX:x Y:y orientation:[AppDelegate orientation]];
}
- (void)layoutIconsForOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {

    CGRect outsideRect;
    CGFloat h = 0;
    for (int i=0; i<[self maxColumnsForOrientation:orientation]; i++) {
        for (int j=0; j<[self maxRowsForOrientation:orientation]; j++) {
            CGPoint origin = [self originForIconAtX:i Y:j orientation:orientation];
            int index = j * [self maxColumnsForOrientation:orientation] + i;
            if (index >= self.datasource.count) {
                continue;
            }
            NavigationItemView *v = (NavigationItemView *)self.datasource[index];
            [v setHasBeenSelected:NO];
            outsideRect = CGRectMake(origin.x, origin.y, ITEM_WIDTH, ITEM_HEIGHT);
            if (!iPad) {
                if (origin.y + ITEM_HEIGHT > h) {
                    h = (origin.y + ITEM_HEIGHT + [self verticalMargin]);
                }
            }
            [UIView animateWithDuration:0.5 animations:^{
                [v setFrame:outsideRect];
            }];
            
        }
    }
    if (!iPad) {
        [self.mainScrollView setContentSize:CGSizeMake(320.0f, h)];
    }
}
- (void)layoutIconsWithDuration:(NSTimeInterval)duration {
    [self layoutIconsForOrientation:[AppDelegate orientation] duration:duration];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutIconsForOrientation:toInterfaceOrientation duration:duration];
}

#pragma mark - NavigationDelegate
- (void)selectedItemWithName:(NSString *)name {
    if (![[APIController sharedInstance] isSetup]) {
        /*
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Notice!" message:@"I'm not seeing your API Key.  Please navigate to Settings and enter your API Key.  Thanks."];
        [alert addButtonWithTitle:@"Ok" block:nil];
         */
        // Show login as modal
        [self performSegueWithIdentifier:SHOW_LOGIN_PUSH sender:self];
        return;
    }
    if ([name isEqualToString:@"Domains"]) {
        [self performSegueWithIdentifier:SHOW_DOMAINS_PUSH sender:self];
    } else if ([name isEqualToString:@"Settings"]) {
        [self performSegueWithIdentifier:SHOW_SETTINGS_PUSH sender:self];
    } else if ([name isEqualToString:@"Mailboxes"]) {
        self.destinationName = DEST_MAILBOXES;
        [self performSegueWithIdentifier:SHOW_DOMAIN_SELECTION_PUSH sender:self];
    } else if ([name isEqualToString:@"Mailing Lists"]) {
        [self performSegueWithIdentifier:SHOW_MAILING_LISTS_PUSH sender:self];
    } else if ([name isEqualToString:@"Routes"]) {
        [self performSegueWithIdentifier:SHOW_ROUTES_PUSH sender:self];
    } else if ([name isEqualToString:@"About"]) {
        [self performSegueWithIdentifier:SHOW_ABOUT_PUSH sender:self];
    } else if ([name isEqualToString:@"Logs"]) {
        self.destinationName = DEST_LOGS;
        [self performSegueWithIdentifier:SHOW_DOMAIN_SELECTION_PUSH sender:self];
    } else if ([name isEqualToString:@"Complaints"]) {
        self.destinationName = DEST_COMPLAINTS;
        [self performSegueWithIdentifier:SHOW_DOMAIN_SELECTION_PUSH sender:self];
    } else if ([name isEqualToString:@"Unsubscribes"]) {
        self.destinationName = DEST_UNSUBSCRIBES;
        [self performSegueWithIdentifier:SHOW_DOMAIN_SELECTION_PUSH sender:self];
    } else if ([name isEqualToString:@"Bounces"]) {
        self.destinationName = DEST_BOUNCES;
        [self performSegueWithIdentifier:SHOW_DOMAIN_SELECTION_PUSH sender:self];
    } else if ([name isEqualToString:@"Support"]) {
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        [vc setMailComposeDelegate:self];
        [vc setSubject:@"Mailstrap support"];
        [vc setToRecipients:@[@"Mailstrap Support <support@mailstrap.com>"]];
        [self presentViewController:vc animated:YES completion:nil];
    }
#ifdef NO_CAMPAIGNS
    else if ([name isEqualToString:@"Campaigns"]) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Oops..." message:@"This module is not yet activated...You will be notified for an update when it becomes available"];
        [alert addButtonWithTitle:@"Dismiss" block:^{
            [self deselectAllItems];
        }];
        [alert show];
    }
#else
    else if ([name isEqualToString:@"Campaigns"]) {
        self.destinationName = DEST_CAMPAIGNS;
        [self performSegueWithIdentifier:SHOW_DOMAIN_SELECTION_PUSH sender:self];
    }
#endif
}

#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        [Alerter showErrorWithTitle:@"Thanks" message:@"We will contact you shortly."];
    } else if (result == MFMailComposeResultFailed) {
        log_detail(@"Error sending support email: %@", error);
        [Alerter showErrorWithTitle:@"Error" message:error.localizedDescription];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self deselectAllItems];
    }];
}

#pragma mark Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (iPad) {
        if ([segue.identifier isEqualToString:SHOW_DOMAINS_PUSH]) {
            UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
            DomainsViewController *vc = (DomainsViewController *)nav.topViewController;
            vc.delegate = self;
        }  else if ([segue.identifier isEqualToString:SHOW_MAILING_LISTS_PUSH]) {
            UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
            MailingListsViewController *vc = (MailingListsViewController *)nav.topViewController;
            vc.mailingListDelegate = self;
        } else if ([segue.identifier isEqualToString:SHOW_ROUTES_PUSH]) {
            UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
            RoutesViewController *vc = (RoutesViewController *)nav.topViewController;
            vc.routesDelegate = self;
        } else if ([segue.identifier isEqualToString:SHOW_CAMPAIGNS_PUSH]) {
            
        } else if ([segue.identifier isEqualToString:SHOW_SETTINGS_PUSH]) {
            UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
            SettingsViewController *vc = (SettingsViewController *)nav.topViewController;
            vc.delegate = self;
        } else if ([segue.identifier isEqualToString:SHOW_DOMAIN_SELECTION_PUSH]) {
            UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
            DomainSelectionViewController *vc = (DomainSelectionViewController *)nav.topViewController;
            vc.delegate = self;
            vc.destinationName = self.destinationName;
        } else if ([segue.identifier isEqualToString:SHOW_ABOUT_PUSH]) {
            UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
            AboutViewController *vc = (AboutViewController *)nav.topViewController;
            vc.aboutDelegate = self;
        }
        
    } else {
        if ([segue.identifier isEqualToString:SHOW_DOMAIN_SELECTION_PUSH]) {
            DomainSelectionViewController *vc = (DomainSelectionViewController *)segue.destinationViewController;
            vc.destinationName = self.destinationName;
        }
    }
    
    if ([segue.identifier isEqualToString:SHOW_LOGIN_PUSH]) {
        if (iPad) {
            UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
            LoginContainerViewController *container = (LoginContainerViewController *)nav.topViewController;
            container.loginDelegate = self;
        }
    }
}

#pragma mark - Helpers
- (void)deselectAllItems {
    for (NavigationItemView *v in self.datasource) {
        [v setHasBeenSelected:NO];
    }
}

#pragma mark - ModalDelegate
- (void)shouldDismissWithItemName:(NSString *)name {
    [self deselectAllItems];
}

#pragma mark - SettingsDelegate
- (void)dismissSettings {
    [self deselectAllItems];
}

#pragma mark - RoutesDelegate
- (void)shouldDismissRoutesViewController {
    [self deselectAllItems];
}

#pragma mark - MailingListDelegate
- (void)shouldDismissMailingListViewController {
    [self deselectAllItems];
}

#pragma mark - AboutDelegate
- (void)shouldDismissAboutViewController {
    [self deselectAllItems];
}

#pragma mark - LoginDelegate
- (void)shouldDismissLogin {
    [self deselectAllItems];
}

@end
