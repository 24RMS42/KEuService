//
//  PProfileViewController.m
//  KES
//
//  Created by Piglet on 04.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "PProfileViewController.h"

@interface PProfileViewController ()

@end

@implementation PProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [NSUserDefaults standardUserDefaults];
    heightTopOfParentView = 139;
    [self.tbForTypes registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    [self.tbNationality registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    [self.tbMedical registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];

    isSelectUploadOwn = true;
    [self showImgOption];
    [self setButtonsView];
    [self setUI];
    [self setupKeyboardToolBar];
    [self initValues];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectPhoto:)
                                                 name:NOTI_SELECT_PROFILE_PHOTO
                                               object:nil];
    
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

- (void) selectPhoto:(NSNotification *) notification
{
    NSDictionary *dicPhoto = notification.userInfo;
    UIImage *imgPhoto = dicPhoto[@"photo"];
    [self.imgView setImage:imgPhoto];
    
    [self uploadAvatar:imgPhoto];
}

- (void)uploadAvatar:(UIImage *)image {
    UIImage *convertedImage = [self imageWithImage:image convertToSize:CGSizeMake(image.size.width / 7, image.size.height / 7)];
    NSData *imageData =  UIImagePNGRepresentation(image.size.width > 1000 ? convertedImage : image);
    
    uploadAvatarApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, UPLOAD_AVATAR];
    [objWebServices uploadImage:imageData apiName:uploadAvatarApi view:self];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tbForTypes]) {
        return appDelegate.notificationTypeArray.count;
    }
    else if([tableView isEqual:self.tbNationality])
    {
        return appDelegate.nationalityArray.count;
    }
    else if([tableView isEqual:self.tbMedical])
    {
        return appDelegate.preferenceMedicalTypeArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
    NSString *obj;
    bool isSelected;
    if ([tableView isEqual:self.tbForTypes]) {
        ContactNotification *item = [appDelegate.notificationTypeArray objectAtIndex:indexPath.row];
    	cell.lblTypeName.text = item.value;
    	if ([item.value isEqualToString:strSelectedType]) {
            isSelected = YES;
        }
        else
            isSelected = NO;
    }
    else if([tableView isEqual:self.tbNationality]){
        obj = [appDelegate.nationalityArray objectAtIndex:indexPath.row];
        if ([obj isEqualToString:strSelectedNationality]) {
            isSelected = YES;
        }
        else
            isSelected = NO;
        cell.lblTypeName.text = obj;
    }
    else
    {
        PreferenceType *item = [appDelegate.preferenceMedicalTypeArray objectAtIndex:indexPath.row];
        if ([item.label isEqualToString:strSelectedMedical]) {
            isSelected = YES;
        }
        else
            isSelected = NO;
        cell.lblTypeName.text = item.label;
    }
    
    if (isSelected) {
        [cell.lblTypeName setTextColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0]];
    }
    else
        [cell.lblTypeName setTextColor:[UIColor colorWithRed:48.0f/255 green:48.0f/255 blue:48.0f/255 alpha:1.0]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tbForTypes]) {
        isShowingTbType = false;
        ContactNotification *obj = [appDelegate.notificationTypeArray objectAtIndex:indexPath.row];
        NSString *strType = obj.value;
        selectedTypeId = indexPath.row + 1;
        strSelectedType = strType;
        self.tfType.text = strSelectedType;
        [self hideTbTypes];
        
    }
    else if([tableView isEqual:self.tbNationality])
    {
        isShowingTBNationality = false;
        NSString *strNationality = [appDelegate.nationalityArray objectAtIndex:indexPath.row];
        strSelectedNationality = strNationality;
        self.tfNationality.text = strSelectedNationality;
        [self hideTBNationality];
    }
    else {
        isShowingTBMedical = false;
        PreferenceType *obj = [appDelegate.preferenceMedicalTypeArray objectAtIndex:indexPath.row];
        strSelectedMedical = obj.label;
        selectedMedicalId = obj.preference_id;
        self.tfMedical.text = strSelectedMedical;
        [self hideTBMedical];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBlackViewForBoth];
    });
}

#pragma mark - Keyboard Notification

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat keyboardHeight = kbSize.height;
    
    if (keyboardHeight + mtfHeight + mtfposition + heightTopOfParentView > self.view.frame.size.height) {
        float d_height = keyboardHeight + mtfHeight + mtfposition + heightTopOfParentView - self.view.frame.size.height;
        
        [UIView animateWithDuration:0.3f animations:^{
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

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error {
    if ([apiName isEqualToString:updateProfileApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [Functions showSuccessAlert:@"" message:PROFILE_UPDATED image:@""];
                [self.delegate goBackFromPProfileViewController];
            } else {
                [Functions checkError:responseDict];
            }
        }
    } else if ([apiName isEqualToString:uploadAvatarApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [Functions showSuccessAlert:@"" message:PROFILE_UPDATED image:@""];
                NSDictionary *avatarObj = [responseDict objectForKey:@"avatar"];
                NSArray *fileArray = [avatarObj valueForKey:@"files"];
                [userInfo setValue:fileArray[0] forKey:KEY_AVATAR];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - functions


- (void) showTbTypes:(UIButton *) btn
{
    CGFloat heightOfTb = 165.0f;
    
    [self changeScrollWhenSelectBtn:btn andHeightOfShownView:heightOfTb];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showBlackViewsForBoth];
    });
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.tbForTypes.alpha = 1.0f;
        [self.tbForTypes.superview bringSubviewToFront:self.tbForTypes];
    }];
    [self.tbForTypes reloadData];
}

- (void) hideTbTypes
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.tbForTypes.alpha = 0.0f;
        
    }];

}

- (void) showTBNationality:(UIButton *) btn
{
    CGFloat heightOfTb = 165.0f;
    
    [self changeScrollWhenSelectBtn:btn andHeightOfShownView:heightOfTb];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showBlackViewsForBoth];
    });
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.tbNationality.alpha = 1.0f;
        [self.tbNationality.superview bringSubviewToFront:self.tbNationality];
    }];
    [self.tbNationality reloadData];
}

- (void) hideTBNationality
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.tbNationality.alpha = 0.0f;
    }];
}

- (void) showTBMedical:(UIButton *) btn
{
    CGFloat heightOfTb = 165.0f;
    
    [self changeScrollWhenSelectBtn:btn andHeightOfShownView:heightOfTb];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showBlackViewsForBoth];
    });
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.tbMedical.alpha = 1.0f;
        [self.tbMedical.superview bringSubviewToFront:self.tbMedical];
        
    }];
    [self.tbMedical reloadData];
}

- (void) hideTBMedical
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.tbMedical.alpha = 0.0f;
    }];
}

- (void)initValues {
    [self.tfFirstName setText:appDelegate.contactData.first_name];
    [self.tfLastName setText:appDelegate.contactData.last_name];
    [self.tfNationality setText:appDelegate.contactData.nationality];
    NSString *genderStr = [appDelegate.contactData.gender isEqualToString:@"M"] ? @"Male" : @"Female";
    [self.tfGender setText:genderStr];
    
    NSDate *birthDate = [Functions convertStringToDate:appDelegate.contactData.date_of_birth format:MAIN_DATE_FORMAT];
    strBirthDate = [Functions convertDateToString:birthDate format:@"LLL dd, yyyy"];
    [self.tfDateOfBirth setText:strBirthDate];
    
    //get contact detail
    for (ContactNotification *obj in appDelegate.contactData.contactDetails) {
        if ([obj.type_id isEqualToString:@"1"]) {
            _tfEmail.text = obj.value;
        } else if ([obj.type_id isEqualToString:@"2"]) {
            _tfMobile.text = obj.value;
        }
    }
    
    if (appDelegate.contactData.contactDetails.count == 1) {
        ContactNotification *obj = appDelegate.contactData.contactDetails[0];
        ContactNotification *newEmptyObj = [[ContactNotification alloc] init];
        newEmptyObj.detail_id = @"new";
        newEmptyObj.type_id = [obj.type_id isEqualToString:@"1"] ? @"2" : @"1";
        newEmptyObj.value = @"";
        [appDelegate.contactData.contactDetails addObject:newEmptyObj];
    }
    
    //get medical detail
    for (PreferenceType *preferenceObj in appDelegate.contactData.preferenceArray) {
        for (PreferenceType *medicalObj in appDelegate.preferenceMedicalTypeArray) {
            if ([medicalObj.preference_id isEqualToString:preferenceObj.preference_id]) {
                strSelectedMedical = medicalObj.label;
                selectedMedicalId = medicalObj.preference_id;
                self.tfMedical.text = strSelectedMedical;
            }
        }
    }
    
    //get updated medical detail in app
    if (appDelegate.contactData.medicalId.length > 0) {
        for (PreferenceType *medicalObj in appDelegate.preferenceMedicalTypeArray) {
            if ([medicalObj.preference_id isEqualToString:appDelegate.contactData.medicalId]) {
                strSelectedMedical = medicalObj.label;
                selectedMedicalId = medicalObj.preference_id;
                self.tfMedical.text = strSelectedMedical;
            }
        }
    }
    
    //get avatar image
    NSString *avatarUrl = [NSString stringWithFormat:@"%@media/photos/avatars/%@", strMainBaseUrl, [userInfo valueForKey:KEY_AVATAR]];
    avatarUrl = [avatarUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"temporary"]];
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
    self.tfMobile.inputAccessoryView = numberToolbar;
}

-(void)doneWithNumberPad{
    [self.tfMobile resignFirstResponder];
}

- (void) showGenderOption
{
    if ([strGender isEqualToString:@"Male"]) {
        [self.lblMale setTextColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0]];
        [self.lblFemale setTextColor:[UIColor colorWithRed:48.0f/255 green:48.0f/255 blue:48.0f/255 alpha:1.0]];
        self.tfGender.text = strGender;
    }
    else if([strGender isEqualToString:@"Female"])
    {
        [self.lblMale setTextColor:[UIColor colorWithRed:48.0f/255 green:48.0f/255 blue:48.0f/255 alpha:1.0]];
        [self.lblFemale setTextColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0]];
        self.tfGender.text = strGender;
    }
}

- (BOOL)validateContactField {
    if (_tfFirstName.text.length == 0) {
        [Functions showAlert:@"" message:@"Please input first name"];
        return NO;
    } else if (_tfLastName.text.length == 0) {
        [Functions showAlert:@"" message:@"Please input last name"];
        return NO;
    } else if (![Functions validateEmailField:_tfEmail.text]) {
        [_tfEmail becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input correct email address"];
        return NO;
    }
    else if (![Functions validateNumberField:_tfMobile.text]) {
        [_tfMobile becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input correct phone number"];
        return NO;
    }
    
    return YES;
}

- (void) resetValues
{
    
}

- (void) setButtonsView
{
    [Functions setBoundsWithView:self.viewResult];
    
}
- (void) showImgOption
{
    if (isSelectUploadOwn) {
        [self.imgUploadAvatar setImage:[UIImage imageNamed:@"option_yes"]];
        [self.imgUseGravatar setImage:[UIImage imageNamed:@"option_no"]];
        self.btnProfilePhoto.alpha = 1.0f;
        self.lblChangeAvatarWithGra.alpha = 0.0f;
        self.btnChangeAvatarWithGra.alpha = 0.0f;
    }
    else
    {
        [self.imgUploadAvatar setImage:[UIImage imageNamed:@"option_no"]];
        [self.imgUseGravatar setImage:[UIImage imageNamed:@"option_yes"]];
        self.btnProfilePhoto.alpha = 0.0f;
        self.lblChangeAvatarWithGra.alpha = 1.0f;
        self.btnChangeAvatarWithGra.alpha = 1.0f;
    }
}

- (void) setUI
{
    [Functions setBoundsWithView:self.tfFirstName];
    
    [Functions setBoundsWithView:self.tfLastName];
    
    [Functions setBoundsWithView:self.tfDateOfBirth];
    
    [Functions setBoundsWithView:self.tfNationality];
    
    [Functions setBoundsWithView:self.tfGender];
    
    [Functions setBoundsWithView:self.tfMedical];
    
    [Functions setBoundsWithView:self.tfEmail];
    
    [Functions setBoundsWithView:self.tfMobile];
    
    [Functions setBoundsWithView:self.tfType];
    
    [Functions setBoundsWithView:self.tfTypeAdd];
    
    [Functions setBoundsWithView:self.btnAddType];
    
    [Functions setBoundsWithView:self.tbForTypes];
    
    [Functions setBoundsWithView:self.tbNationality];
    [Functions setBoundsWithView:self.tbMedical];
    [self setUIForGenderView];
}

- (void) setUIForGenderView
{
    [Functions setBoundsWithView:self.viewGender];
}

- (void) hideGenderView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBlackViewForBoth];
    });
    
    [UIView animateWithDuration:0.3f animations:^{
        self.viewGender.alpha = 0.0f;
    }];
}

- (void) showGenderView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showBlackViewsForBoth];
    });
    
    [UIView animateWithDuration:0.3f animations:^{
        self.viewGender.alpha = 1.0f;
        [self.viewGender.superview bringSubviewToFront:self.viewGender];
    }];
}

- (void) showBlackViewsForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_SHOW object:nil];
    [self showBlackView];
}

- (void) showBlackView
{
    [UIView animateWithDuration:0.3f animations:^{
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
    [UIView animateWithDuration:0.3f animations:^{
        self.viewBlackOpaque.alpha = 0.0f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0f]];
        isShowingGenderView = false;
        isShowingTbType = false;
        isShowingTBMedical = false;
        isShowingTBNationality = false;
        [UIView animateWithDuration:0.3 animations:^{
            self.viewGender.alpha = 0.0f;
            self.tbForTypes.alpha = 0.0f;
            self.tbNationality.alpha = 0.0f;
            self.tbMedical.alpha = 0.0f;
            self.viewDatePicker.alpha = 0.0f;
        }];
        
    }];
}

- (void) setDateWithString:(NSString *) strDate
{
    self.tfDateOfBirth.text = strDate;
}

- (void) changeScrollWhenSelectBtn:(UIButton *) button andHeightOfShownView:(CGFloat) height
{
    mtfposition = button.frame.origin.y;
    mtfHeight = button.frame.size.height;
    
    
    if (height + mtfHeight + mtfposition + heightTopOfParentView > self.view.frame.size.height) {
        float d_height = height + mtfHeight + mtfposition + heightTopOfParentView - self.view.frame.size.height;
        [UIView animateWithDuration:0.3f animations:^{
            self.scContainer.contentOffset = CGPointMake(0, d_height);
        }];
    }
}

#pragma mark - Actions
- (IBAction)onBtnUseGravatar:(id)sender {
    isSelectUploadOwn = false;
    [self showImgOption];
    [tmpTf resignFirstResponder];
}

- (IBAction)onBtnUploadAvatar:(id)sender {
    isSelectUploadOwn = true;
    [self showImgOption];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SHOW_CAMERAVIEW object:nil];
    [tmpTf resignFirstResponder];
}

- (IBAction)onBtnChangeAvatarWithGravatar:(id)sender {
    NSLog(@"Change avatar with Gravatar clicked");
}
- (IBAction)onBtnForDate:(id)sender {
    [tmpTf resignFirstResponder];
    NSString *strFormatter = @"LLL dd, yyyy";
    if (strBirthDate.length == 0 ) {
        NSDate *currentDate = [NSDate date];
        self.datePicker.date = currentDate;
        
        NSString *strDate = [Functions convertDateToString:currentDate format:strFormatter];
        [self setDateWithString:strDate];
        
    }
    else
    {
        NSDate *date = [Functions convertStringToDate:strBirthDate format:strFormatter];
        self.datePicker.date = date;
    }
    CGFloat heightOfViewPicker = 261.0f;
    
    UIButton *btn = (UIButton *) sender;
    
    [self changeScrollWhenSelectBtn:btn andHeightOfShownView:heightOfViewPicker];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showBlackViewsForBoth];
    });
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        
        self.viewDatePicker.alpha = 1.0f;
    }];
    
}

- (IBAction)onBtnForGender:(id)sender {
    [tmpTf resignFirstResponder];
    isShowingGenderView = !isShowingGenderView;
    if (isShowingGenderView) {
        
        [self showGenderView];
        [self showGenderOption];
    }
    else
    {
        [self hideGenderView];
    }
}

- (IBAction)onBtnForMedical:(id)sender {
    [tmpTf resignFirstResponder];
    isShowingTBMedical = !isShowingTBMedical;
    if (isShowingTBMedical) {
        [self showTBMedical: (UIButton *) sender];
    }
    else
        [self hideTBMedical];
}

- (IBAction)onBtnForType:(id)sender {
    [tmpTf resignFirstResponder];
    isShowingTbType = !isShowingTbType;
    if (isShowingTbType) {
        [self showTbTypes:(UIButton *) sender];
    }
    else
    {
        [self hideTbTypes];
    }
    
}

- (IBAction)onBtnAddType:(id)sender {
    [tmpTf resignFirstResponder];
    NSString *strTypeAdd = self.tfTypeAdd.text;
    NSString *strTmp = [strTypeAdd stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strTmp.length == 0) {
        return;
    }
    /*self.tfTypeAdd.text = @"";
    strSelectedType = strTypeAdd;
    self.tfType.text = strSelectedType;*/
    ContactNotification *newEmptyObj = [[ContactNotification alloc] init];
    newEmptyObj.detail_id = self.tfType.text;
    newEmptyObj.type_id = [NSString stringWithFormat:@"%ld", selectedTypeId];
    newEmptyObj.value = self.tfTypeAdd.text;
    [appDelegate.contactData.contactDetails addObject:newEmptyObj];
}


- (IBAction)onBtnSave:(id)sender
{
    if (![self validateContactField]) {
        return;
    }
    
    appDelegate.contactData.first_name = _tfFirstName.text;
    appDelegate.contactData.last_name = _tfLastName.text;
    appDelegate.contactData.nationality = _tfNationality.text;
    appDelegate.contactData.gender = [_tfGender.text isEqualToString:@"Male"] ? @"M" : @"F";
    appDelegate.contactData.date_of_birth = [Functions convertDateToString:[_datePicker date] format:MAIN_DATE_FORMAT];
    appDelegate.contactData.medicalId = selectedMedicalId;
    
    NSMutableArray *updatedContactArray = [[NSMutableArray alloc] init];
    for (ContactNotification *obj in appDelegate.contactData.contactDetails) {
        if ([obj.type_id isEqualToString:@"1"]) {
            obj.value = _tfEmail.text;
        } else if ([obj.type_id isEqualToString:@"2"]) {
            obj.value = _tfMobile.text;
        }
        [updatedContactArray addObject:obj];
    }
    
    if (updatedContactArray.count == 0) {
        for (int i = 1; i < 3; i++) {
            ContactNotification *contactDetail = [[ContactNotification alloc] init];
            if (i == 1) {
                contactDetail.detail_id = @"new";
                contactDetail.type_id = @"1";
                contactDetail.value = _tfEmail.text;
            } else if (i == 2) {
                contactDetail.detail_id = @"new";
                contactDetail.type_id = @"2";
                contactDetail.value = _tfMobile.text;
            }
            [updatedContactArray addObject:contactDetail];
        }
    }
    
    appDelegate.contactData.contactDetails = [[NSMutableArray alloc] init];
    appDelegate.contactData.contactDetails = [NSMutableArray arrayWithArray:updatedContactArray];
    
    NSMutableDictionary *parameters = [Functions getProfileParameter];
    updateProfileApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, CONTACT_DETAIL];
    [objWebServices callApiWithParameters:parameters apiName:updateProfileApi type:POST_REQUEST loader:YES view:self];
}
- (IBAction)onBtnReset:(id)sender
{
    _tfFirstName.text = @"";
    _tfLastName.text = @"";
    _tfEmail.text = @"";
    _tfMobile.text = @"";
    _tfTypeAdd.text = @"";
    appDelegate.contactData.medicalId = @"";
    _tfDateOfBirth.text = @"";
    _tfNationality.text = @"";
    _tfType.text = @"";
}
- (IBAction)onBtnCancel:(id)sender
{
    [self.delegate goBackFromPProfileViewController];
}

- (IBAction)onBtnNationality:(id)sender {
    
    [tmpTf resignFirstResponder];
    isShowingTBNationality = !isShowingTBNationality;
    if (isShowingTBNationality) {
        [self showTBNationality:(UIButton *) sender];
    }
    else
    {
        [self hideTBNationality];
    }
    
}

- (IBAction)onBtnMale:(id)sender {
    [tmpTf resignFirstResponder];
    isShowingGenderView = false;
    strGender = @"Male";
    [self showGenderOption];
    [self performSelector:@selector(hideGenderView) withObject:nil afterDelay:0.3];
    
}

- (IBAction)onBtnFemale:(id)sender {
    [tmpTf resignFirstResponder];
    isShowingGenderView = false;
    strGender = @"Female";
    [self showGenderOption];
    [self performSelector:@selector(hideGenderView) withObject:nil afterDelay:0.3];
}

- (IBAction)onDoneDate:(id)sender {
    [tmpTf resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBlackViewForBoth];
    });
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.viewDatePicker.alpha = 0.0f;
    }];

}

- (IBAction)datePickerChanged:(id)sender {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"LLL dd, yyyy"];
    NSString *strDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    strBirthDate = strDate;
    
    [self setDateWithString:strDate];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isScrolling = true;
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    isScrolling = false;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isScrolling) {
        return;
    }
    [tmpTf resignFirstResponder];
}

@end
