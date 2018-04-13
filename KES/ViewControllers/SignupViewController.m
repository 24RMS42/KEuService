//
//  SignupViewController.m
//  KES
//
//  Created by matata on 11/21/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Functions makeFloatingField:_EmailField placeholder:@"Email"];
    [Functions makeFloatingField:_PasswordField placeholder:@"Password"];
    [Functions makeFloatingField:_ConfirmField placeholder:@"Confirm Password"];
    _PasswordField.clearButtonMode = UITextFieldViewModeNever;
    _ConfirmField.clearButtonMode = UITextFieldViewModeNever;
    
    CGRect frame= _RoleSegment.frame;
    [_RoleSegment setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 15)];
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
        [self.ConfirmField becomeFirstResponder];
    } else if (theTextField == self.EmailField) {
        [self.PasswordField becomeFirstResponder];
    } else if (theTextField == self.ConfirmField) {
        [theTextField resignFirstResponder];
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
    else if (![_PasswordField.text isEqualToString:_ConfirmField.text]) {
        [_ConfirmField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please confirm password"];
        return FALSE;
    }
    
    return TRUE;
}

- (void)actionSignup{
    
    NSDictionary * parameters=@{@"email":_EmailField.text,
                                @"password":_PasswordField.text,
                                @"mpassword":_ConfirmField.text,
                                @"is_student":@(1),
                                @"is_parent":@(0)
                                };
    signupApi = [NSString stringWithFormat:@"%@%@", BASE_URL, SIGNUP_API];
    [_objWebServices callApiWithParameters:parameters apiName:signupApi type:POST_REQUEST loader:YES view:self];
}

#pragma mark - webservice call delegate
-(void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:signupApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                NSDictionary* info = @{@"info": @"SignUpSuccess"};
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORGOT object:self userInfo:info];
            }else
                [Functions showAlert:@"" message:[responseDict valueForKey:@"msg"]];
        }
    }
}

#pragma mark - IBAction
- (IBAction)OnSignupClicked:(id)sender {
    
    if ([self isValid])
    {
        [self actionSignup];
    }
}

- (IBAction)OnLoginClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN object:self];
}

- (IBAction)OnShowPwdClicked:(id)sender {
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

- (IBAction)OnShowConfirmClicked:(id)sender {
    if (_confirmShown) {
        _confirmShown = NO;
        _ConfirmField.secureTextEntry = YES;
        [_ConfirmToggleBtn setTitle:@"Show" forState:UIControlStateNormal];
    }
    else
    {
        _confirmShown = YES;
        _ConfirmField.secureTextEntry = NO;
        [_ConfirmToggleBtn setTitle:@"Hide" forState:UIControlStateNormal];
    }
}

- (IBAction)OnRoleChanged:(id)sender {
    if (_RoleSegment.selectedSegmentIndex == 1) {
        _RoleSegment.selectedSegmentIndex = 0;
    }
}

@end
