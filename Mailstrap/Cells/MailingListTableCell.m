//
//  MailingListTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "MailingListTableCell.h"
#import "MGMailingList.h"

@implementation MailingListTableCell

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
- (id)initWithMailingList:(MGMailingList *)mailingList {
    if (self = [super init]) {
        self.mailingList = mailingList;
        self.labelName = [[UILabel alloc] init];
        [self labelFrame:self.labelName y:3];
        [self.contentView addSubview:self.labelName];
        self.labelAddress = [[UILabel alloc] init];
        [self labelFrame:self.labelAddress y:25];
        [self.contentView addSubview:self.labelAddress];
        self.labelAccessLevel = [[UILabel alloc] init];
        [self labelFrame:self.labelAccessLevel y:52];
        [self.contentView addSubview:self.labelAccessLevel];
        self.labelMembersCount = [[UILabel alloc] init];
        [self labelFrame:self.labelMembersCount y:76];
        [self.contentView addSubview:self.labelMembersCount];
        [self.labelName setText:self.mailingList.name];
        [self.labelAddress setText:self.mailingList.address];
        [self.labelAccessLevel setText:[self.mailingList.access_level capitalizedString]];
        [self.labelMembersCount setText:[NSString stringWithFormat:@"Members: %@", self.mailingList.members_count]];
        self.labelDescription = [[UILabel alloc] init];
        [self.labelDescription setBackgroundColor:[UIColor clearColor]];
        [self.labelDescription setTextColor:[UIColor whiteColor]];
        [self.labelDescription setFont:[UIFont systemFontOfSize:14.0f]];
        [self.labelDescription setNumberOfLines:0];
        CGFloat labelWidth = MODAL_WIDTH - (MODAL_MARGIN * 2);
        CGSize maxSize = CGSizeMake(labelWidth, MAXFLOAT);
        CGSize s = [self.mailingList.desc sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
        [self.labelDescription setFrame:CGRectMake(20, 100, labelWidth, s.height)];
        [self.labelDescription setText:self.mailingList.desc];
        [self.contentView addSubview:self.labelDescription];
        [self setFrame:CGRectMake(0, 0, 320, [self cellHeight])];
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

- (CGFloat)cellHeight {
    return self.labelDescription.frame.origin.y + self.labelDescription.frame.size.height + 5.0f;
}

- (void)setMailingList:(MGMailingList *)mailingList {
    _mailingList = mailingList;
    CGFloat labelWidth = MODAL_WIDTH - (MODAL_MARGIN * 2);
    CGSize maxSize = CGSizeMake(labelWidth, MAXFLOAT);
    CGSize s = [self.mailingList.desc sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.labelDescription setFrame:CGRectMake(20, 100, labelWidth, s.height)];
    [self setFrame:CGRectMake(0, 0, 320, [self cellHeight])];
}
@end
