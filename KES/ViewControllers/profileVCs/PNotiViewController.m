//
//  PNotiViewController.m
//  KES
//
//  Created by matata on 10/11/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "PNotiViewController.h"

@interface PNotiViewController ()

@end

@implementation PNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    [self setupNotificationPreferenceUI];
    
    for (PreferenceType *preferenceObj in appDelegate.contactData.preferenceArray) {
        NSInteger tag = [preferenceObj.preference_id integerValue];
        NSLog(@"sss=%@", preferenceObj.notification_type);
        if ([preferenceObj.notification_type isKindOfClass:[NSNull class]]) {
            
        }
        else
        {
            if ([preferenceObj.notification_type isEqualToString:@"sms"]) {
                UISwitch *enabledSwitch = (UISwitch*)[self.view viewWithTag:tag*10];
                [enabledSwitch setOn:YES];
            } else if ([preferenceObj.notification_type isEqualToString:@"email"]) {
                UISwitch *enabledSwitch = (UISwitch*)[self.view viewWithTag:tag];
                [enabledSwitch setOn:YES];
            } else if ([preferenceObj.notification_type isEqualToString:@"phone"]) {
                UISwitch *enabledSwitch = (UISwitch*)[self.view viewWithTag:tag*100];
                [enabledSwitch setOn:YES];
            }
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBlackView)
                                                 name:NOTI_SHOW_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:NOTI_HIDE_SUB_BLACK
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showBlackView
{
    [UIView animateWithDuration:0.5f animations:^{
//        self.viewBlackOpaque.alpha = 0.7f;
        [self.scrollView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }];
}

- (void) hideBlackView
{
    [UIView animateWithDuration:0.5f animations:^{
//        self.viewBlackOpaque.alpha = 0.0f;
        [self.scrollView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.7f]];
    }];
}

- (void)setupNotificationPreferenceUI {
    offset = 0;
    for (PreferenceType *preferenceObj in appDelegate.preferenceTypeArray) {
        NSInteger tag = [preferenceObj.preference_id integerValue];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, offset, SCREEN_WIDTH, 227)];
        view.tag = tag * 1000;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 16, SCREEN_WIDTH, 35)];
        label.font = [UIFont fontWithName:@"Roboto-Medium" size:18];
        label.textColor = [UIColor colorWithHex:COLOR_FONT];
        label.text = preferenceObj.label;
        
        UILabel *summaryLbl = [[UILabel alloc] initWithFrame:CGRectMake(22, 45, SCREEN_WIDTH, 30)];
        summaryLbl.font = [UIFont fontWithName:@"Roboto-Light" size:14];
        summaryLbl.textColor = [UIColor colorWithHex:COLOR_FONT];
        summaryLbl.text = preferenceObj.summary;
        
        UILabel *smsLbl = [[UILabel alloc] initWithFrame:CGRectMake(44, 127, 120, 35)];
        smsLbl.font = [UIFont fontWithName:@"Roboto-Light" size:15];
        smsLbl.textColor = [UIColor colorWithHex:COLOR_GRAY];
        smsLbl.text = @"Text Message";
        
        UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(44, 177, 120, 35)];
        phoneLbl.font = [UIFont fontWithName:@"Roboto-Light" size:15];
        phoneLbl.textColor = [UIColor colorWithHex:COLOR_GRAY];
        phoneLbl.text = @"Phone Call";
        
        UILabel *emailLbl = [[UILabel alloc] initWithFrame:CGRectMake(44, 77, 120, 35)];
        emailLbl.font = [UIFont fontWithName:@"Roboto-Light" size:15];
        emailLbl.textColor = [UIColor colorWithHex:COLOR_GRAY];
        emailLbl.text = @"Email";
        
        UISwitch *smsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(302, 130, 51, 31)];
        smsSwitch.tag = tag * 10;
        
        UISwitch *phoneSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(302, 180, 51, 31)];
        phoneSwitch.tag = tag * 100;
        
        UISwitch *emailSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(302, 80, 51, 31)];
        emailSwitch.tag = tag;
        
        [view addSubview:label];
        [view addSubview:summaryLbl];
        [view addSubview:emailLbl];
        [view addSubview:smsLbl];
        [view addSubview:phoneLbl];
        [view addSubview:smsSwitch];
        [view addSubview:phoneSwitch];
        [view addSubview:emailSwitch];
        
        [self.scrollView addSubview:view];
        offset += 227;
    }
    
    UIView *buttonContainView = [self.view viewWithTag:10];
    [_scrollView addSubview:buttonContainView];
    CGRect frame = buttonContainView.frame;
    frame.origin.y = offset + 450;
    buttonContainView.frame = frame;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, offset + buttonContainView.frame.size.height + 50);
}

- (void)updateNotificationValue {
    NSMutableArray *updatedPrefernceArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < appDelegate.preferenceTypeArray.count; i++) {
        PreferenceType *preferenceObj = [appDelegate.preferenceTypeArray objectAtIndex:i];
        NSInteger tag = [preferenceObj.preference_id integerValue];
        UISwitch *emailSwitch = (UISwitch*)[self.view viewWithTag:tag];
        UISwitch *smsSwitch = (UISwitch*)[self.view viewWithTag:tag*10];
        UISwitch *phoneSwitch = (UISwitch*)[self.view viewWithTag:tag*100];
        
        if (emailSwitch.isOn) {
            PreferenceType *obj = [[PreferenceType alloc] init];
            obj.preference_id = preferenceObj.preference_id;
            obj.label = preferenceObj.label;
            obj.summary = preferenceObj.summary;
            obj.notification_type = @"email";
            [updatedPrefernceArray addObject:obj];
        }
        if (smsSwitch.isOn) {
            PreferenceType *obj = [[PreferenceType alloc] init];
            obj.preference_id = preferenceObj.preference_id;
            obj.label = preferenceObj.label;
            obj.summary = preferenceObj.summary;
            obj.notification_type = @"sms";
            [updatedPrefernceArray addObject:obj];
        }
        if (phoneSwitch.isOn) {
            PreferenceType *obj = [[PreferenceType alloc] init];
            obj.preference_id = preferenceObj.preference_id;
            obj.label = preferenceObj.label;
            obj.summary = preferenceObj.summary;
            obj.notification_type = @"phone";
            [updatedPrefernceArray addObject:obj];
        }
    }
    
    appDelegate.contactData.preferenceArray = [[NSMutableArray alloc] init];
    appDelegate.contactData.preferenceArray = [NSMutableArray arrayWithArray:updatedPrefernceArray];
    NSLog(@"%lu", (unsigned long)appDelegate.contactData.preferenceArray.count);
}

- (void)resetValues {
    for (int i = 0; i < appDelegate.preferenceTypeArray.count; i++) {
        PreferenceType *preferenceObj = [appDelegate.preferenceTypeArray objectAtIndex:i];
        NSInteger tag = [preferenceObj.preference_id integerValue];
        UISwitch *emailSwitch = (UISwitch*)[self.view viewWithTag:tag];
        UISwitch *smsSwitch = (UISwitch*)[self.view viewWithTag:tag*10];
        UISwitch *phoneSwitch = (UISwitch*)[self.view viewWithTag:tag*100];
        
        [emailSwitch setOn:NO];
        [smsSwitch setOn:NO];
        [phoneSwitch setOn:NO];
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
                [self.delegate goBackFromNotiViewController];
            } else {
                [Functions checkError:responseDict];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)onBtnSave:(id)sender {
    [self updateNotificationValue];
    
    NSMutableDictionary *parameters = [Functions getProfileParameter];
    updateProfileApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, CONTACT_DETAIL];
    [objWebServices callApiWithParameters:parameters apiName:updateProfileApi type:POST_REQUEST loader:YES view:self];
}

- (IBAction)onBtnReset:(id)sender {
    [self resetValues];
}

- (IBAction)onBtnCancel:(id)sender {
    [self.delegate goBackFromNotiViewController];
}
@end
