//
//  TableCellBackgroundView.m
//  Mailstrapped
//
//  Created by Evan Lucas on 12/16/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "TableCellBackgroundView.h"
#import "DrawingFunctions.h"
@implementation TableCellBackgroundView
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *start = [UIColor colorWithWhite:0.15 alpha:0.9];
    UIColor *end = [UIColor colorWithWhite:0.14 alpha:0.9];
    CGContextSaveGState(ctx);
    drawLinearGradientC(ctx, rect, start, end);
//    CGContextSetFillColorWithColor(ctx, end.CGColor);
//    CGContextFillRect(ctx, rect);
    CGPoint startPoint = CGPointMake(rect.origin.x + 1, rect.origin.y + rect.size.height -1);
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width - 1, rect.origin.y + rect.size.height - 1);
    draw1PxStroke(ctx, startPoint, endPoint, [UIColor colorWithWhite:0.1f alpha:0.7f]);
    CGContextRestoreGState(ctx);
}
@end
