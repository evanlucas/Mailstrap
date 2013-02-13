//
//  MGUnsubscribes.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIController.h"
@interface MGUnsubscribes : NSObject
- (id)initWithAttributes:(NSDictionary *)attrs;
+ (MGUnsubscribes *)fromJSON:(NSDictionary *)jsonDict;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *mg_tag;
@property (nonatomic, strong) NSString *mg_id;
@property (nonatomic, strong) NSString *address;
+ (void)getUnsubscribesForDomain:(NSString *)domain withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *unsubscribes, NSDictionary *error))block;
+ (void)deleteUnsubscribeForID:(NSString *)unsubscribeID forDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err;
+ (void)addUnsubscribeToDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err;
@end
