//
//  MGMailingList.m
//  Mailstrap
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "MGMailingList.h"

@implementation MGMailingList
- (id)initWithAttributes:(NSDictionary *)attrs {
    if (self = [super init]) {
        self.members_count = [attrs objectForKey:@"members_count"];
        self.name = [attrs safeStringForKey:@"name"];
        self.desc = [attrs safeStringForKey:@"description"];
        self.address = [attrs safeStringForKey:@"address"];
        self.access_level = [attrs safeStringForKey:@"access_level"];
        NSLog(@"Mailing List: %@", self);
    }
    return self;
}
+ (MGMailingList *)fromJSON:(NSDictionary *)jsonDict {
    return [[MGMailingList alloc] initWithAttributes:jsonDict];
}
+ (void)getMailingListsWithBlock:(void (^)(NSArray *, NSDictionary *))block {
    [[APIController sharedInstance] getMailingListsWithRes:^(NSDictionary *res){
        NSArray *lists = [res objectForKey:@"items"];
        
        NSLog(@"MGMailingList: Lists: %@", lists);
        NSMutableArray *mutableLists = [NSMutableArray arrayWithCapacity:[lists count]];
        for (NSDictionary *attributes in lists) {
            MGMailingList *list = [[MGMailingList alloc] initWithAttributes:attributes];
            [mutableLists addObject:list];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableLists], nil);
        }
    }err:^(NSDictionary *err){
        if (block) {
            block([NSArray array], err);
        }
    }];
}
+ (void)deleteMailingList:(NSString *)list withRes:(MGRes)res err:(MGErr)err {
    [[APIController sharedInstance] deleteMailingListWithAddress:list withRes:res err:err];
}
+ (void)updateMailingList:(NSString *)list params:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err {
    [[APIController sharedInstance] updateMailingListWithAddress:list params:params withRes:res err:err];
}
+ (void)createMailingListWithParams:(NSDictionary *)params withRes:(MGRes)res err:(MGErr)err {
    [[APIController sharedInstance] createMailingListWithParams:params withRes:res err:err];
}
- (CGFloat)cellHeightForWidth:(CGFloat)width {
    CGFloat margin = 5.0f;
    CGFloat defaultLabelHeight = 20.0f;
    CGFloat defaultLabelHeights = defaultLabelHeight * 4;
    CGFloat totalMargin = margin * (1 + 4);
    CGFloat origin = defaultLabelHeights + totalMargin;
    CGFloat messageHeight = [self messageHeightForWidth:width];
    return origin + messageHeight + 5.0f;
}

- (CGFloat)messageHeightForWidth:(CGFloat)width {
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    CGSize s = [self.desc sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    return s.height;
}
@end
