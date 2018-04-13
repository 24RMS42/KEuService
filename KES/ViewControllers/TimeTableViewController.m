//
//  TimeTableViewController.m
//  KES
//
//  Created by matata on 2/24/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "TimeTableViewController.h"

@interface TimeTableViewController ()

@property (strong, nonatomic) NSMutableArray *datesWithEvent;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSCalendar *gregorian;

@end

@implementation TimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.dateFormat = @"dd/MM/yyyy";
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _datesWithEvent = [[NSMutableArray alloc] init];
    
    _calendarView.backgroundColor = [UIColor whiteColor];
    _calendarView.appearance.headerMinimumDissolvedAlpha = 0;
    _calendarView.appearance.headerTitleColor = [UIColor colorWithHex:COLOR_FONT];
    _calendarView.appearance.headerTitleFont = [UIFont fontWithName:@"Roboto-Medium" size:25];
    _calendarView.appearance.headerDateFormat = @"LLL yyyy";
    _calendarView.appearance.selectionColor = [UIColor colorWithHex:0xB7BED0];
    _calendarView.appearance.todayColor = [UIColor colorWithHex:0xB8D12E];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(retrieveTimeTable:)
                                                 name:NOTI_RETRIEVE_TIMETABLE
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retrieveTimeTable:(NSNotification*) notification {
    bookApi = [NSString stringWithFormat:@"%@%@", BASE_URL, TIME_TABLE];
    [objWebServices callApiWithParameters:nil apiName:bookApi type:GET_REQUEST loader:YES view:self];
}

- (void)parseTimeTableArray:(id)responseObject
{
    totalTimeTableArray = [[NSMutableArray alloc] init];
    _datesWithEvent = [[NSMutableArray alloc] init];
    NSArray* array = [responseObject valueForKey:@"timetable"];
    for (NSDictionary *obj in array) {
        TimetableModel *timetableObj = [[TimetableModel alloc] init];
        timetableObj.title = [obj valueForKey:@"title"];
        timetableObj.booking_item_id = [obj valueForKey:@"booking_item_id"];
        timetableObj.mytime_id = [obj valueForKey:@"mytime_id"];
        timetableObj.first_name = [obj valueForKey:@"first_name"];
        timetableObj.location = [obj valueForKey:@"location"];
        timetableObj.attending = [obj valueForKey:@"attending"];
        timetableObj.schedule_id = [obj valueForKey:@"schedule_id"];
        timetableObj.trainer = [obj valueForKey:@"trainer"];
        timetableObj.room = [Functions checkNullValue:[obj valueForKey:@"room"]];
        
        NSDate *startDateTime = [Functions convertStringToDate:[obj valueForKey:@"start"] format:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *endDateTime = [Functions convertStringToDate:[obj valueForKey:@"end"] format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *startDateStr = [Functions convertDateToString:startDateTime format:@"LLL d, yyyy"];
        NSString *startTimeStr = [Functions convertDateToString:startDateTime format:@"h:mm a"];
        NSString *endTimeStr = [Functions convertDateToString:endDateTime format:@"h:mm a"];
        NSString *dayOfWeek = [Functions convertDateToString:startDateTime format:@"cccc"];
        
        timetableObj.start = startTimeStr;
        timetableObj.end = endTimeStr;
        timetableObj.format_date = startDateStr;
        timetableObj.date = [Functions convertDateToString:startDateTime format:self.dateFormatter1.dateFormat];//It is used for compare
        timetableObj.month = [Functions convertDateToString:startDateTime format:@"yyyy-MM"];
        timetableObj.dayOfWeek = dayOfWeek;
        
        [totalTimeTableArray addObject:timetableObj];
        [_datesWithEvent addObject:timetableObj.date];
    }
}

- (void)getMonthTTArray:(NSString *)targetMonthStr {
    monthTTArray = [[NSMutableArray alloc] init];
    for (TimetableModel *obj in totalTimeTableArray) {
        if ([obj.month isEqualToString:targetMonthStr]) {
            [monthTTArray addObject:obj];
        }
    }
}

- (void)getBookingFromTimetable:(NSString *)targetDateStr {
    _classDetailView.hidden = YES;
    _noMonthItemLbl.hidden = YES;
    for (TimetableModel *obj in totalTimeTableArray) {
        if ([obj.date isEqualToString:targetDateStr]) {
            _dateLbl.text = [NSString stringWithFormat:@"%@, %@", obj.dayOfWeek, obj.format_date];
            _startTimeLbl.text = obj.start;
            _endTimeLbl.text = obj.end;
            _bookTitleLbl.text = obj.title;
            _locationLbl.text = obj.location;
            _crossImgView.hidden = NO;
            _classDetailView.hidden = NO;
        }
    }
    
    if (_classDetailView.hidden) {
        _noMonthItemLbl.hidden = NO;
        NSDate *targetDate = [Functions convertStringToDate:targetDateStr format:self.dateFormatter1.dateFormat];
        NSString *newTargetDateStr = [Functions convertDateToString:targetDate format:@"cccc, LLL d, yyyy"];
        _noMonthItemLbl.text = [NSString stringWithFormat:@"%@ selected\nYou currently have no items", newTargetDateStr];
    }
}

- (void)getNextClass {
    NSString *todayStr = [Functions convertDateToString:[NSDate date] format:self.dateFormatter1.dateFormat];
    NSInteger i = [_datesWithEvent indexOfObject:todayStr];
    if (i == NSNotFound) {
        [_datesWithEvent addObject:todayStr];
        NSArray *sortedArray = [_datesWithEvent sortedArrayUsingSelector:@selector(compare:)];
        i = [sortedArray indexOfObject:todayStr];
        [_datesWithEvent removeObject:todayStr];
        i--;
    }
    
    if (i < _datesWithEvent.count - 1) {
        NSString *nextClassDateStr = [_datesWithEvent objectAtIndex:(i+1)];
        for (TimetableModel *obj in totalTimeTableArray) {
            if ([obj.date isEqualToString:nextClassDateStr]) {
                NSString *promptMsg = [NSString stringWithFormat:@"Your next class in %@ is %@ in %@ with %@", obj.location, obj.title, obj.room, obj.trainer];
                [Functions showSuccessAlert:@"" message:promptMsg image:@""];
            }
        }
    }
}

- (void)checkNoItemsOnList {
    if (!_tableView.hidden) {
        _noListItemLbl.hidden = monthTTArray.count > 0;
    }
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:bookApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseTimeTableArray:responseDict];
                [self getBookingFromTimetable:[Functions convertDateToString:[NSDate date] format:self.dateFormatter1.dateFormat]];
                [self getMonthTTArray:[Functions convertDateToString:[NSDate date] format:@"yyyy-MM"]];
                [self getNextClass];
                
                [self.tableView reloadData];
                [self.calendarView reloadData];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self checkNoItemsOnList];
    if ([monthTTArray count] == 0) {
        return 0;
    }
    else {
        return [monthTTArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TimeListCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *datelbl = (UILabel*)[cell viewWithTag:20];
    UILabel *dayOfWeeklbl = (UILabel*)[cell viewWithTag:25];
    UILabel *startTimelbl = (UILabel*)[cell viewWithTag:21];
    UILabel *endTimelbl = (UILabel*)[cell viewWithTag:22];
    UILabel *titlelbl = (UILabel*)[cell viewWithTag:23];
    UILabel *locationlbl = (UILabel*)[cell viewWithTag:24];
    
    if (monthTTArray.count > 0) {
        TimetableModel *obj = [monthTTArray objectAtIndex:indexPath.row];
        datelbl.text = obj.format_date;
        startTimelbl.text = obj.start;
        endTimelbl.text = obj.end;
        titlelbl.text = obj.title;
        locationlbl.text = obj.location;
        dayOfWeeklbl.text = obj.dayOfWeek;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return cell;
}

#pragma mark - FSCalendarDataSource
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    if ([self.datesWithEvent containsObject:[self.dateFormatter1 stringFromDate:date]]) {
        return 1;
    }
    return 0;
}

#pragma mark - FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter1 stringFromDate:date]);
    [self getBookingFromTimetable:[self.dateFormatter1 stringFromDate:date]];
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[self.dateFormatter1 stringFromDate:calendar.currentPage]);
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date
{
    if ([_datesWithEvent containsObject:[self.dateFormatter1 stringFromDate:date]]) {
        return CGPointMake(0, -2);
    }
    return CGPointZero;
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date
{
    if ([_datesWithEvent containsObject:[self.dateFormatter1 stringFromDate:date]]) {
        return CGPointMake(0, -10);
    }
    return CGPointZero;
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(nonnull NSDate *)date
{
    if ([_datesWithEvent containsObject:[self.dateFormatter1 stringFromDate:date]]) {
        return @[[UIColor whiteColor]];
    }
    return nil;
}

#pragma mark - IBAction
- (IBAction)OnMonthListChanged:(id)sender {
    if (_monthListSegment.selectedSegmentIndex == 0) {
        _tableView.hidden = YES;
        _noListItemLbl.hidden = YES;
    } else {
        _tableView.hidden = NO;
        [_tableView reloadData];
    }
}

- (IBAction)OnPrevClicked:(id)sender {
    NSDate *currentMonth = _calendarView.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendarView setCurrentPage:previousMonth animated:YES];
    
    [self getMonthTTArray:[Functions convertDateToString:previousMonth format:@"yyyy-MM"]];
    [self.tableView reloadData];
}

- (IBAction)OnNextClicked:(id)sender {
    NSDate *currentMonth = self.calendarView.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendarView setCurrentPage:nextMonth animated:YES];
    
    [self getMonthTTArray:[Functions convertDateToString:nextMonth format:@"yyyy-MM"]];
    [self.tableView reloadData];
}

- (IBAction)OnLogoClicked:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_TAP_LOGO object:self];
}
@end
