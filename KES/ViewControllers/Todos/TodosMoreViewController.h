//
//  TodosMoreViewController.h
//  KES
//
//  Created by Piglet on 17.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import "TypeTableViewCell.h"

@interface TodosMoreViewController : UIViewController <UITextViewDelegate>
{
    int selectedViewIndex;
    
    int selectedAssigneeIndex;
    int selectedStatusIndex;
    
    int selectedAssignIndexForCommentView;
    
    int selectedAssigneeIndexForReopen;
    int selectedStatusIndexForReopen;
    NSArray *arrTestDataForAssignee;
    NSArray *arrTestDataForStatus;
    CGFloat keyboardHeight;
    NSString *strTVPlaceholder1;
}
@property (weak, nonatomic) IBOutlet UIView *viewContainer1;
@property (weak, nonatomic) IBOutlet UIView *viewContainer2;
@property (weak, nonatomic) IBOutlet UIView *viewContainer3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewContainter1_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewContainer1_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tvComment1_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tvComment2_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tvComment3_height;

- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnDoneComment:(id)sender;
- (IBAction)onBtnComment:(id)sender;
- (IBAction)onBtnReopen:(id)sender;


// ----- Done Comment -----
@property (weak, nonatomic) IBOutlet UIView *viewDoneComment;
@property (weak, nonatomic) IBOutlet UITextField *tfAssignee;
@property (weak, nonatomic) IBOutlet UITextField *tfStatus;
@property (weak, nonatomic) IBOutlet UITextView *tvComment;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewDoneComment_top;
@property (weak, nonatomic) IBOutlet UITableView *tbAssignee;
@property (weak, nonatomic) IBOutlet UITableView *tbStatus;

- (IBAction)onBtnAssignee:(id)sender;
- (IBAction)onBtnStatus:(id)sender;

// -----

// ----- Comment -----
@property (weak, nonatomic) IBOutlet UIView *viewComment;
@property (weak, nonatomic) IBOutlet UITextField *tfAssignForCommentView;
@property (weak, nonatomic) IBOutlet UITableView *tbAssignForCommentView;
@property (weak, nonatomic) IBOutlet UITextView *tvCommentForCommentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comstraint_viewComment_top;

- (IBAction)onBtnAssignForCommentView:(id)sender;

// ------


// ----- Reopen -----
@property (weak, nonatomic) IBOutlet UIView *viewReopen;
@property (weak, nonatomic) IBOutlet UITextField *tfAssigneeForReopen;
@property (weak, nonatomic) IBOutlet UITextField *tfStatusForReopen;
@property (weak, nonatomic) IBOutlet UITextView *tvCommentForReopen;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewForReopen_top;
@property (weak, nonatomic) IBOutlet UITableView *tbAssigneeForReopen;
@property (weak, nonatomic) IBOutlet UITableView *tbStatusForReopen;

- (IBAction)onBtnAssigneeForReopen:(id)sender;
- (IBAction)onBtnStatusForReopen:(id)sender;
// -----

@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)sliderChanged:(UISlider *)sender;



@end
