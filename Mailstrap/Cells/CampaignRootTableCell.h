//
//  CampaignRootTableCell.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampaignRootTableCell : UITableViewCell
- (id)initWithTitle:(NSString *)title value:(NSString *)value;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;
@end
