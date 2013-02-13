//
//  MGMailbox.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/23/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIController.h"
@interface MGMailbox : NSObject
@property (nonatomic, strong) NSString *mailbox;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *size_bytes;
@property (nonatomic, strong) NSString *domain;
- (id)initWithAttributes:(NSDictionary *)attrs;
+ (MGMailbox *)fromJSON:(NSDictionary *)jsonDict;
+ (void)getMailboxesForDomain:(NSString *)domain withBlock:(void (^)(NSArray *mailboxes, NSDictionary *error))block;
+ (void)deleteMailbox:(NSString *)mailbox forDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err;
+ (void)updateMailbox:(NSString *)mailbox forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err;
+ (void)createMailboxForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err;
@end
