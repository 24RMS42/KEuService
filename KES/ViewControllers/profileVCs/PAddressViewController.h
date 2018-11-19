//
//  PAddressViewController.h
//  KES
//
//  Created by Piglet on 05.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "Functions.h"
#import "WebServices.h"
#import "CountryPicker.h"

@protocol PAddressViewControllerDelegate
- (void) goBackFromPAddressVC;
@end

@interface PAddressViewController : UIViewController<UITextFieldDelegate, WebServicesDelegate>
{
    NSString *strSelectedCountry;
    CGFloat mtfposition;
    CGFloat mtfHeight;
    UITextField *tmpTf;
    CGFloat heightTopOfParentView;
    
    BOOL isShowingTBCountry;
    NSArray *arrCountries;
    WebServices *objWebServices;
    NSString *updateProfileApi;
}

@property (nonatomic, strong) id <PAddressViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *tfAddress1;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress2;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress3;
@property (weak, nonatomic) IBOutlet UITextField *tfCity;
@property (weak, nonatomic) IBOutlet UITextField *tfCountry;
@property (weak, nonatomic) IBOutlet UITextField *tfPostcode;
@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;
@property (weak, nonatomic) IBOutlet CountryPicker *countryPicker;
@property (weak, nonatomic) IBOutlet UIView *pickerContainer;



- (IBAction)onBtnCountry:(id)sender;
- (IBAction)onBtnDoneCountryPicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scContainer;


@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnReset:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

@end
