//
//  TodosMoreViewController.m
//  KES
//
//  Created by Piglet on 17.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "TodosMoreViewController.h"

@interface TodosMoreViewController ()

@end

@implementation TodosMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    selectedAssigneeIndex = -1;
    selectedStatusIndex = -1;
    selectedAssignIndexForCommentView = -1;
    selectedAssigneeIndexForReopen = -1;
    selectedStatusIndexForReopen = -1;
    
    if ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height == 568) {
        self.constraint_tvComment1_height.constant = 150.0f;
        self.constraint_tvComment2_height.constant = 150.0f;
        self.constraint_tvComment3_height.constant = 150.0f;
        
    }
    else
    {
        self.constraint_tvComment1_height.constant = 200.0f;
        self.constraint_tvComment2_height.constant = 200.0f;
        self.constraint_tvComment3_height.constant = 200.0f;
    }
    
    strTVPlaceholder1 = @"Add your comment";
    [self.tbAssignee registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    [self.tbStatus registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    
    [self.tbAssignForCommentView registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    
    [self.tbAssigneeForReopen registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    [self.tbStatusForReopen registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    
    arrTestDataForAssignee = @[@"Tara", @"test1", @"test2", @"test3", @"test4", @"test5", @"test6", @"test7"];
    arrTestDataForStatus = @[@"Open", @"In progress", @"Closed"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self setupKeyboardToolBar];
    [self showViewForSelectedIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return true;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView isEqual:self.tvComment]) {
        self.tbAssignee.alpha = 0.0f;
        self.tbStatus.alpha = 0.0f;
        
    }
    else if ([textView isEqual:self.tvCommentForCommentView])
    {
        self.tbAssignForCommentView.alpha = 0.0f;
        
    }
    
    if ([textView.text isEqualToString:strTVPlaceholder1]) {
        textView.text = @"";
        [textView setTextColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0]];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.tvComment] || [textView isEqual:self.tvCommentForCommentView]) {
        if ([textView.text isEqualToString:@""]) {
            [textView setTextColor:[UIColor colorWithRed:120.0f/255 green:120.0f/255 blue:120.0f/255 alpha:1.0]];
            textView.text = strTVPlaceholder1;
        }
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *strComment = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return true;
}

#pragma mark - Keyboard

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardFrame = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRectangle = [keyboardFrame CGRectValue];
    CGFloat offsetY = keyboardRectangle.size.height;
    keyboardHeight = offsetY;
    
    NSLog(@"constant=%f", self.constraint_viewDoneComment_top.constant - (keyboardHeight-65));
    CGFloat changedValue = self.constraint_viewDoneComment_top.constant - (keyboardHeight - 65);
    if (changedValue < - 100) {
        changedValue = -96;
    }
    self.constraint_viewDoneComment_top.constant = changedValue ;
    
    self.comstraint_viewComment_top.constant = changedValue ;
    
    self.constraint_viewForReopen_top.constant = changedValue ;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    self.constraint_viewDoneComment_top.constant = 141 ;
    
    self.comstraint_viewComment_top.constant = 141 ;
    
    self.constraint_viewForReopen_top.constant = 141 ;

    
    keyboardHeight = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - Functions

- (void) showViewForSelectedIndex
{
    switch (selectedViewIndex) {
        case 0:
        {
            [self.viewContainer1 setBackgroundColor:[UIColor colorWithRed:0 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
            [self.viewContainer2 setBackgroundColor:[UIColor whiteColor]];
            [self.viewContainer3 setBackgroundColor:[UIColor whiteColor]];
            
            self.viewDoneComment.alpha = 1.0f;
            self.viewComment.alpha = 0.0f;
            self.viewReopen.alpha = 0.0f;
        }
            break;
        case 1:
        {
            [self.viewContainer1 setBackgroundColor:[UIColor whiteColor]];
            [self.viewContainer2 setBackgroundColor:[UIColor colorWithRed:0 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
            [self.viewContainer3 setBackgroundColor:[UIColor whiteColor]];
            self.viewDoneComment.alpha = 0.0f;
            self.viewComment.alpha = 1.0f;
            self.viewReopen.alpha = 0.0f;
        }
            break;
        case 2:
        {
            [self.viewContainer1 setBackgroundColor:[UIColor whiteColor]];
            [self.viewContainer2 setBackgroundColor:[UIColor whiteColor]];
            [self.viewContainer3 setBackgroundColor:[UIColor colorWithRed:0 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
            
            self.viewDoneComment.alpha = 0.0f;
            self.viewComment.alpha = 0.0f;
            self.viewReopen.alpha = 1.0f;
        }
            break;
            
        default:
            break;
    }
}
- (void) setupKeyboardToolBar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    [numberToolbar setBackgroundColor:[UIColor colorWithRed:220.0/255.0f green:220.0/255.0f blue:220.0/255.0f alpha:1.0f]];
    self.tvComment.inputAccessoryView = numberToolbar;
    self.tvCommentForCommentView.inputAccessoryView = numberToolbar;
    self.tvCommentForReopen.inputAccessoryView = numberToolbar;
}

-(void)doneWithNumberPad{
    [self.tvComment resignFirstResponder];
    [self.tvCommentForCommentView resignFirstResponder];
    [self.tvCommentForReopen resignFirstResponder];
}

- (void) setUI
{
    CGFloat width_container = ([[UIScreen mainScreen] bounds].size.width - 20 * 2 - 15 * 2)/3;
    self.constraint_viewContainter1_width.constant = width_container;
    self.constraint_viewContainer1_height.constant = width_container;
    
    [Functions setBoundsWithView:self.tfAssignee];
    [Functions setBoundsWithView:self.tfStatus];
    [Functions setBoundsWithView:self.tvComment];
    [Functions setBoundsWithView:self.tbAssignee];
    [Functions setBoundsWithView:self.tbStatus];
    [Functions setBoundsWithView:self.tbAssignForCommentView];
    [Functions setBoundsWithView:self.tfAssignForCommentView];
    [Functions setBoundsWithView:self.tbAssigneeForReopen];
    [Functions setBoundsWithView:self.tbStatusForReopen];
    [Functions setBoundsWithView:self.tfAssigneeForReopen];
    [Functions setBoundsWithView:self.tfStatusForReopen];
    [Functions setBoundsWithView:self.tvCommentForReopen];
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
// ----- Done Comment -----

- (void) setAssigneeName
{
    if (selectedAssigneeIndex == -1) {
        return;
    }
    NSString *strName = [arrTestDataForAssignee objectAtIndex:selectedAssigneeIndex];
    self.tfAssignee.text = strName;
}

- (void) setStatusName
{
    if (selectedStatusIndex == -1) {
        return;
    }
    NSString *strStatusName = [arrTestDataForStatus objectAtIndex:selectedStatusIndex];
    self.tfStatus.text = strStatusName;
}

- (void) setAssignTb
{
    if (self.tbAssignee.alpha == 1.0f) {
        [UIView animateWithDuration:0.3f animations:^{
            self.tbAssignee.alpha = 0.0f;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.tbAssignee.alpha = 1.0f;
            self.tbStatus.alpha = 0.0f;
        }];
    }
}

- (void) setStatusTb
{
    if (self.tbStatus.alpha == 1.0f) {
        [UIView animateWithDuration:0.3f animations:^{
            self.tbStatus.alpha = 0.0f;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.tbStatus.alpha = 1.0f;
            self.tbAssignee.alpha = 0.0f;
        }];
    }
}
// -----

// ----- Comment View -----
- (void) setAssignTbForCommentView
{
    if (self.tbAssignForCommentView.alpha == 1.0f) {
        [UIView animateWithDuration:0.3f animations:^{
            self.tbAssignForCommentView.alpha = 0.0f;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.tbAssignForCommentView.alpha = 1.0f;
        }];
    }
}

- (void) setAssignNameForCommentView
{
    if (selectedAssignIndexForCommentView == -1) {
        return;
    }
    NSString *strName = [arrTestDataForAssignee objectAtIndex:selectedAssignIndexForCommentView];
    self.tfAssignForCommentView.text = strName;
}

// -----

// ----- Reopen -----

- (void) setAssigneeNameForReopen
{
    if (selectedAssigneeIndexForReopen == -1) {
        return;
    }
    NSString *strName = [arrTestDataForAssignee objectAtIndex:selectedAssigneeIndexForReopen];
    self.tfAssigneeForReopen.text = strName;
}

- (void) setStatusNameForReopen
{
    if (selectedStatusIndexForReopen == -1) {
        return;
    }
    NSString *strStatusName = [arrTestDataForStatus objectAtIndex:selectedStatusIndexForReopen];
    self.tfStatusForReopen.text = strStatusName;
}

- (void) setAssignTbForReopen
{
    if (self.tbAssigneeForReopen.alpha == 1.0f) {
        [UIView animateWithDuration:0.3f animations:^{
            self.tbAssigneeForReopen.alpha = 0.0f;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.tbAssigneeForReopen.alpha = 1.0f;
            self.tbStatusForReopen.alpha = 0.0f;
        }];
    }
}

- (void) setStatusTbForReopen
{
    if (self.tbStatusForReopen.alpha == 1.0f) {
        [UIView animateWithDuration:0.3f animations:^{
            self.tbStatusForReopen.alpha = 0.0f;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.tbStatusForReopen.alpha = 1.0f;
            self.tbAssigneeForReopen.alpha = 0.0f;
        }];
    }
}

// -----

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tbAssignee]) {
        return arrTestDataForAssignee.count;
    }
    if ([tableView isEqual:self.tbStatus]) {
        return arrTestDataForStatus.count;
    }
    if ([tableView isEqual:self.tbAssigneeForReopen]) {
        return arrTestDataForAssignee.count;
    }
    if ([tableView isEqual:self.tbStatusForReopen]) {
        return arrTestDataForStatus.count;
    }
    if ([tableView isEqual:self.tbAssignForCommentView]) {
        return arrTestDataForAssignee.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.tbAssignee]) {
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
        NSString *strName = [arrTestDataForAssignee objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strName;
        if (selectedAssigneeIndex == indexPath.row) {
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:0 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if([tableView isEqual:self.tbStatus])
    {
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
        NSString *strStatus = [arrTestDataForStatus objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strStatus;
        if (selectedStatusIndex == indexPath.row) {
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:0 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if ([tableView isEqual:self.tbAssignForCommentView]) {
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
        NSString *strName = [arrTestDataForAssignee objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strName;
        if (selectedAssignIndexForCommentView == indexPath.row) {
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:0 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if([tableView isEqual:self.tbAssigneeForReopen])
    {
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
        NSString *strName = [arrTestDataForAssignee objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strName;
        if (selectedAssigneeIndexForReopen == indexPath.row) {
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:0 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if([tableView isEqual:self.tbStatusForReopen])
    {
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
        NSString *strStatus = [arrTestDataForStatus objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strStatus;
        if (selectedStatusIndexForReopen == indexPath.row) {
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:0 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tbAssignee]) {
        selectedAssigneeIndex = (int)indexPath.row;
        [self setAssigneeName];
        [self setAssignTb];
        [self.tbAssignee reloadData];
    }
    if ([tableView isEqual:self.tbStatus]) {
        selectedStatusIndex = (int) indexPath.row;
        [self setStatusTb];
        [self setStatusName];
        [self.tbStatus reloadData];
    }
    if ([tableView isEqual:self.tbAssignForCommentView]) {
        selectedAssignIndexForCommentView = (int) indexPath.row;
        [self setAssignTbForCommentView];
        [self setAssignNameForCommentView];
        [self.tbAssignForCommentView reloadData];
    }
    if ([tableView isEqual:self.tbAssigneeForReopen]) {
        selectedAssigneeIndexForReopen = (int) indexPath.row;
        [self setAssigneeNameForReopen];
        [self setAssignTbForReopen];
        [self.tbAssigneeForReopen reloadData];
    }
    if ([tableView isEqual:self.tbStatusForReopen]) {
        selectedStatusIndexForReopen = (int) indexPath.row;
        [self setStatusTbForReopen];
        [self setStatusNameForReopen];
        [self.tbStatusForReopen reloadData];
    }
}

#pragma mark - Actions

- (IBAction)onBtnCancel:(id)sender {
    [self goBack];
}

- (IBAction)onBtnSave:(id)sender {
    [self goBack];
}

- (IBAction)onBtnDoneComment:(id)sender {
    selectedViewIndex = 0;
    [self showViewForSelectedIndex];
}

- (IBAction)onBtnComment:(id)sender {
    selectedViewIndex = 1;
    [self showViewForSelectedIndex];
}

- (IBAction)onBtnReopen:(id)sender {
    selectedViewIndex = 2;
    [self showViewForSelectedIndex];
}
- (IBAction)onBtnAssignee:(id)sender {
    [self setAssignTb];
    
}

- (IBAction)onBtnStatus:(id)sender {
    [self setStatusTb];
    
}
- (IBAction)onBtnAssignForCommentView:(id)sender {
    [self setAssignTbForCommentView];
}

- (IBAction)onBtnAssigneeForReopen:(id)sender
{
    [self setAssignTbForReopen];
}
- (IBAction)onBtnStatusForReopen:(id)sender
{
    [self setStatusTbForReopen];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    
    NSLog(@"sss=%f", sender.value);
}
- (IBAction)sliderTouchUpInside:(id)sender {
}
- (IBAction)sliderTouchDragInside:(id)sender {
}


@end
