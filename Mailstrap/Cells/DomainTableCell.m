//
//  DomainTableCell.m
//  DomainNav
//
//  Created by Evan Lucas on 12/19/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "DomainTableCell.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
@implementation DomainTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect {
    self.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:self.bounds];
}
@end
