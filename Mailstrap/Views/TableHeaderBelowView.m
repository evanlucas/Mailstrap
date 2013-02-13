//
//  TableHeaderBelowView.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "TableHeaderBelowView.h"
#import "DrawingFunctions.h"
@implementation TableHeaderBelowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *end = [UIColor colorWithWhite:0.18 alpha:0.9];
    CGContextSaveGState(ctx);
    //drawLinearGradientC(ctx, rect, start, end);
    CGContextSetFillColorWithColor(ctx, end.CGColor);
    CGContextFillRect(ctx, rect);
    CGPoint startPoint = CGPointMake(rect.origin.x + 1, rect.origin.y + rect.size.height -1);
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width - 1, rect.origin.y + rect.size.height - 1);
    draw1PxStroke(ctx, startPoint, endPoint, [UIColor colorWithWhite:0.1f alpha:0.5f]);
    CGContextRestoreGState(ctx);
}

@end
