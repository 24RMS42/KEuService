//
//  TodosListViewController.m
//  KES
//
//  Created by Piglet on 15.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "TodosListViewController.h"

@interface TodosListViewController ()
{
    NSMutableArray *arrSelectedSectionIndex;
    NSMutableArray *arrSetions;
    NSMutableArray *arrFilters;
    BOOL isMultipleExpansionAllowed;
    NSMutableArray *arrSelectedFilters;
    BOOL isSelectedForUnRead;

}
@end

@implementation TodosListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPlusBtnUI];
    
    arrTodos = [[NSMutableArray alloc] init];
    // ----- Filters Usage -----
    isMultipleExpansionAllowed = YES;
    arrSelectedSectionIndex = [[NSMutableArray alloc] init];
    arrSetions = [[NSMutableArray alloc] init];
    arrFilters = [[NSMutableArray alloc] init];
    arrSelectedFilters = [[NSMutableArray alloc] init];
    [self.tbFilter registerNib:[UINib nibWithNibName:@"FilterHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"FilterHeaderTableViewCell"];
    [self.tbFilter registerNib:[UINib nibWithNibName:@"FilterContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"FilterContentTableViewCell"];
    
    [self setTestDataForSection];
    // -----
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideItemsInNewTodoView)];
    [self.viewNewTodos addGestureRecognizer:tapGesture];
    
    [self.tbTodos registerNib:[UINib nibWithNibName:@"TodoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TodoListTableViewCell"];
    
    [self setTestData];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    [swipeLeft setDirection: UISwipeGestureRecognizerDirectionLeft ];
    [self.tbTodos addGestureRecognizer:swipeLeft];
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tbTodos addGestureRecognizer:swipeRight];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFilterView)];
    [self.viewBlackOpaque addGestureRecognizer:tapGesture1];
    
    [self performSelector:@selector(hideNoTodoView) withObject:nil afterDelay:3.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Functions
- (void) hideNoTodoView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewNoTodos.alpha = 0;
    }];
    
}
- (void) setTestData
{
    NSDictionary *dic = @{TODO_LIST_IMAGE: @"imgSample.png", TODO_LIST_TITLE:@"Do essay on Macbeth", TODO_LIST_TIME:@"Thu 1 Jan 2018 @ 4 - 5pm", TODO_LIST_TYPE: @"Open", TODO_LIST_LOCATION : @"Limerick, Room 1", TODO_LIST_SUBJECT:@"", TODO_LIST_ACCOUNTNAME:@"", TODO_LIST_DAY:@"Due Tomorrow"};
    NSDictionary *dic1 = @{TODO_LIST_IMAGE: @"imgSample.png", TODO_LIST_TITLE:@"Study for physics", TODO_LIST_TIME:@"Thu 1 Jan 2018 @ 4 - 5pm", TODO_LIST_TYPE: @"In progress", TODO_LIST_LOCATION : @"", TODO_LIST_SUBJECT:@"Personal, Study", TODO_LIST_ACCOUNTNAME:@"", TODO_LIST_DAY:@"Due Next week"};
    NSDictionary *dic2 = @{TODO_LIST_IMAGE: @"imgSample.png", TODO_LIST_TITLE:@"Chase payment", TODO_LIST_TIME:@"Thu 1 Jan 2018 @ 4 - 5pm", TODO_LIST_TYPE: @"Closed", TODO_LIST_LOCATION : @"", TODO_LIST_SUBJECT:@"accounts", TODO_LIST_ACCOUNTNAME:@"Georgiana Darcy", TODO_LIST_DAY:@"Due Next week"};
    
    [arrTodos addObject:dic];
    [arrTodos addObject:dic1];
    [arrTodos addObject:dic2];
}

- (void) setTestDataForSection
{
    [arrSetions removeAllObjects];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"Reporter" forKey:@"section_title"];
    [dic setObject:@"" forKey:@"section_content"];
    
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"Status" forKey:@"section_title"];
    [dic1 setObject:@"" forKey:@"section_content"];
    
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"Assignee" forKey:@"section_title"];
    [dic2 setObject:@"" forKey:@"section_content"];
    
    [arrSetions addObject:dic];
    [arrSetions addObject:dic1];
    [arrSetions addObject:dic2];
    
    [self setTestDataForFilter];
    
}
- (void) setTestDataForFilter
{
    NSMutableArray *arrTm1 = [NSMutableArray new];
    [arrTm1 addObject:@"Julie Kilmartin"];
    [arrTm1 addObject:@"Me"];
    
    NSMutableArray *arrTm2 = [NSMutableArray new];
    [arrTm2 addObject:@"In Progress"];
    [arrTm2 addObject:@"Open"];
    [arrTm2 addObject:@"Closed"];
    
    NSMutableArray *arrTm3 = [NSMutableArray new];
    [arrTm3 addObject:@"Teacher 1"];
    [arrTm3 addObject:@"Teacher 2"];
    [arrTm3 addObject:@"Teacher 3"];
    [arrTm3 addObject:@"Frined 1"];
    [arrTm3 addObject:@"Frined 2"];
    [arrTm3 addObject:@"Frined 3"];
    
    [arrFilters addObject:arrTm1];
    [arrFilters addObject:arrTm2];
    [arrFilters addObject:arrTm3];
    
}


- (void) setPlusBtnUI
{
    self.btnPlus.layer.cornerRadius = 32.0f;
    self.btnPlus.layer.masksToBounds = YES;
}
- (void) hideItemsInNewTodoView
{
    self.constraint_btnTmp_height.constant = 32;
    self.constraint_btnCreateReminder_height.constant = 0;
    self.constraint_btnCreateReminder_bottom.constant = 0;
    self.constraint_btnCreateAssignment_height.constant = 0;
    self.constraint_btnCreateAssignment_bottom.constant = 0;
    self.constraint_btnCreateTodo_height.constant = 0;
    self.constraint_btnCreateTodo_bottom.constant = 0;

    [UIView animateWithDuration:0.3 animations:^{
        self.lblCreateTodo.alpha = 0.0f;
        self.lblCreateReminder.alpha = 0.0f;
        self.lblCreateAssignment.alpha = 0.0f;
        
        [self.view layoutIfNeeded];
    }];
    
    [self performSelector:@selector(hideNewTodoView) withObject:nil afterDelay:0.3];
}

- (void) hideNewTodoView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewNewTodos.alpha = 0.0f;
        [self.btnPlus setBackgroundColor:[UIColor colorWithRed:16.0/255.0 green:42.0/255.0 blue:108.0/255.0 alpha:1.0f]];
    }];
}

- (void) showNewTodoView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewNewTodos.alpha = 1.0f;
        
    }];
    [self performSelector:@selector(showItemsInNewTodoView) withObject:nil afterDelay:0.3];
}

- (void) showItemsInNewTodoView
{
    self.constraint_btnTmp_height.constant = 64;
    
    self.constraint_btnCreateReminder_height.constant = 50;
    self.constraint_btnCreateReminder_bottom.constant = 10;
    self.constraint_btnCreateAssignment_height.constant = 50;
    self.constraint_btnCreateAssignment_bottom.constant = 10;
    self.constraint_btnCreateTodo_height.constant = 50;
    self.constraint_btnCreateTodo_bottom.constant = 10;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lblCreateTodo.alpha = 1.0f;
        self.lblCreateReminder.alpha = 1.0f;
        self.lblCreateAssignment.alpha = 1.0f;
        [self.btnPlus setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:186.0/255.0 blue:233.0/255.0 alpha:1.0f]];
        [self.view layoutIfNeeded];
    }];
}

-(void)rightSwipe:(UISwipeGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.tbTodos];
    NSIndexPath * indexPath = [self.tbTodos indexPathForRowAtPoint:location];
    if (indexPath) {
        TodoListTableViewCell *cell = (TodoListTableViewCell *) [self.tbTodos cellForRowAtIndexPath:indexPath];
        if (cell.constraint_viewDone_width.constant != 0.0f)
        {
            cell.constraint_viewDone_width.constant = 0.0f;
            cell.constraint_viewMore_width.constant = 0.0f;
            cell.constraint_viewDoTomorrow_left.constant = 0.0f;
        }
        else
        {
            if (cell.constraint_viewDoTomorrow_width.constant == 0) {
                cell.constraint_viewDoTomorrow_width.constant = 68.0f;
                cell.constraint_viewDoNextWeek_width.constant = 68.0f;
                cell.constraint_viewMore_right.constant = -136.0f;
            }
            else
            {
                cell.constraint_viewDoTomorrow_width.constant = 0.0f;
                cell.constraint_viewDoNextWeek_width.constant = 68.0f;
                cell.constraint_viewMore_right.constant = 0.0f;
            }
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [cell layoutIfNeeded];
        }];
    }
}

-(void)leftSwipe:(UISwipeGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.tbTodos];
    NSIndexPath * indexPath = [self.tbTodos indexPathForRowAtPoint:location];
    if (indexPath) {
        TodoListTableViewCell *cell = (TodoListTableViewCell *) [self.tbTodos cellForRowAtIndexPath:indexPath];
        if (cell.constraint_viewDoTomorrow_width.constant != 0.0f) {
            cell.constraint_viewDoTomorrow_width.constant = 0.0f;
            cell.constraint_viewDoNextWeek_width.constant = 0.0f;
            cell.constraint_viewMore_right.constant = 0.0f;
        }
        else
        {
            if (cell.constraint_viewDone_width.constant == 0) {
                cell.constraint_viewDone_width.constant = 68.0f;
                cell.constraint_viewMore_width.constant = 68.0f;
                cell.constraint_viewDoTomorrow_left.constant = -136.0f;
            }
            else
            {
                cell.constraint_viewDone_width.constant = 0.0f;
                cell.constraint_viewMore_width.constant = 0.0f;
                cell.constraint_viewDoTomorrow_left.constant = 0.0f;
            }
        }
        [UIView animateWithDuration:0.3 animations:^{
            [cell layoutIfNeeded];
        }];
    }
}
- (void) hideFilterView
{
    isShowingFilterView = false;
    [self showFilterView];
    [self showBlackOpaqueView];
}
- (void) showFilterView
{
    if (isShowingFilterView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.btnFilter setImage:[UIImage imageNamed:@"filter_press.png"] forState:UIControlStateNormal];
            self.viewFilterParent.alpha = 1.0f;
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.viewFilterParent.alpha = 0.0f;
            [self.btnFilter setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
            [self.view layoutIfNeeded];
        }];
    }
    
}

- (void) showBlackOpaqueView
{
    if (isShowingFilterView) {
        [Functions showStatusBarBlackView];
        [UIView animateWithDuration:0.3 animations:^{
            self.viewBlackOpaque.alpha = 0.7;
        }];
    }
    else
    {
        [Functions hideStatusBarBlackView];
        [UIView animateWithDuration:0.3 animations:^{
            self.viewBlackOpaque.alpha = 0.0f;
        }];
        
    }
    
}

- (void) setLblClearallWithCount
{
    if (arrSelectedFilters.count > 0) {
        self.lblClearall.text = [NSString stringWithFormat:@"Clear all(%lu)", (unsigned long)arrSelectedFilters.count];
    }
    else
        self.lblClearall.text = @"Clear all";
//    [self setMsgArrayWithSearchAndFilter];
}


-(void)btnTapShowHideSection:(UIButton*)sender
{
    if(sender.tag == 3)
    {
        isSelectedForUnRead = !isSelectedForUnRead;
        [self setLblClearallWithCount];
    }
    else
    {
        if (![arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:sender.tag]])
        {
            [arrSelectedSectionIndex removeAllObjects];
            [arrSelectedSectionIndex addObject:[NSNumber numberWithInteger:sender.tag]];
        }
        else{
            [arrSelectedSectionIndex removeObject:[NSNumber numberWithInteger:sender.tag]];
        }
        
    }
    [self.tbFilter reloadData];
    
}

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.tbFilter]) {
        return arrSetions.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tbFilter]) {
        return 58.0f;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tbFilter])
    {
        if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
        {
            NSArray *arrTmp = [arrFilters objectAtIndex:section];
            return arrTmp.count;
        }else{
            return 0;
        }
    }
    return arrTodos.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tbFilter])
    {
        FilterContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterContentTableViewCell"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FilterContentTableViewCell"];
        }
        NSArray *arrTmp = [arrFilters objectAtIndex:indexPath.section];
        NSString *strTmp = [arrTmp objectAtIndex:indexPath.row];
        BOOL isIncluding = false;
        if ([arrSelectedFilters containsObject:strTmp]) {
            isIncluding = YES;
        }

        [cell configureCell:strTmp isSelected:isIncluding];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else
    {
        NSDictionary *dic = [arrTodos objectAtIndex:indexPath.row];
        TodoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodoListTableViewCell"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"TodoListTableViewCell"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureCell:dic];
        
        return cell;
    }
    
    return nil;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    FilterHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterHeaderTableViewCell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FilterHeaderTableViewCell"];
    }
    NSDictionary *dic = [arrSetions objectAtIndex:section];
    
    cell.lblTitle.text = [dic objectForKey:@"section_title"];
    cell.lblContent.text = [dic objectForKey:@"section_content"];
    if (section == 3) {
        [cell.btnCollapse setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [cell.btnCollapse setImage:[UIImage imageNamed:@"check1.png"] forState:UIControlStateSelected];
        if (isSelectedForUnRead) {
            cell.btnCollapse.selected = YES;
        }
        else
            cell.btnCollapse.selected = NO;
    }
    else
    {
        [cell.btnCollapse setImage:[UIImage imageNamed:@"chevron_down.png"] forState:UIControlStateNormal];
        [cell.btnCollapse setImage:[UIImage imageNamed:@"expanded.png"] forState:UIControlStateSelected];
        if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
        {
            cell.btnCollapse.selected = YES;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell btnOverwrap] setTag:section];
    [[cell btnOverwrap] addTarget:self action:@selector(btnTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
#pragma mark - FilterContentTableViewCellDelegate

- (void) clickCheck:(id) cell
{
    NSIndexPath *indexPath = [self.tbFilter indexPathForCell:cell];
    NSArray *arrTmp = [arrFilters objectAtIndex:indexPath.section];
    NSString *strTmp = [arrTmp objectAtIndex:indexPath.row];
    
    if (![arrSelectedFilters containsObject:strTmp]) {
        [arrSelectedFilters addObject:strTmp];
    }
    else
    {
        [arrSelectedFilters removeObject:strTmp];
    }
    // ----- Reporter -----
    NSMutableDictionary *dic = [arrSetions firstObject];
    NSString *strTmp1 = @"";
    NSArray *arrSubFilter1 = [arrFilters objectAtIndex:0];
    for (int i=0; i<arrSubFilter1.count; i++) {
        NSString *strFilter = [arrSubFilter1 objectAtIndex:i];  // Julie Kilmartin or Me
        if ([arrSelectedFilters containsObject:strFilter]) {
            if (strTmp1.length > 0) {
                strTmp1 = [NSString stringWithFormat:@"%@, %@", strTmp1, strFilter];
            }
            else
                strTmp1 = strFilter;
        }
    }
    [dic setObject:strTmp1 forKey:@"section_content"];
    [arrSetions replaceObjectAtIndex:0 withObject:dic];
    // -----
    
    // ------ Status -----
    NSMutableDictionary *dic1 = [arrSetions objectAtIndex:1];
    strTmp1 = @"";

    NSArray *arrSubFilter2 = [arrFilters objectAtIndex:1];
    for (int i=0; i<arrSubFilter2.count; i++) {
        NSString *strFilter = [arrSubFilter2 objectAtIndex:i];
        if ([arrSelectedFilters containsObject:strFilter]) {
            if (strTmp1.length > 0) {
                strTmp1 = [NSString stringWithFormat:@"%@, %@", strTmp1, strFilter];
            }
            else
                strTmp1 = strFilter;
        }
    }
    [dic1 setObject:strTmp1 forKey:@"section_content"];
    [arrSetions replaceObjectAtIndex:1 withObject:dic1];
    
    // -----
    
    // ----- Assignee -----
    NSMutableDictionary *dic2 = [arrSetions objectAtIndex:2];
    strTmp1 = @"";
    NSArray *arrSubFilter3 = [arrFilters objectAtIndex:2];
    for (int i=0; i<arrSubFilter3.count; i++) {
        NSString *strFilter = [arrSubFilter3 objectAtIndex:i];
        if ([arrSelectedFilters containsObject:strFilter]) {
            if (strTmp1.length > 0) {
                strTmp1 = [NSString stringWithFormat:@"%@, %@", strTmp1, strFilter];
            }
            else
                strTmp1 = strFilter;
        }
    }
    [dic2 setObject:strTmp1 forKey:@"section_content"];
    [arrSetions replaceObjectAtIndex:2 withObject:dic2];
    
    // -----
    
    
    [self.tbFilter reloadData];
    [self setLblClearallWithCount];
}
#pragma mark - TodoListTableViewCellDelegate

- (void) onClickDoTomorrow:(id) cell
{
    TodoListTableViewCell *tmpCell = (TodoListTableViewCell *) cell;
//    NSIndexPath *indexPath = [self.tbTodos indexPathForCell:tmpCell];
    
    // Do something
    // -----
    //
    tmpCell.constraint_viewDoTomorrow_width.constant = 0;
    tmpCell.constraint_viewDoNextWeek_width.constant = 0;
    tmpCell.constraint_viewMore_right.constant = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [tmpCell layoutIfNeeded];
    }];

}
- (void) onClickDoNextWeek:(id) cell
{
    TodoListTableViewCell *tmpCell = (TodoListTableViewCell *) cell;
//    NSIndexPath *indexPath = [self.tbTodos indexPathForCell:tmpCell];
    
    // Do something
    // -----
    //
    tmpCell.constraint_viewDoTomorrow_width.constant = 0;
    tmpCell.constraint_viewDoNextWeek_width.constant = 0;
    tmpCell.constraint_viewMore_right.constant = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [tmpCell layoutIfNeeded];
    }];

}
- (void) onClickDone:(id) cell
{
    TodoListTableViewCell *tmpCell = (TodoListTableViewCell *) cell;
//    NSIndexPath *indexPath = [self.tbTodos indexPathForCell:tmpCell];
    
    // Do something
    // -----
    //
    tmpCell.constraint_viewDone_width.constant = 0;
    tmpCell.constraint_viewMore_width.constant = 0;
    tmpCell.constraint_viewDoTomorrow_left.constant = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [tmpCell layoutIfNeeded];
    }];
}
- (void) onClickMore:(id) cell
{
    TodoListTableViewCell *tmpCell = (TodoListTableViewCell *) cell;
//    NSIndexPath *indexPath = [self.tbTodos indexPathForCell:tmpCell];

    // Do something
    // -----
    //
    tmpCell.constraint_viewDone_width.constant = 0;
    tmpCell.constraint_viewMore_width.constant = 0;
    tmpCell.constraint_viewDoTomorrow_left.constant = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [tmpCell layoutIfNeeded];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TODO_LIST_MORE object:nil];
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.constraint_btnCancel_width.constant = 46.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.btnFilter.hidden = YES;
    self.btnSearchClose.hidden = false;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    self.btnSearchClose.hidden = YES;
    self.btnFilter.hidden = false;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strText =  [textField.text stringByReplacingCharactersInRange:range withString:string];
    strSearch = strText;
//    [self setMsgArrayWithSearchAndFilter];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tfSearch resignFirstResponder];
    return YES;
}

#pragma mark - Actions

- (IBAction)onBtnCreateReminder:(id)sender {
    [self hideItemsInNewTodoView];
}

- (IBAction)onBtnCreateAssignment:(id)sender {
    [self hideItemsInNewTodoView];
}

- (IBAction)onBtnCreateTodo:(id)sender {
    [self hideItemsInNewTodoView];
    [[NSNotificationCenter defaultCenter] postNotificationName:TODO_CREATE object:nil userInfo:nil];
}

- (IBAction)onBtnPlus:(id)sender {
    if (self.viewNewTodos.alpha == 1.0f) {
        [self hideItemsInNewTodoView];
        return;
    }
    [self showNewTodoView];
}

- (IBAction)categorySegChanged:(id)sender {
}

- (IBAction)onBtnFilter:(id)sender {
    if (self.constraint_btnCancel_width.constant != 0) {
        self.constraint_viewFilter_right.constant = -46.0f;
    }
    else
        self.constraint_viewFilter_right.constant = 0.0f;
//    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
//    }];
    isShowingFilterView = !isShowingFilterView;
    if (isShowingFilterView) {
        [self showBlackOpaqueView];
        [self showFilterView];
    }
    else
    {
        [self showFilterView];
        [self showBlackOpaqueView];
    }
}

- (IBAction)onBtnSearchClose:(id)sender {
    if (self.tfSearch.text.length == 0) {
        return;
    }
//    self.btnSearchClose.hidden = YES;
//    self.btnFilter.hidden = NO;
    self.tfSearch.text = @"";
    
}

- (IBAction)onBtnCancel:(id)sender {
    
    self.tfSearch.text = @"";
    
    [self.tfSearch resignFirstResponder];
    self.constraint_btnCancel_width.constant = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    strSearch = @"";

    
    [self.tbTodos reloadData];

}

- (IBAction)onClear:(id)sender
{
    [self setTestDataForSection];
    [arrSelectedFilters removeAllObjects];
    isSelectedForUnRead = false;
    [self setLblClearallWithCount];
    [self.tbFilter reloadData];

}
@end
