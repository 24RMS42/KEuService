//
//  PFamilyViewController.m
//  KES
//
//  Created by Piglet on 06.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "PFamilyViewController.h"

@interface PFamilyViewController ()

@end

@implementation PFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setButtonsView];
    
    [self.tbMembers registerNib:[UINib nibWithNibName:@"MemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"MemberTableViewCell"];
    [self.tfAddMember addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBlackView)
                                                 name:NOTI_SHOW_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:NOTI_HIDE_SUB_BLACK
                                               object:nil];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:HIDE_BLACKVIEW_SUPER
                                               object:nil];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBlackViewForBoth)];
    [self.viewBlackOpaque addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - functions
- (void) setButtonsView
{
    [Functions setBoundsWithView:self.viewResult];
}
- (void) setUI
{
    [Functions setBoundsWithView:self.tfAddMember];
    
    [Functions setBoundsWithView:self.tbMembers];
    
    [Functions setBoundsWithView:self.btnAdd];
    self.btnAdd.userInteractionEnabled = false;
    self.btnAdd.alpha = 0.0f;
}

- (void) showBlackViewsForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_SHOW object:nil];
    [self showBlackView];
}

- (void) showBlackView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.viewBlackOpaque.alpha = 0.7f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }];
}

- (void) hideBlackViewForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_HIDE object:nil];
    [self hideBlackView];
}

- (void) hideBlackView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.viewBlackOpaque.alpha = 0.0f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0f]];
    }];
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error {
    if ([apiName isEqualToString:inviteMemberApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [Functions showSuccessAlert:@"" message:@"Invited successfully!" image:@""];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return appDelegate.familyMemberArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberTableViewCell"];
    StudentModel *obj = [appDelegate.familyMemberArray objectAtIndex:indexPath.row];
    NSString *memberDetail = [NSString stringWithFormat:@"%@ %@ - %@", obj.first_name, obj.last_name, obj.role];
    cell.lblMemberName.text = memberDetail;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidChange:(UITextField *)textField
{
    NSString *strTxt = textField.text;
    NSString *strSubTxt = [strTxt stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strSubTxt.length == 0) {
        self.btnAdd.userInteractionEnabled = false;
        self.btnAdd.alpha = 0.0f;
    }
    else
    {
        if ([Functions validateEmailField:_tfAddMember.text]) {
            self.btnAdd.userInteractionEnabled = true;
            self.btnAdd.alpha = 1.0f;
        } else {
            self.btnAdd.userInteractionEnabled = false;
            self.btnAdd.alpha = 0.0f;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Actions
- (IBAction)onBtnAddMember:(id)sender {
    NSDictionary * parameters=@{@"email":_tfAddMember.text};
    inviteMemberApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, INVITE_MEMBER];
    [objWebServices callApiWithParameters:parameters apiName:inviteMemberApi type:POST_REQUEST loader:YES view:self];
    
    self.tfAddMember.text = @"";
    [self.tfAddMember resignFirstResponder];
    self.btnAdd.userInteractionEnabled = false;
    self.btnAdd.alpha = 0.5f;
    [self.tbMembers reloadData];
}

- (IBAction)onBtnSave:(id)sender
{
    [self.delegate goBackFromPFamilyVC];
}

- (IBAction)onBtnReset:(id)sender
{
    self.tfAddMember.text = @"";
    [self textFieldDidChange:self.tfAddMember];
}

- (IBAction)onBtnCancel:(id)sender
{
    [self.delegate goBackFromPFamilyVC];
}
@end
