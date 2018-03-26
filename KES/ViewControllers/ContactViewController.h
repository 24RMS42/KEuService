//
//  ContactViewController.h
//  KES
//
//  Created by matata on 3/19/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "WebServices.h"

@interface ContactViewController : UIViewController<UITextViewDelegate, WebServicesDelegate>
{
    WebServices *objWebServices;
    NSString *contactApi;
}

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *nameField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *addressField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextView *messageField;


- (IBAction)OnCancelClicked:(id)sender;
- (IBAction)OnSendClicked:(id)sender;
@end
