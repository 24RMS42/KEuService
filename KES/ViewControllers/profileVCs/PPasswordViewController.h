//
//  PPasswordViewController.h
//  KES
//
//  Created by Piglet on 06.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "Functions.h"
#import "WebServices.h"

@protocol PPasswordViewControllerDelegate
- (void) goBackFromPasswordVC;
@end
@interface PPasswordViewController : UIViewController <UITextFieldDelegate, WebServicesDelegate>
{
    CGFloat mtfposition;
    CGFloat mtfHeight;
    NSUserDefaults *userInfo;
    UITextField *tmpTf;
    WebServices *objWebServices;
    NSString *updatePasswordApi;
}
@property (nonatomic, strong) id <PPasswordViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *tfCurrentPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPassword;


@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;
@property (weak, nonatomic) IBOutlet UIScrollView *scContainer;


@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnReset:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

@end
