//
//  MailingListTableCell.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGMailingList;
@interface MailingListTableCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *labelDescription;
@property (nonatomic, strong) IBOutlet UILabel *labelName;
@property (nonatomic, strong) IBOutlet UILabel *labelAddress;
@property (nonatomic, strong) IBOutlet UILabel *labelAccessLevel;
@property (nonatomic, strong) IBOutlet UILabel *labelMembersCount;
@property (nonatomic, strong) MGMailingList *mailingList;
- (id)initWithMailingList:(MGMailingList *)mailingList;
- (CGFloat)cellHeight;
@end
