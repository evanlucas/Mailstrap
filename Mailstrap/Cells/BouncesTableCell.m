//
//  BouncesTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "BouncesTableCell.h"
#import "MGBounce.h"
@interface BouncesTableCell ()
@property (nonatomic, strong) UILabel *labelAddress;
@property (nonatomic, strong) UILabel *labelCode;
@property (nonatomic, strong) UILabel *labelError;
@property (nonatomic, strong) UILabel *labelCreatedAt;
@end
@implementation BouncesTableCell

- (id)initWithBounce:(MGBounce *)bounce {
    if (self = [super initWithFrame:CGRectMake(0, 0, MODAL_WIDTH, 80)]) {
        self.bounce = bounce;
        
        self.labelCreatedAt = [[UILabel alloc] init];
        [self labelFrame:self.labelCreatedAt y:5];
        [self.labelCreatedAt setText:self.bounce.created_at];
        [self.contentView addSubview:self.labelCreatedAt];
        
        self.labelAddress = [[UILabel alloc] init];
        [self labelFrame:self.labelAddress y:30];
        [self.labelAddress setText:self.bounce.address];
        [self.contentView addSubview:self.labelAddress];
        
        self.labelCode = [[UILabel alloc] init];
        [self labelFrame:self.labelCode y:55];
        [self.labelCode setText:[NSString stringWithFormat:@"Code: %@", self.bounce.code]];
        [self.contentView addSubview:self.labelCode];
        
        self.labelError = [[UILabel alloc] init];
        [self.labelError setBackgroundColor:[UIColor clearColor]];
        [self.labelError setTextColor:[UIColor whiteColor]];
        [self.labelError setFont:[UIFont systemFontOfSize:14.0f]];
        [self.labelError setNumberOfLines:0];
        CGFloat labelWidth = MODAL_WIDTH - (MODAL_MARGIN * 2);
        CGSize maxSize = CGSizeMake(labelWidth, MAXFLOAT);
        CGSize s = [self.bounce.error sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
        [self.labelError setFrame:CGRectMake(20, 100, labelWidth, s.height)];
        [self.labelError setText:self.bounce.error];
        [self.contentView addSubview:self.labelError];
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
