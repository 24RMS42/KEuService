//
//  ProfileViewController.m
//  KES
//
//  Created by matata on 3/12/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "ProfileViewController.h"

#define DATE_PICKER @"date_picker"
#define NATIONAL_PICKER @"national_picker"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Functions makeFloatingField:_titleField placeholder:@"Title"];
    [Functions makeFloatingField:_firstNameField placeholder:@"First Name"];
    [Functions makeFloatingField:_lastNameField placeholder:@"Last Name"];
    
    [Functions makeFloatingField:_emailField placeholder:@"Email"];
    [Functions makeFloatingField:_phoneField placeholder:@"Phone"];
    
    [Functions makeFloatingField:_passwordField placeholder:@"Current password"];
    [Functions makeFloatingField:_passwordNewField placeholder:@"New password"];
    [Functions makeFloatingField:_confirmPwdField placeholder:@"Confirm password"];
    _passwordField.clearButtonMode = UITextFieldViewModeNever;
    _passwordNewField.clearButtonMode = UITextFieldViewModeNever;
    _confirmPwdField.clearButtonMode = UITextFieldViewModeNever;
    
    [Functions makeBorderView:_dateSelectionView];
    [Functions makeBorderView:_nationalSelectionView];
    
    _dateBirthPicker.backgroundColor = [UIColor whiteColor];
    
    NSDate *birthDate = [Functions convertStringToDate:appDelegate.contactData.date_of_birth format:MAIN_DATE_FORMAT];
    NSString *birthDateStr = [Functions convertDateToString:birthDate format:@"LLL dd, yyyy"];
    [_dateBirthBtn setTitle:birthDateStr forState:UIControlStateNormal];
    [_nationalBtn setTitle:appDelegate.contactData.nationality forState:UIControlStateNormal];
    _genderSwitch.selectedSegmentIndex = [appDelegate.contactData.gender isEqualToString:@"M"] ? 1 : 0;
    
    UILongPressGestureRecognizer *tap1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap1:)];
    UILongPressGestureRecognizer *tap2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap2:)];
    UILongPressGestureRecognizer *tap3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap3:)];
    tap1.minimumPressDuration = 0;
    tap2.minimumPressDuration = 0;
    tap3.minimumPressDuration = 0;
    [self.eye1Btn addGestureRecognizer:tap1];
    [self.eye2Btn addGestureRecognizer:tap2];
    [self.eye3Btn addGestureRecognizer:tap3];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    userInfo = [NSUserDefaults standardUserDefaults];
    
    _userNameLbl.text = [NSString stringWithFormat:@"%@ %@", appDelegate.contactData.first_name, appDelegate.contactData.last_name];
    _firstNameField.text = appDelegate.contactData.first_name;
    _lastNameField.text = appDelegate.contactData.last_name;
    _titleField.text = appDelegate.contactData.title;
    
    for (ContactNotification *obj in appDelegate.contactData.contactDetails) {
        if ([obj.type_id isEqualToString:@"1"]) {
            _emailField.text = obj.value;
        } else if ([obj.type_id isEqualToString:@"2"]) {
            _phoneField.text = obj.value;
        }
    }
    
    CGRect frame = _emailField.frame;
    frame.origin.y = 0;
    _emailField.frame = frame;
    
    CGRect pFrame = _passwordField.frame;
    pFrame.origin.y = 0;
    _passwordField.frame = pFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleLongTap1:(UIGestureRecognizer*)gesture {
    if (gesture.state == UIPressPhaseChanged) {
        _passwordField.secureTextEntry = NO;
    } else if (gesture.state == UIPressPhaseEnded) {
        _passwordField.secureTextEntry = YES;
    }
}

- (void)handleLongTap2:(UIGestureRecognizer*)gesture {
    if (gesture.state == UIPressPhaseChanged) {
        _passwordNewField.secureTextEntry = NO;
    } else if (gesture.state == UIPressPhaseEnded) {
        _passwordNewField.secureTextEntry = YES;
    }
}

- (void)handleLongTap3:(UIGestureRecognizer*)gesture {
    if (gesture.state == UIPressPhaseChanged) {
        _confirmPwdField.secureTextEntry = NO;
    } else if (gesture.state == UIPressPhaseEnded) {
        _confirmPwdField.secureTextEntry = YES;
    }
}

- (void)displayContentController:(UIViewController*) content {
    [self addChildViewController:content];
    
    CGRect newFrame = content.view.frame;
    newFrame.size.height = self.containerView.frame.size.height;
    [content.view setFrame:newFrame];
    
    [self.containerView addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (BOOL)validatePassword {
    NSString *currentPwd = [userInfo valueForKey:KEY_PASSWORD];
    if (![currentPwd isEqualToString:_passwordField.text]) {
        [_passwordField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Plasse check current password"];
        return FALSE;
    }
    if ([_passwordNewField.text isEqualToString:@""]) {
        [_passwordNewField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Plaese input new password"];
        return FALSE;
    }
    if (![_passwordNewField.text isEqualToString:_confirmPwdField.text]) {
        [_confirmPwdField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please confirm password"];
        return FALSE;
    }
    return TRUE;
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - PickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return appDelegate.nationalityArray.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return appDelegate.nationalityArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:updateProfileApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [Functions showSuccessAlert:@"" message:PROFILE_UPDATED image:@""];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:updatePasswordApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                NSLog(@"======= password update success =======");
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - IBAction
- (IBAction)OnCategoryChanged:(id)sender {
    category = _categorySegment.selectedSegmentIndex;
    _containerView.hidden = YES;
    _ContactView.hidden = YES;
    _PasswordView.hidden = YES;
    
    if (_categorySegment.selectedSegmentIndex == 0) {
        
    } else if (_categorySegment.selectedSegmentIndex == 1) {
        _ContactView.hidden = NO;
    } else if (_categorySegment.selectedSegmentIndex == 2) {
        _containerView.hidden = NO;
        if (!addressViewLoaded) {
            //addressViewLoaded = YES;
            AddressViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"address"];
            [self displayContentController:controller];
        }
    } else if (_categorySegment.selectedSegmentIndex == 3) {
        _containerView.hidden = NO;
        if (!educationViewLoaded) {
            //educationViewLoaded = YES;
            EducationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"education"];
            [self displayContentController:controller];
        }
    } else if (_categorySegment.selectedSegmentIndex == 4) {
        _PasswordView.hidden = NO;
    }
}

- (IBAction)OnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnLogoutClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT object:self];
}

- (IBAction)OnDateClicked:(id)sender {
    _decisionView.hidden = NO;
    _dateBirthPicker.hidden = NO;
    _nationalityPicker.hidden = YES;
    visiblePicker = DATE_PICKER;
}

- (IBAction)OnNationalClicked:(id)sender {
    visiblePicker = NATIONAL_PICKER;
    _decisionView.hidden = NO;
    _nationalityPicker.hidden = NO;
    _dateBirthPicker.hidden = YES;
}

- (IBAction)OnGenderChanged:(id)sender {
}

- (IBAction)OnOKClicked:(id)sender {
    _decisionView.hidden = YES;
    if ([visiblePicker isEqualToString:DATE_PICKER]) {
        _dateBirthPicker.hidden = YES;
        [_dateBirthBtn setTitle:[Functions convertDateToString:[_dateBirthPicker date] format:@"LLL dd, yyyy"] forState:UIControlStateNormal];
        appDelegate.contactData.date_of_birth = [Functions convertDateToString:[_dateBirthPicker date] format:MAIN_DATE_FORMAT];
    } else {
        _nationalityPicker.hidden = YES;
        NSInteger row = [_nationalityPicker selectedRowInComponent:0];
        [_nationalBtn setTitle:appDelegate.nationalityArray[row] forState:UIControlStateNormal];
        appDelegate.contactData.nationality = appDelegate.nationalityArray[row];
    }
}

- (IBAction)OnCancelClicked:(id)sender {
    _decisionView.hidden = YES;
    _dateBirthPicker.hidden = YES;
    _nationalityPicker.hidden = YES;
}

- (IBAction)OnUpdateProfileClicked:(id)sender {
    if (category == 0) {
        appDelegate.contactData.title = _titleField.text;
        appDelegate.contactData.first_name = _firstNameField.text;
        appDelegate.contactData.last_name = _lastNameField.text;
        appDelegate.contactData.gender = _genderSwitch.selectedSegmentIndex == 0 ? @"F" : @"M";
    } else if (category == 1) {
        NSMutableArray *updatedContactArray = [[NSMutableArray alloc] init];
        for (ContactNotification *obj in appDelegate.contactData.contactDetails) {
            if ([obj.type_id isEqualToString:@"1"]) {
                obj.value = _emailField.text;
            } else if ([obj.type_id isEqualToString:@"2"]) {
                obj.value = _phoneField.text;
            }
            [updatedContactArray addObject:obj];
        }
        appDelegate.contactData.contactDetails = [[NSMutableArray alloc] init];
        appDelegate.contactData.contactDetails = [NSMutableArray arrayWithArray:updatedContactArray];
    } else if (category == 4) {
        if ([self validatePassword]) {
            NSDictionary * parameters = @{@"password":_passwordNewField.text,
                                          @"mpassword":_confirmPwdField.text};
            updatePasswordApi = [NSString stringWithFormat:@"%@%@", BASE_URL, PROFILE_API];
            [objWebServices callApiWithParameters:parameters apiName:updatePasswordApi type:POST_REQUEST loader:YES view:self];
        }
        return;
    }
    
    NSMutableDictionary *parameters = [Functions getProfileParameter];
    updateProfileApi = [NSString stringWithFormat:@"%@%@", BASE_URL, CONTACT_DETAIL];
    [objWebServices callApiWithParameters:parameters apiName:updateProfileApi type:POST_REQUEST loader:YES view:self];
}
@end
