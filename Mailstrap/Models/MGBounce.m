//
//  MGBounce.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "MGBounce.h"

@implementation MGBounce
- (id)initWithAttributes:(NSDictionary *)attrs {
    if (self = [super init]) {
        self.address = [attrs safeStringForKey:@"address"];
        self.code = attrs[@"code"];
        self.error = [attrs safeStringForKey:@"error"];
        self.created_at = [attrs safeStringForKey:@"created_at"];
    }
    return self;
}
+ (MGBounce *)fromJSON:(NSDictionary *)JSONDict {
    return [[MGBounce alloc] initWithAttributes:JSONDict];
}
+ (void)getBouncesForDomain:(NSString *)domain params:(NSDictionary *)params block:(void (^)(NSArray *, NSDictionary *))block {
    [[APIController sharedInstance] getBouncesForDomain:domain params:params withRes:^(NSDictionary *res){
        NSArray *bounces = [res objectForKey:@"items"];
        NSMutableArray *mutableBounces = [[NSMutableArray alloc] initWithCapacity:[bounces count]];
        for (NSDictionary *attrs in bounces) {
            MGBounce *bounce = [[MGBounce alloc] initWithAttributes:attrs];
            [mutableBounces addObject:bounce];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableBounces], nil);
        }
    }err:^(NSDictionary *err){
        if (block) {
            block([NSArray array], err);
        }
    }];
}

+ (void)deleteBounceAtAddress:(NSString *)address domain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err {
    [[APIController sharedInstance] deleteBounceWithAddress:address forDomain:domain withRes:res err:err];
}

+ (void)createBounceForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err {
    [[APIController sharedInstance] createBounceForDomain:domain params:params withRes:res err:err];
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
    CGSize s = [self.error sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    return s.height;
}
@end
