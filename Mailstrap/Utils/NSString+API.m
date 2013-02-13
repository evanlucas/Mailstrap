//
//  NSString+API.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "NSString+API.h"

@implementation NSString (API)
- (CGFloat)textHeightForFontSize:(CGFloat)size width:(CGFloat)width {
    CGFloat maxWidth = width;
    CGFloat maxHeight = 9999;
    CGSize maxLabelSize = CGSizeMake(maxWidth, maxHeight);
    CGSize expectedSize = [self sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:maxLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    return expectedSize.height;
}
@end
