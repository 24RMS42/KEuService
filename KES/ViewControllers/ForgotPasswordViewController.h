//
//  ForgotPasswordViewController.h
//  KES
//
//  Created by matata on 11/22/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "WebServices.h"

@interface ForgotPasswordViewController : UIViewController<CAAnimationDelegate, WebServicesDelegate>
{
    WebServices *objWebServices;
    NSString *forgotPwdApi;
}
@property (nonatomic, strong) NSString *info;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *EmailField;
@property (weak, nonatomic) IBOutlet UIView *ConfirmView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

- (IBAction)OnClickSendEmail:(id)sender;
- (IBAction)OnClickBack:(id)sender;
- (IBAction)OnClickReturnLogin:(id)sender;

@end
