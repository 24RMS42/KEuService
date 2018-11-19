//
//  NewGroupMessageViewController.h
//  KES
//
//  Created by Piglet on 02.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MintAnnotationChatView.h"
#import "UserTableViewCell.h"
#import "ChatViewController.h"
@interface NewGroupMessageViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *arrTestAllUsers;
    NSMutableArray *arrUsers;
    NSMutableArray *arrSelectedUsers;
    NSString *strTVPlaceholder1;
}

@property (weak, nonatomic) IBOutlet UITextField *tfGroupName;
@property (weak, nonatomic) IBOutlet UIView *viewParent1;
@property (weak, nonatomic) IBOutlet UIView *viewParent2;
@property (weak, nonatomic) IBOutlet MintAnnotationChatView *annotationView;
@property (weak, nonatomic) IBOutlet UIView *viewFilter;
@property (weak, nonatomic) IBOutlet UITableView *tbUsers;

- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnCloseFilter:(id)sender;
- (IBAction)onBtnMessage:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewMsgTitle_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_lblFilter_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewBottom_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tvUsers_height;



@end
