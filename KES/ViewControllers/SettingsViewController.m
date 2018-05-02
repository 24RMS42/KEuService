//
//  SettingsViewController.m
//  KES
//
//  Created by matata on 3/1/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "SettingsViewController.h"

#define APP_STORE_ID 912632260

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    userInfo = [NSUserDefaults standardUserDefaults];
    if ([[userInfo objectForKey:KEY_SUPER_USER] isEqualToString:@"1"]) {
        [_UserMngView setHidden:NO];
    } else {
        [_UserMngView setHidden:YES];
    }
    
    [self toggleUserMngView];
    
    NSString *val = [userInfo valueForKey:KEY_SHAKE_APP];
    [self.shakeAppSwitch setOn:[val isEqualToString:@"1"]];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [_versionBtn setTitle:[NSString stringWithFormat:@"About My KES v%@", version] forState:UIControlStateNormal];
    
    countryApi = [NSString stringWithFormat:@"%@%@", BASE_URL, CONTACT_COUNTRY];
    [objWebServices callApiWithParameters:nil apiName:countryApi type:GET_REQUEST loader:NO view:self];
    
    countyApi = [NSString stringWithFormat:@"%@%@", BASE_URL, CONTACT_COUNTY];
    [objWebServices callApiWithParameters:nil apiName:countyApi type:GET_REQUEST loader:NO view:self];
    
    nationalityApi = [NSString stringWithFormat:@"%@%@", BASE_URL, CONTACT_NATIONAL];
    [objWebServices callApiWithParameters:nil apiName:nationalityApi type:GET_REQUEST loader:NO view:self];
    
    schoolApi = [NSString stringWithFormat:@"%@%@", BASE_URL, CONTACT_SCHOOK];
    [objWebServices callApiWithParameters:nil apiName:schoolApi type:GET_REQUEST loader:NO view:self];
    
    yearApi = [NSString stringWithFormat:@"%@%@", BASE_URL, COURSE_YEAR];
    [objWebServices callApiWithParameters:nil apiName:yearApi type:GET_REQUEST loader:NO view:self];
    
    academicYearApi = [NSString stringWithFormat:@"%@%@", BASE_URL, COURSE_ACADEMIC];
    [objWebServices callApiWithParameters:nil apiName:academicYearApi type:GET_REQUEST loader:NO view:self];
    
    preferenceApi = [NSString stringWithFormat:@"%@%@", BASE_URL, PREFERENCE_TYPE];
    [objWebServices callApiWithParameters:nil apiName:preferenceApi type:GET_REQUEST loader:NO view:self];
    
    calendarEventApi = [NSString stringWithFormat:@"%@%@", BASE_URL, CALENDAR_EVENT];
    [objWebServices callApiWithParameters:nil apiName:calendarEventApi type:GET_REQUEST loader:NO view:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayUserInfo:)
                                                 name:NOTI_SETTING_USERINFO
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayUserInfo:(NSNotification*)notification {
    _userNameLbl.text = [NSString stringWithFormat:@"%@ %@", appDelegate.contactData.first_name, appDelegate.contactData.last_name];
    NSDate *sinceDate = [Functions convertStringToDate:appDelegate.contactData.date_created format:MAIN_DATE_FORMAT];
    _memberSinceLbl.text = [NSString stringWithFormat:@"Member since %@", [Functions convertDateToString:sinceDate format:@"dd LLLL yyyy"]];
}

- (void)toggleUserMngView {
    if (appDelegate.isLogAs) {
        [_UserMngButton setTitle:appDelegate.logAsUser forState:UIControlStateNormal];
        [_UserMngButton setEnabled:NO];
        [_LogBackButton setHidden:NO];
        [_LogBackButton setTitle:[NSString stringWithFormat:@"Login back as %@", appDelegate.logOriginUser] forState:UIControlStateNormal];
    } else {
        [_LogBackButton setHidden:YES];
        [_UserMngButton setTitle:@"User Management" forState:UIControlStateNormal];
        [_UserMngButton setEnabled:YES];
    }
}

- (void)actionLoginAs:(NSString*)userId {
    NSDictionary *parameters=@{@"user_id":userId};
    loginAsApi = [NSString stringWithFormat:@"%@%@", BASE_URL, USER_LOGINAS];
    [objWebServices callApiWithParameters:parameters apiName:loginAsApi type:POST_REQUEST loader:YES view:self];
}

- (void)actionLoginBack {
    loginBackApi = [NSString stringWithFormat:@"%@%@", BASE_URL, USER_LOGINBACK];
    [objWebServices callApiWithParameters:nil apiName:loginBackApi type:GET_REQUEST loader:YES view:self];
}

- (void)getUserList {
    userListApi = [NSString stringWithFormat:@"%@%@", BASE_URL, USER_LIST];
    [objWebServices callApiWithParameters:nil apiName:userListApi type:GET_REQUEST loader:YES view:self];
}

- (void)parseUserArray:(id)responseObject {
    NSArray* userObject = [responseObject valueForKey:@"users"];
    for (NSDictionary *obj in userObject) {
        UserModel *userModel = [[UserModel alloc] init];
        userModel.user_id = [obj valueForKey:@"id"];
        userModel.email = [obj valueForKey:@"email"];
        userModel.can_login = [obj valueForKey:@"can_login"];
        userModel.role = [obj valueForKey:@"role"];
        
        [appDelegate.UserArray addObject:userModel];
        [appDelegate.UserEmailArray addObject:[NSString stringWithFormat:@"%@ - %@", userModel.email, userModel.role]];
    }
    
    [self showUserList];
}

- (void)parseCountryArray:(id)responseObject {
    NSMutableArray *countryAry = [[NSMutableArray alloc] init];
    NSDictionary *countries = [responseObject valueForKey:@"countries"];
    for (NSString *key in [countries allKeys]) {
        NSDictionary *countryObject = countries[key];
        CountryModel *countryModel = [[CountryModel alloc] init];
        countryModel.name = [countryObject valueForKey:@"name"];
        countryModel.dial_code = [countryObject valueForKey:@"dial_code"];
        countryModel.country_id = [countryObject valueForKey:@"id"];
        [countryAry addObject:countryModel];
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    NSArray *sortedArray = [countryAry sortedArrayUsingDescriptors:@[sortDescriptor]];
    appDelegate.countryArray = [NSMutableArray arrayWithArray:sortedArray];
    NSLog(@"country count:%lu", (unsigned long)appDelegate.countryArray.count);
}

- (void)parseNationality:(id)responseObject {
    NSDictionary *nationalities = [responseObject valueForKey:@"nationalities"];
    for (NSString *national in nationalities) {
        [appDelegate.nationalityArray addObject:national];
    }
    NSLog(@"national count:%lu", (unsigned long)appDelegate.nationalityArray.count);
}

- (void)parseSchoolArray:(id)responseObject {
    NSDictionary *schools = [responseObject valueForKey:@"schools"];
    for (NSDictionary *obj in schools) {
        SchoolModel *schoolModel = [[SchoolModel alloc] init];
        schoolModel.school_id = [obj valueForKey:@"id"];
        schoolModel.name = [obj valueForKey:@"name"];
        
        [appDelegate.schoolArray addObject:schoolModel];
    }
    NSLog(@"school count:%lu", (unsigned long)appDelegate.schoolArray.count);
}

- (void)parseYearArray:(id)responseObject {
    NSDictionary *years = [responseObject valueForKey:@"years"];
    for (NSDictionary *obj in years) {
        YearModel *schoolModel = [[YearModel alloc] init];
        schoolModel.year_id = [obj valueForKey:@"id"];
        schoolModel.year = [obj valueForKey:@"year"];
        
        [appDelegate.yearArray addObject:schoolModel];
    }
    NSLog(@"year count:%lu", (unsigned long)appDelegate.yearArray.count);
}

- (void)parseAcademicYearArray:(id)responseObject {
    NSDictionary *years = [responseObject valueForKey:@"academic_years"];
    for (NSDictionary *obj in years) {
        AcademicYearModel *schoolModel = [[AcademicYearModel alloc] init];
        schoolModel.academic_id = [obj valueForKey:@"id"];
        schoolModel.title = [obj valueForKey:@"title"];
        
        [appDelegate.academicYearArray addObject:schoolModel];
    }
    NSLog(@"academic year count:%lu", (unsigned long)appDelegate.academicYearArray.count);
}

- (void)parsePreferencesType:(id)responseObject {
    NSDictionary *preferences = [responseObject valueForKey:@"preference_types"];
    for (NSDictionary *obj in preferences) {
        PreferenceType *model = [[PreferenceType alloc] init];
        model.preference_id = [obj valueForKey:@"id"];
        model.label = [obj valueForKey:@"label"];
        model.required = [obj valueForKey:@"required"];
        
        [appDelegate.preferenceTypeArray addObject:model];
    }
    NSLog(@"preferences type count:%lu", (unsigned long)appDelegate.preferenceTypeArray.count);
}

- (void)parseCountyArray:(id)responseObject {
    NSDictionary *counties = [responseObject valueForKey:@"counties"];
    for (NSDictionary *obj in counties) {
        CountryModel *countryModel = [[CountryModel alloc] init];
        countryModel.name = [obj valueForKey:@"name"];
        countryModel.country_id = [obj valueForKey:@"id"];
        
        [appDelegate.countyArray addObject:countryModel];
    }
    NSLog(@"county count:%lu", (unsigned long)appDelegate.countyArray.count);
}

- (void)parseCalendarEvents:(id)responseObject {
    NSDictionary *events = [responseObject valueForKey:@"events"];
    for (NSDictionary *obj in events) {
        CalendarEvent *model = [[CalendarEvent alloc] init];
        NSDate *dateVal = [Functions convertStringToDate:[obj valueForKey:@"date"] format:MAIN_DATE_FORMAT];
        model.date = [Functions convertDateToString:dateVal format:@"dd/MM/yyyy"];
        model.title = [obj valueForKey:@"title"];
        model.color = [obj valueForKey:@"color"];
        
        [appDelegate.calendarEventArray addObject:model];
    }
    NSLog(@"calendarEventArray count:%lu", (unsigned long)appDelegate.calendarEventArray.count);
}

- (void)showUserList {
    if(_menuDrop == nil) {
        CGFloat f = 224;
        _menuDrop = [[NIDropDown alloc] showDropDown:_UserMngButton :&f :appDelegate.UserEmailArray :nil :@"up"];
        _menuDrop.delegate = self;
        _bottomView.hidden = YES;
    }
    else {
        [_menuDrop hideDropDown:_UserMngButton];
        _menuDrop = nil;
        _bottomView.hidden = NO;
    }
}

- (void)share
{
    NSArray* sharedObjects=[NSArray arrayWithObjects:@"Here is app link", nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                     //UIActivityTypeMessage,
                                                     //UIActivityTypeMail,
                                                     //UIActivityTypePrint,
                                                     //UIActivityTypeCopyToPasteboard,
                                                     //UIActivityTypeAssignToContact,
                                                     //UIActivityTypeSaveToCameraRoll,
                                                     //UIActivityTypeAddToReadingList,
                                                     //UIActivityTypePostToFlickr,
                                                     //UIActivityTypePostToVimeo,
                                                     //UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypeAirDrop,
                                                     //UIActivityTypePostToFacebook
                                                     ];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)rateUS {
    NSString *iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
    NSString *iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
    
    NSString *url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, APP_STORE_ID];
    [self openURl:url];
}

- (void)openURl:(NSString*)url {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:loginAsApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                appDelegate.isLogAs = YES;
                appDelegate.logAsUser = _UserMngButton.titleLabel.text;
                appDelegate.logOriginUser = [responseDict valueForKey:@"login_as_return_email"];
                
                [self toggleUserMngView];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RETRIEVE_FEED object:self];
                
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:loginBackApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                appDelegate.isLogAs = NO;
                
                [self toggleUserMngView];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RETRIEVE_FEED object:self];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:userListApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseUserArray:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:countryApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseCountryArray:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:nationalityApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseNationality:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:schoolApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseSchoolArray:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:yearApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseYearArray:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:academicYearApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseAcademicYearArray:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:preferenceApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parsePreferencesType:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:countyApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseCountyArray:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    } else if ([apiName isEqualToString:calendarEventApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseCalendarEvents:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - NIDropDelegates
- (void) niDropDownDelegateMethod: (NIDropDown *) sender selectedIndex:(NSInteger)selectedIndex{
    _bottomView.hidden = NO;
    _menuDrop = nil;
    UserModel *userObj = [appDelegate.UserArray objectAtIndex:selectedIndex];
    [self actionLoginAs:userObj.user_id];
}

- (IBAction)OnUserMngClicked:(id)sender {
    if (appDelegate.UserArray.count == 0) {
        [self getUserList];
    } else {
        [self showUserList];
    }
}

#pragma mark - IBAction
- (IBAction)OnLogBackClicked:(id)sender {
    [self actionLoginBack];
}

- (IBAction)OnLogoutClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT object:self];
}

- (IBAction)OnProfileClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PROFILE object:self];
}

- (IBAction)OnNotificationClicked:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PREFERENCES object:self];
}

- (IBAction)OnHelpClicked:(id)sender {
    NSDictionary* info = @{@"info": @"Help"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HELP object:self userInfo:info];
}

- (IBAction)OnAboutClicked:(id)sender {
    NSDictionary* info = @{@"info": @"About"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HELP object:self userInfo:info];
}

- (IBAction)OnRateUsClicked:(id)sender {
    [self rateUS];
}

- (IBAction)OnShareClicked:(id)sender {
    [self share];
}

- (IBAction)OnSubjectClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SUBJECTS object:self];
}

- (IBAction)OnContactClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CONTACTUS object:self];
}

- (IBAction)OnSendFeedbackClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_FEEDBACK object:self];
}

- (IBAction)OnShakeAppChanged:(id)sender {
    NSString *val = _shakeAppSwitch.isOn ? @"1" : @"0";
    [userInfo setValue:val forKey:KEY_SHAKE_APP];
}

- (IBAction)OnBetaTesterClicked:(id)sender {
    [self openURl:KES_BOARD];
}
@end
