//
//  EditMailingListViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "EditMailingListViewController.h"
#import "MGMailingList.h"
#import "MGDomain.h"
#import "MailingListMembersViewController.h"
#import "ImageUtil.h"
@interface EditMailingListViewController ()

@end

@implementation EditMailingListViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat height = 44;
    CGFloat font = 15.0f;
    if (!iPad) {
        height = 30;
        font = 12.0f;
    }
    [self.segControlAccessLevel setBackgroundImage:[ImageUtil imageWithColor:[UIColor mailstrapBlueColor] size:CGSizeMake(100, height)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segControlAccessLevel setBackgroundImage:[ImageUtil imageWithColor:[UIColor mailstrapDarkBlueColor] size:CGSizeMake(100, height)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.segControlAccessLevel setBackgroundImage:[ImageUtil imageWithColor:[UIColor mailstrapDarkBlueColor] size:CGSizeMake(100, height)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self.segControlAccessLevel setDividerImage:[ImageUtil imageWithColor:[UIColor mailstrapDarkBlueColor] size:CGSizeMake(2, height)] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segControlAccessLevel setDividerImage:[ImageUtil imageWithColor:[UIColor mailstrapBlueColor] size:CGSizeMake(2, height)] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.segControlAccessLevel setDividerImage:[ImageUtil imageWithColor:[UIColor mailstrapDarkBlueColor] size:CGSizeMake(2, height)] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segControlAccessLevel setDividerImage:[ImageUtil imageWithColor:[UIColor mailstrapBlueColor] size:CGSizeMake(2, height)] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segControlAccessLevel setDividerImage:[ImageUtil imageWithColor:[UIColor mailstrapBlueColor] size:CGSizeMake(2, height)] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.segControlAccessLevel setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeFont: [UIFont boldSystemFontOfSize:font]} forState:UIControlStateNormal];
  [self.segControlAccessLevel setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor colorWithWhite:0.9 alpha:1.0], UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeFont: [UIFont boldSystemFontOfSize:font]} forState:UIControlStateSelected];
    if (!self.addMode) {
        if (self.mailingList) {
            self.textName.text = self.mailingList.name;
            self.textAddress.text = self.mailingList.address;
            self.textDescription.text = self.mailingList.desc;
            self.title = @"Edit List";
            if ([[self.mailingList.access_level lowercaseString] rangeOfString:@"readonly"].location != NSNotFound) {
                [self.segControlAccessLevel setSelectedSegmentIndex:0];
            } else if ([[self.mailingList.access_level lowercaseString] rangeOfString:@"members"].location != NSNotFound) {
                [self.segControlAccessLevel setSelectedSegmentIndex:1];
            } else {
                [self.segControlAccessLevel setSelectedSegmentIndex:2];
            }
        }
    } else {
        self.title = @"New List";
    }
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 20 + CGRectGetMaxY(self.segControlAccessLevel.frame))];
    self.keyboardIsShown = NO;
    if (!self.mailingList) {
        [self.buttonMembers setEnabled:NO];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignTheFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Helpers
- (void)keyboardWillHide:(NSNotification *)n {
    //NSDictionary *userInfo = [n userInfo];
    CGRect svFrame = self.view.frame;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setFrame:svFrame];
    }];
    self.keyboardIsShown = NO;
    
}
- (void)keyboardWillShow:(NSNotification *)n {
    if (self.keyboardIsShown) {
        return;
    }
    
    NSDictionary *userInfo = [n userInfo];
    CGSize keyboardSize = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= keyboardSize.height;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 20 + CGRectGetMaxY(self.segControlAccessLevel.frame));
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setFrame:viewFrame];
    }];
    self.keyboardIsShown = YES;
}

#pragma mark - IBActions
- (IBAction)tappedMembersBtn:(id)sender {
//    [self performSegueWithIdentifier:SHOW_MAILING_LIST_MEMBERS sender:self];
}
- (IBAction)tappedSaveBtn:(id)sender {
    [self resignTheFirstResponder];
    NSString *address = self.textAddress.text;
    NSString *name = self.textName.text;
    NSString *desc = self.textDescription.text;
    NSString *accessLevel = [self accessLevelForIndex:self.segControlAccessLevel.selectedSegmentIndex];
    NSDictionary *params = @{@"address" : address, @"name": name, @"description": desc, @"access_level": accessLevel};
    if (self.addMode) {
        [MGMailingList createMailingListWithParams:params withRes:^(NSDictionary *res){
            [self.navigationController popViewControllerAnimated:YES];
        }err:^(NSDictionary *err){
            if (err) {
                if ([err isKindOfClass:[NSDictionary class]]) {
                    if (err[@"message"]) {
                        log_detail(@"Error Message: %@", err[@"message"]);
                        [Alerter showErrorWithTitle:@"Error creating mailing list" message:err[@"message"]];
                    }
                }
            }
        }];
    } else {
        [MGMailingList updateMailingList:self.mailingList.address params:params withRes:^(NSDictionary *res){
            log_detail(@"Updated mailing list");
            [self.navigationController popViewControllerAnimated:YES];
        }err:^(NSDictionary *err){
            if (err) {
                if ([err isKindOfClass:[NSDictionary class]]) {
                    if (err[@"message"]) {
                        log_detail(@"Error Message: %@", err[@"message"]);
                        [Alerter showErrorWithTitle:@"Error updating mailing list" message:err[@"message"]];
                        // Todo show alert with error message
                    }
                }
            }
        }];
    }
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_MAILING_LIST_MEMBERS]) {
        MailingListMembersViewController *vc = (MailingListMembersViewController *)segue.destinationViewController;
            vc.listAddress = self.mailingList.address;
    }
}

#pragma mark - Helpers
- (NSString *)accessLevelForIndex:(NSInteger)index {
    NSString *al;
    switch (index) {
        case 0:
            al = @"readonly";
            break;
        case 1:
            al = @"members";
            break;
        case 2:
            al = @"everyone";
            break;
        default:
            al = @"readonly";
            break;
    }
    return al;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)viewDidUnload {
    [self setButtonMembers:nil];
    [super viewDidUnload];
}
@end
