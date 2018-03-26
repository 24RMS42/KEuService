//
//  AddressViewController.h
//  KES
//
//  Created by matata on 3/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "WebServices.h"
#import "AppDelegate.h"

@interface AddressViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, WebServicesDelegate, UIScrollViewDelegate, UITextFieldDelegate>
{
    NSString *visiblePicker;
    NSMutableArray *countryPickerData, *countyPickerData;
    WebServices *objWebServices;
    NSString *updateProfileApi;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *address1Field;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *address2Field;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *address3Field;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *postcodeField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *cityField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *countyField;
@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UIButton *countyBtn;
@property (weak, nonatomic) IBOutlet UIView *countryView;
@property (weak, nonatomic) IBOutlet UIView *countyView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *decisionView;
@property (weak, nonatomic) IBOutlet UIView *countyFieldView;

- (IBAction)OnCountryClicked:(id)sender;
- (IBAction)OnCountyClicked:(id)sender;
- (IBAction)OnOKClicked:(id)sender;
- (IBAction)OnCancelClicked:(id)sender;
- (IBAction)OnUpdateClicked:(id)sender;

@end
