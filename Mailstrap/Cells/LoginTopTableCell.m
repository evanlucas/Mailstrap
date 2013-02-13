//
//  LoginTopTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/13/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "LoginTopTableCell.h"
#import "TopCellBackgroungView.h"
#import "TopCellSelectedBackgroundView.h"
@implementation LoginTopTableCell
- (id)init {
    if (self = [super init]) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    self.backgroundView = [[TopCellBackgroungView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView = [[TopCellSelectedBackgroundView alloc] initWithFrame:self.bounds];
}
@end
