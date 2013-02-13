//
//  MGBounce.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIController.h"
@interface MGBounce : NSObject
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *created_at;
- (id)initWithAttributes:(NSDictionary *)attrs;
+ (MGBounce *)fromJSON:(NSDictionary *)JSONDict;
+ (void)getBouncesForDomain:(NSString *)domain params:(NSDictionary *)params block:(void (^)(NSArray *bounces, NSDictionary *error))block;
+ (void)createBounceForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err;
+ (void)deleteBounceAtAddress:(NSString *)address domain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err;
- (CGFloat)cellHeightForWidth:(CGFloat)width;
- (CGFloat)messageHeightForWidth:(CGFloat)width;
@end
