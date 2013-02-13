//
//  Alerter.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "Alerter.h"
#import "BlockAlertView.h"
@implementation Alerter
+ (void)showErrorWithTitle:(NSString *)title message:(NSString *)message {
    //CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    //[alertView show];
    BlockAlertView *alert = [BlockAlertView alertWithTitle:title message:message];
    [alert addButtonWithTitle:@"Done" block:nil];
    [alert show];
}

+ (void)showForbiddenError {
    //CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Forbidden" message:@"Access forbidden. This is typically caused by unauthorized access or an invalid API Key" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    //[alertView show];
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Forbidden" message:@"Access forbidden. This is typically caused by unauthorized access or an invalid API Key"];
    [alert addButtonWithTitle:@"Done" block:nil];
    [alert show];
}

+ (void)showNotConnectedError {
    //CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Error!" message:@"It seems that you are not connected to the internet.  There is not much we can do without internet." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    //[alertView show];
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Error!" message:@"It seems that you are not connected to the internet.  There is not much we can do without internet."];
    [alert addButtonWithTitle:@"Done" block:nil];
    [alert show];
}
@end
