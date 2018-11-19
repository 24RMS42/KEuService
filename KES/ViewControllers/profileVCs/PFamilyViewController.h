//
//  PFamilyViewController.h
//  KES
//
//  Created by Piglet on 06.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "MemberTableViewCell.h"
#import "Functions.h"
#import "WebServices.h"

@protocol PFamilyViewControllerDelegate
- (void) goBackFromPFamilyVC;
@end
@interface PFamilyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, WebServicesDelegate>
{
    CGFloat mtfposition;
    CGFloat mtfHeight;
    
    UITextField *tmpTf;
    NSMutableArray *arrMembers;
    WebServices *objWebServices;
    NSString *inviteMemberApi;
}

@property (nonatomic, strong) id <PFamilyViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tbMembers;
@property (weak, nonatomic) IBOutlet UITextField *tfAddMember;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIScrollView *scContainer;

- (IBAction)onBtnAddMember:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;
@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnReset:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

@end
