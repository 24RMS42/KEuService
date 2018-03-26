//
//  FeedbackViewController.m
//  KES
//
//  Created by matata on 3/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userInfo = [NSUserDefaults standardUserDefaults];
    [Functions makeBorderView:_messageField];
    msgPlaceHolder = @"Tell";
    _messageField.text = msgPlaceHolder;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    if (self.screenshot != nil) {
        [self.imageView setImage:_screenshot];
        [Functions makeRoundShadowView:self.imageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
{
    [_messageField resignFirstResponder];
}

- (BOOL)checkValidate {
    if ([_messageField.text isEqualToString:@""] || [_messageField.text isEqualToString:@"Tell"]) {
        [Functions showAlert:@"" message:@"Please write message"];
        return false;
    }
    return true;
}

#pragma mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:msgPlaceHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor colorWithHex:COLOR_FONT];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = msgPlaceHolder;
        textView.textColor = [UIColor grayColor];
    }
    [textView resignFirstResponder];
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:sendFeedbackApi])
    {
        if(responseDict != nil)
        {
            [userInfo setValue:@"1" forKey:KEY_SHAKE_APP];
            [self.navigationController popViewControllerAnimated:YES];
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [Functions showSuccessAlert:@"" message:@"Successfully sent!" image:@""];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - IBAction
- (IBAction)onCancelClicked:(id)sender {
    [userInfo setValue:@"1" forKey:KEY_SHAKE_APP];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnSendClicked:(id)sender {
    if ([self checkValidate]) {
        NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:@"Mobile app feedback" forKey:@"subject"];
        [parameters setValue:_messageField.text forKey:@"message"];
        
        if (self.screenshot != nil) {
            [parameters setObject:_screenshot forKey:@"image"];
        }
        
        sendFeedbackApi = [NSString stringWithFormat:@"%@%@", BASE_URL, SEND_FEEDBACK];
        [objWebServices callApiWithParameters:parameters apiName:sendFeedbackApi type:POST_REQUEST loader:YES view:self];
    }
}
@end
