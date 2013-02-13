//
//  CreateCampaignViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeTextField.h"
@class MGDomain;
@interface CreateCampaignViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet LargeTextField *textCampaignID;
@property (strong, nonatomic) IBOutlet LargeTextField *textName;
@property (nonatomic, strong) MGDomain *currentDomain;
- (IBAction)tappedSaveButton:(id)sender;
@end
