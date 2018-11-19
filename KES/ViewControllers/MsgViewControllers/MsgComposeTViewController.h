//
//  MsgComposeTViewController.h
//  KES
//
//  Created by Piglet on 22.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipientGeneralTableViewCell.h"
#import "RecipientPersonalTableViewCell.h"
#import "ChatViewController.h"

@interface MsgComposeTViewController : UIViewController
{
    NSString *strSearch;
    NSString *strTFPlaceholder;
    NSMutableArray *arrAttributes;
    NSMutableArray *arrSelected;
    NSString *strType;
}

@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgSearch;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnCancel_width;  // 46
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_imgSearch_widht;

- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnFilter:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
