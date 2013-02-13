//
//  TopCellSelectedBackgroundView.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/14/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "TopCellSelectedBackgroundView.h"
#import "DrawingFunctions.h"
@implementation TopCellSelectedBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Comment this out if blank
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *start = [UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0];
    UIColor *end = [UIColor colorWithRed:7/255.0f green:94/255.0f blue:137/255.0f alpha:1.0];
    CGContextSaveGState(ctx);
    CGMutablePathRef path = createTopTableCell(rect, 10);
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    drawLinearGradientC(ctx, rect, start, end);
    CGContextRestoreGState(ctx);
}


@end
