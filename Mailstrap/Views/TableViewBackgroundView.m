//
//  TableViewBackgroundView.m
//  Mailstrapped
//
//  Created by Evan Lucas on 12/16/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "TableViewBackgroundView.h"
#import "DrawingFunctions.h"
@implementation TableViewBackgroundView
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *end = [UIColor colorWithWhite:0.18 alpha:0.9];
    UIColor *start = [UIColor colorWithWhite:0.23 alpha:0.9];
    CGContextSaveGState(ctx);
    drawLinearGradientC(ctx, rect, start, end);
    CGContextRestoreGState(ctx);
}
@end
