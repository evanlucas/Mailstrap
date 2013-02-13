//
//  ComplaintsTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ComplaintsTableCell.h"
#import "MGComplaints.h"

@interface ComplaintsTableCell ()
@property (nonatomic, strong) UILabel *labelCreatedAt;
@property (nonatomic, strong) UILabel *labelAddress;
@property (nonatomic, strong) UILabel *labelCount;
@end
@implementation ComplaintsTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithComplaints:(MGComplaints *)complaint {
    if (self = [super init]) {
        self.complaint = complaint;
        self.labelCreatedAt = [[UILabel alloc] init];
        [self labelFrame:self.labelCreatedAt y:5];
        [self.labelCreatedAt setText:self.complaint.created_at];
        [self.contentView addSubview:self.labelCreatedAt];
        
        self.labelAddress = [[UILabel alloc] init];
        [self labelFrame:self.labelAddress y:30];
        [self.labelAddress setText:self.complaint.address];
        [self.contentView addSubview:self.labelAddress];
        
        self.labelCount = [[UILabel alloc] init];
        [self labelFrame:self.labelCount y:55];
        [self.labelCount setText:[NSString stringWithFormat:@"Count: %@", self.complaint.count]];
        [self.contentView addSubview:self.labelCount];
        [self setFrame:CGRectMake(0, 0, MODAL_WIDTH, 80)];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)labelFrame:(UILabel *)label y:(CGFloat)y {
    CGFloat labelWidth = MODAL_WIDTH - (MODAL_MARGIN * 2);
    [label setFrame:CGRectMake(20, y, labelWidth, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:16.0f]];
}

@end