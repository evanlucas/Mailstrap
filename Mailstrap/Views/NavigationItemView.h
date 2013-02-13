//
//  NavigationItemView.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/20/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NavigationDelegate
- (void)selectedItemWithName:(NSString *)name;
@end

@class TableCellBackgroundView;
@class TableCellSelectedBackgroundView;
@interface NavigationItemView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UIImageView *iconSelectedImageView;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) UIImage *iconSelectedImage;
@property (nonatomic) BOOL hasBeenSelected;
@property (nonatomic, strong) TableCellBackgroundView *backgroundView;
@property (nonatomic, strong) TableCellSelectedBackgroundView *selectedBackgroundView;
- (id)initWithTitle:(NSString *)title icon:(NSString *)iconName iconSelected:(NSString *)iconSelectedName;
@property (nonatomic, assign) id<NavigationDelegate> delegate;
@end
