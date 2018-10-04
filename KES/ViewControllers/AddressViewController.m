//
//  AddressViewController.m
//  KES
//
//  Created by matata on 3/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "AddressViewController.h"

#define COUNTRY_PICKER @"country"
#define COUNTY_PICKER  @"county"

@interface AddressViewController ()

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    [Functions makeFloatingField:_address1Field placeholder:@"Address 1"];
    [Functions makeFloatingField:_address2Field placeholder:@"Address 2"];
    [Functions makeFloatingField:_address3Field placeholder:@"Address 3"];
    [Functions makeFloatingField:_postcodeField placeholder:@"Eircode"];
    [Functions makeFloatingField:_cityField placeholder:@"City"];
    [Functions makeFloatingField:_countyField placeholder:@"County"];
    
    [Functions makeBorderView:_countryView];
    [Functions makeBorderView:_countyView];
    
    countryPickerData = [[NSMutableArray alloc] init];
    for (CountryModel *countryObj in appDelegate.countryArray) {
        [countryPickerData addObject:countryObj.name];
        if ([countryObj.country_id isEqualToString:appDelegate.contactData.country]) {
            [_countryBtn setTitle:countryObj.name forState:UIControlStateNormal];
            
            [self checkIreland:countryObj.country_id];
        }
    }
    
    countyPickerData = [[NSMutableArray alloc] init];
    for (CountryModel *countryObj in appDelegate.countyArray) {
        [countyPickerData addObject:countryObj.name];
        if ([countryObj.country_id isEqualToString:appDelegate.contactData.county]) {
            [_countyBtn setTitle:countryObj.name forState:UIControlStateNormal];
        }
    }
    
    CGRect decisionViewFrame = _decisionView.frame;
    CGRect pickerViewFrame = _pickerView.frame;
    decisionViewFrame.origin.y = pickerViewFrame.origin.y - decisionViewFrame.size.height;
    _decisionView.frame = decisionViewFrame;
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    _address1Field.text = appDelegate.contactData.address1;
    _address2Field.text = appDelegate.contactData.address2;
    _address3Field.text = appDelegate.contactData.address3;
    _postcodeField.text = appDelegate.contactData.postcode;
    _cityField.text = appDelegate.contactData.town;
    _countyField.text = appDelegate.contactData.county;
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

- (void)checkIreland:(NSString*)countryId {
    if ([countryId isEqualToString:@"IE"]) {
        self.countyFieldView.hidden = YES;
    } else
        self.countyFieldView.hidden = NO;
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _postcodeField || textField == _countyField) {
        CGSize oldSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView setContentSize:oldSize];
        [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _postcodeField || textField == _countyField) {
        CGSize newSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 150);
        [_scrollView setContentSize:newSize];
        CGPoint bottomOffset = CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    }
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

#pragma mark - PickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([visiblePicker isEqualToString:COUNTRY_PICKER]) {
        return countryPickerData.count;
    } else if ([visiblePicker isEqualToString:COUNTY_PICKER]) {
        return countyPickerData.count;
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([visiblePicker isEqualToString:COUNTRY_PICKER]) {
        return countryPickerData[row];
    } else if ([visiblePicker isEqualToString:COUNTY_PICKER]) {
        return countyPickerData[row];
    }
    return @"";
}

#pragma mark - IBAction
- (IBAction)OnCountryClicked:(id)sender {
    visiblePicker = COUNTRY_PICKER;
    [self showPickerView];
}

- (IBAction)OnCountyClicked:(id)sender {
    visiblePicker = COUNTY_PICKER;
    [self showPickerView];
}

- (IBAction)OnOKClicked:(id)sender {
    [self hidePickerView];
    NSInteger row = [_pickerView selectedRowInComponent:0];
    
    if ([visiblePicker isEqualToString:COUNTRY_PICKER]) {
        [_countryBtn setTitle:countryPickerData[row] forState:UIControlStateNormal];
        CountryModel *countryObj = [appDelegate.countryArray objectAtIndex:row];
        appDelegate.contactData.country = countryObj.country_id;
        
        [self checkIreland:countryObj.country_id];
    } else if ([visiblePicker isEqualToString:COUNTY_PICKER]) {
        [_countyBtn setTitle:countyPickerData[row] forState:UIControlStateNormal];
        CountryModel *countryObj = [appDelegate.countyArray objectAtIndex:row];
        appDelegate.contactData.county = countryObj.country_id;
    }
}

- (IBAction)OnCancelClicked:(id)sender {
    [self hidePickerView];
}

- (IBAction)OnUpdateClicked:(id)sender {
    appDelegate.contactData.address1 = _address1Field.text;
    appDelegate.contactData.address2 = _address2Field.text;
    appDelegate.contactData.address3 = _address3Field.text;
    appDelegate.contactData.town = _cityField.text;
    appDelegate.contactData.postcode = _postcodeField.text;
    
    if (!_countyFieldView.hidden) {
        appDelegate.contactData.county = _countyField.text;
    }
    
    NSMutableDictionary *parameters = [Functions getProfileParameter];
    updateProfileApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, CONTACT_DETAIL];
    [objWebServices callApiWithParameters:parameters apiName:updateProfileApi type:POST_REQUEST loader:YES view:self];
}
@end
