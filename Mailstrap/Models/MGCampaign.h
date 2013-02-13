//
//  MGCampaign.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIController.h"
@interface MGCampaign : NSObject
@property (nonatomic, strong) NSNumber *delivered_count;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSNumber *clicked_count;
@property (nonatomic, strong) NSNumber *opened_count;
@property (nonatomic, strong) NSNumber *submitted_count;
@property (nonatomic, strong) NSNumber *unsubscribed_count;
@property (nonatomic, strong) NSNumber *bounced_count;
@property (nonatomic, strong) NSString *campaign_id;
@property (nonatomic, strong) NSNumber *dropped_count;
@property (nonatomic, strong) NSNumber *complained_count;
- (id)initWithAttributes:(NSDictionary *)attrs;
+ (MGCampaign *)fromJSON:(NSDictionary *)JSONDict;
+ (void)getCampaignsForDomain:(NSString *)domain params:(NSDictionary *)params block:(void(^)(NSArray *campaigns, NSDictionary *err))block;
+ (void)getCampaignID:(NSString *)campaignID forDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err;
+ (void)createCampaignForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err;
+ (void)updateCampaignID:(NSString *)campaignID forDomain:(NSString *)domain withParams:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err;
+ (void)deleteCampaignID:(NSString *)campaignID forDomain:(NSString *)domain withRes:(MGRes)res err:(MGErr)err;
- (NSDictionary *)dictValue;
@end
