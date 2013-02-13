//
//  MGMailingList.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIController.h"
@interface MGMailingList : NSObject
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *access_level;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *members_count;

- (id)initWithAttributes:(NSDictionary *)attrs;
+ (MGMailingList *)fromJSON:(NSDictionary *)jsonDict;
+ (void)getMailingListsWithBlock:(void (^)(NSArray *lists, NSDictionary *error))block;
+ (void)deleteMailingList:(NSString *)list withRes:(MGRes)res err:(MGErr)err;
+ (void)updateMailingList:(NSString *)list params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err;
+ (void)createMailingListWithParams:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err;
- (CGFloat)cellHeightForWidth:(CGFloat)width;
- (CGFloat)messageHeightForWidth:(CGFloat)width;
@end
