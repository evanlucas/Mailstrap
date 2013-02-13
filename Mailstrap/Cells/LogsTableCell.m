//
//  LogsTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/9/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "LogsTableCell.h"
#import "MGLog.h"
@implementation LogsTableCell
- (id)initWithLog:(MGLog *)log {
    if (self = [super init]) {
        self.log = log;
        
        self.labelCreatedAt = [[UILabel alloc] init];
        [self labelFrame:self.labelCreatedAt y:3];
        [self.contentView addSubview:self.labelCreatedAt];
        self.message_id = [[UILabel alloc] init];
        [self labelFrame:self.message_id y:25];
        [self.message_id setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.message_id];
        self.log_type = [[UILabel alloc] init];
        [self labelFrame:self.log_type y:52];
        [self.contentView addSubview:self.log_type];
        self.labelHap = [[UILabel alloc] init];
        [self labelFrame:self.labelHap y:76];
        [self.contentView addSubview:self.labelHap];
        [self.labelCreatedAt setText:self.log.created_at];
        [self.labelHap setText:[self.log.hap capitalizedString]];
        [self.message_id setText:self.log.message_id];
        [self.log_type setText:[self.log.log_type capitalizedString]];
        self.message = [[UILabel alloc] init];
        [self.message setBackgroundColor:[UIColor clearColor]];
        [self.message setTextColor:[UIColor whiteColor]];
        [self.message setFont:[UIFont systemFontOfSize:14.0f]];
        [self.message setNumberOfLines:0];
        CGFloat labelWidth = MODAL_WIDTH - (MODAL_MARGIN * 2);
        CGSize maxSize = CGSizeMake(labelWidth, MAXFLOAT);
        CGSize s = [self.log.message sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
        [self.message setFrame:CGRectMake(20, 100, labelWidth, s.height)];
        [self.message setText:self.log.message];
        [self.contentView addSubview:self.message];
        [self setFrame:CGRectMake(0, 0, MODAL_WIDTH, [self cellHeight])];
    }
    return self;
}
- (void)labelFrame:(UILabel *)label y:(CGFloat)y {
    CGFloat labelWidth = MODAL_WIDTH - (MODAL_MARGIN * 2);
    [label setFrame:CGRectMake(20, y, labelWidth, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:16.0f]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (CGFloat)cellHeight {
    return self.message.frame.origin.y + self.message.frame.size.height + 5.0f;
}

- (void)setLog:(MGLog *)log {
    _log = log;
    CGFloat labelWidth = MODAL_WIDTH - (MODAL_MARGIN * 2);
    CGSize maxSize = CGSizeMake(labelWidth, MAXFLOAT);
    CGSize s = [self.log.message sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.message setFrame:CGRectMake(20, 100, labelWidth, s.height)];
    [self setFrame:CGRectMake(0, 0, MODAL_WIDTH, [self cellHeight])];
}
@end
