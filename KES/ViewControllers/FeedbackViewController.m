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
    [self makeRoundBorderView:_messageField];
    msgPlaceHolder = @"Tell Julie...";
    _messageField.text = msgPlaceHolder;
    msgFieldOriginY = _messageField.frame.origin.y;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    if (self.screenshot != nil) {
        [self.imageView setImage:_screenshot];
        
        UIView *darkBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
        darkBackgroundView.backgroundColor = [UIColor darkGrayColor];
        darkBackgroundView.alpha = 0.5;
        [self.containerView addSubview:darkBackgroundView];
        
        [Functions makeRoundShadowView:self.imageView];
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardOnScreen:(NSNotification *)notification {
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    [self replaceMsgView];
}

- (void)replaceMsgView {
    CGFloat newOrignY = msgFieldOriginY - keyboardFrame.size.height - (_messageField.frame.size.height - 33);
    CGRect frame = _messageField.frame;
    frame.origin.y = newOrignY;
    _messageField.frame = frame;
}

- (void)backMsgView {
    CGFloat newOrignY = _messageField.frame.origin.y + keyboardFrame.size.height;
    CGRect frame = _messageField.frame;
    frame.origin.y = newOrignY;
    _messageField.frame = frame;
}

- (void)makeRoundBorderView:(UIView *)view {
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:0.5f];
    [view.layer setCornerRadius:4.0f];
}

- (void)dismissKeyboard {
    [_messageField resignFirstResponder];
    [self backMsgView];
}

- (BOOL)checkValidate {
    if ([_messageField.text isEqualToString:@""] || [_messageField.text isEqualToString:msgPlaceHolder]) {
        [Functions showAlert:@"" message:@"Please write message"];
        return false;
    }
    return true;
}

#pragma mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:msgPlaceHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor colorWithHex:COLOR_FONT];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = msgPlaceHolder;
        textView.textColor = [UIColor grayColor];
    }
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    
    [self replaceMsgView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        
    }
    
    return YES;
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:sendFeedbackApi])
    {
        if(responseDict != nil)
        {
            [userInfo setValue:@"1" forKey:KEY_SHAKE_APP];
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [Functions showSuccessAlert:@"" message:@"Successfully sent!" image:@""];
            } else {
                [Functions checkError:responseDict];
            }
            [self.navigationController popViewControllerAnimated:YES];
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
