//
//  AnalyticsViewController.m
//  KES
//
//  Created by matata on 2/14/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "AnalyticsViewController.h"

#define LAST_MONTH  @"last_month"
#define THIS_MONTH  @"this_month"
#define TOTAL_DAY   @"total_day"

@interface AnalyticsViewController() {
    NSArray* categories;
    int currentIndex;
}

@end

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    stat = @"Category";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(retrieveAnalytics:)
                                                 name:NOTI_RETRIEVE_ANALYTICS
                                               object:nil];
    userInfo = [NSUserDefaults standardUserDefaults];
    NSString *userRole = [userInfo valueForKey:@"user_role"];
    if ([userRole isEqualToString:@"Student"] || [userRole isEqualToString:@"Parent"]) {
        categories = @[@"My bookings"];
    } else if ([userRole isEqualToString:@"Teacher"]) {
        categories = @[@"My bookings", @"My income"];
    } else if ([userRole isEqualToString:@"Staff"]) {
        categories = @[@"All bookings"];
    } else if ([userRole isEqualToString:@"Manager"]) {
        categories = @[@"All bookings", @"Total income"];
    } else {
        categories = @[@"All bookings"];
    }
    _titleTotalLbl.text = categories[0];
    [_dropDownMenu setDisclosureIndicatorImage:[UIImage imageNamed:@"white_down_arrow.png"]];
    if (categories.count == 1) {
        [_dropDownMenu setHidden:YES];
    }
    
    UIFont *font = [UIFont systemFontOfSize:18];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [_statSegment setTitleTextAttributes:attributes forState:UIControlStateSelected];
    [_statSegment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:COLOR_GRAY],
                                           NSFontAttributeName:font}
                                forState:UIControlStateNormal];
    currentIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"=====view will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"=====view did apear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCarousel
{
    NSMutableArray *yourItemArray = [[NSMutableArray alloc] init];
    if (currentIndex == 0) {
        yourItemArray = [[NSMutableArray alloc] initWithObjects:
                         [NSString stringWithFormat:@"%@", _lastMonthHRLbl.text],
                         [NSString stringWithFormat:@"%@", _thisMonthHRLbl.text],
                         [NSString stringWithFormat:@"%@", _AllHRLbl.text], nil];
    } else {
        yourItemArray = [[NSMutableArray alloc] initWithObjects:
                         [NSString stringWithFormat:@"%d", lastTotalIncome],
                         [NSString stringWithFormat:@"%d", thisTotalIncome],
                         [NSString stringWithFormat:@"%d", allTotalIncome], nil];
    }
    
    _selectItemColor = [UIColor clearColor];
    _normalItemColor = [UIColor clearColor];
    _selectedTextColor = [UIColor colorWithHex:COLOR_FONT];
    _normalTextColor = [UIColor colorWithHex:0xa0a0a0];
    
    NSDate *startDateOfLastMonth = [Functions startDateOfLastMonth];
    _lastMonthName = [Functions convertDateToString:startDateOfLastMonth format:@"LLLL"];
    
    _width = (self.view.frame.size.width-6)/3;
    _height = self.carousel.frame.size.height;
    aryPrice = [NSMutableArray new];
    aryPrice = [yourItemArray mutableCopy];
    _carousel.pagingEnabled = FALSE;
    _carousel.delegate = self;
    _carousel.dataSource =self;
    _carousel.type = iCarouselTypeLinear;
    
    _selectedIndex = 1;
    [_carousel scrollToItemAtIndex:_selectedIndex animated:NO];
    
    [_carousel reloadData];
}

- (void)retrieveAnalytics:(NSNotification*)notification {
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    categoryArray = [[NSMutableArray alloc] init];
    subjectArray = [[NSMutableArray alloc] init];
    teacherArray = [[NSMutableArray alloc] init];
    
    NSString *analyticsApiEnd = IS_STUDENT ? ANALYTICS : TRAINER_ANALYTICS;
    
    //===== This month Anyalytics call ======//
    NSDate *startOfMonth = [Functions startDateOfMonth];
    NSDate *endOfMonth = [Functions endDateOfMonth];
    analyticsApi = [NSString stringWithFormat:@"%@%@?before=%@&after=%@",
                    strMainBaseUrl,
                    analyticsApiEnd,
                    [Functions convertDateToString:endOfMonth format:@"yyyy-MM-dd HH:mm:ss"],
                    [Functions convertDateToString:startOfMonth format:@"yyyy-MM-dd HH:mm:ss"]];
    analyticsApi = [analyticsApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [objWebServices callApiWithParameters:nil apiName:analyticsApi type:GET_REQUEST loader:NO view:self];
    
    //===== Last month Anyalytics call ======//
    NSDate *startOfLastMonth = [Functions startDateOfLastMonth];
    NSDate *endOfLastMonth = [Functions endDateOfLastMonth];
    lastMonthAnalyticsApi = [NSString stringWithFormat:@"%@%@?before=%@&after=%@",
                    strMainBaseUrl,
                    analyticsApiEnd,
                    [Functions convertDateToString:endOfLastMonth format:@"yyyy-MM-dd HH:mm:ss"],
                    [Functions convertDateToString:startOfLastMonth format:@"yyyy-MM-dd HH:mm:ss"]];
    lastMonthAnalyticsApi = [lastMonthAnalyticsApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [objWebServices callApiWithParameters:nil apiName:lastMonthAnalyticsApi type:GET_REQUEST loader:YES view:self];
    
    //===== Total month Anyalytics call ======//
    totalAnalyticsApi = [NSString stringWithFormat:@"%@%@",
                    strMainBaseUrl,
                    analyticsApiEnd];
    [objWebServices callApiWithParameters:nil apiName:totalAnalyticsApi type:GET_REQUEST loader:NO view:self];
}

- (void)parseAnalyticsArray:(id)responseObject purpose:(NSString *)purpose
{
    NSLog(@"analytics purpose: %@", purpose);
    NSString *courseKey = @"course";
    id statsObject = [responseObject valueForKey:@"stats"];
    id categoryObj = [statsObject valueForKey:@"category"];
    id subjectObj = [statsObject valueForKey:@"subject"];
    int total_income = 0;
    if (!IS_STUDENT) {
        id booksObj = [statsObject valueForKey:@"bookings"];
        total_income = [[booksObj valueForKey:@"receipts"] intValue];
    } else {
        courseKey = @"trainer";
    }
    id teacherObj = [statsObject valueForKey:courseKey];
    
    NSString *categoryTotal = [[categoryObj valueForKey:@"total_quantity"] stringValue];
    
    if ([purpose isEqualToString:TOTAL_DAY])
    {
        _AllHRLbl.text = categoryTotal;
        allTotalIncome = total_income;
    }
    else if ([purpose isEqualToString:LAST_MONTH])
    {
        _lastMonthHRLbl.text = categoryTotal;
        lastTotalIncome = total_income;
    }
    else if ([purpose isEqualToString:THIS_MONTH])
    {
        _thisMonthHRLbl.text = categoryTotal;
        thisTotalIncome = total_income;
    }
    
    NSArray *categoryData = [categoryObj valueForKey:@"data"];
    for (NSDictionary *obj in categoryData) {
        AnalyticsModel *analyticsModel = [[AnalyticsModel alloc] init];
        analyticsModel.name = [obj valueForKey:@"name"];
        analyticsModel.minute = [[obj valueForKey:@"minutes"] intValue];
        analyticsModel.income = [[obj valueForKey:@"income"] intValue];
        analyticsModel.quantity = [[obj valueForKey:@"quantity"] intValue];
        analyticsModel.image = [NSString stringWithFormat:@"%@media/photos/courses/%@", strMainBaseUrl, [obj valueForKey:@"image"]];
        analyticsModel.total_minute = [[categoryObj valueForKey:@"total_minutes"] intValue];
        analyticsModel.total_quantity = [[categoryObj valueForKey:@"total_quantity"] intValue];
        analyticsModel.hour = [self convertMinuteToHourByFloat:analyticsModel.minute];
        analyticsModel.timebar = purpose;
        
        float percent = analyticsModel.minute * 100 / (float)analyticsModel.total_minute;
        analyticsModel.percent = [NSString stringWithFormat:@"%ld", lroundf(percent)];
        
        [categoryArray addObject:analyticsModel];
    }
    
    NSArray *subjectData = [subjectObj valueForKey:@"data"];
    for (NSDictionary *obj in subjectData) {
        AnalyticsModel *analyticsModel = [[AnalyticsModel alloc] init];
        analyticsModel.name = [obj valueForKey:@"name"];
        analyticsModel.minute = [[obj valueForKey:@"minutes"] intValue];
        analyticsModel.income = [[obj valueForKey:@"income"] intValue];
        analyticsModel.quantity = [[obj valueForKey:@"quantity"] intValue];
        analyticsModel.image = [NSString stringWithFormat:@"%@media/photos/courses/%@", strMainBaseUrl, [obj valueForKey:@"image"]];
        analyticsModel.total_minute = [[subjectObj valueForKey:@"total_minutes"] intValue];
        analyticsModel.total_quantity = [[subjectObj valueForKey:@"total_quantity"] intValue];
        analyticsModel.total_income = total_income;
        analyticsModel.hour = [self convertMinuteToHourByFloat:analyticsModel.minute];
        analyticsModel.timebar = purpose;
        
        float percent = analyticsModel.minute * 100 / (float)analyticsModel.total_minute;
        analyticsModel.percent = [NSString stringWithFormat:@"%ld", lroundf(percent)];
        
        [subjectArray addObject:analyticsModel];
    }
    
    NSArray *teacherData = [teacherObj valueForKey:@"data"];
    for (NSDictionary *obj in teacherData) {
        AnalyticsModel *analyticsModel = [[AnalyticsModel alloc] init];
        analyticsModel.name = [Functions checkNullValue:[obj valueForKey:@"name"]];
        analyticsModel.minute = [[obj valueForKey:@"minutes"] intValue];
        analyticsModel.income = [[obj valueForKey:@"income"] intValue];
        analyticsModel.quantity = [[obj valueForKey:@"quantity"] intValue];
        analyticsModel.image = [NSString stringWithFormat:@"%@media/photos/courses/%@", strMainBaseUrl, [obj valueForKey:@"image"]];
        analyticsModel.total_minute = [[teacherObj valueForKey:@"total_minutes"] intValue];
        analyticsModel.total_quantity = [[teacherObj valueForKey:@"total_quantity"] intValue];
        analyticsModel.total_income = total_income;
        analyticsModel.hour = [self convertMinuteToHourByFloat:analyticsModel.minute];
        analyticsModel.timebar = purpose;
        
        float percent = analyticsModel.minute * 100 / (float)analyticsModel.total_minute;
        analyticsModel.percent = [NSString stringWithFormat:@"%ld", lroundf(percent)];
        
        [teacherArray addObject:analyticsModel];
    }
    
    NSLog(@"category array count: %lu", (unsigned long)categoryArray.count);
    NSLog(@"subjectArray array count: %lu", (unsigned long)subjectArray.count);
    NSLog(@"teacherArray array count: %lu", (unsigned long)teacherArray.count);
    
    [self setupCarousel];
}

- (NSString*)convertMinuteToHourByFloat:(NSInteger)minute {
    float hour = minute / 3600.0f;
    return [NSString stringWithFormat:@"%.01f", hour];
}

- (NSString*)convertMinuteToHourByInteger:(NSInteger)minute {
    NSInteger hour = minute / 3600;
    return [NSString stringWithFormat:@"%ld", (long)hour];
}

- (void)filterAnalyticsArray:(NSInteger)selectedIndex {
    NSString *timeBar = @"";
    if (selectedIndex == 0) {
        timeBar = LAST_MONTH;
    } else if (selectedIndex == 1) {
        timeBar = THIS_MONTH;
    } else if (selectedIndex == 2) {
        timeBar = TOTAL_DAY;
    }
    
    filterCategoryArray = [[NSMutableArray alloc] init];
    filterSubjectArray = [[NSMutableArray alloc] init];
    filterTeacherArray = [[NSMutableArray alloc] init];
    
    for (AnalyticsModel *obj in categoryArray) {
        if ([obj.timebar isEqualToString:timeBar]) {
            [filterCategoryArray addObject:obj];
        }
    }
    
    for (AnalyticsModel *obj in subjectArray) {
        if ([obj.timebar isEqualToString:timeBar]) {
            [filterSubjectArray addObject:obj];
        }
    }
    
    for (AnalyticsModel *obj in teacherArray) {
        if ([obj.timebar isEqualToString:timeBar]) {
            [filterTeacherArray addObject:obj];
        }
    }
    
    NSLog(@"filterCategoryArray count: %lu", (unsigned long)filterCategoryArray.count);
    NSLog(@"filterSubjectArray count: %lu", (unsigned long)filterSubjectArray.count);
    NSLog(@"filterTeacherArray count: %lu", (unsigned long)filterTeacherArray.count);
    [self.tableView reloadData];
    
    if (filterCategoryArray.count == 0 && filterSubjectArray.count == 0 && filterTeacherArray.count == 0) {
        self.tableView.hidden = YES;
    } else
        self.tableView.hidden = NO;
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:analyticsApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseAnalyticsArray:responseDict purpose:THIS_MONTH];
                [self filterAnalyticsArray:1];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:totalAnalyticsApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseAnalyticsArray:responseDict purpose:TOTAL_DAY];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:lastMonthAnalyticsApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseAnalyticsArray:responseDict purpose:LAST_MONTH];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark -
#pragma mark iCarousel methods
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [aryPrice count];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return _width-10;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    UILabel *catLabel = nil;
    
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
        //view.contentMode = UIViewContentModeCenter;
        if (_selectedIndex == index) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(-_width*0.1, 0, _width*1.2, _height*0.6)];
        } else {
            label = [[UILabel alloc] initWithFrame:CGRectMake(_width*0.1, 0, _width*0.8, _height*0.6)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Roboto-Medium" size:40];
        label.tag = 1;
        
        catLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _height*0.5, _width, _height*0.4)];
        catLabel.textAlignment = NSTextAlignmentCenter;
        catLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
        catLabel.tag = 2;
        
        [view addSubview:label];
        [view addSubview:catLabel];
    }
    else
    {
        label = (UILabel *)[view viewWithTag:1];
        catLabel = (UILabel *)[view viewWithTag:2];
    }
    
    label.text = [NSString stringWithFormat:@"%@", aryPrice[index]];
    if(_selectedIndex == index)
    {
        view.backgroundColor = _selectItemColor;
        label.textColor = _selectedTextColor;
        catLabel.textColor = _selectedTextColor;
        
        if (currentIndex != 0) {
            label.text = [NSString stringWithFormat:@"€%@", label.text];
        }
    }
    else
    {
        view.backgroundColor = _normalItemColor;
        label.textColor = _normalTextColor;
        catLabel.textColor = _normalTextColor;
        label.font = [UIFont fontWithName:@"Roboto-Medium" size:35];
        catLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
        
        CGRect frame = label.frame;
        frame.origin.y += 3;
        label.frame = frame;
    }
    
    if (index == 0) {
        catLabel.text = _lastMonthName;
    } else if (index == 1) {
        catLabel.text = @"This month";
    } else if (index == 2) {
        catLabel.text = @"All time";
    }
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    } else if (option == iCarouselOptionWrap) {
        return NO;
    }
    return value;
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    if(decelerate == FALSE)
    {
        _selectedIndex = carousel.currentItemIndex;
        [_carousel reloadData];
        [self filterAnalyticsArray:_selectedIndex];
    }
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    _selectedIndex = carousel.currentItemIndex;
    [_carousel reloadData];
    [self filterAnalyticsArray:_selectedIndex];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if(_isClicked)
    {
        _isClicked = FALSE;
        _selectedIndex = carousel.currentItemIndex;
        [_carousel reloadData];
        [self filterAnalyticsArray:_selectedIndex];
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    _isClicked = TRUE;
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([stat isEqualToString:@"Category"]) {
        if ([filterCategoryArray count] == 0) {
            return 0;
        } else
            return [filterCategoryArray count];
    } else if ([stat isEqualToString:@"Subject"]) {
        if ([filterSubjectArray count] == 0) {
            return 0;
        } else
            return [filterSubjectArray count];
    } else if ([stat isEqualToString:@"Teacher"]) {
        if ([filterTeacherArray count] == 0) {
            return 0;
        } else
            return [filterTeacherArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"AnalyticsCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImageView *headerImg = (UIImageView*)[cell viewWithTag:10];
    UILabel *namelbl = (UILabel*)[cell viewWithTag:21];
    UILabel *quantitylbl = (UILabel*)[cell viewWithTag:22];
    UILabel *timelbl = (UILabel*)[cell viewWithTag:23];
    UILabel *percentlbl = (UILabel*)[cell viewWithTag:24];
    
    if ([stat isEqualToString:@"Category"]) {
        if ([filterCategoryArray count] > 0) {
            AnalyticsModel *item = [filterCategoryArray objectAtIndex:indexPath.row];
            [headerImg sd_setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            namelbl.text = item.name;
            quantitylbl.text = [NSString stringWithFormat:@"%ld bookings", (long)item.quantity];
            if (currentIndex == 0) {
                timelbl.text = [NSString stringWithFormat:@"%@ hrs", item.hour];
            } else {
                timelbl.text = [NSString stringWithFormat:@"€%ld", (long)item.income];
            }
            percentlbl.text = [NSString stringWithFormat:@"%@%%", item.percent];
            
            if ([item.hour isEqualToString:@"0"]) {
                [self setGrayTextColor:namelbl];
                [self setGrayTextColor:quantitylbl];
                [self setGrayTextColor:timelbl];
                [self setGrayTextColor:percentlbl];
            } else {
                [self restoreTextColor:namelbl];
                [self restoreTextColor:quantitylbl];
                [self restoreTextColor:timelbl];
                [self restoreTextColor:percentlbl];
            }
        }
    } else if ([stat isEqualToString:@"Subject"]) {
        if ([filterSubjectArray count] > 0) {
            AnalyticsModel *item = [filterSubjectArray objectAtIndex:indexPath.row];
            [headerImg sd_setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            namelbl.text = [Functions checkNullValue:item.name];
            quantitylbl.text = [NSString stringWithFormat:@"%ld bookings", (long)item.quantity];
            if (currentIndex == 0) {
                timelbl.text = [NSString stringWithFormat:@"%@ hrs", item.hour];
            } else {
                timelbl.text = [NSString stringWithFormat:@"€%ld", (long)item.income];
            }
            percentlbl.text = [NSString stringWithFormat:@"%@%%", item.percent];
            
            if ([item.hour isEqualToString:@"0"]) {
                [self setGrayTextColor:namelbl];
                [self setGrayTextColor:quantitylbl];
                [self setGrayTextColor:timelbl];
                [self setGrayTextColor:percentlbl];
            } else {
                [self restoreTextColor:namelbl];
                [self restoreTextColor:quantitylbl];
                [self restoreTextColor:timelbl];
                [self restoreTextColor:percentlbl];
            }
        }
    } else if ([stat isEqualToString:@"Teacher"]) {
        if ([filterTeacherArray count] > 0) {
            AnalyticsModel *item = [filterTeacherArray objectAtIndex:indexPath.row];
            headerImg.image = [UIImage imageNamed:@"person.png"];
            namelbl.text = item.name;
            quantitylbl.text = [NSString stringWithFormat:@"%ld bookings", (long)item.quantity];
            if (currentIndex == 0) {
                timelbl.text = [NSString stringWithFormat:@"%@ hrs", item.hour];
            } else {
                timelbl.text = [NSString stringWithFormat:@"€%ld", (long)item.income];
            }
            percentlbl.text = [NSString stringWithFormat:@"%@%%", item.percent];
            
            if ([item.hour isEqualToString:@"0"]) {
                [self setGrayTextColor:namelbl];
                [self setGrayTextColor:quantitylbl];
                [self setGrayTextColor:timelbl];
                [self setGrayTextColor:percentlbl];
            } else {
                [self restoreTextColor:namelbl];
                [self restoreTextColor:quantitylbl];
                [self restoreTextColor:timelbl];
                [self restoreTextColor:percentlbl];
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return cell;
}

- (void)setGrayTextColor:(UILabel *)label {
    label.textColor = [UIColor colorWithHex:COLOR_GRAY];
}

- (void)restoreTextColor:(UILabel *)label {
    label.textColor = [UIColor colorWithHex:COLOR_FONT];
}

#pragma mark - IBAction
- (IBAction)OnViewUpBookingsClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_GO_BOOK object:self];
}

- (IBAction)OnStatChanged:(id)sender {
    if (_statSegment.selectedSegmentIndex == 0) {
        stat = @"Category";
        [self.tableView reloadData];
    } else if (_statSegment.selectedSegmentIndex == 1) {
        stat = @"Subject";
        [self.tableView reloadData];
    } else if (_statSegment.selectedSegmentIndex == 2) {
        stat = @"Teacher";
        [self.tableView reloadData];
    }
}

- (NSString*) dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return categories[row];
}

- (NSInteger) numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger) dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return categories.count;
}

- (void) dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _titleTotalLbl.text = categories[row];
    [dropdownMenu closeAllComponentsAnimated:true];
    currentIndex = (int)row;
    [self setupCarousel];
    [self.tableView reloadData];
}

@end
