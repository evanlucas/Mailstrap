//
//  MailingListTableHeaderView.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableHeaderAboveView.h"
#import "TableHeaderBelowView.h"
@class MGMailingList;
@class TableCellBackgroundView;
@class TableCellSelectedBackgroundView;
@protocol MailingListTableHeaderViewDelegate;
@interface MailingListTableHeaderView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelAddress;
@property (nonatomic, strong) UILabel *labelMembersCount;
@property (nonatomic, strong) UILabel *labelAccessLevel;
@property (nonatomic, strong) TableCellBackgroundView *backgroundView;
@property (nonatomic, strong) TableCellSelectedBackgroundView *selectedBackgroundView;
@property (nonatomic, getter = isExpanded) BOOL expanded;
@property (nonatomic, strong) MGMailingList *mailingList;
@property (nonatomic, assign) id<MailingListTableHeaderViewDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) TableHeaderBelowView *belowView;
@property (nonatomic, strong) TableHeaderAboveView *aboveView;
@property (nonatomic, strong) UIButton *trashBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic) BOOL swiped;
- (void)toggleOpenWithUserAction:(BOOL)userAction;
- (id)initWithMailingList:(MGMailingList *)mailingList delegate:(id<MailingListTableHeaderViewDelegate>)delegate;
@end

@protocol MailingListTableHeaderViewDelegate <NSObject>
- (void)headerView:(MailingListTableHeaderView *)headerView sectionOpened:(NSInteger)section;
- (void)headerView:(MailingListTableHeaderView *)headerView sectionClosed:(NSInteger)section;
- (void)headerViewWasTapped:(MailingListTableHeaderView *)headerView;
- (void)editMailingList:(MGMailingList *)mailingList;
- (void)deleteMailingList:(MGMailingList *)mailingList;
@end