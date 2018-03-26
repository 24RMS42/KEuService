//
//  LoginViewController.m
//  KES
//
//  Created by matata on 11/21/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Functions makeFloatingField:_EmailField placeholder:@"Email"];
    [Functions makeFloatingField:_PasswordField placeholder:@"Password"];
    _PasswordField.clearButtonMode = UITextFieldViewModeNever;
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [_EmailField setText:[userInfo objectForKey:KEY_EMAIL]];
    [_PasswordField setText:[userInfo objectForKey:KEY_PASSWORD]];
}

- (void)viewDidAppear:(BOOL)animated {
    _objWebServices = [WebServices sharedInstance];
    _objWebServices.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.PasswordField) {
        [theTextField resignFirstResponder];
    } else if (theTextField == self.EmailField) {
        [self.PasswordField becomeFirstResponder];
    }
    return YES;
}

- (BOOL)isValid {
    
    NSString *_regex =@"\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _regex];
    
    if (_EmailField.text == nil || [_EmailField.text length] == 0 ||
        [[_EmailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [_EmailField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input email address"];
        return FALSE;
    }
    else if (![_predicate evaluateWithObject:_EmailField.text] == YES) {
        [_EmailField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input correct email address"];
        return FALSE;
    }
    else if (_PasswordField.text == nil || [_PasswordField.text length] == 0
        ||[[_PasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [_PasswordField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input password"];
        return FALSE;
    }
                 
    return TRUE;
}

- (void)actionLogin {
    
    NSDictionary * parameters=@{@"email":_EmailField.text,
                                @"password":_PasswordField.text
                                };
    loginApi = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_API];
    [_objWebServices callApiWithParameters:parameters apiName:loginApi type:POST_REQUEST loader:YES view:self];
}

- (void)getProfile {
    
    getProfileApi = [NSString stringWithFormat:@"%@%@", BASE_URL, PROFILE_API];
    [_objWebServices callApiWithParameters:nil apiName:getProfileApi type:GET_REQUEST loader:NO view:self];
}

#pragma mark - webservice call delegate
-(void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:loginApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self getProfile];
            } else {
                [Functions showAlert:@"" message:[responseDict valueForKey:@"msg"]];
            }
        }
    } else if ([apiName isEqualToString:getProfileApi]) {
        if (responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                [userInfo setObject:[_RememberSwitch isOn] ? @"yes" : @"no" forKey:KEY_REMEMBER];
                [userInfo setObject:_PasswordField.text forKey:KEY_PASSWORD];
                
                id profileObject = [responseDict valueForKey:@"profile"];
                
                if (profileObject != [NSNull null]) {
                    [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"name"]]    forKey:KEY_FIRSTNAME];
                    [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"surname"]] forKey:KEY_LASTNAME];
                    [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"email"]]   forKey:KEY_EMAIL];
                    [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"phone"]]   forKey:KEY_PHONE];
                    [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"address"]] forKey:KEY_ADDRESS];
                    [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"eircode"]] forKey:KEY_EIRCODE];
                    [userInfo setObject:[profileObject valueForKey:@"id"]      forKey:KEY_USERID];
                    [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"registered"]] forKey:KEY_REGISTERED];
                }
                
                BOOL has_login_as = [[responseDict valueForKey:@"has_login_as"] boolValue];
                [userInfo setObject:has_login_as == YES ? @"1":@"0" forKey:KEY_SUPER_USER];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GO_HOME object:self];
            } else
                [Functions showAlert:@"" message:[responseDict valueForKey:@"msg"]];
        }
    }
    else
    {
        NSLog(@"Connection time out!");
    }
}

- (IBAction)OnSignupClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SIGNUP object:self];
}

- (IBAction)OnForgotClicked:(id)sender {
    NSDictionary* info = @{@"info": @"ForgotPassword"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORGOT object:self userInfo:info];
}

- (IBAction)OnPwdShowClicked:(id)sender {
    if (_passwordShown) {
        _passwordShown = NO;
        _PasswordField.secureTextEntry = YES;
        [_PwdToggleButton setTitle:@"Show" forState:UIControlStateNormal];
    }
    else
    {
        _passwordShown = YES;
        _PasswordField.secureTextEntry = NO;
        [_PwdToggleButton setTitle:@"Hide" forState:UIControlStateNormal];
    }
}

- (IBAction)OnQuestionClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_QUESTION object:self];
}

- (IBAction)OnLoginClicked:(id)sender {
    if ([self isValid]) {
        [self actionLogin];
    };
}
@end
