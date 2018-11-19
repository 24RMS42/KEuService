//
//  PPasswordViewController.m
//  KES
//
//  Created by Piglet on 06.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "PPasswordViewController.h"

@interface PPasswordViewController ()

@end

@implementation PPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [NSUserDefaults standardUserDefaults];
    [self setUI];
    [self setButtonsView];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBlackView)
                                                 name:NOTI_SHOW_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:NOTI_HIDE_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:HIDE_BLACKVIEW_SUPER
                                               object:nil];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBlackViewForBoth)];
    [self.viewBlackOpaque addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error {
    if ([apiName isEqualToString:updatePasswordApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [Functions showSuccessAlert:@"" message:@"Your password has been changed!" image:@""];
                [self.delegate goBackFromPasswordVC];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - Functions
- (void) setUI
{
    [Functions setBoundsWithView:self.tfCurrentPassword];
    
    [Functions setBoundsWithView:self.tfNewPassword];
    
    [Functions setBoundsWithView:self.tfConfirmPassword];
    
}

- (void) setButtonsView
{
    [Functions setBoundsWithView:self.viewResult];
}

- (void) showBlackViewsForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_SHOW object:nil];
    [self showBlackView];
}

- (void) showBlackView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.viewBlackOpaque.alpha = 0.7f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }];
}

- (void) hideBlackViewForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_HIDE object:nil];
    [self hideBlackView];
}

- (void) hideBlackView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.viewBlackOpaque.alpha = 0.0f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0f]];
    }];
}

- (BOOL)validatePassword {
    NSString *currentPwd = [userInfo valueForKey:KEY_PASSWORD];
    if (![currentPwd isEqualToString:_tfCurrentPassword.text]) {
        [_tfCurrentPassword becomeFirstResponder];
        [Functions showAlert:@"" message:@"Plasse check current password"];
        return FALSE;
    }
    if ([_tfNewPassword.text isEqualToString:@""]) {
        [_tfNewPassword becomeFirstResponder];
        [Functions showAlert:@"" message:@"Plaese input new password"];
        return FALSE;
    }
    if (![_tfNewPassword.text isEqualToString:_tfConfirmPassword.text]) {
        [_tfConfirmPassword becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please confirm password"];
        return FALSE;
    }
    return TRUE;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    mtfposition = textField.frame.origin.y;
    mtfHeight = textField.frame.size.height;
    tmpTf = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (void) textFieldDidChange:(UITextField *)textField
{
    NSString *strTxt = textField.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Actions

- (IBAction)onBtnSave:(id)sender
{
    if ([self validatePassword]) {
        NSDictionary * parameters = @{@"password":_tfNewPassword.text,
                                      @"mpassword":_tfConfirmPassword.text};
        updatePasswordApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, PROFILE_API];
        [objWebServices callApiWithParameters:parameters apiName:updatePasswordApi type:POST_REQUEST loader:YES view:self];
    }
}
- (IBAction)onBtnReset:(id)sender
{
    _tfCurrentPassword.text = @"";
    _tfNewPassword.text = @"";
    _tfConfirmPassword.text = @"";
}
- (IBAction)onBtnCancel:(id)sender
{
    [self.delegate goBackFromPasswordVC];
}

@end
