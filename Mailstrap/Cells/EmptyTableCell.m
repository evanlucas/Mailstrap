//
//  EmptyTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "EmptyTableCell.h"
#import "TableCellBackgroundView.h"
@implementation EmptyTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:self.bounds];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
