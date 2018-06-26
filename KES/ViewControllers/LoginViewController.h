//
//  LoginViewController.h
//  KES
//
//  Created by matata on 11/21/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "WebServices.h"

@interface LoginViewController : UIViewController<WebServicesDelegate>
{
    NSString *loginApi, *getProfileApi;
}

@property (nonatomic, assign) BOOL passwordShown;
@property (nonatomic, retain) WebServices *objWebServices;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *EmailField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *PasswordField;
@property (weak, nonatomic) IBOutlet UISwitch *RememberSwitch;
@property (weak, nonatomic) IBOutlet UIButton *PwdToggleButton;
@property (weak, nonatomic) IBOutlet UITextView *TOSTextView;

- (IBAction)OnLoginClicked:(id)sender;
- (IBAction)OnSignupClicked:(id)sender;
- (IBAction)OnForgotClicked:(id)sender;
- (IBAction)OnPwdShowClicked:(id)sender;
- (IBAction)OnQuestionClicked:(id)sender;
- (IBAction)OnContinueClicked:(id)sender;

@end
