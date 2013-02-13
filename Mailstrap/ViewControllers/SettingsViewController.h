//
//  SettingsViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SettingsDelegate
- (void)dismissSettings;
@end
@interface SettingsViewController : UIViewController
- (IBAction)tappedSaveAction:(id)sender;
- (IBAction)dismissMe:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textAPIKey;
@property (nonatomic, weak) IBOutlet UISwitch *switchShowPostmaster;
- (IBAction)tappedLogout:(id)sender;
@property (nonatomic, assign) id<SettingsDelegate> delegate;
@end
