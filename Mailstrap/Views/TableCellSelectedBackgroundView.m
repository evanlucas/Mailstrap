//
//  TableCellSelectedBackgroundView.m
//  Mailstrapped
//
//  Created by Evan Lucas on 12/16/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "TableCellSelectedBackgroundView.h"
#import "DrawingFunctions.h"
@implementation TableCellSelectedBackgroundView
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *start = [UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0];
    UIColor *end = [UIColor colorWithRed:7/255.0f green:94/255.0f blue:137/255.0f alpha:1.0];
    CGContextSaveGState(ctx);
    drawLinearGradientC(ctx, rect, start, end);
    CGContextRestoreGState(ctx);
}
@end
