//
//  MGComplaints.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIController.h"
@interface MGComplaints : NSObject
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *count;
- (id)initWithAttributes:(NSDictionary *)attrs;
+ (MGComplaints *)fromJSON:(NSDictionary *)JSONDict;
+ (void)getComplaintsForDomain:(NSString *)domain withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *complaints, NSDictionary *error))block;
+ (void)addComplaintForAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)res withErr:(MGErr)err;
+ (void)deleteComplaintForAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)res withErr:(MGErr)err;
@end
