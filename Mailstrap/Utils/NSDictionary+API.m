//
//  NSDictionary+API.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "NSDictionary+API.h"

@implementation NSDictionary (API)
- (id)valueForKey:(NSString *)key defaultsTo:(id)defaultValue {
	id value = [self valueForKey:key];
	return (value != nil && value != [NSNull null]) ? value : defaultValue;
}

- (id)valueForKeyPath:(NSString *)keyPath defaultsTo:(id)defaultValue {
	id value = [self valueForKeyPath:keyPath];
	return (value != nil && value != [NSNull null]) ? value : defaultValue;
}

- (BOOL)safeBoolForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:nil];
	return (!value || value == [NSNull null]) ? (BOOL)nil : [value boolValue];
}

- (BOOL)safeBoolForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:nil];
	return (!value || value == [NSNull null]) ? (BOOL)nil : [value boolValue];
}

- (NSInteger)safeIntegerForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:nil];
	return (!value || value == [NSNull null]) ? (int)nil : [value integerValue];
}

- (NSInteger)safeIntegerForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:nil];
	return (!value || value == [NSNull null]) ? (int)nil : [value integerValue];
}

- (NSDictionary *)safeDictForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:@""];
	return ([value isKindOfClass:NSDictionary.class]) ? value : nil;
}

- (NSDictionary *)safeDictForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:@""];
	return ([value isKindOfClass:NSDictionary.class]) ? value : nil;
}

- (NSString *)safeStringForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:@""];
	return ([value isKindOfClass:NSString.class]) ? value : @"";
}

- (NSString *)safeStringForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:@""];
	return ([value isKindOfClass:NSString.class]) ? value : @"";
}

- (NSArray *)safeArrayForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:nil];
	return ([value isKindOfClass:NSArray.class]) ? value : nil;
}

- (NSArray *)safeArrayForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:nil];
	return ([value isKindOfClass:NSArray.class]) ? value : nil;
}

- (NSDate *)safeDateForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:nil];
	return ([value isKindOfClass:NSDate.class]) ? value : nil;
}

- (NSDate *)safeDateForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:nil];
	return ([value isKindOfClass:NSDate.class]) ? value : nil;
}

@end
