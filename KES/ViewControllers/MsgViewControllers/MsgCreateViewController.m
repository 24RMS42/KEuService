//
//  MsgCreateGroupViewController.m
//  KES
//
//  Created by Piglet on 22.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "MsgCreateViewController.h"

@interface MsgCreateViewController ()

@end

@implementation MsgCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imgViewPhoto.layer.cornerRadius = 3.0f;
    self.imgViewPhoto.layer.masksToBounds = YES;
    [self createCameraSelectView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [Functions setBoundsWithView:self.tvMsg];
    
    strTVPlaceholder = @"Write a message";
    strTVPlaceholder1 = @"To:";
    isEnableReply = false;
    
    [self setMsgType];
    [self setHeightForbottomViews];
    [self setTestDataForUsers];
    
    [self.tbUsers registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserTableViewCell"];
    arrUsers = [NSMutableArray new];
    arrSelectedUsers = [NSMutableArray new];
    self.annotationView.delegate = self;
    self.annotationView.nameTagImage = [[UIImage imageNamed:@"tagImage"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    self.annotationView.nameTagColor = [UIColor colorWithRed:30.0/255 green:30.0/255 blue:30.0/255 alpha:1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationRemoved:) name:@"annotation_removed" object:nil];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.tbMsg addGestureRecognizer:gestureRecognizer];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [self setAnnotationView:nil];
    [super viewDidUnload];
}


#pragma mark - Functions
- (void) createCameraSelectView
{
    self.cameraSelectView = [NSBundle.mainBundle loadNibNamed:@"CameraSelectView" owner:self options:nil].firstObject;
    self.cameraSelectView.delegate = self;
    [self.view addSubview:self.cameraSelectView];
    self.cameraSelectView.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}
- (void) showCameraView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.cameraSelectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
}
- (void) dismissKeyboard
{
    [self.annotationView resignFirstResponder];
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
}

- (void) setHeightForbottomViews
{
    self.constraint_viewBottom_height.constant = 0;
    self.constraint_viewMsg_height.constant = 0;
}

- (void) setMsgType
{
    if ([self.msgType isEqualToString:@"private"]) {
        self.lblMsgTitle.text = @"New message";
    }
    else if([self.msgType isEqualToString:@"group"])
    {
        self.lblMsgTitle.text = @"New group message";
    }
}

- (void) showEnableReplyBtn
{
    isEnableReply = !isEnableReply;
    if (isEnableReply)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.btnSwitch setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.btnSwitch setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
        }];
    }
}
- (void) showCommentBar1:(NSString *) strComment
{
    //Getting User mention
    if (isIncreased) {
        return;
    }
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-40, CGFLOAT_MAX);
    CGRect textRect = [self.tvMsg.text boundingRectWithSize:maximumLabelSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:16.0]}
                                                    context:nil];
    if (textRect.size.height < 120) {
        [self.tvMsg sizeToFit];
        float height_tvMsg = self.tvMsg.frame.size.height;
        if (self.tvMsg.frame.size.height > 120) {
            height_tvMsg = 120;
        }
        
        self.tvMsg.frame = CGRectMake(20, 3, [UIScreen mainScreen].bounds.size.width-60, height_tvMsg);
        
        self.constraint_viewMsg_height.constant = self.tvMsg.frame.size.height + 7;
        [UIView animateWithDuration:0.05 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else
    {
        self.tvMsg.frame = CGRectMake(20, 3, [UIScreen mainScreen].bounds.size.width-60, 120);
        self.constraint_viewMsg_height.constant = 127;
        [UIView animateWithDuration:0.05 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    
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
    if (arrUsers.count > 0) {
        self.tbUsers.alpha = 1.0f;
    }
    else
        self.tbUsers.alpha = 0.0f;
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
    [self showNameView];
    [self showMsgView];
    self.tbUsers.alpha = 0.0f;
    self.annotationView.contentOffset = CGPointMake(0, 0);
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

- (void) showNameView
{
    if (arrSelectedUsers.count > 1) {
        self.constraint_viewMsgTitle_height.constant = 40.0f;
    }
    else
    {
        self.constraint_viewMsgTitle_height.constant = 0.0f;
    }
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) showMsgView
{
    if (arrSelectedUsers.count > 0) {
        if (self.constraint_viewBottom_height.constant == 0) {
            self.constraint_viewBottom_height.constant = 40;
            self.constraint_viewMsg_height.constant = 40;
        }
    }
    else
    {
        self.constraint_viewBottom_height.constant = 0;
        self.constraint_viewMsg_height.constant = 0;

    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
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
    if ([tableView isEqual:self.tbMsg]) {
        return;
    }
    
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
    if ([textView isEqual:self.tvMsg]) {
        if ([textView.text isEqualToString:strTVPlaceholder]) {
            textView.text = @"";
            [textView setTextColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0]];
        }
    }
    else if([textView isEqual:self.annotationView])
    {
        if ([textView.text isEqualToString:strTVPlaceholder1]) {
            textView.text = @"";
            [textView setTextColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0]];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.tvMsg]) {
        [self textEditingEnded];
    }
    
}

- (void) textEditingEnded
{
    NSString *strComment = self.tvMsg.text;
    strComment = [strComment stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strComment.length == 0 || [strComment isEqualToString:@"Writeamessage"]) {
        self.tvMsg.text = strTVPlaceholder;
        [self.tvMsg setTextColor:[UIColor colorWithRed:131.0f/255 green:131.0f/255 blue:131.0f/255 alpha:1.0f]];
        [self showCommentBar1:self.tvMsg.text];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *strComment = textView.text;
    NSRange selectedRange = textView.selectedRange;
//    textView.attributedText = strComment;
    textView.selectedRange = selectedRange;

    if ([textView isEqual:self.tvMsg]) {
        [self showCommentBar1:strComment];
    }
    else if([textView isEqual:self.annotationView])
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
        [self.btnEdit setImage:[UIImage imageNamed:@"close_small.png"] forState:UIControlStateNormal];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.tfGroupName]) {
        [self.btnEdit setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
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
    heightKeyboard = offsetY;
    self.constraint_viewBottom_bottom.constant = 0-offsetY;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    heightKeyboard = 0;
    self.constraint_viewBottom_bottom.constant = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Actions

- (IBAction)onBtnEdit:(id)sender
{

    if ([self.tfGroupName isEditing]) {
        self.tfGroupName.text = @"";
    }
    else
        [self.tfGroupName becomeFirstResponder];
}

- (IBAction)onBtnChevron:(id)sender {
    isIncreased = !isIncreased;
    float navHeight = 64;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 812.0f)
            navHeight = 88;
    }
//    self.constraint_viewMsg_height
    NSString *strImg;
    if (isIncreased) {
        strImg = @"chevron-down.png";
        
        self.constraint_viewMsg_height.constant = [UIScreen mainScreen].bounds.size.height - navHeight - 40 - heightKeyboard - self.constraint_tvUsers_height.constant - 9 - self.constraint_viewMsgTitle_height.constant - self.constraint_viewImgPost_height.constant;
    }
    else
    {
        strImg = @"chevron-up.png";
        [self showCommentBar1:self.tvMsg.text];
//        self.constraint_viewMsg_height.constant = heightViewMsg;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.btnChevron setImage:[UIImage imageNamed:strImg] forState:UIControlStateNormal];
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)onBtnCamera:(id)sender
{
    [self.tfGroupName resignFirstResponder];
    [self.tvMsg resignFirstResponder];
    [self showCameraView];
}

- (IBAction)onBtnSend:(id)sender {
    self.tvMsg.text = strTVPlaceholder;
    [self.tvMsg resignFirstResponder];
    self.constraint_viewImgPost_height.constant = 0.0f;
    self.constraint_imgViewPhoto_height.constant = 0.0f;
    self.imgViewPhoto.image = nil;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnSwitch:(id)sender {
    [self showEnableReplyBtn];
}
- (IBAction)onBtnClose:(id)sender {
    imgPost = nil;
    self.constraint_viewImgPost_height.constant = 0;
    self.constraint_imgViewPhoto_height.constant = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - CameraSelectViewDelegate
- (void) hideCameraSelectView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.cameraSelectView.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
}

- (void) selectTakeAPhoto
{
    [self hideCameraSelectView];
    @try
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerCameraDeviceFront;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        picker.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:picker animated:YES completion:nil];
        });
        
        
        
    }
    @catch (NSException *exception)
    {
        
    }
}
- (void) selectGallery
{
    [self hideCameraSelectView];
    @try
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        picker.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:picker animated:YES completion:nil];
        });
        
    }
    @catch (NSException *exception)
    {
        
    }
}
#pragma mark - UIImagePicker Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    imgPost = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self showImgView];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) showImgView
{
    self.constraint_viewImgPost_height.constant = 85.0f;
    self.constraint_imgViewPhoto_height.constant = 75.0f;
    
    [self.imgViewPhoto setImage:imgPost];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
@end
