//
//  BouncesTableCell.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGBounce;
@interface BouncesTableCell : UITableViewCell
- (id)initWithBounce:(MGBounce *)bounce;
@property (nonatomic, strong) MGBounce *bounce;
@end
