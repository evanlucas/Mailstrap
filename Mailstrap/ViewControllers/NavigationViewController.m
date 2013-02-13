//
//  NavigationViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/19/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "NavigationViewController.h"
#import "NavigationItemView.h"
#import "AppDelegate.h"
#import "DomainsViewController.h"
#import "MailboxesViewController.h"
#import "DomainSelectionViewController.h"
//#define ITEM_WIDTH 240.0f
//#define ITEM_HEIGHT 230.0f

@interface NavigationViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation NavigationViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildDatasource];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutIconsWithDuration:0];
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
    @{@"name" : @"About", @"icon": @"About", @"icon_selected": @"About_Selected"}
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


#pragma mark - Helper Methods
- (NSInteger)maxColumnsForOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return 3;
    }
    return 4;
}
- (NSInteger)maxColumns {
    if ([AppDelegate is_iPhone]) {
        return 2;
    }
    return [self maxColumnsForOrientation:[AppDelegate orientation]];
}
- (NSInteger)maxRowsForOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return 4;
    }
    return 3;
}
- (NSInteger)maxRows {
    if ([AppDelegate is_iPhone]) {
        return 6;
    }
    return [self maxRowsForOrientation:[AppDelegate orientation]];
}
- (CGFloat)horizontalMarginForOrientation:(UIInterfaceOrientation)orientation {
    // Landscape W = 1024, H = 704
    // Portrait W = 768, H = 960
    CGFloat width = 1024;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        width = 768;
    }
    CGFloat cols = [self maxColumnsForOrientation:orientation];
    CGFloat totalSpace = width - (cols * ITEM_WIDTH);
    return totalSpace / (cols + 1);
}
- (CGFloat)horizontalMargin {
    return [self horizontalMarginForOrientation:[AppDelegate orientation]];
}
- (CGFloat)verticalMarginForOrientation:(UIInterfaceOrientation)orientation {
    CGFloat height = 724;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        height = 980;
    }
    CGFloat rows = [self maxRowsForOrientation:orientation];
    CGFloat totalSpace = height - (rows * ITEM_HEIGHT);
    return totalSpace / (rows + 1);
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
    CGFloat mainWidth = 1024;
    CGFloat mainHeight = 724;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        mainWidth = 768;
        mainHeight = 980;
    }
    [self.mainScrollView setContentSize:CGSizeMake(mainWidth, mainHeight)];

    for (int i=0; i<[self maxColumnsForOrientation:orientation]; i++) {
        for (int j=0; j<[self maxRowsForOrientation:orientation]; j++) {
            CGPoint origin = [self originForIconAtX:i Y:j orientation:orientation];
            int index = j * [self maxColumnsForOrientation:orientation] + i;
            if (index >= self.datasource.count) {
                continue;
            }
            NavigationItemView *v = (NavigationItemView *)self.datasource[index];
            [v setHasBeenSelected:NO];
            [UIView animateWithDuration:0.5 animations:^{
                [v setFrame:CGRectMake(origin.x, origin.y, ITEM_WIDTH, ITEM_HEIGHT)];
            }];
        }
    }
}
- (void)layoutIconsWithDuration:(NSTimeInterval)duration {
    [self layoutIconsForOrientation:[AppDelegate orientation] duration:duration];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    log_detail(@"Will rotate");
    [self layoutIconsForOrientation:toInterfaceOrientation duration:duration];
}


#pragma mark - NavigationDelegate
- (void)selectedItemWithName:(NSString *)name {
    if ([name isEqualToString:@"Domains"]) {
        [self performSegueWithIdentifier:SHOW_DOMAINS_MODAL sender:self];
    } else if ([name isEqualToString:@"Settings"]) {
        [self performSegueWithIdentifier:SHOW_SETTINGS_MODAL sender:self];
    } else if ([name isEqualToString:@"Mailboxes"]) {
        self.destinationName = DEST_MAILBOXES;
        [self performSegueWithIdentifier:SHOW_DOMAIN_SELECTION_MODAL sender:self];
    } else if ([name isEqualToString:@"Routes"]) {
        [self performSegueWithIdentifier:SHOW_ROUTES_PUSH sender:self];
    }
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_DOMAINS_MODAL]) {
        UINavigationController *nav = [segue destinationViewController];
        DomainsViewController *vc = (DomainsViewController *)nav.topViewController;
        [vc setDelegate:self];
    } else if ([segue.identifier isEqualToString:SHOW_SETTINGS_MODAL]) {
        UINavigationController *nav = [segue destinationViewController];
        SettingsViewController *vc = (SettingsViewController *)nav.topViewController;
        [vc setDelegate:self];
    } else if ([segue.identifier isEqualToString:SHOW_MAILBOXES_MODAL]) {
        UINavigationController *nav = [segue destinationViewController];
        MailboxesViewController *vc = (MailboxesViewController *)nav.topViewController;
        [vc setDelegate:self];
    } else if ([segue.identifier isEqualToString:SHOW_DOMAIN_SELECTION_MODAL]) {
        UINavigationController *nav = [segue destinationViewController];
        DomainSelectionViewController *vc = (DomainSelectionViewController *)nav.topViewController;
        vc.destinationName = self.destinationName;
        vc.delegate = self;
    }
}

#pragma mark - ModalDelegate
- (void)shouldDismissWithItemName:(NSString *)name {
    for (NavigationItemView *v in self.datasource) {
        [v setHasBeenSelected:NO];
    }
}

#pragma mark - SettingsDelegate
- (void)dismissSettings {
    for (NavigationItemView *v in self.datasource) {
        if ([v.titleString isEqualToString:@"Settings"]) {
            [v setHasBeenSelected:NO];
        }
    }
}





@end
