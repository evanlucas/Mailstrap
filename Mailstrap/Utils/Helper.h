


//#define NO_CAMPAIGNS
//#define IN_BETA
#define MAILSTRAP_VERSION @"1.0.1"


#pragma mark Segues

#define SHOW_SETTINGS_MODAL @"SHOW_SETTINGS_MODAL"
#define SHOW_DOMAINS_MODAL @"LOGIN_MODAL_NAV"
#define SHOW_DOMAIN_SELECTION_MODAL @"SHOW_DOMAIN_SELECTION_MODAL"
#define SHOW_MAILBOXES_MODAL @"SHOW_MAILBOXES_MODAL"



#define STORYBOARD_LOGIN_API @"LoginAPIKeyViewController"
#define STORYBOARD_LOGIN_USERNAME @"LoginUsernameViewController"
#define STORYBOARD_LOGIN_MODAL @"LoginContainerViewController"


#define SHOW_LOGIN_PUSH @"SHOW_LOGIN_PUSH"
#define SHOW_DOMAINS_PUSH @"SHOW_DOMAINS_PUSH"
#define SHOW_SETTINGS_PUSH @"SHOW_SETTINGS_PUSH"
#define SHOW_DOMAIN_SELECTION_PUSH @"SHOW_DOMAIN_SELECTION_PUSH"
#define SHOW_MAILBOXES_PUSH @"SHOW_MAILBOXES_PUSH"
#define SHOW_ADD_MAILBOX_PUSH @"SHOW_ADD_MAILBOX_PUSH"
#define SHOW_EDIT_MAILBOX_PUSH @"SHOW_EDIT_MAILBOX_PUSH"
#define SHOW_MAILING_LISTS_PUSH @"SHOW_MAILING_LISTS_PUSH"
#define EDIT_MAILING_LIST_PUSH @"EDIT_MAILING_LIST_PUSH"
#define SHOW_MAILING_LIST_MEMBERS @"SHOW_MAILING_LIST_MEMBERS"
#define SHOW_MAILING_LIST_ADD_MEMBER @"SHOW_MAILING_LIST_ADD_MEMBER"
#define SHOW_ROUTES_PUSH @"SHOW_ROUTES_PUSH"
#define SHOW_ROUTE_DETAIL_PUSH @"SHOW_ROUTE_DETAIL_PUSH"
#define SHOW_ROUTE_ACTIONS_PUSH @"SHOW_ROUTE_ACTIONS_PUSH"
#define SHOW_ADD_ROUTE_PUSH @"SHOW_ADD_ROUTE_PUSH"
#define SHOW_ABOUT_PUSH @"SHOW_ABOUT_PUSH"
#define SHOW_LOGS_PUSH @"SHOW_LOGS_PUSH"
#define ADD_MAILING_LIST_PUSH @"ADD_MAILING_LIST_PUSH"
#define SHOW_COMPLAINTS_PUSH @"SHOW_COMPLAINTS_PUSH"
#define SHOW_UNSUBSCRIBES_PUSH @"SHOW_UNSUBSCRIBES_PUSH"
#define SHOW_ADD_COMPLAINT_PUSH @"SHOW_ADD_COMPLAINT_PUSH"
#define SHOW_ADD_UNSUBSCRIBES_PUSH @"SHOW_ADD_UNSUBSCRIBES_PUSH"
#define SHOW_BOUNCES_PUSH @"SHOW_BOUNCES_PUSH"
#define SHOW_ADD_BOUNCES_PUSH @"SHOW_ADD_BOUNCES_PUSH" 
#define SHOW_CAMPAIGNS_PUSH @"SHOW_CAMPAIGNS_PUSH"
#define SHOW_CAMPAIGN_DETAILS_PUSH @"SHOW_CAMPAIGN_DETAILS_PUSH"
#define SHOW_CREATE_CAMPAIGN_PUSH @"SHOW_CREATE_CAMPAIGN_PUSH"

#pragma mark Table Cells

#define DOMAIN_TABLE_CELL @"DOMAIN_TABLE_CELL"
#define DOMAINS_LIST_TABLE_CELL @"DOMAINS_LIST_TABLE_CELL"
#define MAILBOX_TABLE_CELL @"MAILBOX_TABLE_CELL"
#define MAILING_LIST_TABLE_CELL @"MAILING_LIST_TABLE_CELL"
#define MAILING_LIST_MEMBERS_TABLE_CELL @"MAILING_LIST_MEMBERS_TABLE_CELL"
#define ROUTES_TABLE_CELL @"ROUTES_TABLE_CELL"
#define EMPTY_TABLE_CELL @"EMPTY_TABLE_CELL"
#define ROUTE_ACTION_TABLE_CELL @"ROUTE_ACTION_TABLE_CELL"
#define LOGS_TABLE_CELL @"LOGS_TABLE_CELL"
#define CAMPAIGN_NAME_CELL @"CAMPAIGN_NAME_CELL"
#define CAMPAIGN_ROOT_TABLE_CELL @"CAMPAIGN_ROOT_TABLE_CELL"
#define CAMPAIGN_DETAIL_TABLE_CELL @"CAMPAIGN_DETAIL_TABLE_CELL"

#pragma mark True Destinations

#define DEST_MAILBOXES @"DEST_MAILBOXES"
#define DEST_MAILING_LISTS @"DEST_MAILING_LISTS"
#define DEST_ROUTES @"DEST_ROUTES"
#define DEST_LOGS @"DEST_LOGS"
#define DEST_COMPLAINTS @"DEST_COMPLAINTS"
#define DEST_CAMPAIGNS @"DEST_CAMPAIGNS"
#define DEST_BOUNCES @"DEST_BOUNCES"
#define DEST_UNSUBSCRIBES @"DEST_UNSUBSCRIBES"


#pragma mark Macros
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define MODAL_WIDTH (iPad ? 540.0f : 320.0f)
#define MODAL_MARGIN 20.0f
#define ITEM_WIDTH (iPad ? 240.0f : 150.0f)
#define ITEM_HEIGHT (iPad ? 220.0f : 150.0f)
#ifndef RELEASE
    #define log_detail(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #define log_f() NSLog(@"log_f(): %s", __PRETTY_FUNCTION__)
    #define PRINT_RECT(title, rect) NSLog(@"RECT: %@ - %@", title, NSStringFromCGRect(rect))
    #define PRINT_FLOAT(title, float) NSLog(@"Float: %@ - %f", title, float)
    #define PRINT_SIZE(title, size) NSLog(@"Size: %@ - %@", title, NSStringFromCGSize(size))
    #define PRINT_POINT(title, point) NSLog(@"Point: %@ - %@", title, NSStringFromCGPoint(point))
#else
    #define log_detail(...)
    #define log_f()
    #define PRINT_RECT
    #define PRINT_FLOAT
    #define PRINT_SIZE
    #define PRINT_POINT
#endif

//
//  BlockUI.h
//
//  Created by Gustavo Ambrozio on 14/2/12.
//

#ifndef BlockUI_h
#define BlockUI_h

// Action Sheet constants

#define kActionSheetBounce         10
#define kActionSheetBorder         10
#define kActionSheetButtonHeight   45
#define kActionSheetTopMargin      15

#define kActionSheetTitleFont           [UIFont systemFontOfSize:18]
#define kActionSheetTitleTextColor      [UIColor whiteColor]
#define kActionSheetTitleShadowColor    [UIColor blackColor]
#define kActionSheetTitleShadowOffset   CGSizeMake(0, -1)

#define kActionSheetButtonFont          [UIFont boldSystemFontOfSize:20]
#define kActionSheetButtonTextColor     [UIColor whiteColor]
#define kActionSheetButtonShadowColor   [UIColor blackColor]
#define kActionSheetButtonShadowOffset  CGSizeMake(0, -1)

#define kActionSheetBackground              @"action-sheet-panel.png"
#define kActionSheetBackgroundCapHeight     30


// Alert View constants

#define kAlertViewBounce         20
#define kAlertViewBorder         10
#define kAlertButtonHeight       44

#define kAlertViewTitleFont             [UIFont boldSystemFontOfSize:20]
#define kAlertViewTitleTextColor        [UIColor colorWithWhite:244.0/255.0 alpha:1.0]
#define kAlertViewTitleShadowColor      [UIColor blackColor]
#define kAlertViewTitleShadowOffset     CGSizeMake(0, -1)

#define kAlertViewMessageFont           [UIFont systemFontOfSize:16]
#define kAlertViewMessageTextColor      [UIColor colorWithWhite:244.0/255.0 alpha:1.0]
#define kAlertViewMessageShadowColor    [UIColor blackColor]
#define kAlertViewMessageShadowOffset   CGSizeMake(0, -1)

#define kAlertViewButtonFont            [UIFont boldSystemFontOfSize:18]
#define kAlertViewButtonTextColor       [UIColor whiteColor]
#define kAlertViewButtonShadowColor     [UIColor blackColor]
#define kAlertViewButtonShadowOffset    CGSizeMake(0, -1)

#define kAlertViewBackground            @"alert_bg.png"
#define kAlertViewBackgroundCapHeight   38

#endif
