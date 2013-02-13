//
//  MGComplaints.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "MGComplaints.h"
#import "APIController.h"
@implementation MGComplaints
- (id)initWithAttributes:(NSDictionary *)attrs {
    if (self = [super init]) {
        self.created_at = [attrs safeStringForKey:@"created_at"];
        self.address = [attrs safeStringForKey:@"address"];
        self.count = [attrs objectForKey:@"count"];
    }
    return self;
}
+ (MGComplaints *)fromJSON:(NSDictionary *)JSONDict {
    return [[MGComplaints alloc] initWithAttributes:JSONDict];
}
+ (void)getComplaintsForDomain:(NSString *)domain withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *, NSDictionary *))block {
    NSMutableDictionary *params = [@{} mutableCopy];
    if (limit != 0) {
        params[@"limit"] = [NSString stringWithFormat:@"%d", limit];
    }
    if (skip != 0) {
        params[@"skip"] = [NSString stringWithFormat:@"%d", skip];
    }
    [[APIController sharedInstance] getComplaintsForDomain:domain params:params withRes:^(NSDictionary *res){
        NSArray *complaints = [res objectForKey:@"items"];
        NSMutableArray *mutableComplaints = [NSMutableArray arrayWithCapacity:[complaints count]];
        for (NSDictionary *attributes in complaints) {
            MGComplaints *complaint = [[MGComplaints alloc] initWithAttributes:attributes];
            [mutableComplaints addObject:complaint];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableComplaints], nil);
        }
        
    }err:^(NSDictionary *err){
        if (block) {
            block([NSArray array], err);
        }
    }];
}
+ (void)addComplaintForAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)res withErr:(MGErr)err {
    [[APIController sharedInstance] createComplaintForDomain:domain params:@{@"address" : address} withRes:res err:err];
}
+ (void)deleteComplaintForAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)res withErr:(MGErr)err {
    [[APIController sharedInstance] deleteComplaintAtAddress:address forDomain:domain withRes:res err:err];
}
@end
