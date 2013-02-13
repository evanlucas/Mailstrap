//
//  ProgressTableCell.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ProgressTableCell.h"


@interface ProgressTableCell ()
@property (nonatomic, strong) UILabel *messageLabel;
@end
@implementation ProgressTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, MODAL_WIDTH, 65)]) {
        // Make progress view have 20px of margin on each side and be half of the height
        CGFloat margin = 20.0f;
        CGRect frame;
        frame.size.width = self.frame.size.width - (margin * 2);
        frame.size.height = 20;
        frame.origin.x = margin;
        frame.origin.y = 15;
        if (iPad) {
            frame.size.width = MODAL_WIDTH - 100;
            frame.origin.x = (MODAL_WIDTH - (MODAL_WIDTH - 100))/2;
        }
        self.progressView = [[IndeterminateProgressView alloc] initWithFrame:frame];
        [self.progressView setBorderRadius:10.0f];
        [self.contentView addSubview:self.progressView];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 20)];
        [self.messageLabel setBackgroundColor:[UIColor clearColor]];
        [self.messageLabel setTextColor:[UIColor whiteColor]];
        [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.messageLabel];
        [self setFrame:CGRectMake(0, 0, MODAL_WIDTH, 65)];
        
    }
    return self;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    [self.messageLabel setText:message];
    [self setFrame:CGRectMake(0, 0, MODAL_WIDTH, 65)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    CGFloat margin = 20.0f;
    CGRect frame;
    frame.size.width = self.frame.size.width - (margin * 2);
    frame.size.height = 20;
    frame.origin.x = margin;
    frame.origin.y = 15;
    if (iPad) {
        frame.size.width = MODAL_WIDTH - 100;
        frame.origin.x = (MODAL_WIDTH - (MODAL_WIDTH - 100))/2;
    }
    [self.progressView setFrame:frame];
    [self.messageLabel setFrame:CGRectMake(0, 40, self.frame.size.width, 20)];
    [self setFrame:CGRectMake(0, 0, MODAL_WIDTH, 65)];
}

- (void)startProgressing {
    if (self.progressView) {
        [self.progressView startProgressing];
    }
}
- (void)stopProgressing {
    if (self.progressView) {
        [self.progressView stopProgressing];
    }
}
@end
