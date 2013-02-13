//
//  MGLog.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/9/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "MGLog.h"

@implementation MGLog
- (id)initWithAttributes:(NSDictionary *)attrs {
    if (self = [super init]) {
        self.created_at = [attrs safeStringForKey:@"created_at"];
        self.hap = [attrs safeStringForKey:@"hap"];
        self.log_type = [attrs safeStringForKey:@"type"];
        self.message = [attrs safeStringForKey:@"message"];
        self.message_id = [attrs safeStringForKey:@"message_id"];
    }
    return self;
}

+ (MGLog *)fromJSON:(NSDictionary *)jsonDict {
    return [[MGLog alloc] initWithAttributes:jsonDict];
}
+ (void)getLogsForDomain:(NSString *)domain withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *domains, NSDictionary *error))block {
    NSMutableDictionary *params = [@{} mutableCopy];
    if (limit != 0) {
        params[@"limit"] = [NSString stringWithFormat:@"%d", limit];
    }
    if (skip != 0) {
        params[@"skip"] = [NSString stringWithFormat:@"%d", skip];
    }
    [[APIController sharedInstance] getLogsForDomain:domain params:params withRes:^(NSDictionary *res){
        NSArray *logs = [res objectForKey:@"items"];
        NSMutableArray *mutableLogs = [NSMutableArray arrayWithCapacity:[logs count]];
        for (NSDictionary *attributes in logs) {
            MGLog *log = [[MGLog alloc] initWithAttributes:attributes];
            [mutableLogs addObject:log];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableLogs], nil);
        }
    }err:^(NSDictionary *err){
        if (block) {
            block([NSArray array], err);
        }
    }];
}

- (CGFloat)cellHeightForWidth:(CGFloat)width {
    CGFloat margin = 5.0f;
    CGFloat defaultLabelHeight = 20.0f;
    CGFloat defaultLabelHeights = defaultLabelHeight * 4;
    CGFloat totalMargin = margin * (1 + 4);
    CGFloat origin = defaultLabelHeights + totalMargin;
    CGFloat messageHeight = [self messageHeightForWidth:width];
    return origin + messageHeight + 5.0f;
}

- (CGFloat)messageHeightForWidth:(CGFloat)width {
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    CGSize s = [self.message sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    return s.height;
}

@end
