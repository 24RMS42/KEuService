//
//  PNotificationViewController.h
//  KES
//
//  Created by Piglet on 03.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "Functions.h"

@protocol PNotificationViewControllerDelegate
- (void) goBackFromNotificationViewController;
@end


@interface PNotificationViewController : UIViewController
{
    BOOL isShowingViewEmergency;
    BOOL isShowingViewAccount;
    BOOL isShowingViewAbsenteeism;
    
    // bool value for Emergency
    
    BOOL isEmergency;
    BOOL isEmergencyMessage;
    BOOL isEmergencyPhoneCall;
    BOOL isEmergencyEmail;
    
    // bool value for Accounts
    
    BOOL isAccount;
    BOOL isAccountMessage;
    BOOL isAccountPhoneCall;
    BOOL isAccountEmail;
    
    // bool value for Absenteeism
    
    BOOL isAbsenteeism;
    BOOL isAbsenteeismMessage;
    BOOL isAbsenteeismPhoneCall;
    BOOL isAbsenteeismEmail;
    
    // bool value for Reminders
    
    BOOL isReminder;
    BOOL isReminderMessage;
    BOOL isReminderPhoneCall;
    BOOL isReminderEmail;
    
    // bool value for Time Sheet
    
    BOOL isTimesheet;
    BOOL isTimeSheetMessage;
    BOOL isTimeSheetPhoneCall;
    BOOL isTimeSheetEmail;
    
    // bool value for course bookings
    
    BOOL isCoureBooking;
    
    // bool value for Marketing updates
    
    BOOL isMarketingUpdates;
}

@property (nonatomic, strong) id <PNotificationViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewEmergency_height;  // 165
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewAccount_height;  // 165
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewAbsenteeism_height;  // 165
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewEmergency_top;  // 10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewAccount_top;  // 10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewAbsenteeism_top;  // 10

@property (weak, nonatomic) IBOutlet UIView *viewEmergency;
@property (weak, nonatomic) IBOutlet UIView *viewAccount;
@property (weak, nonatomic) IBOutlet UIView *viewAbsenteeism;

@property (weak, nonatomic) IBOutlet UIButton *btnEmergency;
@property (weak, nonatomic) IBOutlet UIButton *btnEmergencyTM;
@property (weak, nonatomic) IBOutlet UIButton *btnEmergencyPhonecall;
@property (weak, nonatomic) IBOutlet UIButton *btnEmergencyEmail;

- (IBAction)onBtnEmergency:(id)sender;
- (IBAction)onBtnEmergencyTM:(id)sender;
- (IBAction)onBtnEmergencyPhoneCall:(id)sender;
- (IBAction)onBtnEmergencyEmail:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnAccount;
@property (weak, nonatomic) IBOutlet UIButton *btnAccountTM;
@property (weak, nonatomic) IBOutlet UIButton *btnAccountPhonecall;
@property (weak, nonatomic) IBOutlet UIButton *btnAccountEmail;

- (IBAction)onBtnAccount:(id)sender;
- (IBAction)onBtnAccountTM:(id)sender;
- (IBAction)onBtnAccountPhoneCall:(id)sender;
- (IBAction)onBtnAccountEmail:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnAbsenteeism;
@property (weak, nonatomic) IBOutlet UIButton *btnAbsenteeismTM;
@property (weak, nonatomic) IBOutlet UIButton *btnAbsenteeismPhonecall;
@property (weak, nonatomic) IBOutlet UIButton *btnAbsenteeismEmail;

- (IBAction)onBtnAbsenteeism:(id)sender;
- (IBAction)onBtnAbsenteeismTM:(id)sender;
- (IBAction)onBtnAbsenteeismPhonecall:(id)sender;
- (IBAction)onBtnAbsenteeismEmail:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnReminder;
@property (weak, nonatomic) IBOutlet UIButton *btnReminderTM;
@property (weak, nonatomic) IBOutlet UIButton *btnReminderPhonecall;
@property (weak, nonatomic) IBOutlet UIButton *btnReminderEmail;

- (IBAction)onBtnReminder:(id)sender;
- (IBAction)onBtnReminderTM:(id)sender;
- (IBAction)onBtnReminderPhonecall:(id)sender;
- (IBAction)onBtnReminderEmail:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnTimesheet;
@property (weak, nonatomic) IBOutlet UIButton *btnTimesheetTM;
@property (weak, nonatomic) IBOutlet UIButton *btnTimesheetPhonecall;
@property (weak, nonatomic) IBOutlet UIButton *btnTimesheetEmail;

- (IBAction)onBtnTimesheet:(id)sender;
- (IBAction)onBtnTimesheetTM:(id)sender;
- (IBAction)onBtnTimesheetPhonecall:(id)sender;
- (IBAction)onBtnTimesheetEmail:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCourseBooking;
- (IBAction)onBtnCourseBooking:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnMarketingupdate;
- (IBAction)onBtnMarketUpdate:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;

@property (weak, nonatomic) IBOutlet UIView *viewResult;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnReset:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)onBtnCancel:(id)sender;

@end
