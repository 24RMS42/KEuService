//
//  SettingsViewController.h
//  KES
//
//  Created by matata on 3/1/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WebServices.h"
#import "NIDropDown.h"
#import "AppDelegate.h"

@interface SettingsViewController : UIViewController<WebServicesDelegate, NIDropDownDelegate>
{
    NSUserDefaults *userInfo;
    WebServices *objWebServices;
    NSString *loginAsApi, *loginBackApi, *userListApi, *countryApi, *nationalityApi, *schoolApi, *yearApi, *academicYearApi, *preferenceApi, *countyApi, *calendarEventApi;
}

@property (nonatomic, strong) NIDropDown *menuDrop;

@property (weak, nonatomic) IBOutlet UIView *UserMngView;
@property (weak, nonatomic) IBOutlet UIButton *UserMngButton;
@property (weak, nonatomic) IBOutlet UIButton *LogBackButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLbl;
@property (weak, nonatomic) IBOutlet UIButton *versionBtn;
@property (weak, nonatomic) IBOutlet UISwitch *shakeAppSwitch;

- (IBAction)OnUserMngClicked:(id)sender;
- (IBAction)OnLogBackClicked:(id)sender;
- (IBAction)OnLogoutClicked:(id)sender;
- (IBAction)OnProfileClicked:(id)sender;
- (IBAction)OnNotificationClicked:(id)sender;
- (IBAction)OnHelpClicked:(id)sender;
- (IBAction)OnAboutClicked:(id)sender;
- (IBAction)OnRateUsClicked:(id)sender;
- (IBAction)OnShareClicked:(id)sender;
- (IBAction)OnSubjectClicked:(id)sender;
- (IBAction)OnContactClicked:(id)sender;
- (IBAction)OnSendFeedbackClicked:(id)sender;
- (IBAction)OnShakeAppChanged:(id)sender;
- (IBAction)OnBetaTesterClicked:(id)sender;

@end
