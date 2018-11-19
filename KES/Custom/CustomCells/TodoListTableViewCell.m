//
//  TodoListTableViewCell.m
//  KES
//
//  Created by Piglet on 16.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "TodoListTableViewCell.h"

@implementation TodoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgUser.layer.cornerRadius = 27.5f;
    self.imgUser.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void) configureCell:(NSDictionary *) dic
{
    [self.imgUser setImage:[UIImage imageNamed:dic[TODO_LIST_IMAGE]]];
    self.lblTodoTitle.text = dic[TODO_LIST_TITLE];
    NSString *strType = dic[TODO_LIST_TYPE];
    self.lblTodoType.text = strType;
    if ([strType isEqualToString:@"Open"]) {
        [self.viewLine1 setBackgroundColor:[UIColor colorWithRed:184.0f/255 green:209.0f/255 blue:47.0f/255 alpha:1.0f]];
        [self.lblTodoType setTextColor:[UIColor colorWithRed:184.0f/255 green:209.0f/255 blue:47.0f/255 alpha:1.0f]];
        [self.lblTodoTitle setFont:[UIFont fontWithName:@"Roboto-Medium" size:20.0f]];
    }
    else if([strType isEqualToString:@"In progress"])
    {
        [self.viewLine1 setBackgroundColor:[UIColor colorWithRed:239.0f/255 green:144.0f/255 blue:34.0f/255 alpha:1.0f]];
        [self.lblTodoType setTextColor:[UIColor colorWithRed:239.0f/255 green:144.0f/255 blue:34.0f/255 alpha:1.0f]];
        [self.lblTodoTitle setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0f]];
    }
    else if([strType isEqualToString:@"Closed"])
    {
        [self.viewLine1 setBackgroundColor:[UIColor colorWithRed:138.0f/255 green:138.0f/255 blue:138.0f/255 alpha:1.0f]];
        [self.lblTodoType setTextColor:[UIColor colorWithRed:138.0f/255 green:138.0f/255 blue:138.0f/255 alpha:1.0f]];
        [self.lblTodoTitle setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0f]];
    }
    
    self.lblTime.text = dic[TODO_LIST_TIME];
    if (dic[TODO_LIST_LOCATION] && [dic[TODO_LIST_LOCATION] length] > 0) {
        self.lblLocationOrOther.text = dic[TODO_LIST_LOCATION];
        [self.imgStopWatch setImage:[UIImage imageNamed:@"stop_watch.png"]];
    }
    else if(dic[TODO_LIST_SUBJECT] && [dic[TODO_LIST_SUBJECT] length] > 0)
    {
        self.lblLocationOrOther.text = dic[TODO_LIST_SUBJECT];
        [self.imgStopWatch setImage:[UIImage imageNamed:@"tag.png"]];
    }
    
    self.lblDay.text = dic[TODO_LIST_DAY];
    
    if (dic[TODO_LIST_ACCOUNTNAME] && [dic[TODO_LIST_ACCOUNTNAME] length] > 0) {
        self.lblAccountName.text = dic[TODO_LIST_ACCOUNTNAME];
        self.imgAccount.alpha = 1.0f;
        self.constraint_lblLocation_bottom.constant = 5.0f;
    }
    else
    {
        self.lblAccountName.text = @"";
        self.imgAccount.alpha = 0.0f;
        self.constraint_lblLocation_bottom.constant = 0.0f;
    }
}
- (IBAction)onBtnDoTomorrow:(id)sender {
    [self.delegate onClickDoTomorrow:self];
}
- (IBAction)onBtnDoNextWeek:(id)sender {
    [self.delegate onClickDoNextWeek:self];
}
- (IBAction)onBtnDone:(id)sender {
    [self.delegate onClickDone:self];
}
- (IBAction)onBtnMore:(id)sender {
    [self.delegate onClickMore:self];
}
@end
