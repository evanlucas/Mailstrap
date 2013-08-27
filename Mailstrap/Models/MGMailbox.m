//
//  MGMailbox.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/23/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "MGMailbox.h"

@implementation MGMailbox
- (id)initWithAttributes:(NSDictionary *)attrs {
  if (self = [super init]) {
    self.created_at = [attrs safeStringForKey:@"created_at"];
    self.mailbox = [attrs safeStringForKey:@"mailbox"];
    id s = attrs[@"size_bytes"];
    if (![s isKindOfClass:[NSNull class]]) {
      self.size_bytes = [self transformedBytes:s];
    } else {
      self.size_bytes = @"0 B";
    }
  }
  return self;
}
+ (MGMailbox *)fromJSON:(NSDictionary *)jsonDict {
  return [[MGMailbox alloc] initWithAttributes:jsonDict];
}
+ (NSArray *)sortResults:(NSArray *)res {
  return [NSArray arrayWithArray:[res sortedArrayUsingSelector:@selector(compare:)]];
}
- (NSComparisonResult)compare:(MGMailbox *)mb {
  return [self.mailbox compare:mb.mailbox];
}
+ (void)getMailboxesForDomain:(NSString *)domain withBlock:(void (^)(NSArray *, NSDictionary *))block {
  [[APIController sharedInstance] getMailboxesForDomain:domain withRes:^(NSDictionary *response){
    NSArray *mailboxes = [response objectForKey:@"items"];
    NSMutableArray *mutableMailboxes = [NSMutableArray arrayWithCapacity:[mailboxes count]];
    for (NSDictionary *attributes in mailboxes) {
      MGMailbox *mailbox = [[MGMailbox alloc] initWithAttributes:attributes];
      mailbox.domain = domain;
      if ([mailbox.mailbox rangeOfString:@"postmaster"].location != NSNotFound) {
        if ([[APIController sharedInstance] shouldShowPostmaster]) {
          [mutableMailboxes addObject:mailbox];
        }
      } else {
        [mutableMailboxes addObject:mailbox];
      }
      
    }
    
    if (block) {
      if ([[APIController sharedInstance] shouldOrderResults]) {
        NSArray *a = [self sortResults:mutableMailboxes];
        block([NSArray arrayWithArray:a], nil);
      } else {
        block([NSArray arrayWithArray:mutableMailboxes], nil);
      }
    }
    
  }err:^(NSDictionary *error){
    if (block) {
      block([NSArray array], error);
    }
  }];
}

+ (void)createMailboxForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] createMailboxForDomain:domain params:params withRes:res err:err];
}
+ (void)deleteMailbox:(NSString *)mailbox forDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] deleteMailbox:mailbox forDomain:domain withRes:res err:err];
}
+ (void)updateMailbox:(NSString *)mailbox forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] updateMailbox:mailbox forDomain:domain params:params withRes:res err:err];
}
- (id)transformedBytes:(id)value {
  double convertedValue = [value doubleValue];
  int multiplyFactor = 0;
  NSArray *tokens = @[@"B", @"KiB", @"MiB", @"GiB", @"TiB"];
  while (convertedValue > 1024) {
    convertedValue /= 1024;
    multiplyFactor++;
  }
  return [NSString stringWithFormat:@"%4.2f %@", convertedValue, tokens[multiplyFactor]];
}

@end
