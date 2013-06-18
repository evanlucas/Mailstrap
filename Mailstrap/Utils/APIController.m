//
//  APIController.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/20/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "APIController.h"
#import "AFNetworking.h"
#import "Alerter.h"
#import "BlockAlertView.h"
static NSString *const kAPIClientBaseURLString = @"https://api.mailgun.net";
static NSString *const kAPIPushClientBaseURLString = @"http://push.mailstrap.com";
@implementation APIController
@synthesize apiKey = _apiKey;
@synthesize currentDomain = _currentDomain;
static APIController *controller = nil;
+ (APIController *)sharedInstance {
    @synchronized(self) {
        if (controller == nil) {
            controller = [[super alloc] init];
        }
    }
    return controller;
}
- (void)loginWithUsername:(NSString *)username password:(NSString *)password res:(MGRes)resBlock err:(MGErr)errBlock {
    if (!username || [username isEqualToString:@""]) {
        log_detail(@"No email provided");
        errBlock(@{@"status": @"error", @"message": @"No email provided"});
    }
    
    if (!password || [password isEqualToString:@""]) {
        log_detail(@"No password provided");
        errBlock(@{@"status": @"error", @"message": @"No password provided"});
    }
    NSString *urlString = @"https://mailgun.com";
    NSDictionary *formData = @{@"email" : username, @"password": password, @"remember": @"1", @"submit": @"Login"};
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/sessions" parameters:formData];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id response){
        NSString *res = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        if ([self parseStringForCodeBlock:res]) {
            resBlock(@{@"key": self.tempAPIKey});
        } else {
            log_detail(@"Unable to find API Key");
            if ([res rangeOfString:@"Invalid email or password"].location != NSNotFound) {
                errBlock(@{@"status": @"error", @"message": @"Invalid email or password"});
            } else {
                errBlock(@{@"status": @"error", @"message": @"Unable to find API Key."});
            }
        }
        //NSLog(@"Response: %@", res);
    }failure:^(AFHTTPRequestOperation *op, NSError *error){
        log_detail(@"ERROR: %@", error);
        errBlock(@{@"status": @"error", @"message": error});
    }];
    
    [operation start];
}


- (void)loginWithAPIKey:(NSString *)apiKey res:(MGRes)resBlock err:(MGErr)errBlock {
    NSURL *url = [NSURL URLWithString:kAPIClientBaseURLString];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            [Alerter showNotConnectedError];
        }
        NSDictionary *errorDict = @{@"status" : @"error", @"message": @"Unable to connect"};
        errBlock(errorDict);
        return;
    }];
    [client setAuthorizationHeaderWithUsername:@"api" password:apiKey];
    NSMutableURLRequest *request = [client requestWithMethod:[self method:MailgunMethodGET] path:@"/v2/domains" parameters:nil];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSError *parseError = NULL;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&parseError];
        if (!parseError) {
            resBlock(response);
            return;
        } else {
            log_detail(@"Parse Errog: %@", parseError);
            NSDictionary *d = @{@"status" : @"error", @"message": parseError};
            errBlock(d);
            return;
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSDictionary *errorDict;
        
        NSError *e = NULL;
        NSData *a = [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding];
        if (!a) {
            log_detail(@"Request Failed Error: %@", error.localizedDescription);
            if (error.localizedDescription) {
                if ([error.localizedDescription rangeOfString:@"offline"].location != NSNotFound) {
                    [Alerter showNotConnectedError];
                    return;
                }
            }
        }
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:a options:NSJSONReadingAllowFragments error:&e];
        if (!e) {
            errorDict = @{@"status" : @"error", @"message": d[@"message"]};
            errBlock(errorDict);
        } else {
            errorDict = @{@"status" : @"error", @"message": error.localizedRecoverySuggestion};
            errBlock(errorDict);
        }
        
        return;
    }];
    
    [op start];
}
- (BOOL)parseStringForCodeBlock:(NSString *)s {
    NSScanner *scanner = [NSScanner scannerWithString:s];
    // Make sure that the account information header is available
    if(![scanner scanUpToString:@"<h1>Account Information</h1>" intoString:nil]) {
        log_detail(@"Unable to find account information");
        return NO;
    }
    
    // Make sure we can find the <code> block (that is where the API Key resides)
    if (![scanner scanUpToString:@"<code>" intoString:nil]) {
        log_detail(@"Unable to find <code> block");
        return NO;
    }
    
    // Make sure the API URL and API Key values are present
    if (![scanner scanUpToString:@"API URL :" intoString:nil]) {
        log_detail(@"Unable to find API URL : field");
        return NO;
    }
    
    if (![scanner scanString:@"API URL :" intoString:nil]) {
        log_detail(@"Unable to scan API URL :");
        return NO;
    }
    NSString *apiurl = NULL;
    if (![scanner scanUpToString:@"API Key :" intoString:&apiurl]) {
        log_detail(@"Unable to find API URL Field");
        return NO;
    }
    
    if (![scanner scanString:@"API Key :" intoString:nil]) {
        log_detail(@"Unable to scan API Key :");
        return NO;
    }
    self.tempAPIUrl = [apiurl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *apikey = NULL;
    // Scan for the </pre> tag
    if (![scanner scanUpToString:@"</code>" intoString:&apikey]) {
        log_detail(@"Unable to find </code> tag");
        return NO;
    }
    
    apikey = [apikey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.tempAPIKey = apikey;
    
    return YES;
}
- (NSString *)apiKey {
    if (!_apiKey) {
        if (!self.apiKeyItem) {
            self.apiKeyItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.curapps.mailstrap.api.key" accessGroup:nil];
        }
        _apiKey = [self.apiKeyItem objectForKey:(__bridge id)kSecAttrService];
    }
    return _apiKey;
}
- (void)setApiKey:(NSString *)apiKey {
    _apiKey = apiKey;
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.curapps.mailstrap.api.key" accessGroup:nil];

    self.apiKeyItem = wrapper;
    if ([_apiKey isEqualToString:@""]) {
        log_detail(@"Resetting keychain");
        [self.apiKeyItem resetKeychainItem];
    } else {
        log_detail(@"Setting API Key");
        [self.apiKeyItem setObject:apiKey forKey:(__bridge id)kSecAttrService];
    }
    
     
}
- (NSString *)currentDomain {
    if (!_currentDomain) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentDomain"];
    }
    return _currentDomain;
}
- (void)setCurrentDomain:(NSString *)currentDomain {
    _currentDomain = currentDomain;
    [[NSUserDefaults standardUserDefaults] setObject:_currentDomain forKey:@"CurrentDomain"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setShouldShowPostmaster:(BOOL)shouldShowPostmaster {
    [[NSUserDefaults standardUserDefaults] setBool:shouldShowPostmaster forKey:@"ShouldShowPostmaster"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)shouldShowPostmaster {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldShowPostmaster"];
}
- (BOOL)isSetup {
    if (self.apiKey == NULL || [self.apiKey isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
- (void)sendToken:(NSString *)token {
    NSLog(@"Sending token: %@", token);
    NSURL *url = [NSURL URLWithString:kAPIPushClientBaseURLString];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/device/token" parameters:@{@"token" : token}];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON){
        NSError *parseError = NULL;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingAllowFragments error:&parseError];
        log_detail(@"Success: %@", res);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if (error) {
            log_detail(@"Error: %@", error);
        }
    }];
    [op start];
    
}
- (void)checkFirstRun {
#ifdef IN_BETA
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    if (![d boolForKey:@"FirstRunFinished"]) {
        log_detail(@"Has not bee run");
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Thanks for testing Mailstrap!" message:@"We are welcome to all feedback/criticism.\nPlease, don't hold back"];
        [alert addButtonWithTitle:@"Dismiss" block:^{
            [d setBool:YES forKey:@"FirstRunFinished"];
            [d synchronize];
        }];
        [alert show];
    } else {
        log_detail(@"Has been run");
    }
#endif
}
#pragma mark Request Helpers
- (NSString *)method:(MailgunMethod)method {
    if (method == MailgunMethodGET) {
        return @"GET";
    } else if (method == MailgunMethodDELETE) {
        return @"DELETE";
    } else if (method == MailgunMethodPOST) {
        return @"POST";
    } else if (method == MailgunMethodPUT) {
        return @"PUT";
    }
    return nil;
}

#pragma mark Main Request Method
- (void)performRequestOnPath:(NSString *)path method:(MailgunMethod)method params:(NSDictionary *)params responseBlock:(MGRes)responseBlock errorBlock:(MGErr)errorBlock {
    if ([self.apiKey isEqualToString:@""]) {
        NSDictionary *dict = @{@"status" : @"error", @"message": @"API Key has not been set."};
        errorBlock(dict);
        return;
    }
    log_detail(@"Request Method: %@, Path: %@", [self method:method], path);
    NSURL *url = [NSURL URLWithString:kAPIClientBaseURLString];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            [Alerter showNotConnectedError];
            NSDictionary *errorDict = @{@"status" : @"error", @"message": @"Unable to connect"};
            log_detail(@"Network status changed");
            errorBlock(errorDict);
            return;
        }
        
    }];
    [client setAuthorizationHeaderWithUsername:@"api" password:self.apiKey];
    NSMutableURLRequest *request = [client requestWithMethod:[self method:method] path:path parameters:params];
    if (method == MailgunMethodPOST || method == MailgunMethodPUT) {
        if (params == nil) {
            NSDictionary *errDict = @{@"status" : @"error", @"message": @"Must have params set for a PUT or a POST."};
            errorBlock(errDict);
            return;
        }
    }
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSError *parseError = NULL;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&parseError];
        if (!parseError) {
            responseBlock(response);
            return;
        } else {
            log_detail(@"Parse Errog: %@", parseError);
            NSDictionary *d = @{@"status" : @"error", @"message": parseError};
            errorBlock(d);
            return;
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSDictionary *errorDict;
        
        NSError *e = NULL;
        NSData *a = [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding];
        if (!a) {
            log_detail(@"Request Failed Error: %@", error.localizedDescription);
            if (error.localizedDescription) {
                if ([error.localizedDescription rangeOfString:@"offline"].location != NSNotFound) {
                    //[Alerter showNotConnectedError];
                    errorBlock(@{@"status" : @"error", @"message": @"The Internet connection appears to be offline"});
                    return;
                }
            }
        }
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:a options:NSJSONReadingAllowFragments error:&e];
        if (!e) {
            errorDict = @{@"status" : @"error", @"message": d[@"message"]};
            errorBlock(errorDict);
        } else {
            errorDict = @{@"status" : @"error", @"message": error.localizedRecoverySuggestion};
            errorBlock(errorDict);
        }
        
    }];
    
    [op start];
}

#pragma mark Method Type Specific Request Methods
- (void)getRequestOnPath:(NSString *)path params:(NSDictionary *)params res:(MGRes)resBlock err:(MGErr)errBlock {
    [self performRequestOnPath:path method:MailgunMethodGET params:params responseBlock:^(NSDictionary *res){
        resBlock(res);
    }errorBlock:^(NSDictionary *errorDict){
        errBlock(errorDict);
    }];
}

- (void)putRequestOnPath:(NSString *)path params:(NSDictionary *)params res:(MGRes)resBlock err:(MGErr)errBlock {
    [self performRequestOnPath:path method:MailgunMethodPUT params:params responseBlock:^(NSDictionary *res){
        resBlock(res);
    }errorBlock:^(NSDictionary *errorDict){
        errBlock(errorDict);
    }];
}

- (void)postRequestOnPath:(NSString *)path params:(NSDictionary *)params res:(MGRes)resBlock err:(MGErr)errBlock {
    [self performRequestOnPath:path method:MailgunMethodPOST params:params responseBlock:^(NSDictionary *res){
        resBlock(res);
    }errorBlock:^(NSDictionary *errorDict){
        errBlock(errorDict);
    }];
}

- (void)deleteRequestOnPath:(NSString *)path params:(NSDictionary *)params res:(MGRes)resBlock err:(MGErr)errBlock {
    [self performRequestOnPath:path method:MailgunMethodDELETE params:params responseBlock:^(NSDictionary *res){
        resBlock(res);
    }errorBlock:^(NSDictionary *errorDict){
        errBlock(errorDict);
    }];
}


#pragma mark Path Specific Request Methods
- (void)getDomainsWithRes:(MGRes)resBlock err:(MGErr)errBlock {
    [self getRequestOnPath:@"/v2/domains" params:nil res:^(NSDictionary *res){
        resBlock(res);
    }err:^(NSDictionary *err){
        errBlock(err);
    }];
}
- (void)getDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/domains/%@", domain];
    [self getRequestOnPath:path params:nil res:^(NSDictionary *res){
        resBlock(res);
    }err:^(NSDictionary *err){
        errBlock(err);
    }];
}
- (void)deleteDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/domains/%@", domain];
    [self deleteRequestOnPath:path params:nil res:^(NSDictionary *res){
        resBlock(res);
    }err:^(NSDictionary *err){
        errBlock(err);
    }];
}
- (void)createDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSDictionary *params = @{@"name" : domain};
    [self postRequestOnPath:@"/v2/domains" params:params res:resBlock err:errBlock];
}


#pragma mark Mailboxes
- (void)getMailboxesForDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/mailboxes", domain];
    [self getRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)createMailboxForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/mailboxes", domain];
    [self postRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)updateMailbox:(NSString *)mailbox forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/mailboxes/%@", domain, mailbox];
    [self putRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)deleteMailbox:(NSString *)mailbox forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/mailboxes/%@", domain, mailbox];
    [self deleteRequestOnPath:path params:nil res:resBlock err:errBlock];
}


#pragma mark Mailing Lists
- (void)getMailingListsWithRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/lists"];
    [self getRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)getMailingListWithAddress:(NSString *)address withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/lists/%@", address];
    [self getRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)createMailingListWithParams:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    [self postRequestOnPath:@"/v2/lists" params:params res:resBlock err:errBlock];
}
- (void)updateMailingListWithAddress:(NSString *)address params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/lists/%@", address];
    [self putRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)deleteMailingListWithAddress:(NSString *)address withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/lists/%@", address];
    [self deleteRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)getMailingListMembersWithAddress:(NSString *)address withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/lists/%@/members", address];
    [self getRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)getMailingListMembersWithListAddress:(NSString *)listAddress memberAddress:(NSString *)memberAddress withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/lists/%@/members/%@", listAddress, memberAddress];
    [self getRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)addMemberToMailingListWithAddress:(NSString *)address params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/lists/%@/members", address];
    [self postRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)updateMember:(NSString *)memberAddress onMailingListWithAddress:(NSString *)address params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/lists/%@/members/%@", address, memberAddress];
    [self putRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)deleteMember:(NSString *)memberAddress onMailingListWithAddress:(NSString *)address withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/lists/%@/members/%@", address, memberAddress];
    [self deleteRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)getMailingListStatsWithAddress:(NSString *)address withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/lists/%@/stats", address];
    [self getRequestOnPath:path params:nil res:resBlock err:errBlock];
}


#pragma mark Routes
- (void)getRoutesWithRes:(MGRes)resBlock err:(MGErr)errBlock {
    [self getRequestOnPath:@"/v2/routes" params:nil res:resBlock err:errBlock];
}
- (void)getRouteID:(NSString *)routeID params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/routes/%@", routeID];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)createRouteWithParams:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    [self postRequestOnPath:@"/v2/routes" params:params res:resBlock err:errBlock];
}
- (void)updateRouteID:(NSString *)routeID withParams:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/routes/%@", routeID];
    [self putRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)deleteRouteID:(NSString *)routeID withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/routes/%@", routeID];
    [self deleteRequestOnPath:path params:nil res:resBlock err:errBlock];
}

#pragma mark Logs
- (void)getLogsForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/log", domain];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}

#pragma mark Campaigns
- (void)getCampaignsForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns", domain];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)getCampaign:(NSString *)campaignid forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns/%@", domain, campaignid];
    [self getRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)createCampaignForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns", domain];
    [self postRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)updateCampaign:(NSString *)campaignid forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns/%@", domain, campaignid];
    [self putRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)deleteCampaign:(NSString *)campaignID forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns/%@", domain, campaignID];
    [self deleteRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)getCampaignEvents:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns/%@/events", domain, campaignID];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)getCampaignStats:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns/%@/stats", domain, campaignID];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)getCampaignClicks:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns/%@/clicks", domain, campaignID];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)getCampaignOpens:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns/%@/opens", domain, campaignID];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)getCampaignUnsubscribes:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns/%@/unsubscribes", domain, campaignID];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)getCampaignComplaints:(NSString *)campaignID forDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/campaigns/%@/complaints", domain, campaignID];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}

#pragma mark Bounces
- (void)getBouncesForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/bounces", domain];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)getBounceAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/bounces/%@", domain, address];
    [self getRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)createBounceForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/bounces", domain];
    [self postRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)deleteBounceWithAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/bounces/%@", domain, address];
    [self deleteRequestOnPath:path params:nil res:resBlock err:errBlock];
}

#pragma mark - Complaints
- (void)getComplaintsForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/complaints", domain];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)getComplaintAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/complaints/%@", domain, address];
    [self getRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)createComplaintForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/complaints", domain];
    [self postRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)deleteComplaintAtAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/complaints/%@", domain, address];
    [self deleteRequestOnPath:path params:nil res:resBlock err:errBlock];
}

#pragma mark - Unsubscribes
- (void)getUnsubscribesForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/unsubscribes", domain];
    [self getRequestOnPath:path params:params res:resBlock err:errBlock];
}
- (void)getUnsubscribeAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/unsubscribes/%@", domain, address];
    [self getRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)deleteUnsubscribeForAddress:(NSString *)address forDomain:(NSString *)domain withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/unsubscribes/%@", domain, address];
    [self deleteRequestOnPath:path params:nil res:resBlock err:errBlock];
}
- (void)createUnsubscribeForDomain:(NSString *)domain params:(NSDictionary *)params withRes:(MGRes)resBlock err:(MGErr)errBlock {
    NSString *path = [NSString stringWithFormat:@"/v2/%@/unsubscribes", domain];
    [self postRequestOnPath:path params:params res:resBlock err:errBlock];
}
@end
