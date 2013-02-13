//
//  CampaignRootTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "CampaignRootTableCell.h"

@implementation CampaignRootTableCell
- (id)initWithTitle:(NSString *)title value:(NSString *)value {
    if (self = [super initWithFrame:CGRectMake(0, 0, MODAL_WIDTH, 50)]) {
        self.title = title;
        self.value = value;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
