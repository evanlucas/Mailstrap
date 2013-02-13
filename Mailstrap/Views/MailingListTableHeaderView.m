//
//  MailingListTableHeaderView.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "MailingListTableHeaderView.h"
#import "MGMailingList.h"
#import "AppDelegate.h"
#import "TableCellBackgroundView.h"
#import "TableCellSelectedBackgroundView.h"
#import <QuartzCore/QuartzCore.h>
@implementation MailingListTableHeaderView
- (id)initWithMailingList:(MGMailingList *)mailingList delegate:(id<MailingListTableHeaderViewDelegate>)delegate {
    CGRect frame;
    CGFloat height;
    if ([AppDelegate is_iPhone]) {
        frame = CGRectMake(0, 0, 320, 120);
        height = 25;
    } else {
        frame = CGRectMake(0, 0, 540, 170);
        height = 35;
    }
    if (self = [super initWithFrame:frame]) {
        self.backgroundView = [[TableCellBackgroundView alloc] initWithFrame:self.bounds];
        [self addSubview:self.backgroundView];
        self.selectedBackgroundView = [[TableCellSelectedBackgroundView alloc] initWithFrame:self.bounds];
        [self.selectedBackgroundView setAlpha:0.0f];
        [self addSubview:self.selectedBackgroundView];
        
        
        self.belowView = [[TableHeaderBelowView alloc] initWithFrame:self.bounds];
        
        [self addSubview:self.belowView];
        
        self.aboveView = [[TableHeaderAboveView alloc] initWithFrame:self.bounds];
        
        [self addSubview:self.aboveView];
        
        CGRect frame = ([AppDelegate is_iPhone]) ? CGRectMake(50, 40, 40.0f, 40.0f) : CGRectMake(0, 0, 60.0f, 60.0f);
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"EditBtn"] forState:UIControlStateNormal];
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"EditBtn_Selected"] forState:UIControlStateHighlighted];
        [self.editBtn setFrame:frame];
        [self.editBtn setCenter:CGPointMake(self.frame.size.width/4, 60.0f)];
        [self.editBtn setContentMode:UIViewContentModeScaleAspectFit];
        [self.editBtn addTarget:self action:@selector(editList:) forControlEvents:UIControlEventTouchUpInside];
        [self.belowView addSubview:self.editBtn];
        
        self.trashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.trashBtn setBackgroundImage:[UIImage imageNamed:@"TrashBtn"] forState:UIControlStateNormal];
        [self.trashBtn setBackgroundImage:[UIImage imageNamed:@"TrashBtn_Selected"] forState:UIControlStateHighlighted];
        frame = CGRectMake(130, 40, 40, 40);
        [self.trashBtn setFrame:frame];
        [self.trashBtn setContentMode:UIViewContentModeScaleAspectFit];
        [self.trashBtn setCenter:CGPointMake(self.frame.size.width/2, 60.0f)];
        [self.trashBtn addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self.belowView addSubview:self.trashBtn];
        
        self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.detailBtn setBackgroundImage:[UIImage imageNamed:@"DetailBtn"] forState:UIControlStateNormal];
        [self.detailBtn setBackgroundImage:[UIImage imageNamed:@"DetailBtn_Selected"] forState:UIControlStateHighlighted];
        [self.detailBtn setFrame:frame];
        [self.detailBtn setContentMode:UIViewContentModeScaleAspectFit];
        [self.detailBtn setCenter:CGPointMake((self.frame.size.width/4)*3, 60.0f)];
        [self.detailBtn addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self.belowView addSubview:self.detailBtn];
        
        
        UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        [swiper setDelegate:self];
        [swiper setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        UISwipeGestureRecognizer *swiper2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        [swiper2 setDelegate:self];
        [swiper2 setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swiper];
        [self addGestureRecognizer:swiper2];
        
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [tapper setDelegate:self];
        [self.aboveView addGestureRecognizer:tapper];
        _delegate = delegate;
        self.userInteractionEnabled = YES;
        self.mailingList = mailingList;
        self.labelName = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.frame.size.width - 40, height)];
        [self.labelName setBackgroundColor:[UIColor clearColor]];
        [self.labelName setTextColor:[UIColor whiteColor]];
        [self.labelName setText:self.mailingList.name];
        [self.aboveView addSubview:self.labelName];
        
        self.labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(20, height + 10, self.frame.size.width - 40, height)];
        [self.labelAddress setBackgroundColor:[UIColor clearColor]];
        [self.labelAddress setTextColor:[UIColor whiteColor]];
        [self.labelAddress setText:self.mailingList.address];
        [self.aboveView addSubview:self.labelAddress];
        
        self.labelAccessLevel = [[UILabel alloc] initWithFrame:CGRectMake(20, height + height + 10, self.frame.size.width - 40, height)];
        [self.labelAccessLevel setBackgroundColor:[UIColor clearColor]];
        [self.labelAccessLevel setTextColor:[UIColor whiteColor]];
        [self.labelAccessLevel setText:self.mailingList.access_level];
        [self.aboveView addSubview:self.labelAccessLevel];
        
        self.labelMembersCount = [[UILabel alloc] initWithFrame:CGRectMake(20, height*3 + 10, self.frame.size.width - 40, height)];
        [self.labelMembersCount setBackgroundColor:[UIColor clearColor]];
        [self.labelMembersCount setTextColor:[UIColor whiteColor]];
        [self.labelMembersCount setText:[NSString stringWithFormat:@"Members: %@", self.mailingList.members_count]];
        [self.aboveView addSubview:self.labelMembersCount];
    
    }
    return self;
}

- (CGPoint)originForButtonAtIndex:(NSInteger)index {
    CGFloat width = self.frame.size.width;
    CGFloat buttonWidth = ([AppDelegate is_iPhone]) ? 40.0f : 60.0f;
    CGFloat margin = width / 4;
    CGFloat y = (self.frame.size.height - buttonWidth)/2;
    CGFloat x = (index * margin) + (index * buttonWidth) + margin;
    return CGPointMake(x, y);
}
- (void)fadeInSelected {
    [UIView animateWithDuration:0.35 animations:^{
        [self.selectedBackgroundView setAlpha:1.0f];
        [self.backgroundView setAlpha:0.0f];
    }];
}
- (void)fadeOutSelected {
    [UIView animateWithDuration:0.35 animations:^{
        [self.selectedBackgroundView setAlpha:0.0f];
        [self.backgroundView setAlpha:1.0f];
    }];
}
- (void)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];
}

- (void)editList:(id)sender {
    [self.delegate editMailingList:self.mailingList];
}

- (void)doDelete:(id)sender {
    [self.delegate deleteMailingList:self.mailingList];
}
- (void)didSwipe:(UISwipeGestureRecognizer *)swiper {
    if (self.swiped) {

        [UIView animateWithDuration:0.5 animations:^{
            [self.aboveView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        }];
    } else {
        CGFloat x;
        if (swiper.direction == UISwipeGestureRecognizerDirectionRight) {
            x = self.frame.size.width;
        } else {
            x = -self.frame.size.width;
        }
        [UIView animateWithDuration:0.5 animations:^{
            [self.aboveView setFrame:CGRectMake(x, 0, self.frame.size.width, self.frame.size.height)];
        }];
    }
    self.swiped = !self.swiped;
}
- (void)didTap:(UITapGestureRecognizer *)recog {
    
    
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.center.x, self.center.y);
    CGPathAddLineToPoint(path, NULL, self.center.x - 30, self.center.y);
    CGPathAddLineToPoint(path, NULL, self.center.x + 20, self.center.y);
    CGPathAddLineToPoint(path, NULL, self.center.x - 15, self.center.y);
    CGPathAddLineToPoint(path, NULL, self.center.x + 10, self.center.y);
    CGPathAddLineToPoint(path, NULL, self.center.x - 5, self.center.y);
    CGPathAddLineToPoint(path, NULL, self.center.x, self.center.y);
    [anim setPath:path];
    [anim setDuration:1.0];
    [self.aboveView.layer addAnimation:anim forKey:@"wiggle"];
    
}
- (BOOL)isExpanded {
    return _expanded;
}
- (void)toggleOpenWithUserAction:(BOOL)userAction {
    _expanded = !_expanded;
    if (userAction) {
        if ([self isExpanded]) {
            if ([self.delegate respondsToSelector:@selector(headerView:sectionOpened:)]) {
                [self.delegate headerView:self sectionOpened:self.section];
                [self fadeInSelected];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(headerView:sectionClosed:)]) {
                [self.delegate headerView:self sectionClosed:self.section];
                [self fadeOutSelected];
            }
        }
    }
}
@end
