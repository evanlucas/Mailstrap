//
//  EditMailingListViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeTextField.h"
#import "LargeTextView.h"
@class MGMailingList;
@interface EditMailingListViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet LargeTextField *textName;
@property (strong, nonatomic) IBOutlet LargeTextField *textAddress;
@property (strong, nonatomic) IBOutlet LargeTextView *textDescription;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL addMode;
@property (nonatomic, strong) MGMailingList *mailingList;
@property (nonatomic) BOOL keyboardIsShown;
- (IBAction)tappedMembersBtn:(id)sender;
- (IBAction)tappedSaveBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControlAccessLevel;
@property (strong, nonatomic) IBOutlet UIButton *buttonMembers;

@end
