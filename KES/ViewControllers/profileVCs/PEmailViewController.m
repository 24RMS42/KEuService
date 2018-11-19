//
//  PEmailViewController.m
//  KES
//
//  Created by Piglet on 05.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "PEmailViewController.h"

@interface PEmailViewController ()

@end

@implementation PEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    heightTopOfParentView = 139;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBlackView)
                                                 name:NOTI_SHOW_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:NOTI_HIDE_SUB_BLACK
                                               object:nil];
    
    [self setupKeyboardToolBar];
    [self setUI];
    arrProtocols = @[@"http1", @"http2", @"http3", @"http4", @"http5", @"http6", @"http7", @"http8", @"http9"];
    [self.tbProtocol registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    
    [self setButtonsView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrProtocols.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
    NSString *strProtocol = [arrProtocols objectAtIndex:indexPath.row];
    cell.lblTypeName.text = strProtocol;
    if ([strProtocol isEqualToString:strSelectedProtocol]) {
        [cell.lblTypeName setTextColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0]];
    }
    else
        [cell.lblTypeName setTextColor:[UIColor colorWithRed:48.0f/255 green:48.0f/255 blue:48.0f/255 alpha:1.0]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    isShowingTBProtocol = false;
    NSString *strProtocol = [arrProtocols objectAtIndex:indexPath.row];
    strSelectedProtocol = strProtocol;
    self.tfProtocol.text = strSelectedProtocol;
    [self hideTBProtocol];
}

#pragma mark - Functions
- (void) setupKeyboardToolBar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    [numberToolbar setBackgroundColor:[UIColor colorWithRed:220.0/255.0f green:220.0/255.0f blue:220.0/255.0f alpha:1.0f]];
    self.tfPeriod.inputAccessoryView = numberToolbar;
    self.tvDefaultMsg.inputAccessoryView = numberToolbar;
}

-(void)doneWithNumberPad{
    [tmpTf resignFirstResponder];
    [self.tvDefaultMsg resignFirstResponder];
}


- (void) setUI
{
    [Functions setBoundsWithView:self.tvDefaultMsg];
    
    [Functions setBoundsWithView:self.tfusername];
    
    [Functions setBoundsWithView:self.tfPassword];
    
    [Functions setBoundsWithView:self.tfHost];
    
    [Functions setBoundsWithView:self.tfPort];
    
    [Functions setBoundsWithView:self.tfSecurity];
    
    [Functions setBoundsWithView:self.tfProtocol];
    
    [Functions setBoundsWithView:self.tfPeriod];
    
    [Functions setBoundsWithView:self.tbProtocol];
    
}

- (void) showTBProtocol:(UIButton *) btn
{
    CGFloat heightOfTb = 120.0f;
    self.constraint_tbProtocol_height.constant = heightOfTb;
    
    [self changeScrollWhenSelectBtn:btn andHeightOfShownView:heightOfTb];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showBlackViewsForBoth];
    });
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [self.imgChevronForProtocol setImage:[UIImage imageNamed:@"chevron-up.png"]];
        [self.tbProtocol.superview bringSubviewToFront:self.tbProtocol];
    }];
    [self.tbProtocol reloadData];
}

- (void) hideTBProtocol
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBlackViewForBoth];
    });
    self.constraint_tbProtocol_height.constant = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        
        [self.imgChevronForProtocol setImage:[UIImage imageNamed:@"chevron-down.png"]];
    }];
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

- (void) changeScrollWhenSelectBtn:(UIButton *) button andHeightOfShownView:(CGFloat) height
{
    mtfposition = button.frame.origin.y;
    mtfHeight = button.frame.size.height;
    
    if (height + mtfHeight + mtfposition + heightTopOfParentView > self.view.frame.size.height) {
        float d_height = height + mtfHeight + mtfposition + heightTopOfParentView - self.view.frame.size.height;
        [UIView animateWithDuration:0.5f animations:^{
            self.scContainer.contentOffset = CGPointMake(0, d_height);
        }];
    }
}

- (void) setButtonsView
{
    [Functions setBoundsWithView:self.viewResult];
}
#pragma mark - Keyboard Notification

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat keyboardHeight = kbSize.height;
    
    if (keyboardHeight + mtfHeight + mtfposition + heightTopOfParentView > self.view.frame.size.height) {
        float d_height = keyboardHeight + mtfHeight + mtfposition + heightTopOfParentView - self.view.frame.size.height;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
            self.scContainer.contentOffset = CGPointMake(0, d_height);
        }];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    mtfposition = textField.frame.origin.y;
    mtfHeight = textField.frame.size.height;
    tmpTf = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (void) textFieldDidChange:(UITextField *)textField
{
    NSString *strTxt = textField.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Actions
- (IBAction)onBtnForProtocol:(id)sender {
    [tmpTf resignFirstResponder];
    [self.tvDefaultMsg resignFirstResponder];
    isShowingTBProtocol = !isShowingTBProtocol;
    
    if (isShowingTBProtocol) {
        UIButton *btn = (UIButton *) sender;
        [self showTBProtocol:btn];
    }
    else
        [self hideTBProtocol];
}
- (IBAction)onBtnSave:(id)sender
{
    // Save values here
    
    //
    
    [self.delegate goBackFromPEmailVC];
}
- (IBAction)onBtnReset:(id)sender
{
    
}
- (IBAction)onBtnCancel:(id)sender
{
    [self.delegate goBackFromPEmailVC];
}
@end
