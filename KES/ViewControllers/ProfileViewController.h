//
//  ProfileViewController.h
//  KES
//
//  Created by matata on 3/12/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "CustomButton.h"
#import "WebServices.h"
#import "AppDelegate.h"
#import "AddressViewController.h"
#import "EducationViewController.h"

@interface ProfileViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, WebServicesDelegate>
{
    NSUserDefaults *userInfo;
    WebServices *objWebServices;
    NSString *loginApi, *updateProfileApi, *updatePasswordApi;
    NSString *visiblePicker;
    bool addressViewLoaded, educationViewLoaded;
    NSInteger category;
    NSMutableArray *titlePickerArray;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegment;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *firstNameField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *lastNameField;
@property (weak, nonatomic) IBOutlet UIView *titleSelectionView;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIView *dateSelectionView;
@property (weak, nonatomic) IBOutlet UIView *nationalSelectionView;
@property (weak, nonatomic) IBOutlet UIButton *dateBirthBtn;
@property (weak, nonatomic) IBOutlet UIButton *nationalBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *nationalityPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateBirthPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSwitch;
@property (weak, nonatomic) IBOutlet UIView *decisionView;
@property (weak, nonatomic) IBOutlet CustomButton *updateBtn;

@property (weak, nonatomic) IBOutlet UIView *ContactView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneField;

@property (weak, nonatomic) IBOutlet UIView *PasswordView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordNewField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *confirmPwdField;
@property (weak, nonatomic) IBOutlet UIButton *eye1Btn;
@property (weak, nonatomic) IBOutlet UIButton *eye2Btn;
@property (weak, nonatomic) IBOutlet UIButton *eye3Btn;


- (IBAction)OnCategoryChanged:(id)sender;
- (IBAction)OnBackClicked:(id)sender;
- (IBAction)OnLogoutClicked:(id)sender;
- (IBAction)OnDateClicked:(id)sender;
- (IBAction)OnNationalClicked:(id)sender;
- (IBAction)OnGenderChanged:(id)sender;
- (IBAction)OnOKClicked:(id)sender;
- (IBAction)OnCancelClicked:(id)sender;
- (IBAction)OnUpdateProfileClicked:(id)sender;
- (IBAction)OnTitleClicked:(id)sender;
@end
