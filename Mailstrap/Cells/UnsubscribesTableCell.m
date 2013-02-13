//
//  UnsubscribesTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "UnsubscribesTableCell.h"
#import "MGUnsubscribes.h"
@interface UnsubscribesTableCell ()
@property (nonatomic, strong) UILabel *labelCreatedAt;
@property (nonatomic, strong) UILabel *labelAddress;
@property (nonatomic, strong) UILabel *labelID;
@property (nonatomic, strong) UILabel *labelTag;
@end
@implementation UnsubscribesTableCell
- (id)initWithUnsubscribes:(MGUnsubscribes *)unsubscribe {
    if (self = [super init]) {
        self.unsubscribe = unsubscribe;
        self.labelCreatedAt = [[UILabel alloc] init];
        [self labelFrame:self.labelCreatedAt y:5];
        [self.labelCreatedAt setText:self.unsubscribe.created_at];
        [self.contentView addSubview:self.labelCreatedAt];
        self.labelAddress = [[UILabel alloc] init];
        [self labelFrame:self.labelAddress y:30];
        [self.labelAddress setText:self.unsubscribe.address];
        [self.contentView addSubview:self.labelAddress];
        
        
        self.labelID = [[UILabel alloc] init];
        [self labelFrame:self.labelID y:55];
        [self.labelID setText:[NSString stringWithFormat:@"ID: %@", self.unsubscribe.mg_id]];
        [self.contentView addSubview:self.labelID];
        
        self.labelTag = [[UILabel alloc] init];
        [self labelFrame:self.labelTag y:80];
        [self.labelTag setText:[NSString stringWithFormat:@"Tag: %@", self.unsubscribe.mg_tag]];
        [self.contentView addSubview:self.labelTag];
        
        [self setFrame:CGRectMake(0, 0, MODAL_WIDTH, 105)];
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
