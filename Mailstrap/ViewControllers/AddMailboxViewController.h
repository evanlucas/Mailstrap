//
//  AddMailboxViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LargeTextField;
@class MGDomain;
@class MGMailbox;
@interface AddMailboxViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet LargeTextField *textPassword;
@property (strong, nonatomic) IBOutlet LargeTextField *textMailbox;
@property (nonatomic, strong) MGDomain *currentDomain;
@property (nonatomic, strong) MGMailbox *currentMailbox;
@property (nonatomic) BOOL editMode;
- (IBAction)tappedSave:(id)sender;

@end
