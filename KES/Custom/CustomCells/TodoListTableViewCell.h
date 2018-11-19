//
//  TodoListTableViewCell.h
//  KES
//
//  Created by Piglet on 16.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
@protocol TodoListTableViewCellDelegate
- (void) onClickDoTomorrow:(id) cell;
- (void) onClickDoNextWeek:(id) cell;
- (void) onClickDone:(id) cell;
- (void) onClickMore:(id) cell;
@end



@interface TodoListTableViewCell : UITableViewCell

@property (nonatomic, strong) id <TodoListTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblTodoTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTodoType;
@property (weak, nonatomic) IBOutlet UIView *viewLine1;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationOrOther;
@property (weak, nonatomic) IBOutlet UIImageView *imgStopWatch;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountName;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UIImageView *imgAccount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_lblLocation_bottom;

- (void) configureCell:(NSDictionary *) dic;


// ----- Do Tomorrow -----

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewDoTomorrow_width;  // 68
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewDoTomorrow_left;
- (IBAction)onBtnDoTomorrow:(id)sender;

// end

// ----- Do Next week -----

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewDoNextWeek_width;  // 68
- (IBAction)onBtnDoNextWeek:(id)sender;

// end

// ----- Done -----
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewDone_width;
- (IBAction)onBtnDone:(id)sender;

// end

// ----- More -----

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewMore_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewMore_right;
- (IBAction)onBtnMore:(id)sender;

// end

@end
