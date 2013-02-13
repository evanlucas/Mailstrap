//
//  AddDomainViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/21/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LargeTextField;
@interface AddDomainViewController : UIViewController <UITextFieldDelegate>
- (IBAction)tappedSaveButton:(id)sender;
@property (strong, nonatomic) IBOutlet LargeTextField *textDomain;

@end
