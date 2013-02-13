//
//  NavigationItemView.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/20/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "NavigationItemView.h"
#import "AppDelegate.h"
#import "DrawingFunctions.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
#import <QuartzCore/QuartzCore.h>
@implementation NavigationItemView
- (id)initWithTitle:(NSString *)title icon:(NSString *)iconName iconSelected:(NSString *)iconSelectedName {
    if ([AppDelegate is_iPhone]) {
        if (self = [super initWithFrame:CGRectMake(0, 0, 150, 150)]) {
            self.titleString = title;
            self.iconImage = [UIImage imageNamed:iconName];
            self.iconSelectedImage = [UIImage imageNamed:iconSelectedName];
            [self setupView];
        }
        return self;
    } else {
        if (self = [super initWithFrame:CGRectMake(0, 0, 240, 220)]) {
            self.titleString = title;
            self.iconImage = [UIImage imageNamed:iconName];
            self.iconSelectedImage = [UIImage imageNamed:iconSelectedName];
            [self setupView];
        }
        return self;
    }
}

- (void)setupView {
    CGRect iconFrame = CGRectMake(45, 20, 150, 150);
    CGRect titleFrame = CGRectMake(20, 179, 200, 25);
    CGFloat fontSize = 22.0f;
    if ([AppDelegate is_iPhone]) {
        iconFrame = CGRectMake(29, 13, 92, 92);
        titleFrame = CGRectMake(0, 120, 150, 21);
        fontSize = 15.0f;
    }
    // setup bg view
    self.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:self.bounds];
    [self addSubview:self.backgroundView];
    
    self.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:self.bounds];
    [self.selectedBackgroundView setAlpha:0.0f];
    [self addSubview:self.selectedBackgroundView];
    
    // setup icon
    self.iconImageView = [[UIImageView alloc] initWithFrame:iconFrame];
    [self.iconImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.iconImageView setUserInteractionEnabled:YES];
    [self.iconImageView setImage:self.iconSelectedImage];
    // add to view
    [self addSubview:self.iconImageView];
    
    // setup icon
    self.iconSelectedImageView = [[UIImageView alloc] initWithFrame:iconFrame];
    [self.iconSelectedImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.iconSelectedImageView setUserInteractionEnabled:YES];
    [self.iconSelectedImageView setImage:self.iconImage];
    self.iconSelectedImageView.alpha = 0.0f;
    // add to view
    [self addSubview:self.iconSelectedImageView];
    
    // setup label
    self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.titleLabel setText:self.titleString];
    // add to view
    [self addSubview:self.titleLabel];
    
    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedMe:)];
    [recog setDelegate:self];
    [self addGestureRecognizer:recog];
    
    
    //self.layer.borderColor = [UIColor redColor].CGColor;
    //self.layer.borderWidth = 2.0f;
}

- (void)tappedMe:(UITapGestureRecognizer *)recog {
    [self setHasBeenSelected:YES];
    [self.delegate selectedItemWithName:self.titleString];
}
- (void)setHasBeenSelected:(BOOL)hasBeenSelected {
    _hasBeenSelected = hasBeenSelected;
    if (hasBeenSelected) {
        [UIView animateWithDuration:0.15 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [self.selectedBackgroundView setAlpha:1.0f];
            [self.backgroundView setAlpha:0.0f];
            [self.iconSelectedImageView setAlpha:1.0f];
            [self.iconImageView setAlpha:0.0f];
        }];
    } else {
        [UIView animateWithDuration:0.15 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [self.selectedBackgroundView setAlpha:0.0f];
            [self.backgroundView setAlpha:1.0f];
            [self.iconSelectedImageView setAlpha:0.0f];
            [self.iconImageView setAlpha:1.0f];
        }];
    }
}






@end
