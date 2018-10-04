//
//  LeftMenuViewController.m
//  KES
//
//  Created by Monkey on 7/25/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "Functions.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _backView.alpha = 0;
    _profileView.alpha = 0;
    userInfo = [NSUserDefaults standardUserDefaults];
    
    _btnBookCourse.layer.cornerRadius = 3;
    _btnBookCourse.layer.borderWidth = 1;
    _btnBookCourse.layer.borderColor = [UIColor colorWithHex:COLOR_SECONDARY].CGColor;
    _topViewConstraint.constant = [Functions isiPhoneX] ? 20 : 0;
    
    UIImageView *avatarImgView = [self.view viewWithTag:50];
    [Functions makeRoundImageView:avatarImgView];
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    NSString *avatarUrl = [NSString stringWithFormat:@"%@media/photos/avatars/%@", strMainBaseUrl, [userInfo valueForKey:KEY_AVATAR]];
    [avatarImgView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"teacher"]];

    appDelegate.countryArray = [[NSMutableArray alloc] init];
    appDelegate.countyArray = [[NSMutableArray alloc] init];
    appDelegate.nationalityArray = [[NSMutableArray alloc] init];
    appDelegate.schoolArray = [[NSMutableArray alloc] init];
    appDelegate.yearArray = [[NSMutableArray alloc] init];
    appDelegate.academicYearArray = [[NSMutableArray alloc] init];
    appDelegate.preferenceTypeArray = [[NSMutableArray alloc] init];
    appDelegate.calendarEventArray = [[NSMutableArray alloc] init];
    appDelegate.UserArray = [[NSMutableArray alloc] init];
    appDelegate.UserEmailArray = [[NSMutableArray alloc] init];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    countryApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, CONTACT_COUNTRY];
    [objWebServices callApiWithParameters:nil apiName:countryApi type:GET_REQUEST loader:NO view:self];
    
    countyApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, CONTACT_COUNTY];
    [objWebServices callApiWithParameters:nil apiName:countyApi type:GET_REQUEST loader:NO view:self];
    
    nationalityApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, CONTACT_NATIONAL];
    [objWebServices callApiWithParameters:nil apiName:nationalityApi type:GET_REQUEST loader:NO view:self];
    
    schoolApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, CONTACT_SCHOOK];
    [objWebServices callApiWithParameters:nil apiName:schoolApi type:GET_REQUEST loader:NO view:self];
    
    yearApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, COURSE_YEAR];
    [objWebServices callApiWithParameters:nil apiName:yearApi type:GET_REQUEST loader:NO view:self];
    
    academicYearApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, COURSE_ACADEMIC];
    [objWebServices callApiWithParameters:nil apiName:academicYearApi type:GET_REQUEST loader:NO view:self];
    
    preferenceApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, PREFERENCE_TYPE];
    [objWebServices callApiWithParameters:nil apiName:preferenceApi type:GET_REQUEST loader:NO view:self];
    
    calendarEventApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, CALENDAR_EVENT];
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
    UILabel *nameLbl = [self.view viewWithTag:30];
    UILabel *memberLbl = [self.view viewWithTag:31];
    
    nameLbl.text = [NSString stringWithFormat:@"%@ %@", appDelegate.contactData.first_name, appDelegate.contactData.last_name];
    NSDate *sinceDate = [Functions convertStringToDate:appDelegate.contactData.date_created format:MAIN_DATE_FORMAT];
    memberLbl.text = [NSString stringWithFormat:@"Member since %@", [Functions convertDateToString:sinceDate format:@"LLL"]];
}

- (void)openURl:(NSString*)url {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
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
        if ([[obj valueForKey:@"group"] isEqualToString:@"notification"]) {
            PreferenceType *model = [[PreferenceType alloc] init];
            model.preference_id = [obj valueForKey:@"id"];
            model.label = [obj valueForKey:@"label"];
            model.required = [obj valueForKey:@"required"];
            model.summary = [Functions checkNullValue:[obj valueForKey:@"summary"]];
            [appDelegate.preferenceTypeArray addObject:model];
        }
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

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:countryApi])
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

#pragma mark - IBAction
- (IBAction)goProfile:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PROFILE object:self];
    _backView.alpha = 1;
    _profileView.alpha = 1;
    [UIView animateWithDuration:2 animations:^{
        [self.view layoutIfNeeded];
    }];
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:false];
}

- (IBAction)goBacktoProfile:(id)sender {
    _backView.alpha = 0;
    _profileView.alpha = 0;
    [UIView animateWithDuration:2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnTimetable:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_GO_TIMETABLE object:self];
}

- (IBAction)onBtnMessaging:(id)sender {
}

- (IBAction)onBtnNotification:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PREFERENCES object:self];
}

- (IBAction)onBtnSubject:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SUBJECTS object:self];
}

- (IBAction)onBtnSendFeedback:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_FEEDBACK object:self];
}

- (IBAction)onBtnShakeSendFeedback:(id)sender {
    
}

- (IBAction)onBtnRateus:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RATEUS object:self];
}

- (IBAction)onBtnHelp:(id)sender {
    NSDictionary* info = @{@"info": @"Help"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HELP object:self userInfo:info];
}

- (IBAction)onBtnContactUs:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CONTACTUS object:self];
}

- (IBAction)onBtnShareAppWithFriends:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SHAREWITHFRIENDS object:self];
}

- (IBAction)onBtnBeABetaTester:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BETATESTER object:self];
}

- (IBAction)onBtnAboutMyKes:(id)sender {
    NSDictionary* info = @{@"info": @"About"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HELP object:self userInfo:info];
}

- (IBAction)onBtnLogout:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT object:self];
}

- (IBAction)onBtnBookCourse:(id)sender {
    [self openURl:[NSString stringWithFormat:@"%@%@", strMainBaseUrl, CREATE_BOOK_URL]];
}
@end
