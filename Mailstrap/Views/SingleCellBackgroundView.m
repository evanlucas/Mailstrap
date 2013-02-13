//
//  SingleCellBackgroundView.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/13/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "SingleCellBackgroundView.h"
#import "DrawingFunctions.h"
@implementation SingleCellBackgroundView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *start = [UIColor colorWithWhite:0.15 alpha:0.9];
    UIColor *end = [UIColor colorWithWhite:0.13 alpha:0.9];
    CGContextSaveGState(ctx);
    CGMutablePathRef path = createRoundedRectForRect(rect, 10);
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    drawLinearGradientC(ctx, rect, start, end);
    CGContextRestoreGState(ctx);
}
@end
