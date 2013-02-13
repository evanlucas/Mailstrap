//
//  MGMLMember.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIController.h"
@interface MGMLMember : NSObject
@property (nonatomic, strong) NSString *address;
@property (nonatomic) BOOL subscribed;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *vars;
@property (nonatomic, strong) NSString *listAddress;
- (id)initWithAttributes:(NSDictionary *)attrs;
+ (MGMLMember *)fromJSON:(NSDictionary *)jsonDict;
+ (void)getMembersForListAddress:(NSString *)listAddr withBlock:(void (^)(NSArray *members, NSDictionary *error))block;
+ (void)addMemberForListWithAddress:(NSString *)listAddr params:(NSDictionary *)params res:(MGRes)res err:(MGErr)err;
@end
