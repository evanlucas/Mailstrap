//
//  RouteDetailViewController.h
//  Mailstrap
//
//  Created by Evan Lucas on 12/28/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGRoutes.h"
#import "LargeTextField.h"
#import "LargeTextView.h"
#import "RouteActionsViewController.h"
@interface RouteDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, RouteActionsDelegate>
@property (nonatomic, strong) MGRoutes *currentRoute;
@property (strong, nonatomic) IBOutlet LargeTextField *textPriority;
@property (strong, nonatomic) IBOutlet LargeTextField *textExpression;
@property (nonatomic) BOOL isNew;
@property (nonatomic) BOOL keyboardIsShown;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet LargeTextView *textDescription;
@property (nonatomic, strong) NSMutableArray *routeActions;
- (IBAction)tappedSaveBtn:(id)sender;
@end
