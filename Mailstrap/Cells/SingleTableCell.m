//
//  SingleTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/15/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "SingleTableCell.h"
#import "SingleCellBackgroundView.h"
#import "SingleCellSelectedBackgroundView.h"
@implementation SingleTableCell
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
}
@end
