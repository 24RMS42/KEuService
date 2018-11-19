//
//  ChatViewController.h
//  KES
//
//  Created by Piglet on 25.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentView.h"
#import "ChatTableViewCellXIB.h"
#import "ChatCellSettings.h"
#import "iMessage.h"
#import "MessagesViewController.h"
#import "CameraSelectView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CameraSelectViewDelegate>
{
    // For Test
    BOOL isSend;
    
    NSString *strTVPlaceholder;
    BOOL isEnableReply;
    UIImage *imgPost;
}

@property (nonatomic, assign) BOOL isNoReply;
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (nonatomic, strong) NSArray *arrUsers;
@property (nonatomic, strong) NSString *strType;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblNoreply;

@property (weak, nonatomic) IBOutlet UIView *viewTitleSub;
@property (weak, nonatomic) IBOutlet UIView *viewTitleContain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewTop_height;
@property (weak, nonatomic) IBOutlet UIView *viewMore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewMore_height;
@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaqure;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) CameraSelectView *cameraSelectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewImgPost_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_imgViewPhoto_height;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPhoto;

- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnSwitch:(id)sender;
- (IBAction)onBtnCamera:(id)sender;
- (IBAction)onBtnMore:(id)sender;
- (IBAction)onBtnAddPeople:(id)sender;
- (IBAction)onBtnMute:(id)sender;
- (IBAction)onBtnUnread:(id)sender;
- (IBAction)onBtnArchive:(id)sender;
- (IBAction)onBtnReport:(id)sender;
- (IBAction)onBtnDelete:(id)sender;
- (IBAction)onBtnClose:(id)sender;


@end
