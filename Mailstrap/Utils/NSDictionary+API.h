//
//  NSDictionary+API.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (API)
- (id)valueForKey:(NSString *)key defaultsTo:(id)defaultValue;
- (id)valueForKeyPath:(NSString *)keyPath defaultsTo:(id)defaultValue;
- (BOOL)safeBoolForKey:(NSString *)key;
- (BOOL)safeBoolForKeyPath:(NSString *)keyPath;
- (NSInteger)safeIntegerForKey:(NSString *)key;
- (NSInteger)safeIntegerForKeyPath:(NSString *)keyPath;
- (NSDictionary *)safeDictForKey:(NSString *)key;
- (NSDictionary *)safeDictForKeyPath:(NSString *)keyPath;
- (NSString *)safeStringForKey:(NSString *)key;
- (NSString *)safeStringForKeyPath:(NSString *)keyPath;
- (NSArray *)safeArrayForKey:(NSString *)key;
- (NSArray *)safeArrayForKeyPath:(NSString *)keyPath;
- (NSDate *)safeDateForKey:(NSString *)key;
- (NSDate *)safeDateForKeyPath:(NSString *)keyPath;
@end
