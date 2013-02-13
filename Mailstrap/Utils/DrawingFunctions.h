//
//  Common.h
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//


//
//  DrawingFunctions.h
//  Drawing
//
//  Modified by Evan Lucas on 6/3/12.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
void drawLinearGradient(CGContextRef ctx, CGRect rect, CGColorRef bottomColor, CGColorRef topColor);
void drawLinearGradientC(CGContextRef ctx, CGRect rect, UIColor *bottomColor, UIColor *topColor);
void drawStrokeWithWidth(CGContextRef ctx, CGPoint start, CGPoint end, CGColorRef color, CGFloat width);
CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius);
CGMutablePathRef createTopTableCell(CGRect rect, CGFloat radius);
CGMutablePathRef createBottomTableCell(CGRect rect, CGFloat radius);
CGMutablePathRef createRoundedRectForLeft(CGRect rect, CGFloat radius);
CGMutablePathRef createRoundedRectForRight(CGRect rect, CGFloat radius);
void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, UIColor *color);