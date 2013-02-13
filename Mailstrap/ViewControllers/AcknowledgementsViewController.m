//
//  AcknowledgementsViewController.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/14/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "AcknowledgementsViewController.h"

@interface AcknowledgementsViewController ()

@end

@implementation AcknowledgementsViewController


#pragma mark View lifecycla
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *h = [[NSBundle mainBundle] pathForResource:@"Acks" ofType:@"html"];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:h encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:contents baseURL:nil];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] scheme] rangeOfString:@"http"].location != NSNotFound) {
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {
            return ![[UIApplication sharedApplication] openURL:[request URL]];
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
