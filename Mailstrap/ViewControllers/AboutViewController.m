//
//  AboutViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/7/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "AboutViewController.h"
#import "TableViewBackgroundView.h"
#import "BlockAlertView.h"
@interface AboutViewController ()
@property (nonatomic) CGFloat currentY;
@end
@implementation AboutViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"About";
    self.titleLabel.text = [NSString stringWithFormat:@"Mailstrap v%@", MAILSTRAP_VERSION];
    TableViewBackgroundView *bg = [[TableViewBackgroundView alloc] initWithFrame:self.view.bounds];
    [bg setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.tableView.backgroundView = bg;
     
}
- (void)setupView {
    
}
#pragma mark - Helpers
- (void)showCurapps {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://curapps.com"]];
}
- (void)showOnGithub {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://github.com/evanlucas/Mailstrap"]];
}
- (void)showMailgun {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mailgun.com"]];
}
- (void)showMailgunSignup {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mailgun.net/signup?plan=free"]];
}
- (IBAction)dismissMe:(id)sender {
    [self.aboutDelegate shouldDismissAboutViewController];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectTableCells];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self showMailgunSignup];
        } else {
            [self showMailgun];
        }
    } else if (indexPath.section == 1) {
        // Rate
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Thanks for using Mailstrap" message:@"If you have enjoyed using Mailstrap, please take a moment to rate it."];
        [alert setCancelButtonWithTitle:@"No, thanks" block:^{
            
        }];
        [alert addButtonWithTitle:@"Rate Now" block:^{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/mailstrap/id593668123?ls=1&mt=8"]];
        }];
        [alert show];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self showCurapps];
            
        } else if (indexPath.row == 1) {
            [self showOnGithub];
        }
    }
}
- (void)deselectTableCells {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setTextViewAttributes:nil];
    [super viewDidUnload];
}
@end
