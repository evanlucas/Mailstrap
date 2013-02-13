//
//  MGRoutes.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIController.h"
@interface MGRoutes : NSObject
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) NSNumber *priority;
@property (nonatomic, strong) NSString *expression;
@property (nonatomic, strong) NSString *route_id;
- (id)initWithAttributes:(NSDictionary *)attrs;
+ (MGRoutes *)fromJSON:(NSDictionary *)jsonDict;
+ (void)getRoutesWithBlock:(void (^)(NSArray *routes, NSDictionary *error))block;
+ (void)deleteRouteID:(NSString *)routeID withRes:(MGRes)res err:(MGErr)err;
+ (void)updateRouteID:(NSString *)routeID params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err;
+ (void)createRouteWithParams:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err;
@end
