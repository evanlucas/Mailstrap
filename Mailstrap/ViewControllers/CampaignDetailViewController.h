//
//  CampaignDetailViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
@class MGCampaign;
@class MGDomain;
@interface CampaignDetailViewController : ModalTableViewController
@property (nonatomic, strong) MGCampaign *currentCampaign;
@property (nonatomic, strong) MGDomain *currentDomain;
@end
