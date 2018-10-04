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
    
    [Functions makeFloatingField:_EmailField placeholder:@"Your email"];
    [Functions makeFloatingField:_PasswordField placeholder:@"Password"];
    [Functions makeFloatingField:_FirstNameField placeholder:@"First name"];
    [Functions makeFloatingField:_LastNameField placeholder:@"Last name"];
    [Functions makeFloatingField:_ConfirmField placeholder:@"Confirm Password"];
    _PasswordField.clearButtonMode = UITextFieldViewModeNever;
    _ConfirmField.clearButtonMode = UITextFieldViewModeNever;
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    CGRect frame= _RoleSegment.frame;
    [_RoleSegment setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 0)];
    for (int i = 0; i < appDelegate.userRoleArray.count; i++) {
        if (i == 0 && appDelegate.userRoleArray.count == 1) {
            [_RoleSegment removeSegmentAtIndex:1 animated:NO];
        } else if (i == 2) {
            [_RoleSegment insertSegmentWithTitle:appDelegate.userRoleArray[i] atIndex:i animated:NO];
        }
        [_RoleSegment setTitle:appDelegate.userRoleArray[i] forSegmentAtIndex:i];
    }
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"By signing up, you agree to Kilmartin' \nPrivacy Policy and Terms of use"];
    [hogan addAttribute:NSForegroundColorAttributeName
                  value:[UIColor colorWithHex:COLOR_PRIMARY]
                  range:NSMakeRange(40, 15)];
    [hogan addAttribute:NSLinkAttributeName
                  value:[NSString stringWithFormat:@"%@%@", strMainBaseUrl, PRIVACY_POLICY]
                  range:NSMakeRange(40, 15)];
    [hogan addAttribute:NSForegroundColorAttributeName
                  value:[UIColor colorWithHex:COLOR_PRIMARY]
                  range:NSMakeRange(58, 13)];
    [hogan addAttribute:NSLinkAttributeName
                  value:[NSString stringWithFormat:@"%@%@", strMainBaseUrl, TERMS_SERVICE]
                  range:NSMakeRange(58, 13)];
    _TOSTextView.attributedText = hogan;
    [_TOSTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:13]];
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
    if (theTextField == self.FirstNameField) {
        [self.LastNameField becomeFirstResponder];
    } else if (theTextField == self.LastNameField) {
        [self.EmailField becomeFirstResponder];
    } else if (theTextField == self.EmailField) {
        [self.PasswordField becomeFirstResponder];
    } else if (theTextField == self.PasswordField) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)isValid {
    if (_FirstNameField.text == nil || [_FirstNameField.text length] == 0 ||
        [[_FirstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [_FirstNameField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input first name"];
        return FALSE;
    }
    else if (_LastNameField.text == nil || [_LastNameField.text length] == 0 ||
        [[_LastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [_LastNameField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input last name"];
        return FALSE;
    }
    else if (_EmailField.text == nil || [_EmailField.text length] == 0 ||
        [[_EmailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [_EmailField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input email address"];
        return FALSE;
    }
    else if (![Functions validateEmailField:_EmailField.text]) {
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

- (void)actionSignup{
    
    NSDictionary * parameters=@{@"email":_EmailField.text,
                                @"password":_PasswordField.text,
                                @"mpassword":_PasswordField.text,
                                @"role":[_RoleSegment titleForSegmentAtIndex:_RoleSegment.selectedSegmentIndex]
                                };
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    signupApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, SIGNUP_API];
    [_objWebServices callApiWithParameters:parameters apiName:signupApi type:POST_REQUEST loader:YES view:self];
}

#pragma mark - UITextField delegate
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXFIELDLENGTH || returnKey;
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
    
    NSString *tmpString;
    tmpString = _PasswordField.text;
    _PasswordField.text = @" ";
    _PasswordField.text = tmpString;
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
    
    NSString *tmpString;
    tmpString = _ConfirmField.text;
    _ConfirmField.text = @" ";
    _ConfirmField.text = tmpString;
}

- (IBAction)OnRoleChanged:(id)sender {
    if (_RoleSegment.selectedSegmentIndex == 1) {
        
    }
}

- (IBAction)OnContinueClicked:(id)sender {
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    [Functions openURl:strMainBaseUrl];
}

@end
