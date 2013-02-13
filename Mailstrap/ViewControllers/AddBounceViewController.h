//
//  AddBounceViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeTextField.h"
#import "LargeTextView.h"
@class MGDomain;
@class MGBounce;
@interface AddBounceViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet LargeTextField *textAddress;
@property (strong, nonatomic) IBOutlet LargeTextField *textCode;
@property (strong, nonatomic) IBOutlet LargeTextView *textError;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) MGDomain *currentDomain;
@property (nonatomic) BOOL keyboardIsShown;
- (IBAction)tappedSaveBtn:(id)sender;
@end
