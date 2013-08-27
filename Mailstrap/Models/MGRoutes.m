//
//  MGRoutes.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "MGRoutes.h"

@implementation MGRoutes
- (id)initWithAttributes:(NSDictionary *)attrs {
  if (self = [super init]) {
    self.description = [attrs safeStringForKey:@"description"];
    self.created_at = [attrs safeStringForKey:@"created_at"];
    self.actions = [attrs safeArrayForKey:@"actions"];
    self.priority = attrs[@"priority"];
    self.expression = [attrs safeStringForKey:@"expression"];
    self.route_id = [attrs safeStringForKey:@"id"];
  }
  return self;
}
+ (MGRoutes *)fromJSON:(NSDictionary *)jsonDict {
  return [[MGRoutes alloc] initWithAttributes:jsonDict];
}
+ (NSArray *)sortResults:(NSArray *)res {
  return [NSArray arrayWithArray:[res sortedArrayUsingSelector:@selector(compare:)]];
}
- (NSComparisonResult)compare:(MGRoutes *)route {
  return [self.description compare:route.description];
}
+ (void)getRoutesWithBlock:(void (^)(NSArray *, NSDictionary *))block {
  [[APIController sharedInstance] getRoutesWithRes:^(NSDictionary *res){
    NSArray *routes = [res objectForKey:@"items"];
    NSMutableArray *mutableRoutes = [[NSMutableArray alloc] initWithCapacity:[routes count]];
    for (NSDictionary *d in routes) {
      MGRoutes *route = [[MGRoutes alloc] initWithAttributes:d];
      [mutableRoutes addObject:route];
    }
    
    if (block) {
      if ([[APIController sharedInstance] shouldOrderResults]) {
        NSArray *a = [self sortResults:mutableRoutes];
        block([NSArray arrayWithArray:a], nil);
      } else {
        block([NSArray arrayWithArray:mutableRoutes], nil);
      }
    }
    
  }err:^(NSDictionary *error) {
    if (block) {
      block([NSArray array], error);
    }
  }];
}

+ (void)deleteRouteID:(NSString *)routeID withRes:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] deleteRouteID:routeID withRes:res err:err];
}
+ (void)updateRouteID:(NSString *)routeID params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] updateRouteID:routeID withParams:params withRes:res err:err];
}
+ (void)createRouteWithParams:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] createRouteWithParams:params withRes:res err:err];
}
@end
