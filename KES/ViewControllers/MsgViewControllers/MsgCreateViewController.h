//
//  MsgCreateGroupViewController.h
//  KES
//
//  Created by Piglet on 22.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MintAnnotationChatView.h"
#import "UserTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CameraSelectView.h"
#import "Functions.h"

@interface MsgCreateViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CameraSelectViewDelegate>
{
    
    NSString *strTVPlaceholder;
    BOOL isEnableReply;
    NSString *strTVPlaceholder1;
    NSMutableArray *arrTestAllUsers;
    NSMutableArray *arrUsers;
    NSMutableArray *arrSelectedUsers;
    BOOL isIncreased;
    CGFloat heightKeyboard;
    UIImage *imgPost;
    
}
@property (nonatomic, strong) NSString *msgType;
@property (weak, nonatomic) IBOutlet UITextField *tfGroupName;

@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;
@property (weak, nonatomic) IBOutlet UITextView *tvMsg;
@property (weak, nonatomic) IBOutlet UIView *viewMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (weak, nonatomic) IBOutlet UIView *viewParent1;
@property (weak, nonatomic) IBOutlet UIView *viewParent2;
@property (weak, nonatomic) IBOutlet UILabel *lblMsgTitle;

@property (weak, nonatomic) IBOutlet MintAnnotationChatView *annotationView;

@property (weak, nonatomic) IBOutlet UIButton *btnCamera;

@property (weak, nonatomic) IBOutlet UITableView *tbMsg;
@property (weak, nonatomic) IBOutlet UITableView *tbUsers;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewMsg_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewBottom_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewMsgTitle_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewBottom_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tvUsers_height;
@property (weak, nonatomic) IBOutlet UIButton *btnChevron;

@property (nonatomic, strong) CameraSelectView *cameraSelectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewImgPost_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_imgViewPhoto_height;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPhoto;



- (IBAction)onBtnEdit:(id)sender;
- (IBAction)onBtnChevron:(id)sender;

- (IBAction)onBtnCamera:(id)sender;
- (IBAction)onBtnSend:(id)sender;
- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnSwitch:(id)sender;
- (IBAction)onBtnClose:(id)sender;

@end
