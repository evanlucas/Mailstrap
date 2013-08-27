//
//  MGCampaign.m
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "MGCampaign.h"

@implementation MGCampaign
- (id)initWithAttributes:(NSDictionary *)attrs {
  if (self = [super init]) {
    self.delivered_count = attrs[@"delivered_count"];
    self.name = [attrs safeStringForKey:@"name"];
    self.created_at = [attrs safeStringForKey:@"created_at"];
    self.clicked_count = attrs[@"clicked_count"];
    self.opened_count = attrs[@"opened_count"];
    self.submitted_count = attrs[@"submitted_count"];
    self.unsubscribed_count = attrs[@"unsubscribed_count"];
    self.bounced_count = attrs[@"bounced_count"];
    self.campaign_id = [attrs safeStringForKey:@"id"];
    self.dropped_count = attrs[@"dropped_count"];
    self.complained_count = attrs[@"complained_count"];
  }
  return self;
}
+ (MGCampaign *)fromJSON:(NSDictionary *)JSONDict {
  return [[MGCampaign alloc] initWithAttributes:JSONDict];
}
+ (NSArray *)sortResults:(NSArray *)res {
  return [NSArray arrayWithArray:[res sortedArrayUsingSelector:@selector(compare:)]];
}
- (NSComparisonResult)compare:(MGCampaign *)camp {
  return [self.name compare:camp.name];
}

+ (void)getCampaignsForDomain:(NSString *)domain params:(NSDictionary *)params block:(void (^)(NSArray *campaigns, NSDictionary *err))block {
  [[APIController sharedInstance] getCampaignsForDomain:domain params:params withRes:^(NSDictionary *res){
    NSArray *campaigns = res[@"items"];
    NSMutableArray *mutableCampaigns = [[NSMutableArray alloc] initWithCapacity:[campaigns count]];
    for (NSDictionary *attrs in campaigns) {
      MGCampaign *campaign = [[MGCampaign alloc] initWithAttributes:attrs];
      [mutableCampaigns addObject:campaign];
    }
    
    if (block) {
      if ([[APIController sharedInstance] shouldOrderResults]) {
        NSArray *a = [self sortResults:mutableCampaigns];
        block([NSArray arrayWithArray:a], nil);
      } else {
        block([NSArray arrayWithArray:mutableCampaigns], nil);
      }
    }
  }err:^(NSDictionary *err){
    log_detail(@"Error: %@", err);
    if (block) {
      block([NSArray array], err);
    }
  }];
}
- (NSString *)name {
  if (_name) return _name;
  return @"";
}
- (NSNumber *)clicked_count {
  if (_clicked_count) return _clicked_count;
  return @0;
}
- (NSNumber *)delivered_count {
  if (_delivered_count) return _delivered_count;
  return @0;
}
- (NSNumber *)submitted_count {
  if (_submitted_count) return _submitted_count;
  return @0;
}
- (NSNumber *)opened_count {
  if (_opened_count) return _opened_count;
  return @0;
}
- (NSNumber *)unsubscribed_count {
  if (_unsubscribed_count) return _unsubscribed_count;
  return @0;
}
- (NSNumber *)bounced_count {
  if (_bounced_count) return _bounced_count;
  return @0;
}
- (NSString *)created_at {
  if (_created_at) return _created_at;
  return @"";
}
- (NSNumber *)dropped_count {
  if (_dropped_count) return _dropped_count;
  return @0;
}
- (NSNumber *)complained_count {
  if (_complained_count) return _complained_count;
  return @0;
}
+ (void)getCampaignID:(NSString *)campaignID forDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] getCampaign:campaignID forDomain:domain withRes:res err:err];
}

+ (void)createCampaignForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] createCampaignForDomain:domain params:params withRes:res err:err];
}

+ (void)deleteCampaignID:(NSString *)campaignID forDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] deleteCampaign:campaignID forDomain:domain withRes:res err:err];
}

+ (void)updateCampaignID:(NSString *)campaignID forDomain:(NSString *)domain withParams:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err {
  [[APIController sharedInstance] updateCampaign:campaignID forDomain:domain params:params withRes:res err:err];
}
- (NSDictionary *)dictValue {
  return @{
           @"Dropped" : self.dropped_count,
           @"Delivered": self.delivered_count,
           @"Bounced": self.bounced_count,
           @"Created": self.created_at,
           @"Unsubscribed": self.unsubscribed_count,
           @"Opened": self.opened_count,
           @"Submitted": self.submitted_count,
           @"Clicked": self.clicked_count,
           @"Name": self.name,
           @"ID": self.campaign_id,
           @"Complained": self.complained_count
           };
}
@end
