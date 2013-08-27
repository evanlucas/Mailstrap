//
//  MGDomain.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIController.h"
@interface MGDomain : NSObject
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *name;
- (id)initWithAttributes:(NSDictionary *)attrs;
+ (MGDomain *)fromJSON:(NSDictionary *)jsonDict;
+ (void)getDomainsWithBlock:(void (^)(NSArray *domains, NSDictionary *error))block;
+ (void)getDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err;
+ (void)deleteDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err;
+ (void)createDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err;
- (NSComparisonResult)compare:(MGDomain *)dom;
@end
