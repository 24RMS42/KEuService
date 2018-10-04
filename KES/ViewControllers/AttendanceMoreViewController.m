//
//  AttendanceMoreViewController.m
//  KES
//
//  Created by Monkey on 7/30/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "AttendanceMoreViewController.h"
#import "RadioButton.h"

@interface AttendanceMoreViewController () {
    int currentFeature;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calendarTrailing;
@property (strong, nonatomic) IBOutlet UIView *sessionClickView;
@property (strong, nonatomic) IBOutlet UILabel *currentSessionLabel;

@property (strong, nonatomic) IBOutlet UIButton *btnPerDay;
@property (strong, nonatomic) IBOutlet UIButton *btnPerSession;

@property (strong, nonatomic) IBOutlet UIView *switchView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *switchHeight;

@end

@implementation AttendanceMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    noPaymentLbl = [self.view viewWithTag:30];
    arrivedLateLbl = [self.view viewWithTag:31];
    leftEarlyLbl = [self.view viewWithTag:32];
    temporaryAbsenseLbl = [self.view viewWithTag:33];
    noPaymentText = [self.view viewWithTag:40];
    temporaryAbsenseText = [self.view viewWithTag:41];
    
    dpDialog = [[LSLDatePickerDialog alloc] init];
    planArrival = [self.view viewWithTag:20];
    planDeparture = [self.view viewWithTag:21];
    actualArrival = [self.view viewWithTag:22];
    actualLate = [self.view viewWithTag:23];//actualDeparture
    expectDeparture = [self.view viewWithTag:24];
    expectReturn = [self.view viewWithTag:25];
    planArrival.delegate = self;
    planDeparture.delegate = self;
    actualArrival.delegate = self;
    actualLate.delegate = self;
    expectDeparture.delegate = self;
    expectReturn.delegate = self;
    
    _oneFeatureTop.constant = 16;
    _oneDetailView.alpha = 0;
    _threeDetailView.alpha = 0;
    _oneDetailViewHeight.constant = 0;
    
    _noPaymentView.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1].CGColor;
    _noPaymentView.layer.borderWidth = 1;
    _arrivedLateView.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1].CGColor;
    _arrivedLateView.layer.borderWidth = 1;
    _leftEarlyView.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1].CGColor;
    _leftEarlyView.layer.borderWidth = 1;
    _temporaryAbsenceView.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1].CGColor;
    _temporaryAbsenceView.layer.borderWidth = 1;
    
    _btnSave.hidden = true;
    _btnCancel.hidden = true;
    
    [self.view layoutIfNeeded];
    
    currentFeature = 0;
    _currentDateIndex = 0;
    _currentSessionIndex = 0;
    
    [_btnPerDay setImage:[UIImage imageNamed:@"white_unchecked.png"] forState:UIControlStateNormal];
    [_btnPerDay setImage:[UIImage imageNamed:@"white_checked.png"] forState:UIControlStateSelected];
    [_btnPerSession setImage:[UIImage imageNamed:@"white_unchecked.png"] forState:UIControlStateNormal];
    [_btnPerSession setImage:[UIImage imageNamed:@"white_checked.png"] forState:UIControlStateSelected];
    _btnPerSession.selected = true;
    
    _sessionClickView.layer.shadowColor = [UIColor colorWithHex:0x808080].CGColor;
    _sessionClickView.layer.shadowOpacity = 0.7;
    _sessionClickView.layer.shadowRadius = 5;
    
    [Functions makeShadowView:_noPaymentView];
    [Functions makeShadowView:_arrivedLateView];
    [Functions makeShadowView:_leftEarlyView];
    [Functions makeShadowView:_temporaryAbsenceView];
    [Functions makeRoundImageView:_studentAvatarView];
    
    _calendarTrailing.constant = 70;
    [self.view layoutIfNeeded];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    NSString *avatarUrl = [NSString stringWithFormat:@"%@media/photos/avatars/%@", strMainBaseUrl, _objStudent.avatar];
    [_studentAvatarView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"teacher"]];
    _studentNameLbl.text = [NSString stringWithFormat:@"%@ %@", _objStudent.first_name, _objStudent.last_name];
    _titleLbl.text = _objBook.course;
    
    [self updateDateLabel];
    _currentSessionLabel.text = [NSString stringWithFormat:@"@%@", [_sessionList objectAtIndex:_currentSessionIndex]];
    
    [planArrival setEnabled:NO];
    [planDeparture setEnabled:NO];
    planArrival.text = [self getTimeValue:_objBook.start_date];
    planDeparture.text = [self getTimeValue:_objBook.end_date];
    
    NSString *timeNowStr = [Functions convertDateToString:[NSDate new] format:@"h:mm a"];
    actualArrival.text = actualLate.text = expectDeparture.text = expectReturn.text = timeNowStr;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionChanged:)
                                                 name:NOTI_SESSIONED_ATTENDANCE
                                               object:nil];
}

- (void)sessionChanged:(NSNotification*)notification {
    if ([[notification name] isEqualToString:NOTI_SESSIONED_ATTENDANCE]) {
        NSDictionary* info = notification.userInfo;
        _currentSessionIndex = [[info valueForKey:@"sessionId"] intValue];
        _currentSessionLabel.text = [NSString stringWithFormat:@"@%@", [_sessionList objectAtIndex:_currentSessionIndex]];
        
        id timeSlotObj = _sessionTimeSlotList[_currentSessionIndex];
        [self getStudents:[timeSlotObj valueForKey:@"id"] loader:YES];
    }
}

- (void)updateDateLabel {
    NSDate *dat = [Functions convertStringToDate:_dateList[_currentDateIndex] format:@"yyyy-MM-dd"];
    _bookDateLbl.text = [Functions convertDateToString:dat format:@"E d LLL yyyy"];
}

- (void)getSessionList:(NSString *)date loader:(BOOL)loader {
    rcTimeSlotsApi = [NSString stringWithFormat:@"%@%@?date=%@", strMainBaseUrl, RC_TIMESLOTS, date];
    [objWebServices callApiWithParameters:nil apiName:rcTimeSlotsApi type:GET_REQUEST loader:loader view:self];
}

- (void)getStudents:(NSString *)timeslotId loader:(BOOL)loader {
    rcStudentApi = [NSString stringWithFormat:@"%@%@?timeslot_id=%@", strMainBaseUrl, RC_STUDENTS, timeslotId];
    [objWebServices callApiWithParameters:nil apiName:rcStudentApi type:GET_REQUEST loader:loader view:self];
}

- (void)parseAttendanceStudent:(id)responseObject {
    _studentList = [[NSMutableArray alloc] init];
    NSArray* studentsObject = [responseObject valueForKey:@"students"];
    for (NSDictionary *obj in studentsObject) {
        @try {
            StudentModel *studentModel = [[StudentModel alloc] init];
            studentModel.booking_id = [obj valueForKey:@"booking_id"];
            studentModel.booking_item_id = [obj valueForKey:@"booking_item_id"];
            studentModel.timeslot_status = [Functions checkNullValue:[obj valueForKey:@"timeslot_status"]];
            studentModel.attending = [obj valueForKey:@"attending"];
            studentModel.contact_id = [obj valueForKey:@"contact_id"];
            studentModel.first_name = [obj valueForKey:@"first_name"];
            studentModel.last_name = [obj valueForKey:@"last_name"];
            studentModel.outstanding = [obj valueForKey:@"outstanding"];
            studentModel.guardian_first_name = [obj valueForKey:@"guardian_first_name"];
            studentModel.guardian_last_name = [obj valueForKey:@"guardian_last_name"];
            studentModel.guardian_mobile = [obj valueForKey:@"guardian_mobile"];
            studentModel.payment_type = [obj valueForKey:@"payment_type"];
            studentModel.fee_amount = [obj valueForKey:@"fee_amount"];
            studentModel.avatar = [Functions checkNullValue:[obj valueForKey:@"avatar"]];
            
            if ([studentModel.timeslot_status isEqualToString:@""]) {
                studentModel.timeslot_status = @"Pending";
            }
            
            [_studentList addObject:studentModel];
        }
        @catch (NSException *exception) {
            [Functions showAlert:@"HomeView:parseBooksArray" message:exception.reason];
        }
    }
}

- (void)parseSessionList:(id)responseObject {
    _currentSessionIndex = 0;
    _sessionList = [[NSMutableArray alloc] init];
    _sessionTimeSlotList = [NSArray new];
    _sessionTimeSlotList = [responseObject valueForKey:@"timeslots"];
    for (NSDictionary *obj in _sessionTimeSlotList) {
        NSString *startDateStr = [obj valueForKey:@"datetime_start"];
        NSString *endDateStr = [obj valueForKey:@"datetime_end"];
        NSDate *startDate = [Functions convertStringToDate:startDateStr format:MAIN_DATE_FORMAT];
        NSDate *endDate = [Functions convertStringToDate:endDateStr format:MAIN_DATE_FORMAT];
        NSString *startTime = [Functions convertDateToString:startDate format:@"HH:mm"];
        NSString *endTime = [Functions convertDateToString:endDate format:@"HH:mm"];
        [_sessionList addObject:[NSString stringWithFormat:@"%@ - %@", startTime, endTime]];
    }
    
    if (_sessionList.count > 0) {
        _currentSessionLabel.text = [NSString stringWithFormat:@"@%@", [_sessionList objectAtIndex:0]];
        id timeSlotObj = _sessionTimeSlotList[0];
        [self getStudents:[timeSlotObj valueForKey:@"id"] loader:YES];
    }
}

- (void)clearFields {
    actualArrival.text = actualLate.text = expectDeparture.text = expectReturn.text = @"";
    noPaymentText.text = temporaryAbsenseText.text = @"";
}

- (NSString *)getTimeValue:(NSString *)dateStr {
    NSDate *date = [Functions convertStringToDate:dateStr format:MAIN_DATE_FORMAT];
    return [Functions convertDateToString:date format:@"h:mm a"];
}

- (NSString *)convertTimeToTodayDate:(NSString *)time {
    NSString *strToday = [Functions convertDateToString:[NSDate new] format:@"yyyy-MM-dd"];
    NSDate *selectedTime = [Functions convertStringToDate:time format:@"h:mm a"];
    NSString *selectedTimeStr = [Functions convertDateToString:selectedTime format:@"HH:mm:ss"];
    return [NSString stringWithFormat:@"%@ %@", strToday, selectedTimeStr];
}

- (void)saveFeatures {
    NSDictionary *parameters = @{};
    NSString *note = @"";
    NSString *actualArrivalStr = [self convertTimeToTodayDate:actualArrival.text];
    NSString *actualLateStr = [self convertTimeToTodayDate:actualLate.text];
    NSString *expectDepartureStr = [self convertTimeToTodayDate:expectDeparture.text];
    NSString *expectReturnStr = [self convertTimeToTodayDate:expectReturn.text];
    switch (currentFeature) {
        case 1:
            note = noPaymentText.text;
            parameters = @{@"booking_id":_objStudent.booking_id,
                           @"booking_item_id":_objStudent.booking_item_id,
                           @"status":@"",
                           @"note":note
                           };
            break;
        case 2:
            note = noPaymentText.text;
            parameters = @{@"booking_id":_objStudent.booking_id,
                           @"booking_item_id":_objStudent.booking_item_id,
                           @"status":@"Late",
                           @"arrived":actualArrivalStr,
                           @"note":note
                           };
            break;
        case 3:
            note = noPaymentText.text;
            parameters = @{@"booking_id":_objStudent.booking_id,
                           @"booking_item_id":_objStudent.booking_item_id,
                           @"status":@"Early Departures",
                           @"left":actualLateStr,
                           @"note":note
                           };
            break;
        case 4:
            note = temporaryAbsenseText.text;
            parameters = @{@"booking_id":_objStudent.booking_id,
                           @"booking_item_id":_objStudent.booking_item_id,
                           @"status":@"Temporary Absence",
                           @"absence_left":expectDepartureStr,
                           @"absence_returned":expectReturnStr,
                           @"note":note
                           };
            break;
        default:
            break;
    }
    
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    rcStudentUpdateApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, RC_STUDENT_UPDATE];
    [objWebServices callApiWithParameters:parameters apiName:rcStudentUpdateApi type:POST_REQUEST loader:YES view:self];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self openDatePicker:textField];
    return NO;
}

- (void)openDatePicker:(UITextField *)textField {
    [dpDialog showWithTitle:@"" doneButtonTitle:@"Done" cancelButtonTitle:@"Cancel"
                defaultDate:[NSDate date] minimumDate:nil maximumDate:nil datePickerMode:UIDatePickerModeTime
                   callback:^(NSDate * _Nullable date){
                       if(date)
                       {
                           textField.text = [Functions convertDateToString:date format:@"h:m a"];
                           [textField resignFirstResponder];
                       }
                   }
     ];
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error {
    if ([apiName isEqualToString:rcStudentUpdateApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [TSMessage showNotificationInViewController:self
                                                      title:@""
                                                   subtitle:@"Successfully saved!"
                                                      image:[UIImage imageNamed:@""]
                                                       type:TSMessageNotificationTypeSuccess
                                                   duration:4.0
                                                   callback:nil
                                                buttonTitle:nil
                                             buttonCallback:nil
                                                 atPosition:TSMessageNotificationPositionTop
                                       canBeDismissedByUser:YES];
            }
        }
    } else if ([apiName isEqualToString:rcTimeSlotsApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseSessionList:responseDict];
            }
        }
    } else if ([apiName isEqualToString:rcStudentApi]) {
        if (responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseAttendanceStudent:responseDict];
                [self.tableView reloadData];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - IBAction
- (IBAction)sessionClicked:(id)sender {
    SessionListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sessionList"];
    controller.from = @"attendanceMore";
    controller.sessionDate = _bookDateLbl.text;
    controller.sessionArray = _sessionList;
    controller.sessionIndex = _currentSessionIndex;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)actionSwitch:(UIButton*)sender {
    switch (sender.tag) {
        case 1:
            _btnPerDay.selected = true;
            _btnPerSession.selected = false;
            _calendarTrailing.constant = 0;
            _bookDateLbl.textAlignment = NSTextAlignmentCenter;
            _sessionClickView.alpha = 0;
            break;
            
        case 2:
            _btnPerDay.selected = false;
            _btnPerSession.selected = true;
            _calendarTrailing.constant = 70;
            _bookDateLbl.textAlignment = NSTextAlignmentLeft;
            _sessionClickView.alpha = 1;
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnBackClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)noPaymentTapped:(id)sender {
    if (currentFeature == 0 || currentFeature == 4) {
        if (currentFeature == 0) {
            _preApprovedView.alpha = 0;
            _threeFeatureTop.constant = 0;
        } else {
            _oneDetailView.alpha = 0;
            _oneDetailViewHeight.constant = 0;
        }
        _oneFeatureTop.constant = 146;
        _threeDetailView.alpha = 1;
        _threeDetailTop.constant = -140;
    }
    if (currentFeature == 2 || currentFeature == 3) {
        _threeDetailTop.constant = -140;
        _oneFeatureTop.constant = 146;
    }
    if (currentFeature == 1) {
        _preApprovedView.alpha = 1;
        _threeDetailView.alpha = 0;
        _threeFeatureTop.constant = 144;
        _oneFeatureTop.constant = 16;
        currentFeature = 0;
    } else
        currentFeature = 1;
    [self setFeatureColors];
    [UIView animateWithDuration:1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)arrivedLateTapped:(id)sender {
    if (currentFeature == 0 || currentFeature == 4) {
        if (currentFeature == 0) {
            _preApprovedView.alpha = 0;
            _threeFeatureTop.constant = 0;
        } else {
            _oneDetailView.alpha = 0;
            _oneDetailViewHeight.constant = 0;
        }
        _oneFeatureTop.constant = 302;
        _threeDetailView.alpha = 1;
        _threeDetailTop.constant = 16;
        _actualLabel.text = @"Arrived late";
    }
    if (currentFeature == 1 || currentFeature == 3) {
        _threeDetailTop.constant = 16;
        _oneFeatureTop.constant = 302;
        _actualLabel.text = @"Arrived late";
    }
    if (currentFeature == 2) {
        _preApprovedView.alpha = 1;
        _threeDetailView.alpha = 0;
        _threeFeatureTop.constant = 144;
        _oneFeatureTop.constant = 16;
        currentFeature = 0;
    } else
        currentFeature = 2;
    [self setFeatureColors];
    [UIView animateWithDuration:1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)leftEarlyTapped:(id)sender {
    if (currentFeature == 0 || currentFeature == 4) {
        if (currentFeature == 0) {
            _preApprovedView.alpha = 0;
            _threeFeatureTop.constant = 0;
        } else {
            _oneDetailView.alpha = 0;
            _oneDetailViewHeight.constant = 0;
        }
        _oneFeatureTop.constant = 232;
        _threeDetailView.alpha = 1;
        _threeDetailTop.constant = -70;
        _actualLabel.text = @"Actual departue";
    }
    if (currentFeature == 1 || currentFeature == 2) {
        _threeDetailTop.constant = -70;
        _oneFeatureTop.constant = 232;
        _actualLabel.text = @"Actual departue";
    }
    if (currentFeature == 3) {
        _threeDetailTop.constant = -70;
        _preApprovedView.alpha = 1;
        _threeDetailView.alpha = 0;
        _threeFeatureTop.constant = 144;
        _oneFeatureTop.constant = 16;
        currentFeature = 0;
    } else
        currentFeature = 3;
    [self setFeatureColors];
    [UIView animateWithDuration:1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)temporaryAbsenceTapped:(id)sender {
    if (currentFeature != 4) {
        if (currentFeature == 0) {
            _preApprovedView.alpha = 0;
            _threeFeatureTop.constant = 0;
        } else {
            _threeDetailView.alpha = 0;
            _oneFeatureTop.constant = 16;
        }
        _oneDetailView.alpha = 1;
        _oneDetailViewHeight.constant = 240;
        currentFeature = 4;
    } else {
        _threeFeatureTop.constant = 144;
        _preApprovedView.alpha = 1;
        _oneDetailView.alpha = 0;
        _oneDetailViewHeight.constant = 0;
        currentFeature = 0;
    }
    [self setFeatureColors];
    [UIView animateWithDuration:1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)setFeatureColors {
    UIColor *activeBkgColor = [UIColor colorWithHex:0xF0F0F0];
    _noPaymentView.layer.borderColor = currentFeature != 1 ? [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1].CGColor : UIColor.cyanColor.CGColor;
    _noPaymentView.backgroundColor = currentFeature != 1 ? UIColor.whiteColor : activeBkgColor;
    _arrivedLateView.layer.borderColor = currentFeature != 2 ? [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1].CGColor : UIColor.cyanColor.CGColor;
    _arrivedLateView.backgroundColor = currentFeature != 2 ? UIColor.whiteColor : activeBkgColor;
    _leftEarlyView.layer.borderColor = currentFeature != 3 ? [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1].CGColor : UIColor.cyanColor.CGColor;
    _leftEarlyView.backgroundColor = currentFeature != 3 ? UIColor.whiteColor : activeBkgColor;
    _temporaryAbsenceView.layer.borderColor = currentFeature != 4 ? [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1].CGColor : UIColor.cyanColor.CGColor;
    _temporaryAbsenceView.backgroundColor = currentFeature != 4 ? UIColor.whiteColor : activeBkgColor;
    
    noPaymentLbl.textColor = currentFeature != 1 ? [UIColor colorWithHex:COLOR_FONT] : [UIColor colorWithHex:COLOR_PRIMARY];
    arrivedLateLbl.textColor = currentFeature != 2 ? [UIColor colorWithHex:COLOR_FONT] : [UIColor colorWithHex:COLOR_PRIMARY];
    leftEarlyLbl.textColor = currentFeature != 3 ? [UIColor colorWithHex:COLOR_FONT] : [UIColor colorWithHex:COLOR_PRIMARY];
    temporaryAbsenseLbl.textColor = currentFeature != 4 ? [UIColor colorWithHex:COLOR_FONT] : [UIColor colorWithHex:COLOR_PRIMARY];
    
    _btnBack.hidden = currentFeature != 0;
    _btnSave.hidden = currentFeature == 0;
    _btnCancel.hidden = currentFeature == 0;
    
    switch (currentFeature) {
        case 0:
            _subTitleLbl.text = @"Attendance more";
            break;
        case 1:
            _subTitleLbl.text = @"No payment";
            break;
        case 2:
            _subTitleLbl.text = @"Arrived late";
            break;
        case 3:
            _subTitleLbl.text = @"Left early";
            break;
        case 4:
            _subTitleLbl.text = @"Temporary absence";
            break;
        default:
            break;
    }
}

- (IBAction)OnTypeChanged:(id)sender {
    _tableView.hidden = _typeSegment.selectedSegmentIndex == 0;
}

- (IBAction)OnPrevClicked:(id)sender {
    if (_currentDateIndex > 0) {
        _currentDateIndex--;
        [self updateDateLabel];
        [self getSessionList:_dateList[_currentDateIndex] loader:YES];
    }
}

- (IBAction)OnNextClicked:(id)sender {
    if (_currentDateIndex < (_dateList.count - 1)) {
        _currentDateIndex++;
        [self updateDateLabel];
        [self getSessionList:_dateList[_currentDateIndex] loader:YES];
    }
}

- (IBAction)cancelTapped:(id)sender {
    _btnBack.hidden = false;
    _btnSave.hidden = true;
    _btnCancel.hidden = true;
    _threeFeatureTop.constant = 144;
    _oneFeatureTop.constant = 16;
    _oneDetailView.alpha = 0;
    _threeDetailView.alpha = 0;
    _oneDetailViewHeight.constant = 0;
    _preApprovedView.alpha = 1;
    currentFeature = 0;
    [self setFeatureColors];
    [self clearFields];
    [self.view layoutIfNeeded];
}

- (IBAction)saveTapped:(id)sender {
    [self saveFeatures];
    _btnBack.hidden = false;
    _btnSave.hidden = true;
    _btnCancel.hidden = true;
    _threeFeatureTop.constant = 144;
    _oneFeatureTop.constant = 16;
    _oneDetailView.alpha = 0;
    _threeDetailView.alpha = 0;
    _oneDetailViewHeight.constant = 0;
    _preApprovedView.alpha = 1;
    currentFeature = 0;
    [self setFeatureColors];
    [self clearFields];
    [self.view layoutIfNeeded];
}

#pragma mark -
#pragma mark TableView delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_studentList count] == 0) {
        return 0;
    } else {
        return [_studentList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttendMoreCell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AttendMoreCell"];
    
    UIImageView *avatarView = [cell viewWithTag:20];
    UILabel *lblName = [cell viewWithTag:21];
    UILabel *lblDetail = [cell viewWithTag:22];
    UILabel *lblTime = [cell viewWithTag:23];
    
    StudentModel *studentModel = [StudentModel new];
    studentModel = [_studentList objectAtIndex:indexPath.row];
    NSString *avatarUrl = [NSString stringWithFormat:@"%@media/photos/avatars/%@", strMainBaseUrl, studentModel.avatar];
    [avatarView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"teacher"]];
    lblName.text = [NSString stringWithFormat:@"%@ %@", studentModel.first_name, studentModel.last_name];
    lblDetail.text = @"";
    lblTime.text = [[NSString alloc]initWithFormat:@"%ld minutes ago", indexPath.row + 10 + indexPath.row];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)swipeDown:(id)sender {
    _switchHeight.constant = 50;
    _switchView.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)swipeUp:(id)sender {
    _switchHeight.constant = 0;
    _switchView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
