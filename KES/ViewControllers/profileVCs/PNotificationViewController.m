//
//  PNotificationViewController.m
//  KES
//
//  Created by Piglet on 03.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "PNotificationViewController.h"

@interface PNotificationViewController ()

@end

@implementation PNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isShowingViewEmergency = YES;
    isShowingViewAccount = YES;
    isShowingViewAbsenteeism = YES;
    [self showOrHideViews];
    [self setButtonsView];
    
    [self showEmergency];
    [self showAccount];
    [self showAbsenteeism];
    [self showReminder];
    [self showTimeSheet];
    [self showEmergencyTM];
    [self showEmergencyPhoneCall];
    [self showEmergencyEmail];
    [self showAccountTM];
    [self showAccountPhonecall];
    [self showAccountEmail];
    [self showAbsenteeismTM];
    [self showAbsenteeismPhoneCall];
    [self showAbsenteeismEmail];
    [self showReminderTM];
    [self showReminderPhoneCall];
    [self showReminderEmail];
    [self showTimeSheetTM];
    [self showTimesheetPhoneCall];
    [self showTimeSheetEmail];
    [self showCourseBooking];
    [self showMarketUpdate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBlackView)
                                                 name:NOTI_SHOW_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:NOTI_HIDE_SUB_BLACK
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:HIDE_BLACKVIEW_SUPER
                                               object:nil];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBlackViewForBoth)];
    [self.viewBlackOpaque addGestureRecognizer:tapGesture];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void) showOrHideViews
{
    
    if (isShowingViewEmergency) {
        self.constraint_viewEmergency_top.constant = 10.0f;
        self.constraint_viewEmergency_height.constant = 165.0f;
        self.viewEmergency.alpha = 1.0f;
    }
    else
    {
        self.constraint_viewEmergency_top.constant = 0.0f;
        self.constraint_viewEmergency_height.constant = 0.0f;
        self.viewEmergency.alpha = 0.0f;
    }
    
    if (isShowingViewAccount) {
        self.constraint_viewAccount_top.constant = 10.0f;
        self.constraint_viewAccount_height.constant = 165.0f;
        self.viewAccount.alpha = 1.0f;
    }
    else
    {
        self.constraint_viewAccount_top.constant = 0.0f;
        self.constraint_viewAccount_height.constant = 0.0f;
        self.viewAccount.alpha = 0.0f;
    }
    
    if (isShowingViewAbsenteeism) {
        self.constraint_viewAbsenteeism_top.constant = 10.0f;
        self.constraint_viewAbsenteeism_height.constant = 165.0f;
        self.viewAbsenteeism.alpha = 1.0f;
    }
    else
    {
        self.constraint_viewAbsenteeism_top.constant = 0.0f;
        self.constraint_viewAbsenteeism_height.constant = 0.0f;
        self.viewAbsenteeism.alpha = 0.0f;
    }
    
}


- (void) setButtonsView
{
    [Functions setBoundsWithView:self.viewResult];
}

- (void) resetValues
{
    isEmergency = true;
    isEmergencyMessage = true;
    isEmergencyPhoneCall = true;
    isEmergencyEmail = true;
    
    // bool value for Accounts
    
    isAccount = true;
    isAccountMessage = true;
    isAccountPhoneCall = true;
    isAccountEmail = true;
    
    // bool value for Absenteeism
    
    isAbsenteeism = true;
    isAbsenteeismMessage = true;
    isAbsenteeismPhoneCall = true;
    isAbsenteeismEmail = true;
    
    // bool value for Reminders
    
    isReminder = true;
    isReminderMessage = true;
    isReminderPhoneCall = true;
    isReminderEmail = true;
    
    // bool value for Time Sheet
    
    isTimesheet = true;
    isTimeSheetMessage = true;
    isTimeSheetPhoneCall = true;
    isTimeSheetEmail = true;
    
    // bool value for course bookings
    
    isCoureBooking = true;
    
    // bool value for Marketing updates
    
    isMarketingUpdates = true;
    
    [self showEmergency];
    [self showAccount];
    [self showAbsenteeism];
    [self showReminder];
    [self showTimeSheet];
    [self showEmergencyTM];
    [self showEmergencyPhoneCall];
    [self showEmergencyEmail];
    [self showAccountTM];
    [self showAccountPhonecall];
    [self showAccountEmail];
    [self showAbsenteeismTM];
    [self showAbsenteeismPhoneCall];
    [self showAbsenteeismEmail];
    [self showReminderTM];
    [self showReminderPhoneCall];
    [self showReminderEmail];
    [self showTimeSheetTM];
    [self showTimesheetPhoneCall];
    [self showTimeSheetEmail];
    [self showCourseBooking];
    [self showMarketUpdate];
}

- (void) showEmergency
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isEmergency) {
            [self.btnEmergency setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
            self.btnEmergencyTM.enabled = YES;
            self.btnEmergencyPhonecall.enabled = YES;
            self.btnEmergencyEmail.enabled = YES;
            self.btnEmergencyTM.alpha = 1.0f;
            self.btnEmergencyPhonecall.alpha = 1.0f;
            self.btnEmergencyEmail.alpha = 1.0f;
        }
        else
        {
            [self.btnEmergency setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
            self.btnEmergencyTM.enabled = NO;
            self.btnEmergencyPhonecall.enabled = NO;
            self.btnEmergencyEmail.enabled = NO;
            self.btnEmergencyTM.alpha = 0.7f;
            self.btnEmergencyPhonecall.alpha = 0.7f;
            self.btnEmergencyEmail.alpha = 0.7f;
        }
    }];
}


- (void) showAccount
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isAccount) {
            [self.btnAccount setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
            self.btnAccountTM.enabled = YES;
            self.btnAccountPhonecall.enabled = YES;
            self.btnAccountEmail.enabled = YES;
            self.btnAccountTM.alpha = 1.0f;
            self.btnAccountPhonecall.alpha = 1.0f;
            self.btnAccountEmail.alpha = 1.0f;
        }
        else
        {
            [self.btnAccount setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
            self.btnAccountTM.enabled = NO;
            self.btnAccountPhonecall.enabled = NO;
            self.btnAccountEmail.enabled = NO;
            self.btnAccountTM.alpha = 0.7f;
            self.btnAccountPhonecall.alpha = 0.7f;
            self.btnAccountEmail.alpha = 0.7f;
        }
    }];
}

- (void) showAbsenteeism
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isAbsenteeism) {
            [self.btnAbsenteeism setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
            self.btnAbsenteeismTM.enabled = YES;
            self.btnAbsenteeismPhonecall.enabled = YES;
            self.btnAbsenteeismEmail.enabled = YES;
            self.btnAbsenteeismTM.alpha = 1.0f;
            self.btnAbsenteeismPhonecall.alpha = 1.0f;
            self.btnAbsenteeismEmail.alpha = 1.0f;
        }
        else
        {
            [self.btnAbsenteeism setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
            self.btnAbsenteeismTM.enabled = NO;
            self.btnAbsenteeismPhonecall.enabled = NO;
            self.btnAbsenteeismEmail.enabled = NO;
            self.btnAbsenteeismTM.alpha = 0.7f;
            self.btnAbsenteeismPhonecall.alpha = 0.7f;
            self.btnAbsenteeismEmail.alpha = 0.7f;

        }
    }];
}

- (void) showReminder
{
    [UIView animateWithDuration:0.5 animations:^{
    
        if (isReminder) {
            [self.btnReminder setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
            self.btnReminderTM.enabled = YES;
            self.btnReminderPhonecall.enabled = YES;
            self.btnReminderEmail.enabled = YES;
            self.btnReminderTM.alpha = 1.0f;
            self.btnReminderPhonecall.alpha = 1.0f;
            self.btnReminderEmail.alpha = 1.0f;
        }
        else
        {
            [self.btnReminder setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
            self.btnReminderTM.enabled = NO;
            self.btnReminderPhonecall.enabled = NO;
            self.btnReminderEmail.enabled = NO;
            self.btnReminderTM.alpha = 0.7f;
            self.btnReminderPhonecall.alpha = 0.7f;
            self.btnReminderEmail.alpha = 0.7f;
            
        }
    }];
}

- (void) showTimeSheet
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isTimesheet) {
            [self.btnTimesheet setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
            self.btnTimesheetTM.enabled = YES;
            self.btnTimesheetPhonecall.enabled = YES;
            self.btnTimesheetEmail.enabled = YES;
            self.btnTimesheetTM.alpha = 1.0f;
            self.btnTimesheetPhonecall.alpha = 1.0f;
            self.btnTimesheetEmail.alpha = 1.0f;
        }
        else
        {
            [self.btnTimesheet setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
            
            self.btnTimesheetTM.enabled = NO;
            self.btnTimesheetPhonecall.enabled = NO;
            self.btnTimesheetEmail.enabled = NO;
            self.btnTimesheetTM.alpha = 0.7f;
            self.btnTimesheetPhonecall.alpha = 0.7f;
            self.btnTimesheetEmail.alpha = 0.7f;
            
        }
    }];
}
- (void) showEmergencyTM
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isEmergencyMessage) {
            [self.btnEmergencyTM setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnEmergencyTM setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}

- (void) showEmergencyPhoneCall
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isEmergencyPhoneCall) {
            [self.btnEmergencyPhonecall setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnEmergencyPhonecall setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}

- (void) showEmergencyEmail
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isEmergencyEmail) {
            [self.btnEmergencyEmail setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnEmergencyEmail setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}

- (void) showAccountTM
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isAccountMessage) {
            [self.btnAccountTM setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnAccountTM setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}
- (void) showAccountPhonecall
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isAccountPhoneCall) {
            [self.btnAccountPhonecall setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnAccountPhonecall setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}


- (void) showAccountEmail
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isAccountEmail) {
            [self.btnAccountEmail setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnAccountEmail setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}


- (void) showAbsenteeismTM
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isAbsenteeismMessage) {
            [self.btnAbsenteeismTM setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnAbsenteeismTM setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}
- (void) showAbsenteeismPhoneCall
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isAbsenteeismPhoneCall) {
            [self.btnAbsenteeismPhonecall setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnAbsenteeismPhonecall setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}

- (void) showAbsenteeismEmail
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isAbsenteeismEmail) {
            [self.btnAbsenteeismEmail setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnAbsenteeismEmail setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}


- (void) showReminderTM
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isReminderMessage) {
            [self.btnReminderTM setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnReminderTM setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}

- (void) showReminderPhoneCall
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isReminderPhoneCall) {
            [self.btnReminderPhonecall setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnReminderPhonecall setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
    
}
- (void) showReminderEmail
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isReminderEmail) {
            [self.btnReminderEmail setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnReminderEmail setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}

- (void) showTimeSheetTM
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isTimeSheetMessage) {
            [self.btnTimesheetTM setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnTimesheetTM setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}

- (void) showTimesheetPhoneCall
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isTimeSheetPhoneCall) {
            [self.btnTimesheetPhonecall setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnTimesheetPhonecall setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}

- (void) showTimeSheetEmail
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isTimeSheetEmail) {
            [self.btnTimesheetEmail setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnTimesheetEmail setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}

- (void) showCourseBooking
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isCoureBooking) {
            [self.btnCourseBooking setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnCourseBooking setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}

- (void) showMarketUpdate
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isMarketingUpdates) {
            [self.btnMarketingupdate setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }
        else
            [self.btnMarketingupdate setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }];
}


- (void) showBlackViewsForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_SHOW object:nil];
    [self showBlackView];
}

- (void) showBlackView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.viewBlackOpaque.alpha = 0.7f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }];
}

- (void) hideBlackViewForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_HIDE object:nil];
    [self hideBlackView];
}

- (void) hideBlackView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.viewBlackOpaque.alpha = 0.0f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0f]];
    }];
}

#pragma mark - Actions

- (IBAction)onBtnEmergency:(id)sender {
    isEmergency = !isEmergency;
    [self showEmergency];
}

- (IBAction)onBtnEmergencyTM:(id)sender {
    isEmergencyMessage = !isEmergencyMessage;
    [self showEmergencyTM];
}

- (IBAction)onBtnEmergencyPhoneCall:(id)sender {
    isEmergencyPhoneCall = !isEmergencyPhoneCall;
    [self showEmergencyPhoneCall];
}

- (IBAction)onBtnEmergencyEmail:(id)sender {
    isEmergencyEmail = !isEmergencyEmail;
    [self showEmergencyEmail];
}
- (IBAction)onBtnAccount:(id)sender {
    isAccount = !isAccount;
    [self showAccount];
}

- (IBAction)onBtnAccountTM:(id)sender {
    isAccountMessage = !isAccountMessage;
    [self showAccountTM];
}

- (IBAction)onBtnAccountPhoneCall:(id)sender {
    isAccountPhoneCall = !isAccountPhoneCall;
    [self showAccountPhonecall];

}

- (IBAction)onBtnAccountEmail:(id)sender {
    isAccountEmail = !isAccountEmail;
    [self showAccountEmail];
}
- (IBAction)onBtnAbsenteeism:(id)sender {
    isAbsenteeism = !isAbsenteeism;
    [self showAbsenteeism];
}

- (IBAction)onBtnAbsenteeismTM:(id)sender {
    isAbsenteeismMessage = !isAbsenteeismMessage;
    [self showAbsenteeismTM];
}

- (IBAction)onBtnAbsenteeismPhonecall:(id)sender {
    isAbsenteeismPhoneCall = !isAbsenteeismPhoneCall;
    [self showAbsenteeismPhoneCall];
}

- (IBAction)onBtnAbsenteeismEmail:(id)sender {
    isAbsenteeismEmail = !isAbsenteeismEmail;
    [self showAbsenteeismEmail];
}

- (IBAction)onBtnReminder:(id)sender {
    isReminder = !isReminder;
    [self showReminder];
}

- (IBAction)onBtnReminderTM:(id)sender {
    isReminderMessage = !isReminderMessage;
    [self showReminderTM];
}


- (IBAction)onBtnReminderPhonecall:(id)sender {
    isReminderPhoneCall = !isReminderPhoneCall;
    [self showReminderPhoneCall];
}

- (IBAction)onBtnReminderEmail:(id)sender {
    isReminderEmail = !isReminderEmail;
    [self showReminderEmail];
}
- (IBAction)onBtnTimesheet:(id)sender {
    isTimesheet = !isTimesheet;
    [self showTimeSheet];
}

- (IBAction)onBtnTimesheetTM:(id)sender {
    isTimeSheetMessage = !isTimeSheetMessage;
    [self showTimeSheetTM];
}

- (IBAction)onBtnTimesheetPhonecall:(id)sender {
    isTimeSheetPhoneCall = !isTimeSheetPhoneCall;
    [self showTimesheetPhoneCall];
}



- (IBAction)onBtnTimesheetEmail:(id)sender {
    isTimeSheetEmail = !isTimeSheetEmail;
    [self showTimeSheetEmail];
}
- (IBAction)onBtnCourseBooking:(id)sender {
    isCoureBooking = !isCoureBooking;
    [self showCourseBooking];
}

- (IBAction)onBtnMarketUpdate:(id)sender {
    isMarketingUpdates = !isMarketingUpdates;
    [self showMarketUpdate];
}
- (IBAction)onBtnSave:(id)sender {
    
    // Save values here
    
    //
    
    [self.delegate goBackFromNotificationViewController];
}

- (IBAction)onBtnReset:(id)sender {
    [self resetValues];
}
- (IBAction)onBtnCancel:(id)sender {
    
    [self.delegate goBackFromNotificationViewController];
}


@end
