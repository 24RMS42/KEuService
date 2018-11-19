//
//  TodosListViewController.h
//  KES
//
//  Created by Piglet on 15.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoListTableViewCell.h"
#import "FilterContentTableViewCell.h"
#import "FilterHeaderTableViewCell.h"
#import "TodosMoreViewController.h"
#import "macro.h"

@interface TodosListViewController : UIViewController <UITextFieldDelegate, TodoListTableViewCellDelegate, FilterContentTableViewCellDelegate>
{
    NSMutableArray *arrTodos;
    NSString *strSearch;
    BOOL isShowingFilterView;

}


@property (weak, nonatomic) IBOutlet UIView *viewNoTodos;
@property (weak, nonatomic) IBOutlet UIView *viewNewTodos;
@property (weak, nonatomic) IBOutlet UILabel *lblCreateReminder;
@property (weak, nonatomic) IBOutlet UILabel *lblCreateAssignment;
@property (weak, nonatomic) IBOutlet UILabel *lblCreateTodo;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

// ----- Create new Todo press -----

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnTmp_height;  // 64
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnCreateReminder_height;  // 50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnCreateReminder_bottom;  // 20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnCreateAssignment_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnCreateAssignment_bottom;  // 10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnCreateTodo_height;  // 50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnCreateTodo_bottom;  // 10

// ------

@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySeg;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchClose;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_btnCancel_width;
@property (weak, nonatomic) IBOutlet UITableView *tbTodos;


- (IBAction)onBtnCreateReminder:(id)sender;
- (IBAction)onBtnCreateAssignment:(id)sender;
- (IBAction)onBtnCreateTodo:(id)sender;
- (IBAction)onBtnPlus:(id)sender;
- (IBAction)categorySegChanged:(id)sender;
- (IBAction)onBtnFilter:(id)sender;
- (IBAction)onBtnSearchClose:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

// ----- Filter View -----

@property (weak, nonatomic) IBOutlet UITableView *tbFilter;
@property (weak, nonatomic) IBOutlet UILabel *lblClearall;
@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;
@property (weak, nonatomic) IBOutlet UIView *viewFilterParent;
- (IBAction)onClear:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewFilter_right;


@end
