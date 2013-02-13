//
//  TableHeaderView.m
//  Mailstrapped
//
//  Created by Evan Lucas on 12/19/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "TableHeaderView.h"
#import "DrawingFunctions.h"
#import <QuartzCore/QuartzCore.h>
@implementation TableHeaderView
- (id)initWithTitle:(NSString *)title {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 40)]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 22)];
        [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:title];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
        titleLabel.center = self.center;
        [self addSubview:titleLabel];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *end = [UIColor colorWithWhite:0.15 alpha:0.9];
    CGContextSaveGState(ctx);
    //drawLinearGradientC(ctx, rect, start, end);
    CGContextSetFillColorWithColor(ctx, end.CGColor);
    CGContextFillRect(ctx, rect);
    CGPoint startPoint = CGPointMake(rect.origin.x + 1, rect.origin.y + rect.size.height -1);
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width - 1, rect.origin.y + rect.size.height - 1);
    draw1PxStroke(ctx, startPoint, endPoint, [UIColor blackColor]);
    CGContextRestoreGState(ctx);
    
}
@end
