//
//  LargeTextField.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "LargeTextField.h"

@implementation LargeTextField
- (void)drawRect:(CGRect)rect {
    UIImage *bg = [[UIImage imageNamed:@"textfield_large"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)];
    [bg drawInRect:rect];
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(5, 0, bounds.size.width - 10, bounds.size.height);
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(5, 0, bounds.size.width - 10, bounds.size.height);
}
@end
