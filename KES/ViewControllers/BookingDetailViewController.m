//
//  BookingDetailViewController.m
//  KES
//
//  Created by Monkey on 7/27/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "BookingDetailViewController.h"
#import "AttendanceMoreViewController.h"
#import "CircleProgressBar.h"

@interface BookingDetailViewController ()

@property (strong, nonatomic) IBOutlet CircleProgressBar *totalCircleProgressBar;
@property (strong, nonatomic) IBOutlet CircleProgressBar *confirmedCircleProgressBar;
@property (strong, nonatomic) IBOutlet CircleProgressBar *paidCircleProgressBar;
@property (strong, nonatomic) IBOutlet CircleProgressBar *topicsCircleProgressBar;
@property (strong, nonatomic) IBOutlet UIView *totalBookingsView;
@property (strong, nonatomic) IBOutlet UIView *confirmedBookingsView;
@property (strong, nonatomic) IBOutlet UIView *paidBookingsView;
@property (strong, nonatomic) IBOutlet UIView *topicsBookingsView;

@property (strong, nonatomic) IBOutlet UILabel *totalBookingsLabel;
@property (strong, nonatomic) IBOutlet UILabel *confirmedBookingsLabel;
@property (strong, nonatomic) IBOutlet UILabel *paidBookingsLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicsBookingsLabel;
@property (strong, nonatomic) IBOutlet UIView *sessionClickView;
@property (strong, nonatomic) UILabel *classReceiptsLbl;
@property (strong, nonatomic) UILabel *rentalDueLbl;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calendarTrailing;
@property (strong, nonatomic) IBOutlet UILabel *currentSessionLabel;

@end

@implementation BookingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    _classReceiptsLbl = [self.view viewWithTag:36];
    _rentalDueLbl = [self.view viewWithTag:37];
    UIButton *leftArrowBtn = [self.view viewWithTag:50];
    UIButton *rightArrowBtn = [self.view viewWithTag:51];
    [leftArrowBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-15, -15, -15, -15)];
    [rightArrowBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-15, -15, -15, -15)];
    originArray = [[NSMutableArray alloc] init];
    currentDateIndex = 0;
    currentSessionIndex = 0;
    
    [_SearchField addTarget:self
                     action:@selector(textFieldDidChanged:)
           forControlEvents:UIControlEventEditingChanged];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    [self getDateList];
    
    _classReceiptsView.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
    _classReceiptsView.layer.borderWidth = 1;
    [Functions makeShadowView:_classReceiptsView];
    _rentalDueView.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
    _rentalDueView.layer.borderWidth = 1;
    [Functions makeShadowView:_rentalDueView];
    
    [_btnPerDay setImage:[UIImage imageNamed:@"white_unchecked.png"] forState:UIControlStateNormal];
    [_btnPerDay setImage:[UIImage imageNamed:@"white_checked.png"] forState:UIControlStateSelected];
    [_btnPerSession setImage:[UIImage imageNamed:@"white_unchecked.png"] forState:UIControlStateNormal];
    [_btnPerSession setImage:[UIImage imageNamed:@"white_checked.png"] forState:UIControlStateSelected];
    _btnPerSession.selected = true;
    
    [_totalCircleProgressBar setProgress:0.66 animated:true];
    [_totalCircleProgressBar setProgressBarWidth:5];
    [_totalCircleProgressBar setProgressBarTrackColor: UIColor.clearColor];
    [_totalCircleProgressBar setProgressBarProgressColor: [UIColor colorWithHex:0x00c6ee]];
    [_totalCircleProgressBar setStartAngle:-90];
    _totalCircleProgressBar.hintHidden = true;
    
    _totalBookingsView.layer.shadowColor = [UIColor colorWithHex:0x808080].CGColor;
    _totalBookingsView.layer.shadowOpacity = 0.7;
    _totalBookingsView.layer.shadowRadius = 10;
    _totalBookingsView.layer.cornerRadius = _totalBookingsView.frame.size.height / 2;
    _totalBookingsView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _totalBookingsView.layer.borderWidth = 2;
    
    
    [_confirmedCircleProgressBar setProgress:0.66 animated:true];
    [_confirmedCircleProgressBar setProgressBarWidth:3];
    [_confirmedCircleProgressBar setProgressBarTrackColor: UIColor.clearColor];
    [_confirmedCircleProgressBar setProgressBarProgressColor: [UIColor colorWithHex:0x00c6ee]];
    [_confirmedCircleProgressBar setStartAngle:-90];
    _confirmedCircleProgressBar.hintHidden = true;
    
    _confirmedBookingsView.layer.shadowColor = [UIColor colorWithHex:0x808080].CGColor;
    _confirmedBookingsView.layer.shadowOpacity = 0.3;
    _confirmedBookingsView.layer.shadowRadius = 2;
    _confirmedBookingsView.layer.cornerRadius = _confirmedBookingsView.frame.size.height / 2;
    _confirmedBookingsView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _confirmedBookingsView.layer.borderWidth = 1;
    
    
    [_paidCircleProgressBar setProgress:0.66 animated:true];
    [_paidCircleProgressBar setProgressBarWidth:3];
    [_paidCircleProgressBar setProgressBarTrackColor: UIColor.clearColor];
    [_paidCircleProgressBar setProgressBarProgressColor: [UIColor colorWithHex:0x00c6ee]];
    [_paidCircleProgressBar setStartAngle:-90];
    _paidCircleProgressBar.hintHidden = true;
    
    _paidBookingsView.layer.shadowColor = [UIColor colorWithHex:0x808080].CGColor;
    _paidBookingsView.layer.shadowOpacity = 0.7;
    _paidBookingsView.layer.shadowRadius = 3;
    _paidBookingsView.layer.cornerRadius = _paidBookingsView.frame.size.height / 2;
    _paidBookingsView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _paidBookingsView.layer.borderWidth = 1;
    
    
    [_topicsCircleProgressBar setProgress:0.66 animated:true];
    [_topicsCircleProgressBar setProgressBarWidth:3];
    [_topicsCircleProgressBar setProgressBarTrackColor: UIColor.clearColor];
    [_topicsCircleProgressBar setProgressBarProgressColor: [UIColor colorWithHex:0x00c6ee]];
    [_topicsCircleProgressBar setStartAngle:-90];
    _topicsCircleProgressBar.hintHidden = true;
    
    _topicsBookingsView.layer.shadowColor = [UIColor colorWithHex:0x808080].CGColor;
    _topicsBookingsView.layer.shadowOpacity = 0.7;
    _topicsBookingsView.layer.shadowRadius = 3;
    _topicsBookingsView.layer.cornerRadius = _topicsBookingsView.frame.size.height / 2;
    _topicsBookingsView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _topicsBookingsView.layer.borderWidth = 1;
    
    _sessionClickView.layer.shadowColor = [UIColor colorWithHex:0x808080].CGColor;
    _sessionClickView.layer.shadowOpacity = 0.7;
    _sessionClickView.layer.shadowRadius = 5;
    
    [self.view layoutIfNeeded];
    
    UIFont *font = [UIFont systemFontOfSize:18];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [_typeSegment setTitleTextAttributes:attributes forState:UIControlStateSelected];
    [_typeSegment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:COLOR_GRAY],
                                           NSFontAttributeName:font}
                                forState:UIControlStateNormal];
    
    _titleLbl.text = _objBook.course;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionChanged:)
                                                 name:NOTI_SESSIONED_BOOK
                                               object:nil];
}

- (void)makeAttributedStrings {
    NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc]initWithString:_totalBookingsLabel.text];
    [totalString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(0, [_totalBookingsLabel.text rangeOfString:@" "].location)];
    _totalBookingsLabel.attributedText = totalString;
    
    NSMutableAttributedString *confirmedString = [[NSMutableAttributedString alloc]initWithString:_confirmedBookingsLabel.text];
    [confirmedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, [_confirmedBookingsLabel.text rangeOfString:@" "].location)];
    _confirmedBookingsLabel.attributedText = confirmedString;
    
    NSMutableAttributedString *paidString = [[NSMutableAttributedString alloc]initWithString:_paidBookingsLabel.text];
    [paidString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, [_paidBookingsLabel.text rangeOfString:@" "].location)];
    _paidBookingsLabel.attributedText = paidString;
    
    NSMutableAttributedString *topicsString = [[NSMutableAttributedString alloc]initWithString:_topicsBookingsLabel.text];
    [topicsString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, [_topicsBookingsLabel.text rangeOfString:@" "].location)];
    _topicsBookingsLabel.attributedText = topicsString;
}

- (void)searchStudentsByKeyword:(NSString*)keyword{
    rcStudentFilterApi = [NSString stringWithFormat:@"%@%@?timeslot_id=%@&keyword=%@", strMainBaseUrl, RC_STUDENTS, _objBook.timeslot_id, keyword];
    rcStudentFilterApi = [rcStudentFilterApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [objWebServices callApiWithParameters:nil apiName:rcStudentFilterApi type:GET_REQUEST loader:NO view:self];
}

- (IBAction)sessionClicked:(id)sender {
    SessionListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sessionList"];
    controller.from = @"bookDetail";
    controller.sessionDate = _bookDateLbl.text;
    controller.sessionArray = sessionList;
    controller.sessionIndex = currentSessionIndex;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)actionSwitch:(UIButton *)sender {
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

- (void)sessionChanged:(NSNotification*)notification {
    if ([[notification name] isEqualToString:NOTI_SESSIONED_BOOK]) {
        NSDictionary* info = notification.userInfo;
        currentSessionIndex = [[info valueForKey:@"sessionId"] intValue];
        _currentSessionLabel.text = [NSString stringWithFormat:@"@%@", [sessionList objectAtIndex:currentSessionIndex]];
        
        id timeSlotObj = sessionTimeSlotList[currentSessionIndex];
        [self getStudents:[timeSlotObj valueForKey:@"id"] loader:YES];
        [self getAnalyticsData:[timeSlotObj valueForKey:@"id"]];
    }
}

- (void)displayContentController:(UIViewController*)content {
    [self addChildViewController:content];
    
    CGRect newFrame = content.view.frame;
    newFrame.size.height = self.detailContentView.frame.size.height;
    [content.view setFrame:newFrame];
    
    [self.detailContentView addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void)getAnalyticsData:(NSString *) timeslotId{
    analyticsApi = [NSString stringWithFormat:@"%@%@?timeslot_id=%@",
                    strMainBaseUrl,
                    TRAINER_ANALYTICS,
                    timeslotId];
    analyticsApi = [analyticsApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [objWebServices callApiWithParameters:nil apiName:analyticsApi type:GET_REQUEST loader:NO view:self];
}

- (void)getSessionList:(NSString *)date loader:(BOOL)loader {
    rcTimeSlotsApi = [NSString stringWithFormat:@"%@%@?date=%@", strMainBaseUrl, RC_TIMESLOTS, date];
    [objWebServices callApiWithParameters:nil apiName:rcTimeSlotsApi type:GET_REQUEST loader:loader view:self];
}

- (void)getDateList {
    NSString *currentDateStr = [Functions convertDateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    rcDatesApi = [NSString stringWithFormat:@"%@%@?%@=%@&schedule_id=%@&booked=1", strMainBaseUrl, RC_DATES, _from, currentDateStr, _objBook.schedule_id];
    rcDatesApi = [rcDatesApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [objWebServices callApiWithParameters:nil apiName:rcDatesApi type:GET_REQUEST loader:YES view:self];
}

- (void)getStudents:(NSString *)timeslotId loader:(BOOL)loader {
    rcStudentApi = [NSString stringWithFormat:@"%@%@?timeslot_id=%@", strMainBaseUrl, RC_STUDENTS, timeslotId];
    [objWebServices callApiWithParameters:nil apiName:rcStudentApi type:GET_REQUEST loader:loader view:self];
}

- (void)parseAttendanceStudent:(id)responseObject {
    studentArray = [[NSMutableArray alloc] init];
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
            
            [studentArray addObject:studentModel];
        }
        @catch (NSException *exception) {
            [Functions showAlert:@"HomeView:parseBooksArray" message:exception.reason];
        }
    }
}

- (void)parseSessionList:(id)responseObject {
    currentSessionIndex = 0;
    sessionList = [[NSMutableArray alloc] init];
    sessionTimeSlotList = [NSArray new];
    sessionTimeSlotList = [responseObject valueForKey:@"timeslots"];
    for (NSDictionary *obj in sessionTimeSlotList) {
        NSString *startDateStr = [obj valueForKey:@"datetime_start"];
        NSString *endDateStr = [obj valueForKey:@"datetime_end"];
        NSDate *startDate = [Functions convertStringToDate:startDateStr format:MAIN_DATE_FORMAT];
        NSDate *endDate = [Functions convertStringToDate:endDateStr format:MAIN_DATE_FORMAT];
        NSString *startTime = [Functions convertDateToString:startDate format:@"HH:mm"];
        NSString *endTime = [Functions convertDateToString:endDate format:@"HH:mm"];
        [sessionList addObject:[NSString stringWithFormat:@"%@ - %@", startTime, endTime]];
    }
    
    if (sessionList.count > 0) {
        _currentSessionLabel.text = [NSString stringWithFormat:@"@%@", [sessionList objectAtIndex:0]];
        id timeSlotObj = sessionTimeSlotList[0];
        [self getStudents:[timeSlotObj valueForKey:@"id"] loader:YES];
        [self getAnalyticsData:[timeSlotObj valueForKey:@"id"]];
    }
}

- (void)parseDateList:(id)responseObject {
    dateList = [NSArray new];
    dateList = [responseObject valueForKey:@"dates"];
    [self getSessionList:dateList[0] loader:YES];
    [self updateDateLabel];
}

- (void)updateDateLabel {
    NSDate *dat = [Functions convertStringToDate:dateList[currentDateIndex] format:@"yyyy-MM-dd"];
    _bookDateLbl.text = [Functions convertDateToString:dat format:@"E d LLL yyyy"];
}

- (void)groupByStatus {
    groupTTDic = [NSMutableDictionary new];
    groupTitleArray = [[NSMutableArray alloc] init];
    
    NSArray *groups = [studentArray valueForKeyPath:@"@distinctUnionOfObjects.timeslot_status"];
    for (NSString *groupId in groups)
    {
        [groupTitleArray addObject:groupId];
        NSArray *groupNames = [studentArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"timeslot_status = %@", groupId]];
        [groupTTDic setObject:groupNames forKey:groupId];
    }
    NSLog(@"-=-=-=%@", groupTTDic);
}

- (void)updateStudent:(NSString *)status studentModel:(StudentModel *)studentObj {
    updatedStudentStatus = status;
    updatedStudentName = [NSString stringWithFormat:@"%@ %@", studentObj.first_name, studentObj.last_name];
    NSDictionary *parameters = @{@"booking_id":studentObj.booking_id,
                                 @"booking_item_id":studentObj.booking_item_id,
                                 @"status":status};
    rcStudentUpdateApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, RC_STUDENT_UPDATE];
    [objWebServices callApiWithParameters:parameters apiName:rcStudentUpdateApi type:POST_REQUEST loader:YES view:self];
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:analyticsApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                id statsObject = [responseDict valueForKey:@"stats"];
                id bookingObj = [statsObject valueForKey:@"bookings"];
                
                _totalBookingsLabel.text = [NSString stringWithFormat:@"%@ bookings", [bookingObj valueForKey:@"bookings"]];
                _confirmedBookingsLabel.text = [NSString stringWithFormat:@"%@ confirmed", [bookingObj valueForKey:@"confirmed"]];
                _paidBookingsLabel.text = [NSString stringWithFormat:@"%@ paid", [bookingObj valueForKey:@"paid"]];
                _topicsBookingsLabel.text = [NSString stringWithFormat:@"%@ topics", [bookingObj valueForKey:@"topics"]];
                _classReceiptsLbl.text = [NSString stringWithFormat:@"€%@", [bookingObj valueForKey:@"receipts"]];
                _rentalDueLbl.text = [NSString stringWithFormat:@"€%@", [bookingObj valueForKey:@"rental_due"]];
                
                [self makeAttributedStrings];
            } else {
                [Functions checkError:responseDict];
            }
        }
    } else if ([apiName isEqualToString:rcStudentApi]) {
        if (responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseAttendanceStudent:responseDict];
                originArray = [[NSMutableArray alloc] init];
                [originArray addObjectsFromArray:studentArray];
                studentArray = [[NSMutableArray alloc] init];
                [studentArray addObjectsFromArray:originArray];
                [self groupByStatus];
                [self.attendTableView reloadData];
            } else {
                [Functions checkError:responseDict];
            }
        }
    } else if ([apiName isEqualToString:rcStudentFilterApi]) {
        if(responseDict != nil) {
            studentArray = [[NSMutableArray alloc] init];
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                if (_whileSearch == NO) {
                    return;
                }
                
                [self parseAttendanceStudent:responseDict];
                [self groupByStatus];
                [self.attendTableView reloadData];
            }
        }
    } else if ([apiName isEqualToString:rcStudentUpdateApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                originArray = [[NSMutableArray alloc] init];
                id timeSlotObj = sessionTimeSlotList[currentSessionIndex];
                [self getStudents:[timeSlotObj valueForKey:@"id"] loader:YES];
                [TSMessage showNotificationInViewController:self
                                                      title:@"Success"
                                                   subtitle:[NSString stringWithFormat:@"%@ marked as %@", updatedStudentName, updatedStudentStatus]
                                                      image:[UIImage imageNamed:@""]
                                                       type:TSMessageNotificationTypeSuccess
                                                   duration:5.0
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
    } else if ([apiName isEqualToString:rcDatesApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseDateList:responseDict];
            }
        }
    }
}

#pragma mark - IBAction
- (IBAction)OnTypeChanged:(id)sender {
    if (_typeSegment.selectedSegmentIndex == 0) {
        _AttendanceView.hidden = true;
        _detailsBackView.hidden = true;
        _DetailsView.hidden = true;
    } else if (_typeSegment.selectedSegmentIndex == 1){
        _AttendanceView.hidden = false;
        _detailsBackView.hidden = true;
        _DetailsView.hidden = true;
    } else {
        _detailsBackView.hidden = false;
        _DetailsView.hidden = false;
        ClassDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"class_detail"];
        controller.objBook = _objBook;
        controller.isContained = true;
        [self displayContentController:controller];
        [_DetailsView setContentOffset:CGPointMake(0, 64) animated:NO];
    }
}

- (IBAction)OnPrevClicked:(id)sender {
    if (currentDateIndex > 0) {
        currentDateIndex--;
        [self updateDateLabel];
        [self getSessionList:dateList[currentDateIndex] loader:YES];
    }
}

- (IBAction)OnNextClicked:(id)sender {
    if (currentDateIndex < (dateList.count - 1)) {
        currentDateIndex++;
        [self updateDateLabel];
        [self getSessionList:dateList[currentDateIndex] loader:YES];
    }
}

- (IBAction)OnBackClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)OnSearchClicked:(id)sender {
}

- (IBAction)OnCancelClicked:(id)sender {
    _SearchField.text = @"";
    [self textFieldDidChanged:_SearchField];
}

- (void)textFieldDidChanged: (UITextField*)textField
{
    studentArray = [[NSMutableArray alloc]init];
    
    if (_SearchField.text.length == 0) {
        _whileSearch = NO;
        [studentArray addObjectsFromArray:originArray]; //take origal values
        [self groupByStatus];
        [_SearchButton setHidden:NO];
        [_CancelButton setHidden:YES];
    }
    else
    {
        _whileSearch = YES;
        [self searchStudentsByKeyword:_SearchField.text];
        [_SearchButton setHidden:YES];
        [_CancelButton setHidden:NO];
    }
    
    [self.attendTableView reloadData];
}

#pragma mark -
#pragma mark TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([studentArray count] == 0) {
        return 0;
    } else {
        NSString *sectionTitle = [groupTitleArray objectAtIndex:section];
        NSArray *sectionArrays = [groupTTDic objectForKey:sectionTitle];
        return [sectionArrays count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [groupTitleArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    StudentModel *obj = [[groupTTDic objectForKey:[groupTitleArray objectAtIndex:section]] objectAtIndex:0];
    return obj.timeslot_status;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.textLabel.textColor = [UIColor colorWithHex:COLOR_THIRD];
        view.tintColor = [UIColor whiteColor];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGSwipeTableCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"AttendCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MGSwipeTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AttendCell"];
    }
    
    UIImageView *avatarView = [cell viewWithTag:20];
    UILabel *lblName = [cell viewWithTag:21];
    UILabel *lblDetail = [cell viewWithTag:22];
    UILabel *lblPrice = [cell viewWithTag:23];
    
    StudentModel *studentModel = [StudentModel new];
    if (studentArray.count > 0) {
        studentModel = [[groupTTDic objectForKey:[groupTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        NSString *avatarUrl = [NSString stringWithFormat:@"%@media/photos/avatars/%@", strMainBaseUrl, studentModel.avatar];
        [avatarView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"teacher"]];
        lblName.text = [NSString stringWithFormat:@"%@ %@", studentModel.first_name, studentModel.last_name];
        lblDetail.text = [NSString stringWithFormat:@"%@ %@ / %@", studentModel.guardian_first_name, studentModel.guardian_last_name, studentModel.guardian_mobile];
        
        NSString *priceVal = @"0.00";
        if ([studentModel.payment_type isEqualToString:@"payg"] && studentModel.fee_amount.floatValue > 0) {
            priceVal = studentModel.fee_amount;
        } else if ([studentModel.payment_type isEqualToString:@"prepay"] && studentModel.outstanding.floatValue > 0) {
            priceVal = studentModel.outstanding;
        }
        lblPrice.text = [NSString stringWithFormat:@"%d", priceVal.intValue];
    }
    
    [Functions makeRoundImageView:avatarView];
    
    MGSwipeButton *absentBtn = [MGSwipeButton buttonWithTitle:@"Absent" backgroundColor:[UIColor colorWithHex:COLOR_PRIMARY] callback:^BOOL(MGSwipeTableCell * sender){
        [self updateStudent:@"Absent" studentModel:studentModel];
        return YES;
    }];
    cell.leftButtons = @[absentBtn];
    cell.leftExpansion.buttonIndex = 0;
    cell.leftSwipeSettings.transition = MGSwipeTransitionBorder;
    
    MGSwipeButton *moreBtn = [MGSwipeButton buttonWithTitle:@"More..." backgroundColor:[UIColor colorWithHex:COLOR_SECONDARY] callback:^BOOL(MGSwipeTableCell * sender){
        AttendanceMoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"attend_more"];
        controller.objBook = _objBook;
        controller.objStudent = studentModel;
        controller.studentList = originArray;
        controller.sessionList = sessionList;
        controller.dateList = dateList;
        controller.sessionTimeSlotList = sessionTimeSlotList;
        [self presentViewController:controller animated:true completion:nil];
        return YES;
    }];
    MGSwipeButton *presentBtn = [MGSwipeButton buttonWithTitle:@"Present and paid" backgroundColor:[UIColor colorWithHex:COLOR_PRIMARY] callback:^BOOL(MGSwipeTableCell * sender){
        [self updateStudent:@"Present,Paid" studentModel:studentModel];
        return YES;
    }];
    cell.rightButtons = @[moreBtn, presentBtn];
    cell.rightExpansion.buttonIndex = 0;
    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.attendTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    return YES;
}

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

- (IBAction)tabAction:(UIButton*)sender {
    [self dismissViewControllerAnimated:true completion:^{
        //[appDelegate.mainTabView.vc.tabBar selectedTabItem:sender.tag - 1 animated:true];//need to revert after add more tabs
        switch (sender.tag) {
            case 1:
                [appDelegate.mainTabView.vc.tabBar selectedTabItem:0 animated:true];
                break;
            case 3:
                [appDelegate.mainTabView.vc.tabBar selectedTabItem:1 animated:true];
                break;
            default:
                break;
        }
    }];
}

@end
