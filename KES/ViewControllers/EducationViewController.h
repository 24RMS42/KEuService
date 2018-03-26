//
//  EducationViewController.h
//  KES
//
//  Created by matata on 3/19/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "WebServices.h"
#import "AppDelegate.h"

#define ACADEMIC_PICKER @"ACADEMIC_PICKER"
#define SCHOOL_PICKER   @"SCHOOL_PICKER"
#define YEAR_PICKER     @"YEAR_PICKER"

@interface EducationViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, WebServicesDelegate>
{
    NSString *visiblePicker;
    NSMutableArray *academicPickerData, *schoolPickerData, *yearPickerData;
    WebServices *objWebServices;
    NSString *updateProfileApi;
}

@property (weak, nonatomic) IBOutlet UIView *academicSelectView;
@property (weak, nonatomic) IBOutlet UIView *schoolSelectView;
@property (weak, nonatomic) IBOutlet UIView *yearSelectView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *courseField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *pointsField;
@property (weak, nonatomic) IBOutlet UIButton *academicBtn;
@property (weak, nonatomic) IBOutlet UIButton *schookBtn;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
@property (weak, nonatomic) IBOutlet UIView *decisionView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)OnAcademicClicked:(id)sender;
- (IBAction)OnSchoolClicked:(id)sender;
- (IBAction)OnYearClicked:(id)sender;
- (IBAction)OnCancelClicked:(id)sender;
- (IBAction)OnOKClicked:(id)sender;
- (IBAction)OnUpdateProfileClicked:(id)sender;

@end
