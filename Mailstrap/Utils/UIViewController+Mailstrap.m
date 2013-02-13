//
//  UIViewController+Mailstrap.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "UIViewController+Mailstrap.h"

@implementation UIViewController (Mailstrap)
- (void)resignTheFirstResponder {
    [self.view endEditing:YES];
}
@end
