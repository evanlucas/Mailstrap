//
//  AddComplaintViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 1/10/13.
//  Copyright (c) 2013 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeTextField.h"

@class MGComplaints;
@class MGDomain;
@interface AddComplaintViewController : UIViewController
- (IBAction)tappedSaveBtn:(id)sender;
@property (nonatomic, strong) MGDomain *currentDomain;
@property (strong, nonatomic) IBOutlet LargeTextField *textAddress;

@end
