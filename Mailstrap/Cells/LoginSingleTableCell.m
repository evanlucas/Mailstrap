//
//  LoginSingleTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/13/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "LoginSingleTableCell.h"
#import "SingleCellBackgroundView.h"
#import "SingleCellSelectedBackgroundView.h"
@implementation LoginSingleTableCell

- (id)init {
    if (self = [super init]) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)drawRect:(CGRect)rect {
    self.backgroundView = [[SingleCellBackgroundView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView = [[SingleCellSelectedBackgroundView alloc] initWithFrame:self.bounds];
}
@end
