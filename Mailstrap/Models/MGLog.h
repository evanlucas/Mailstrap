//
//  MGLog.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/9/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIController.h"
@interface MGLog : NSObject
@property (nonatomic, strong) NSString *hap;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *log_type;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *message_id;
- (id)initWithAttributes:(NSDictionary *)attrs;
+ (MGLog *)fromJSON:(NSDictionary *)jsonDict;
+ (void)getLogsForDomain:(NSString *)domain withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *logs, NSDictionary *error))block;
- (CGFloat)cellHeightForWidth:(CGFloat)width;
- (CGFloat)messageHeightForWidth:(CGFloat)width;
@end
