//
//  NewGroupMessageViewController.m
//  KES
//
//  Created by Piglet on 02.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "NewGroupMessageViewController.h"

@interface NewGroupMessageViewController ()

@end

@implementation NewGroupMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.tbUsers registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserTableViewCell"];
    arrUsers = [NSMutableArray new];
    arrSelectedUsers = [NSMutableArray new];
    self.annotationView.delegate = self;
    self.annotationView.nameTagImage = [[UIImage imageNamed:@"tagImage"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    self.annotationView.nameTagColor = [UIColor colorWithRed:30.0/255 green:30.0/255 blue:30.0/255 alpha:1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationRemoved:) name:@"annotation_removed" object:nil];
    
    strTVPlaceholder1 = @"To: ";
    
    [self setTestDataForUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Functions
- (void)viewDidUnload {
    [self setAnnotationView:nil];
    [super viewDidUnload];
}

- (void) annotationRemoved:(NSNotification *) notification
{
    NSString *num = notification.object;
    for (int i=0; i<arrSelectedUsers.count; i++) {
        NSDictionary *dic = [arrSelectedUsers objectAtIndex:i];
        if ([dic[@"number"] isEqualToString:num]) {
            [arrSelectedUsers removeObject:dic];
        }
    }
    
    [self changeHeightOfUserNames];
}

- (void) selectUsers:(NSString *) strTxt
{
    [arrUsers removeAllObjects];
    for (int i=0; i<arrTestAllUsers.count; i++) {
        NSDictionary *dic = [arrTestAllUsers objectAtIndex:i];
        if([[dic[@"name"] lowercaseString] rangeOfString:[strTxt lowercaseString]].location != NSNotFound )
        {
            [arrUsers addObject:dic];
        }
    }
    
    [self.tbUsers reloadData];
}

- (void) addMention
{
    self.annotationView.text = @"";
    
    [self.annotationView clearAll];
    
    for (int i=0; i<arrSelectedUsers.count; i++) {
        NSDictionary *dic = [arrSelectedUsers objectAtIndex:i];
        MintAnnotation *newAnnoation = [[MintAnnotation alloc] init];
        newAnnoation.usr_id = dic[@"number"];
        NSString *strUsername = dic[@"name"];
        strUsername = [strUsername stringByReplacingOccurrencesOfString:@" " withString:@"_" ];
        newAnnoation.usr_name = strUsername;
        [self.annotationView addAnnotation:newAnnoation];
        
    }
    
    [self changeHeightOfUserNames];
    
}

- (void) changeHeightOfUserNames
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width-25 - 2.0 * self.annotationView.textContainer.lineFragmentPadding;
    [self.annotationView sizeToFit];
    CGFloat heightByBoundingRect = CGRectGetHeight(self.annotationView.frame);
    
    self.annotationView.frame = CGRectMake(10, 5, width, heightByBoundingRect);
    
    self.constraint_tvUsers_height.constant = heightByBoundingRect;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void) setTestDataForUsers
{
    arrTestAllUsers = [NSMutableArray new];
    NSDictionary *dic = @{@"number":@"1", @"name":@"Anthony Quiglery", @"roll":@"Founder, Director, Investor, Advisor", @"image":@"imgSample.png"};
    NSDictionary *dic1 = @{@"number":@"2", @"name":@"Andrew Locatelli", @"roll":@"Vice President", @"image":@"imgSample.png"};
    NSDictionary *dic2 = @{@"number":@"3", @"name":@"Alex Chrnenko", @"roll":@"CEO at TRANSLIT", @"image":@"imgSample.png"};
    NSDictionary *dic3 = @{@"number":@"4", @"name":@"Albert Quiglery", @"roll":@"Launch Engineer at Shopfy", @"image":@"imgSample.png"};
    NSDictionary *dic4 = @{@"number":@"5", @"name":@"Anthony Phelan", @"roll":@"Business Owner", @"image":@"imgSample.png"};
    NSDictionary *dic5 = @{@"number":@"6", @"name":@"Alan Rourke", @"roll":@"Senior Growth marketer", @"image":@"imgSample.png"};
    NSDictionary *dic6 = @{@"number":@"7", @"name":@"Alexkasndr Davydov", @"roll":@"Founder, Director, Investor, Advisor", @"image":@"imgSample.png"};
    NSDictionary *dic7 = @{@"number":@"8", @"name":@"Bruk Alen", @"roll":@"Vice President", @"image":@"imgSample.png"};
    NSDictionary *dic8 = @{@"number":@"9", @"name":@"Ben Rory", @"roll":@"CEO at TRANSLIT", @"image":@"imgSample.png"};
    NSDictionary *dic9 = @{@"number":@"10", @"name":@"Brian Peter", @"roll":@"Launch Engineer at Shopfy", @"image":@"imgSample.png"};
    NSDictionary *dic10 = @{@"number":@"11", @"name":@"Brendan Thomas", @"roll":@"Business Owner", @"image":@"imgSample.png"};
    NSDictionary *dic11 = @{@"number":@"12", @"name":@"Bethany Trisha", @"roll":@"Founder, Director, Investor, Advisor", @"image":@"imgSample.png"};
    NSDictionary *dic12 = @{@"number":@"13", @"name":@"Beth Taylor", @"roll":@"Vice President", @"image":@"imgSample.png"};
    NSDictionary *dic13 = @{@"number":@"14", @"name":@"Cara Jane", @"roll":@"CEO at TRANSLIT", @"image":@"imgSample.png"};
    NSDictionary *dic14 = @{@"number":@"15", @"name":@"Caitriona Fiona", @"roll":@"Launch Engineer at Shopfy", @"image":@"imgSample.png"};
    NSDictionary *dic15 = @{@"number":@"16", @"name":@"Charlotte Mia", @"roll":@"Business Owner", @"image":@"imgSample.png"};
    [arrTestAllUsers addObject:dic];
    [arrTestAllUsers addObject:dic1];
    [arrTestAllUsers addObject:dic2];
    [arrTestAllUsers addObject:dic3];
    [arrTestAllUsers addObject:dic4];
    [arrTestAllUsers addObject:dic5];
    [arrTestAllUsers addObject:dic6];
    [arrTestAllUsers addObject:dic7];
    [arrTestAllUsers addObject:dic8];
    [arrTestAllUsers addObject:dic9];
    [arrTestAllUsers addObject:dic10];
    [arrTestAllUsers addObject:dic11];
    [arrTestAllUsers addObject:dic12];
    [arrTestAllUsers addObject:dic13];
    [arrTestAllUsers addObject:dic14];
    [arrTestAllUsers addObject:dic15];
    [arrUsers addObjectsFromArray:arrTestAllUsers];
    [self.tbUsers reloadData];
}
#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tbUsers])
    {
        return arrUsers.count;
    }
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tbUsers])
    {
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell"];
        }
        NSDictionary *dic = [arrUsers objectAtIndex:indexPath.row];
        BOOL isIncuding = [arrSelectedUsers containsObject:dic];
        [cell configureCell:dic isIncluding:isIncuding];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [arrUsers objectAtIndex:indexPath.row];
    if ([arrSelectedUsers containsObject:dic]) {
        [arrSelectedUsers removeObject:dic];
    }
    else
    {
        [arrSelectedUsers addObject:dic];
        
    }
    [self addMention];
    [self.tbUsers reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return true;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView isEqual:self.annotationView])
    {
        if ([textView.text isEqualToString:strTVPlaceholder1]) {
            textView.text = @"";
            [textView setTextColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0]];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *strComment = textView.text;
    NSRange selectedRange = textView.selectedRange;
    //    textView.attributedText = strComment;
    textView.selectedRange = selectedRange;
    
    if([textView isEqual:self.annotationView])
    {
        [self.annotationView textViewDidChange:textView];
        
        for (int i=0; i<self.annotationView.annotationList.count; i++) {
            MintAnnotation *annotation = [self.annotationView.annotationList objectAtIndex:i];
            NSRange range = [strComment rangeOfString:annotation.usr_name];
            strComment = [strComment stringByReplacingCharactersInRange:range withString:@""];
            
        }
        strComment = [strComment stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [self selectUsers:strComment];
    }
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView isEqual:self.annotationView]) {
        return [self.annotationView shouldChangeTextInRange:range replacementText:text];
    }
    return true;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.tfGroupName]) {
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.tfGroupName]) {
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strText =  [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (strText.length > 0) {
        
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.tfGroupName])
    {
        [self.tfGroupName resignFirstResponder];
    }
    return YES;
}
#pragma mark - Keyboard

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardFrame = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRectangle = [keyboardFrame CGRectValue];
    CGFloat offsetY = keyboardRectangle.size.height;
    
    self.constraint_viewBottom_bottom.constant = 0-offsetY;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    
    self.constraint_viewBottom_bottom.constant = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - Actions

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnCloseFilter:(id)sender {
    self.constraint_lblFilter_height.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewFilter.alpha = 0.0f;
    }];
}

- (IBAction)onBtnMessage:(id)sender {
    if (arrSelectedUsers.count == 0) {
        return;
    }
    ChatViewController *vc = [[UIStoryboard storyboardWithName:@"Messages" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
    vc.arrUsers = arrSelectedUsers;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
