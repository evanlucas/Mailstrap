//
//  LargeAlertView.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "LargeTextView.h"

@implementation LargeTextView

- (void)drawRect:(CGRect)rect {
    UIImage *bg;
    if (iPad) {
        bg = [[UIImage imageNamed:@"LargeTextView-iPad"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 7, 10, 7)];
    } else {
        bg = [[UIImage imageNamed:@"largetextview"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 7, 10, 7)];
    }
    [bg drawInRect:rect];
}

@end
