//
//  MGMLMember.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "MGMLMember.h"

@implementation MGMLMember
- (id)initWithAttributes:(NSDictionary *)attrs {
  if (self = [super init]) {
    self.address = [attrs safeStringForKey:@"address"];
    self.name = [attrs safeStringForKey:@"name"];
    self.subscribed = [attrs safeBoolForKey:@"subscribed"];
    self.vars = [[attrs safeArrayForKey:@"vars"] mutableCopy];
    
  }
  return self;
}
+ (MGMLMember *)fromJSON:(NSDictionary *)jsonDict {
  return [[MGMLMember alloc] initWithAttributes:jsonDict];
}
+ (NSArray *)sortResults:(NSArray *)res {
  return [NSArray arrayWithArray:[res sortedArrayUsingSelector:@selector(compare:)]];
}
- (NSComparisonResult)compare:(MGMLMember *)mb {
  return [self.address compare:mb.address];
}
+ (void)getMembersForListAddress:(NSString *)listAddr withBlock:(void (^)(NSArray *, NSDictionary *))block {
  [[APIController sharedInstance] getMailingListMembersWithAddress:listAddr withRes:^(NSDictionary *res){
    NSArray *members = [res objectForKey:@"items"];
    NSMutableArray *mutableMembers = [[NSMutableArray alloc] initWithCapacity:[members count]];
    for (NSDictionary *d in members) {
      MGMLMember *member = [[MGMLMember alloc] initWithAttributes:d];
      [member setListAddress:listAddr];
      [mutableMembers addObject:member];
    }
    
    if (block) {
      if ([[APIController sharedInstance] shouldOrderResults]) {
        NSArray *a = [self sortResults:mutableMembers];
        block([NSArray arrayWithArray:a], nil);
      } else {
        block([NSArray arrayWithArray:mutableMembers], nil);
      }
    }
  }err:^(NSDictionary *err){
    if (block) {
      block([NSArray array], err);
    }
  }];
}
+ (void)addMemberForListWithAddress:(NSString *)listAddr params:(NSDictionary *)params res:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] addMemberToMailingListWithAddress:listAddr params:params withRes:res err:err];
}
@end
