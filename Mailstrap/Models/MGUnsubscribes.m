//
//  MGUnsubscribes.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "MGUnsubscribes.h"

@implementation MGUnsubscribes
- (id)initWithAttributes:(NSDictionary *)attrs {
    if (self = [super init]) {
        self.mg_id = [attrs safeStringForKey:@"id"];
        self.mg_tag = [attrs safeStringForKey:@"tag"];
        self.address = [attrs safeStringForKey:@"address"];
        self.created_at = [attrs safeStringForKey:@"created_at"];
    }
    return self;
}

+ (MGUnsubscribes *)fromJSON:(NSDictionary *)jsonDict {
    return [[MGUnsubscribes alloc] initWithAttributes:jsonDict];
}

+ (void)getUnsubscribesForDomain:(NSString *)domain withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *, NSDictionary *))block {
    NSMutableDictionary *params = [@{} mutableCopy];
    if (limit != 0) {
        params[@"limit"] = [NSString stringWithFormat:@"%d", limit];
    }
    if (skip != 0) {
        params[@"skip"] = [NSString stringWithFormat:@"%d", skip];
    }
    [[APIController sharedInstance] getUnsubscribesForDomain:domain params:params withRes:^(NSDictionary *res) {
        NSArray *unsubscribes = [res objectForKey:@"items"];
        NSMutableArray *mutableUnsubscribes = [NSMutableArray arrayWithCapacity:[unsubscribes count]];
        for (NSDictionary *attributes in unsubscribes) {
            MGUnsubscribes *unsubscribe = [[MGUnsubscribes alloc] initWithAttributes:attributes];
            [mutableUnsubscribes addObject:unsubscribe];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableUnsubscribes], nil);
        }
    }err:^(NSDictionary *err){
        if (block) {
            block([NSArray array], err);
        }
    }];
}
+ (void)addUnsubscribeToDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err {
    [[APIController sharedInstance] createUnsubscribeForDomain:domain params:params withRes:res err:err];
}

+ (void)deleteUnsubscribeForID:(NSString *)unsubscribeID forDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err {
    [[APIController sharedInstance] deleteUnsubscribeForAddress:unsubscribeID forDomain:domain withRes:res err:err];
}

@end
