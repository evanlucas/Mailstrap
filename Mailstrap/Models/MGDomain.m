//
//  MGDomain.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "MGDomain.h"

@implementation MGDomain
- (id)initWithAttributes:(NSDictionary *)attrs {
    if (self = [super init]) {
        self.created_at = [attrs safeStringForKey:@"created_at"];
        self.name = [attrs safeStringForKey:@"name"];
    }
    return self;
}

+ (MGDomain *)fromJSON:(NSDictionary *)jsonDict {
    return [[MGDomain alloc] initWithAttributes:jsonDict];
}
+ (void)getDomainsWithBlock:(void (^)(NSArray *, NSDictionary *))block {
    [[APIController sharedInstance] getDomainsWithRes:^(NSDictionary *res){
        NSArray *domains = [res objectForKey:@"items"];
        NSMutableArray *mutableDomains = [NSMutableArray arrayWithCapacity:[domains count]];
        for  (NSDictionary *attributes in domains) {
            MGDomain *domain = [[MGDomain alloc] initWithAttributes:attributes];
            [mutableDomains addObject:domain];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableDomains], nil);
        }
    }err:^(NSDictionary *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
+ (void)getDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err {
    [[APIController sharedInstance] getDomain:domain withRes:res err:err];
}
+ (void)deleteDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err {
    [[APIController sharedInstance] deleteDomain:domain withRes:res err:err];
}

+ (void)createDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err {
    [[APIController sharedInstance] createDomain:domain withRes:res err:err];
}
@end
