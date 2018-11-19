//
//  MsgComposeTViewController.m
//  KES
//
//  Created by Piglet on 22.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "MsgComposeTViewController.h"

@interface MsgComposeTViewController ()

@end

@implementation MsgComposeTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    strTFPlaceholder = @"To: Pebbles Flinstone";
    [self setFilterBtnUI];
    
    arrAttributes = [NSMutableArray new];
    arrSelected = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipientGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecipientGeneralTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipientPersonalTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecipientPersonalTableViewCell"];
    [self addTestData1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Functions
- (void) addTestData1
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"YES" forKey:@"category"];
    [dic setObject:@"All" forKey:@"recipient_title"];
    [dic setObject:@"158" forKey:@"recipient_count"];
    [dic setObject:@"YES" forKey:@"recipient_yes"];

    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    [dic1 setObject:@"YES" forKey:@"category"];
    [dic1 setObject:@"Bookings" forKey:@"recipient_title"];
    [dic1 setObject:@"23" forKey:@"recipient_count"];
    [dic1 setObject:@"YES" forKey:@"recipient_yes"];

    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    [dic2 setObject:@"YES" forKey:@"category"];
    [dic2 setObject:@"Parents" forKey:@"recipient_title"];
    [dic2 setObject:@"23" forKey:@"recipient_count"];
    [dic2 setObject:@"YES" forKey:@"recipient_yes"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    [dic3 setObject:@"YES" forKey:@"category"];
    [dic3 setObject:@"Students" forKey:@"recipient_title"];
    [dic3 setObject:@"23" forKey:@"recipient_count"];
    [dic3 setObject:@"YES" forKey:@"recipient_yes"];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    [dic4 setObject:@"YES" forKey:@"category"];
    [dic4 setObject:@"Suggestions" forKey:@"recipient_title"];
    [dic4 setObject:@"0" forKey:@"recipient_count"];
    [dic4 setObject:@"NO" forKey:@"recipient_yes"];
    
    [arrAttributes addObject:dic];
    [arrAttributes addObject:dic1];
    [arrAttributes addObject:dic2];
    [arrAttributes addObject:dic3];
    [arrAttributes addObject:dic4];
    
    [self addTestData2];
}

- (void) addTestData2
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"NO" forKey:@"category"];
    [dic setObject:@"imgSample.png" forKey:@"recipient_personal_img"];
    [dic setObject:@"Pebbles Flinstone" forKey:@"recipient_personal_name"];
    [dic setObject:@"Student" forKey:@"recipient_personal_content"];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    [dic1 setObject:@"NO" forKey:@"category"];
    [dic1 setObject:@"imgSample.png" forKey:@"recipient_personal_img"];
    [dic1 setObject:@"Student 2" forKey:@"recipient_personal_name"];
    [dic1 setObject:@"Parent of Pebbles Finstone" forKey:@"recipient_personal_content"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    [dic2 setObject:@"NO" forKey:@"category"];
    [dic2 setObject:@"imgSample.png" forKey:@"recipient_personal_img"];
    [dic2 setObject:@"Teacher 1" forKey:@"recipient_personal_name"];
    [dic2 setObject:@"Teacher" forKey:@"recipient_personal_content"];
    
    [arrAttributes addObject:dic];
    [arrAttributes addObject:dic1];
    [arrAttributes addObject:dic2];
    [self.tableView reloadData];
}

- (void) setFilterBtnUI
{
    self.viewSearchBg.layer.cornerRadius = 3.0f;
    self.viewSearchBg.layer.masksToBounds = YES;
    
    [self.btnFilter setBackgroundImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
    [self.btnFilter setBackgroundImage:[UIImage imageNamed:@"filter_press.png"] forState:UIControlStateSelected];
    
}
#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrAttributes.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [arrAttributes objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"category"] isEqualToString:@"YES"]) {
        RecipientGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipientGeneralTableViewCell"];
        [cell configureCell:dic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        RecipientPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipientPersonalTableViewCell"];
        bool isIncluding = false;
        if ([arrSelected containsObject:dic]) {
            isIncluding = YES;
        }
        [cell configureCell:dic andIsSelect:isIncluding];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnSelect.tag = indexPath.row;
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [arrAttributes objectAtIndex:indexPath.row];
    if ([arrSelected containsObject:dic]) {
        [arrSelected removeObject:dic];
    }
    else
        [arrSelected addObject:dic];
    [self.tableView reloadData];
    strType = @"booking";
    if (indexPath.row > 3) {
        strType = @"single";
    }
    
    [self performSelector:@selector(goChatView) withObject:nil afterDelay:0.5];
    
}

- (void) goChatView
{
    ChatViewController *vc = [[UIStoryboard storyboardWithName:@"Messages" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
    vc.strType = strType;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RecipientPersonalTableViewCellDelegate

- (void) onClickBtnSelect:(int) index
{
    NSDictionary *dic = [arrAttributes objectAtIndex:index];
    if ([arrSelected containsObject:dic]) {
        [arrSelected removeObject:dic];
    }
    else
        [arrSelected addObject:dic];
    [self.tableView reloadData];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.tfSearch.text isEqualToString:strTFPlaceholder]) {
        self.tfSearch.text = @"";
    }
    [self.tfSearch setTextColor:[UIColor blackColor]];
    self.constraint_btnCancel_width.constant = 46.0f;
    self.constraint_imgSearch_widht.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.imgSearch.alpha = 0.0f;
        [self.view layoutIfNeeded];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""] || [textField.text isEqualToString:strTFPlaceholder]) {
        textField.text = strTFPlaceholder;
        [textField setTextColor:[UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:1.0]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strText =  [textField.text stringByReplacingCharactersInRange:range withString:string];
    strSearch = strText;
    if (strText.length > 0) {
        
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tfSearch resignFirstResponder];
    return YES;
}
#pragma mark - Actions
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onBtnFilter:(id)sender
{
    
}
- (IBAction)onBtnCancel:(id)sender
{
    self.tfSearch.text = strTFPlaceholder;
    [self.tfSearch setTextColor:[UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:1.0]];
    [self.tfSearch resignFirstResponder];
    self.constraint_imgSearch_widht.constant = 30.0f;
    self.constraint_btnCancel_width.constant = 0.0f;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
        self.imgSearch.alpha = 1.0f;
    }];
    strSearch = @"";
}

@end
