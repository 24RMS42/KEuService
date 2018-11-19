//
//  PEmailViewController.h
//  KES
//
//  Created by Piglet on 05.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeTableViewCell.h"
#import "macro.h"
#import "Functions.h"
@protocol PEmailViewControllerDelegate
- (void) goBackFromPEmailVC;
@end

@interface PEmailViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    CGFloat mtfposition;
    CGFloat mtfHeight;
    
    UITextField *tmpTf;
    CGFloat heightTopOfParentView;
    
    NSArray *arrProtocols;
    NSString *strSelectedProtocol;
    BOOL isShowingTBProtocol;
}

@property (weak, nonatomic) IBOutlet UITextView *tvDefaultMsg;
@property (weak, nonatomic) IBOutlet UITextField *tfusername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfHost;
@property (weak, nonatomic) IBOutlet UITextField *tfPort;
@property (weak, nonatomic) IBOutlet UITextField *tfSecurity;
@property (weak, nonatomic) IBOutlet UITextField *tfProtocol;
@property (weak, nonatomic) IBOutlet UIImageView *imgChevronForProtocol;
@property (weak, nonatomic) IBOutlet UITextField *tfPeriod;
@property (weak, nonatomic) IBOutlet UIScrollView *scContainer;
@property (weak, nonatomic) IBOutlet UITableView *tbProtocol;
@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;

@property (nonatomic, strong) id <PEmailViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tbProtocol_height;  // 120


- (IBAction)onBtnForProtocol:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnReset:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

@end
