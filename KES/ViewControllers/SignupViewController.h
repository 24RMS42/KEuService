//
//  SignupViewController.h
//  KES
//
//  Created by matata on 11/21/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "WebServices.h"

@interface SignupViewController : UIViewController<WebServicesDelegate>
{
    NSString *signupApi;
    
}

@property (nonatomic, retain) WebServices *objWebServices;
@property (nonatomic, assign) BOOL passwordShown;
@property (nonatomic, assign) BOOL confirmShown;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *EmailField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *PasswordField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *ConfirmField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *FirstNameField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *LastNameField;
@property (weak, nonatomic) IBOutlet UIButton *PwdToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmToggleBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *RoleSegment;
@property (weak, nonatomic) IBOutlet UITextView *TOSTextView;

- (IBAction)OnSignupClicked:(id)sender;
- (IBAction)OnLoginClicked:(id)sender;
- (IBAction)OnShowPwdClicked:(id)sender;
- (IBAction)OnShowConfirmClicked:(id)sender;
- (IBAction)OnRoleChanged:(id)sender;
- (IBAction)OnContinueClicked:(id)sender;

@end
