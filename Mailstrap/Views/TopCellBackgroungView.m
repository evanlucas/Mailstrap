//
//  TopCellBackgroungView.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/13/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "TopCellBackgroungView.h"
#import "DrawingFunctions.h"
@implementation TopCellBackgroungView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *start = [UIColor colorWithWhite:0.15 alpha:1.0];
    UIColor *end = [UIColor colorWithWhite:0.13 alpha:1.0];
    CGContextSaveGState(ctx);
    CGMutablePathRef path = createTopTableCell(rect, 10);
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    drawLinearGradientC(ctx, rect, start, end);
    CGPoint startPoint = CGPointMake(rect.origin.x + 1, rect.origin.y + rect.size.height -1);
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width - 1, rect.origin.y + rect.size.height - 1);
    draw1PxStroke(ctx, startPoint, endPoint, [UIColor colorWithWhite:0.1f alpha:0.7f]);
    CGContextRestoreGState(ctx);
}

@end
