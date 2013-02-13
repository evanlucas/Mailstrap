//
//  CampaignsViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import "ModalTableViewController.h"
@class MGDomain;
@class MGCampaign;
@interface CampaignsViewController : ModalTableViewController
@property (nonatomic, strong) MGDomain *currentDomain;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) MGCampaign *selectedCampaign;
- (IBAction)dismissMe:(id)sender;
@end
