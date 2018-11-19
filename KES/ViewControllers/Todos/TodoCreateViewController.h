//
//  TodoCreateViewController.h
//  KES
//
//  Created by Piglet on 21.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASJTagsView.h"
#import "TypeTableViewCell.h"
#import "Functions.h"
#import "TodoActivityTableViewCell.h"
#import "TodoActivityTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodoCreateViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    NSString *selectedPriority;
    NSMutableArray *arrPriority;
    
    NSString *strTVPlaceholder1;
    
    NSMutableArray *arrAssignAll;
    NSString *selectedAssign;
    NSMutableArray *arrAssign;
    
    NSMutableArray *arrStatus;
    NSString *selectedStatus;
    
    NSString *strSelectedDate;
    NSString *strSelectedTime;
    UITextField *tmpTf;
    UITextView *tmpTV;
    
    CGFloat mtfposition;
    CGFloat mtfHeight;
    CGFloat keyboardHeight;
    
    NSMutableArray *arrRegardingAll;
    NSMutableArray *arrRegarding;
    NSString *selectedRegarding;
    
    int duration;
    BOOL isRemind;
    
    float defaultHeight;
    float contentOffSet_y;
    
    NSMutableArray *arrActivity;
}

@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UIView *viewPriority;
@property (weak, nonatomic) IBOutlet UIView *viewDetail;
@property (weak, nonatomic) IBOutlet UIView *viewAssign;
@property (weak, nonatomic) IBOutlet UIView *viewStatus;
@property (weak, nonatomic) IBOutlet UIView *viewDate;
@property (weak, nonatomic) IBOutlet UIView *viewTime;
@property (weak, nonatomic) IBOutlet UIView *viewTag;
@property (weak, nonatomic) IBOutlet UIView *viewRegarding;
@property (weak, nonatomic) IBOutlet UIView *viewRegardingSearch;
@property (weak, nonatomic) IBOutlet UIView *viewBlack1;
@property (weak, nonatomic) IBOutlet UIView *viewBlackInSc;
@property (weak, nonatomic) IBOutlet UIView *scContainView;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segCategory;
@property (weak, nonatomic) IBOutlet UIScrollView *scDetails;
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrioriy;
@property (weak, nonatomic) IBOutlet UITableView *tbPriority;
@property (weak, nonatomic) IBOutlet UITextView *tvDetails;
@property (weak, nonatomic) IBOutlet UITextField *tfAssign;
@property (weak, nonatomic) IBOutlet UITextField *tfStatus;
@property (weak, nonatomic) IBOutlet UITableView *tbAssign;
@property (weak, nonatomic) IBOutlet UITextField *tfDate;
@property (weak, nonatomic) IBOutlet UITextField *tfTime;
@property (weak, nonatomic) IBOutlet UITextField *tfTag;
@property (weak, nonatomic) IBOutlet ASJTagsView *tagsView;
@property (weak, nonatomic) IBOutlet UILabel *lblRegarding;
@property (weak, nonatomic) IBOutlet UITextField *tfRegardingSearch;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UITableView *tbTag;
@property (weak, nonatomic) IBOutlet UITableView *tbRegarding;
@property (weak, nonatomic) IBOutlet UITableView *tbRegardingSearch;
@property (weak, nonatomic) IBOutlet UISlider *sliderDuration;
@property (weak, nonatomic) IBOutlet UISlider *sliderDuration1;
@property (weak, nonatomic) IBOutlet UIButton *btnRemind;
@property (weak, nonatomic) IBOutlet UITableView *tbStatus;
@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tbActivity;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_scDetails_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tagsView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_imgRegardSearch_width;   // 25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewDetails_height;



- (IBAction)segValueChanged:(id)sender;
- (IBAction)onBtnPriority:(id)sender;
- (IBAction)onDoneDate:(id)sender;
- (IBAction)onBtnStatus:(id)sender;
- (IBAction)onBtnCalendar:(id)sender;
- (IBAction)onBtnTime:(id)sender;
- (IBAction)onBtnRegarding:(id)sender;
- (IBAction)durationValueChanged:(id)sender;
- (IBAction)onBtnRemindme:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)datePickerChanged:(id)sender;


@end

NS_ASSUME_NONNULL_END
