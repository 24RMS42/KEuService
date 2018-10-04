//
//  ForgotPasswordViewController.m
//  KES
//
//  Created by matata on 11/22/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    
    [Functions makeFloatingField:_EmailField placeholder:@"Email"];
    
    if ([_info isEqualToString:@"SignUpSuccess"]) {
        _ConfirmView.hidden = NO;
        _titleLbl.text = @"Verification Email";
    } else if ([_info isEqualToString:@"ForgotPassword"]) {
        _ConfirmView.hidden = YES;
        _titleLbl.text = @"Forgot password";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
    
    return TRUE;
}

- (void)actionSendEmail{
    
    NSDictionary * parameters=@{@"email":_EmailField.text};
    
    forgotPwdApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, FORGOTPWD_API];
    [objWebServices callApiWithParameters:parameters apiName:forgotPwdApi type:POST_REQUEST loader:YES view:self];
}

#pragma mark - webservice call delegate
-(void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:forgotPwdApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [_ConfirmView setHidden:NO];
                [self viewSlideInFromRightToLeft:_ConfirmView];
            }else
                [Functions showAlert:@"" message:[responseDict valueForKey:@"msg"]];
        }
    }
}

-(void)viewSlideInFromRightToLeft:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

#pragma mark - IBAction
- (IBAction)OnClickSendEmail:(id)sender {
    
    if ([self isValid]) {
        [self actionSendEmail];
    }
}

- (IBAction)OnClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnClickReturnLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
