//
//  NotiViewController.m
//  KES
//
//  Created by matata on 3/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "NotiViewController.h"

@interface NotiViewController ()

@end

@implementation NotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    for (PreferenceType *preferenceObj in appDelegate.contactData.preferenceArray) {
        NSInteger tag = [preferenceObj.preference_id integerValue];
        UISwitch *enabledSwitch = (UISwitch*)[self.view viewWithTag:tag];
        [enabledSwitch setOn:YES];
        [self updateChildParentValue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateChildParentValue {
    [_reminderSwitch setOn:_textMsgSwitch.isOn || _phoneCallSwitch.isOn || _emailSwitch.isOn];
    [_marketUpdateSwitch setOn:_marketReminderSwitch.isOn || _marketSwitch.isOn || _courseBookSwitch.isOn];
}

- (void)updateNotificationValue {
    NSMutableArray *enabledValues = [[NSMutableArray alloc] init];
    NSMutableArray *updatedPrefernceArray = [[NSMutableArray alloc] init];
    
    if (_textMsgSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_textMsgSwitch.tag]];
    }
    if (_phoneCallSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_phoneCallSwitch.tag]];
    }
    if (_emailSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_emailSwitch.tag]];
    }
    if (_marketReminderSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_marketReminderSwitch.tag]];
    }
    if (_marketSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_marketSwitch.tag]];
    }
    if (_courseBookSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_courseBookSwitch.tag]];
    }
    
    for (int i = 0; i < appDelegate.preferenceTypeArray.count; i++) {
        PreferenceType *pType = [appDelegate.preferenceTypeArray objectAtIndex:i];
        for (NSString *val in enabledValues) {
            if ([val isEqualToString:pType.preference_id]) {
                [updatedPrefernceArray addObject:pType];
            }
        }
    }
    
    appDelegate.contactData.preferenceArray = [[NSMutableArray alloc] init];
    appDelegate.contactData.preferenceArray = [NSMutableArray arrayWithArray:updatedPrefernceArray];
    NSLog(@"%lu", (unsigned long)appDelegate.contactData.preferenceArray.count);
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
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)OnBackClicked:(id)sender {
    [self updateNotificationValue];
    
    NSMutableDictionary *parameters = [Functions getProfileParameter];
    updateProfileApi = [NSString stringWithFormat:@"%@%@", BASE_URL, CONTACT_DETAIL];
    [objWebServices callApiWithParameters:parameters apiName:updateProfileApi type:POST_REQUEST loader:YES view:self];
}

- (IBAction)group1Changed:(id)sender {
    if (_reminderSwitch.isOn) {
        [_textMsgSwitch setOn:YES];
        [_phoneCallSwitch setOn:YES];
        [_emailSwitch setOn:YES];
    } else {
        [_textMsgSwitch setOn:NO];
        [_phoneCallSwitch setOn:NO];
        [_emailSwitch setOn:NO];
    }
}

- (IBAction)group2Changed:(id)sender {
    if (_marketUpdateSwitch.isOn) {
        [_marketReminderSwitch setOn:YES];
        [_marketSwitch setOn:YES];
        [_courseBookSwitch setOn:YES];
    } else {
        [_marketReminderSwitch setOn:NO];
        [_marketSwitch setOn:NO];
        [_courseBookSwitch setOn:NO];
    }
}

- (IBAction)childChanged:(id)sender {
    [self updateChildParentValue];
}
@end
