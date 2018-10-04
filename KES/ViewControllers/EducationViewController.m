//
//  EducationViewController.m
//  KES
//
//  Created by matata on 3/19/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "EducationViewController.h"

@interface EducationViewController ()

@end

@implementation EducationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    [Functions makeFloatingField:_courseField placeholder:@"Course you would like to get"];
    [Functions makeFloatingField:_pointsField placeholder:@"Points required"];
    
    [Functions makeBorderView:_academicSelectView];
    [Functions makeBorderView:_schoolSelectView];
    [Functions makeBorderView:_yearSelectView];
    
    academicPickerData = [[NSMutableArray alloc] init];
    schoolPickerData = [[NSMutableArray alloc] init];
    yearPickerData = [[NSMutableArray alloc] init];
    
    for (AcademicYearModel *obj in appDelegate.academicYearArray) {
        if ([obj.academic_id isEqualToString:appDelegate.contactData.academic_year_id]) {
            [_academicBtn setTitle:obj.title forState:UIControlStateNormal];
        }
        [academicPickerData addObject:obj.title];
    }
    
    for (SchoolModel *obj in appDelegate.schoolArray) {
        if ([obj.school_id isEqualToString:appDelegate.contactData.school_id]) {
            [_schookBtn setTitle:obj.name forState:UIControlStateNormal];
        }
        [schoolPickerData addObject:obj.name];
    }
    
    for (YearModel *obj in appDelegate.yearArray) {
        if ([obj.year_id isEqualToString:appDelegate.contactData.year_id]) {
            [_yearBtn setTitle:obj.year forState:UIControlStateNormal];
        }
        [yearPickerData addObject:obj.year];
    }
    
    CGRect frame = _decisionView.frame;
    frame.origin.y = _pickerView.frame.origin.y - _decisionView.frame.size.height;
    _decisionView.frame = frame;
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    _courseField.text = appDelegate.contactData.courses_i_would_like;
    _pointsField.text = appDelegate.contactData.points;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPickerView {
    _pickerView.hidden = NO;
    _decisionView.hidden = NO;
    [_pickerView reloadAllComponents];
}

- (void)hidePickerView {
    _pickerView.hidden = YES;
    _decisionView.hidden = YES;
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
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - PickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([visiblePicker isEqualToString:ACADEMIC_PICKER]) {
        return academicPickerData.count;
    } else if ([visiblePicker isEqualToString:SCHOOL_PICKER]) {
        return schoolPickerData.count;
    } else if ([visiblePicker isEqualToString:YEAR_PICKER]) {
        return yearPickerData.count;
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([visiblePicker isEqualToString:ACADEMIC_PICKER]) {
        return academicPickerData[row];
    } else if ([visiblePicker isEqualToString:SCHOOL_PICKER]) {
        return schoolPickerData[row];
    } else if ([visiblePicker isEqualToString:YEAR_PICKER]) {
        return yearPickerData[row];
    }
    return @"";
}

#pragma mark - IBAction
- (IBAction)OnAcademicClicked:(id)sender {
    visiblePicker = ACADEMIC_PICKER;
    [self showPickerView];
}

- (IBAction)OnSchoolClicked:(id)sender {
    visiblePicker = SCHOOL_PICKER;
    [self showPickerView];
}

- (IBAction)OnYearClicked:(id)sender {
    visiblePicker = YEAR_PICKER;
    [self showPickerView];
}

- (IBAction)OnCancelClicked:(id)sender {
    [self hidePickerView];
}

- (IBAction)OnOKClicked:(id)sender {
    [self hidePickerView];
    NSInteger row = [_pickerView selectedRowInComponent:0];
    
    if ([visiblePicker isEqualToString:ACADEMIC_PICKER]) {
        [_academicBtn setTitle:academicPickerData[row] forState:UIControlStateNormal];
        AcademicYearModel *obj = [appDelegate.academicYearArray objectAtIndex:row];
        appDelegate.contactData.academic_year_id = obj.academic_id;
    } else if ([visiblePicker isEqualToString:SCHOOL_PICKER]) {
        [_schookBtn setTitle:schoolPickerData[row] forState:UIControlStateNormal];
        SchoolModel *obj = [appDelegate.schoolArray objectAtIndex:row];
        appDelegate.contactData.school_id = obj.school_id;
    } else if ([visiblePicker isEqualToString:YEAR_PICKER]) {
        [_yearBtn setTitle:yearPickerData[row] forState:UIControlStateNormal];
        YearModel *obj = [appDelegate.yearArray objectAtIndex:row];
        appDelegate.contactData.year_id = obj.year_id;
    }
}

- (IBAction)OnUpdateProfileClicked:(id)sender {
    appDelegate.contactData.courses_i_would_like = _courseField.text;
    appDelegate.contactData.points = _pointsField.text;
    
    NSMutableDictionary *parameters = [Functions getProfileParameter];
    updateProfileApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, CONTACT_DETAIL];
    [objWebServices callApiWithParameters:parameters apiName:updateProfileApi type:POST_REQUEST loader:YES view:self];
}
@end
