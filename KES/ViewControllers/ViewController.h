//
//  ViewController.h
//  KES
//
//  Created by matata on 2/9/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EAIntroView/EAIntroView.h>
#import "macro.h"
#import "CAPSPageMenu.h"
#import "UIColor+ColorWithHex.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "ForgotPasswordViewController.h"
#import "WebServices.h"

@interface ViewController : UIViewController<CAPSPageMenuDelegate, WebServicesDelegate>
{
    LoginViewController *loginController;
    SignupViewController *signupController;
    WebServices *objWebServices;
    NSString *quoteApi;
}

@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (nonatomic) CAPSPageMenu *pagemenu;
@property (weak, nonatomic) IBOutlet UIView *splashView;
@property (weak, nonatomic) IBOutlet UILabel *splashLbl;
@property (weak, nonatomic) IBOutlet UITextView *quoteTxt;

@end

