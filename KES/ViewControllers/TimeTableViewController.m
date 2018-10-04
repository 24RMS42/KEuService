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
@property (strong, nonatomic) NSMutableDictionary *datesWithHoliday;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSCalendar *gregorian;

@end

@implementation TimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.dateFormat = @"dd/MM/yyyy";
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _datesWithEvent = [[NSMutableArray alloc] init];
    _datesWithHoliday = [[NSMutableDictionary alloc] init];
    
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
    bookApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, TIME_TABLE];
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
        NSString *startDateStr = [Functions convertDateToString:startDateTime format:@"ccc d LLL, yyyy"];
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

- (void)groupByDate {
    groupTTDic = [NSMutableDictionary new];
    groupTitleArray = [[NSMutableArray alloc] init];
    
    NSArray *groups = [monthTTArray valueForKeyPath:@"@distinctUnionOfObjects.date"];
    for (NSString *groupId in groups)
    {
        [groupTitleArray addObject:groupId];
        NSArray *groupNames = [monthTTArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"date = %@", groupId]];
        [groupTTDic setObject:groupNames forKey:groupId];
    }
    //NSLog(@"%@", groupTTDic);
}

- (void)getMonthTTArray:(NSString *)targetMonthStr {
    _classDetailView.hidden = YES;
    _noMonthItemLbl.hidden = YES;
    
    monthTTArray = [[NSMutableArray alloc] init];
    for (TimetableModel *obj in totalTimeTableArray) {
        if ([obj.month isEqualToString:targetMonthStr]) {
            [monthTTArray addObject:obj];
        }
    }
    [self groupByDate];
}

- (void)getBookingFromTimetable:(NSString *)targetDateStr {
    dayTTArray = [[NSMutableArray alloc] init];
    _classDetailView.hidden = YES;
    _noMonthItemLbl.hidden = YES;
    for (TimetableModel *obj in totalTimeTableArray) {
        if ([obj.date isEqualToString:targetDateStr]) {
            _dateLbl.text = [NSString stringWithFormat:@"%@", obj.format_date];
            [dayTTArray addObject:obj];
            _classDetailView.hidden = NO;
        }
    }
    
    [self.monthListTableView reloadData];
    
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

- (void)getHolidayDates {
    for (CalendarEvent *obj in appDelegate.calendarEventArray) {
        [_datesWithHoliday setValue:[UIColor grayColor] forKey:obj.date];
    }
}

- (void)checkNoItemsOnList {
    if (_monthListSegment.selectedSegmentIndex == 1) {
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
                [self getMonthTTArray:[Functions convertDateToString:[NSDate date] format:@"yyyy-MM"]];
                [self getBookingFromTimetable:[Functions convertDateToString:[NSDate date] format:self.dateFormatter1.dateFormat]];
                [self getNextClass];
                [self getHolidayDates];
                
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
    if (tableView == self.tableView) {
        [self checkNoItemsOnList];
        if ([monthTTArray count] == 0) {
            return 0;
        }
        else {
            NSString *sectionTitle = [groupTitleArray objectAtIndex:section];
            NSArray *sectionArrays = [groupTTDic objectForKey:sectionTitle];
            return [sectionArrays count];
        }
    } else if (tableView == self.monthListTableView) {
        if ([dayTTArray count] == 0) {
            return 0;
        }
        else {
            return [dayTTArray count];
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return [groupTitleArray count];
    } else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        TimetableModel *obj = [[groupTTDic objectForKey:[groupTitleArray objectAtIndex:section]] objectAtIndex:0];
        return obj.format_date;
    } else
        return @"";
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return groupTitleArray;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString *simpleTableIdentifier = @"TimeListCell";
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        UILabel *startTimelbl = (UILabel*)[cell viewWithTag:21];
        UILabel *endTimelbl = (UILabel*)[cell viewWithTag:22];
        UILabel *titlelbl = (UILabel*)[cell viewWithTag:23];
        UILabel *locationlbl = (UILabel*)[cell viewWithTag:24];
        
        if (monthTTArray.count > 0) {
            TimetableModel *obj = [[groupTTDic objectForKey:[groupTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            startTimelbl.text = obj.start;
            endTimelbl.text = obj.end;
            titlelbl.text = obj.title;
            locationlbl.text = obj.location;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        return cell;
    } else {
        NSString *simpleTableIdentifier = @"MonthListCell";
        
        UITableViewCell *cell = [self.monthListTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        UILabel *startTimelbl = (UILabel*)[cell viewWithTag:31];
        UILabel *endTimelbl = (UILabel*)[cell viewWithTag:32];
        UILabel *titlelbl = (UILabel*)[cell viewWithTag:33];
        UILabel *locationlbl = (UILabel*)[cell viewWithTag:34];
        
        if (dayTTArray.count > 0) {
            TimetableModel *obj = [dayTTArray objectAtIndex:indexPath.row];
            startTimelbl.text = obj.start;
            endTimelbl.text = obj.end;
            titlelbl.text = obj.title;
            locationlbl.text = obj.location;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.monthListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.monthListTableView.separatorColor = [UIColor clearColor];
        
        return cell;
    }
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
    [self getMonthTTArray:[Functions convertDateToString:calendar.currentPage format:@"yyyy-MM"]];
    [self.tableView reloadData];
    [self checkNoItemsOnList];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_datesWithHoliday.allKeys containsObject:key]) {
        return _datesWithHoliday[key];
    }
    return nil;
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
        [self checkNoItemsOnList];
    }
}

- (IBAction)OnPrevClicked:(id)sender {
    NSDate *currentMonth = _calendarView.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendarView setCurrentPage:previousMonth animated:YES];
    
    [self getMonthTTArray:[Functions convertDateToString:previousMonth format:@"yyyy-MM"]];
    [self.tableView reloadData];
    [self checkNoItemsOnList];
}

- (IBAction)OnNextClicked:(id)sender {
    NSDate *currentMonth = self.calendarView.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendarView setCurrentPage:nextMonth animated:YES];
    
    [self getMonthTTArray:[Functions convertDateToString:nextMonth format:@"yyyy-MM"]];
    [self.tableView reloadData];
    [self checkNoItemsOnList];
}

- (IBAction)OnLogoClicked:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_TAP_LOGO object:self];
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
