//
//  ContactViewController.m
//  KES
//
//  Created by matata on 3/19/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Functions makeFloatingField:_nameField placeholder:@"Name"];
    [Functions makeFloatingField:_addressField placeholder:@"Address"];
    [Functions makeFloatingField:_emailField placeholder:@"Email"];
    [Functions makeFloatingField:_phoneField placeholder:@"Phone"];
    [Functions makeBorderView:_messageField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
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
    if ([_nameField.text isEqualToString:@""] ||
        [_emailField.text isEqualToString:@""] ||
        [_messageField.text isEqualToString:@""] || [_messageField.text isEqualToString:@"Message"]) {
        [Functions showAlert:@"" message:@"Please fill out all fields"];
        return false;
    }
    return true;
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:contactApi])
    {
        if(responseDict != nil)
        {
            [self.navigationController popViewControllerAnimated:YES];
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [Functions showSuccessAlert:@"" message:@"We sent your message. Thank you" image:@""];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Message"]) {
        textView.text = @"";
        textView.textColor = [UIColor colorWithHex:COLOR_FONT];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Message";
        textView.textColor = [UIColor grayColor];
    }
    [textView resignFirstResponder];
}

#pragma mark - IBAction
- (IBAction)OnCancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnSendClicked:(id)sender {
    if ([self checkValidate]) {
        NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:_nameField.text forKey:@"name"];
        [parameters setValue:_emailField.text forKey:@"email"];
        [parameters setValue:_nameField.text forKey:@"subject"];
        [parameters setValue:_messageField.text forKey:@"message"];
        
        contactApi = [NSString stringWithFormat:@"%@%@", BASE_URL, CONTACT_US];
        [objWebServices callApiWithParameters:parameters apiName:contactApi type:POST_REQUEST loader:YES view:self];
    }
}
@end
