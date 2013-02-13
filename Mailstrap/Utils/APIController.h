//
//  APIController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/20/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

typedef enum MailgunMethod{
    MailgunMethodGET = 0,
    MailgunMethodPOST,
    MailgunMethodPUT,
    MailgunMethodDELETE
}MailgunMethod;

typedef void (^MGRes)(NSDictionary *response);
typedef void (^MGErr)(NSDictionary *error);


@interface APIController : NSObject
@property (nonatomic, strong) KeychainItemWrapper *apiKeyItem;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *currentDomain;
@property (nonatomic) BOOL shouldShowPostmaster;

// Temp
- (void)loginWithUsername:(NSString *)username password:(NSString *)password res:(MGRes)resBlock err:(MGErr)errBlock;
- (void)loginWithAPIKey:(NSString *)apiKey res:(MGRes)resBlock err:(MGErr)errBlock;
@property (nonatomic, strong) NSString *tempAPIUrl;
@property (nonatomic, strong) NSString *tempAPIKey;
// End Temp
+ (APIController *)sharedInstance;
- (void)setApiKey:(NSString *)apiKey;
- (void)setCurrentDomain:(NSString *)currentDomain;
- (void)setShouldShowPostmaster:(BOOL)shouldShowPostmaster;
- (BOOL)isSetup;
- (void)checkFirstRun;

#pragma mark Push
- (void)sendToken:(NSString *)token;

#pragma mark Main Request Method
- (void)performRequestOnPath:(NSString *)path method:(MailgunMethod)method params:(NSDictionary *)params responseBlock:(MGRes)responseBlock errorBlock:(MGErr)errorBlock;

#pragma mark Method Type Specific Request Methods
- (void)getRequestOnPath:(NSString *)path params:(NSDictionary *)params res:(MGRes)resBlock err:(MGErr)errBlock;
- (void)putRequestOnPath:(NSString *)path params:(NSDictionary *)params res:(MGRes)resBlock err:(MGErr)errBlock;
- (void)postRequestOnPath:(NSString *)path params:(NSDictionary *)params res:(MGRes)resBlock err:(MGErr)errBlock;
- (void)deleteRequestOnPath:(NSString *)path params:(NSDictionary *)params res:(MGRes)resBlock err:(MGErr)errBlock;

#pragma mark Path Specific Request Methods

// Domains
- (void)getDomainsWithRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)deleteDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)createDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;

// Mailboxes
- (void)getMailboxesForDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)createMailboxForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)updateMailbox:(NSString *)mailbox forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)deleteMailbox:(NSString *)mailbox forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;

// Mailing Lists
- (void)getMailingListsWithRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getMailingListWithAddress:(NSString *)address withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)createMailingListWithParams:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)updateMailingListWithAddress:(NSString *)address params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)deleteMailingListWithAddress:(NSString *)address withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getMailingListMembersWithAddress:(NSString *)address withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getMailingListMembersWithListAddress:(NSString *)listAddress memberAddress:(NSString *)memberAddress withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)addMemberToMailingListWithAddress:(NSString *)address params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)updateMember:(NSString *)memberAddress onMailingListWithAddress:(NSString *)address params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)deleteMember:(NSString *)memberAddress onMailingListWithAddress:(NSString *)address withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getMailingListStatsWithAddress:(NSString *)address withRes:(MGRes)resBlock err:(MGErr)errBlock;

// Routes
- (void)getRoutesWithRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getRouteID:(NSString *)routeID params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)createRouteWithParams:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)updateRouteID:(NSString *)routeID withParams:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)deleteRouteID:(NSString *)routeID withRes:(MGRes)resBlock err:(MGErr)errBlock;

// Logs
- (void)getLogsForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;

// Campaigns
- (void)getCampaignsForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getCampaign:(NSString *)campaignid forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)createCampaignForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)updateCampaign:(NSString *)campaignid forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)deleteCampaign:(NSString *)campaignID forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getCampaignEvents:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getCampaignStats:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getCampaignClicks:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getCampaignOpens:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getCampaignUnsubscribes:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getCampaignComplaints:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
// Bounces

- (void)getBouncesForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getBounceAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)createBounceForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)deleteBounceWithAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;

// Complaints
- (void)getComplaintsForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getComplaintAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)createComplaintForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)deleteComplaintAtAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;
// Unsubscribes

- (void)getUnsubscribesForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)getUnsubscribeAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)deleteUnsubscribeForAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock;
- (void)createUnsubscribeForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock;

@end
