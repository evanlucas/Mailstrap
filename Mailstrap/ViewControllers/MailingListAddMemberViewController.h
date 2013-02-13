//
//  MailingListAddMemberViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/11/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeTextField.h"
@class MGMLMember;
@interface MailingListAddMemberViewController : UIViewController
@property (strong, nonatomic) IBOutlet LargeTextField *textAddress;
@property (strong, nonatomic) IBOutlet LargeTextField *textName;
@property (strong, nonatomic) IBOutlet UISwitch *switchSubscribed;
@property (strong, nonatomic) IBOutlet UISwitch *switchUpsert;
@property (nonatomic, strong) NSString *listAddress;
- (IBAction)tappedSaveButton:(id)sender;

@end
