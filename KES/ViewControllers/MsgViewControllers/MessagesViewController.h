//
//  MessagesViewController.h
//  KES
//
//  Created by Piglet on 20.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgListTableViewCell.h"
#import "MsgComposeTViewController.h"
#import "MsgCreateViewController.h"
#import "FilterHeaderTableViewCell.h"
#import "FilterContentTableViewCell.h"
#import "ChatViewController.h"
#import "NewGroupMessageViewController.h"
@interface MessagesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, FilterContentTableViewCellDelegate, MsgListTableViewCellDelegate>
{
    NSString *strSearch;
    NSMutableArray *arrMsgs;
    BOOL isShowingFilterView;
    NSMutableArray *arrTestData;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIView *viewNoMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UITableView *tbMessaging;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgSearch;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnCancel_width;  // 46
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_imgSearch_widht;

@property (weak, nonatomic) IBOutlet UIView *viewNewMsg;
@property (weak, nonatomic) IBOutlet UILabel *lblComposeOne;
@property (weak, nonatomic) IBOutlet UILabel *lblComposeGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnComposeOne;
@property (weak, nonatomic) IBOutlet UIButton *btnComposeGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnTmp;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnTmp_height; // 64
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnComposeOne_height;  // 50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnComposeGroup_height;  // 50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnComposeOne_bottom;  // 40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnComposeGroup_bottom;  // 30


@property (weak, nonatomic) IBOutlet UITableView *tbFilter;
@property (weak, nonatomic) IBOutlet UILabel *lblClearall;
@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;
@property (weak, nonatomic) IBOutlet UIView *viewFilterParent;


@property (nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewNav_height;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchClose;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchMsg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewFilter_right;

- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnPlus:(id)sender;
- (IBAction)onBtnFilter:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnComposeOne:(id)sender;
- (IBAction)onBtnComposeGroup:(id)sender;
- (IBAction)onBtnSearchClose:(id)sender;

- (IBAction)onClear:(id)sender;

@end
