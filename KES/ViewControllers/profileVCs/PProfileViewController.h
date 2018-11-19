//
//  PProfileViewController.h
//  KES
//
//  Created by Piglet on 04.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeTableViewCell.h"
#import "macro.h"
#import "Functions.h"
#import "WebServices.h"
#import <SDWebImage/UIImageView+WebCache.h>

@protocol PProfileViewControllerDelegate
- (void) goBackFromPProfileViewController;
@end
@interface PProfileViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, WebServicesDelegate>
{
    BOOL isSelectUploadOwn;
    
    CGFloat mtfposition;
    CGFloat mtfHeight;
    
    UITextField *tmpTf;
    NSString *strBirthDate;
    NSString *strGender;
    BOOL isShowingGenderView;
    
    NSMutableArray *arrTypes;
    NSString *strSelectedType;
    NSInteger selectedTypeId;
    BOOL isShowingTbType;
    BOOL isScrolling;
    CGFloat heightTopOfParentView;
    NSUserDefaults *userInfo;
    WebServices *objWebServices;
    NSString *updateProfileApi, *uploadAvatarApi;
    
    NSString *strSelectedNationality;
    bool isShowingTBNationality;
    
    NSString *strSelectedMedical;
    NSString *selectedMedicalId;
    bool isShowingTBMedical;
}

@property (nonatomic, strong) id <PProfileViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scContainer;
@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *viewGender;
@property (weak, nonatomic) IBOutlet UILabel *lblMale;
@property (weak, nonatomic) IBOutlet UILabel *lblFemale;
@property (weak, nonatomic) IBOutlet UITableView *tbForTypes;


- (IBAction)onBtnMale:(id)sender;
- (IBAction)onBtnFemale:(id)sender;

- (IBAction)onDoneDate:(id)sender;
- (IBAction)datePickerChanged:(id)sender;

//    ----- 1. Photo ------
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgUseGravatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgUploadAvatar;
@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;
@property (weak, nonatomic) IBOutlet UIButton *btnProfilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblChangeAvatarWithGra;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeAvatarWithGra;

- (IBAction)onBtnUseGravatar:(id)sender;
- (IBAction)onBtnUploadAvatar:(id)sender;
- (IBAction)onBtnChangeAvatarWithGravatar:(id)sender;
// ------------------------


//    ----- 2.Contact details ------

@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *tfNationality;
@property (weak, nonatomic) IBOutlet UITextField *tfGender;

@property (weak, nonatomic) IBOutlet UITextField *tfMedical;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfMobile;
@property (weak, nonatomic) IBOutlet UITableView *tbNationality;

@property (weak, nonatomic) IBOutlet UITableView *tbMedical;

- (IBAction)onBtnForDate:(id)sender;
- (IBAction)onBtnForGender:(id)sender;
- (IBAction)onBtnForMedical:(id)sender;

// ------------------------

//   ----- 3. Contact information -----

@property (weak, nonatomic) IBOutlet UITextField *tfType;
@property (weak, nonatomic) IBOutlet UITextField *tfTypeAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnAddType;


- (IBAction)onBtnForType:(id)sender;
- (IBAction)onBtnAddType:(id)sender;

// ------------------------

@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnReset:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnNationality:(id)sender;

@end
