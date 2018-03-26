//
//  HomeViewController.m
//  KES
//
//  Created by matata on 2/13/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "HomeViewController.h"

#define LAST_MONTH  @"last_month"
#define THIS_MONTH  @"this_month"
#define TOTAL_DAY   @"total_day"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    category = @"View";
    userInfo = [NSUserDefaults standardUserDefaults];
    refreshControl = [[UIRefreshControl alloc]init];
    //[self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self setupCarousel:[[NSMutableArray alloc] initWithObjects:
                         @"My feed",
                         @"My feed",
                         @"My feed", nil]];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    startOfMonth = [Functions startDateOfMonth];
    endOfMonth = [Functions endDateOfMonth];
    startOfLastMonth = [Functions startDateOfLastMonth];
    endOfLastMonth = [Functions endDateOfLastMonth];
    
    [self retrieveFeed:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(retrieveFeed:)
                                                 name:NOTI_RETRIEVE_FEED
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupCarousel:(NSMutableArray *)yourItemArray
{
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
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeLinear;
    _selectedIndex = 1;
    [_carousel scrollToItemAtIndex:_selectedIndex animated:NO];
    
    [_carousel reloadData];
}

- (void)refreshTable {
//    if ([category isEqualToString:@"News"] || [category isEqualToString:@"Offers"]) {
//        [self retrieveNews];
//    } else if ([category isEqualToString:@"Bookings"]) {
//        [self retrieveBook];
//    }
}

- (void)retrieveFeed:(NSNotification*) notification {
    //_isLoadTimePrompt = NO;
    feedArray = [[NSMutableArray alloc] init];
    newsArray = [[NSMutableArray alloc] init];
    offersArray = [[NSMutableArray alloc] init];
    bookArray = [[NSMutableArray alloc] init];
    
    [self retrieveNews:_selectedIndex];
    [self retrieveOffers:_selectedIndex];
    [self retrieveBook:_selectedIndex];
}

- (void)retrieveNews:(NSInteger)selectedIndex {
    newsArray = [[NSMutableArray alloc] init];
    if (selectedIndex == 0) {
        //===== Last month News call ======//
        lastMonthNewsApi = [NSString stringWithFormat:@"%@%@?category=%@&before=%@&after=%@",
                            BASE_URL,
                            NEWS_LIST,
                            @"News",
                            [Functions convertDateToString:endOfLastMonth format:@"yyyy-MM-dd HH:mm:ss"],
                            [Functions convertDateToString:startOfLastMonth format:@"yyyy-MM-dd HH:mm:ss"]];
        lastMonthNewsApi = [lastMonthNewsApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [objWebServices callApiWithParameters:nil apiName:lastMonthNewsApi type:GET_REQUEST loader:YES view:self];
    } else if (selectedIndex == 1) {
        //===== This month News call ======//
        newsApi = [NSString stringWithFormat:@"%@%@?category=%@&before=%@&after=%@",
                   BASE_URL,
                   NEWS_LIST,
                   @"News",
                   [Functions convertDateToString:endOfMonth format:@"yyyy-MM-dd HH:mm:ss"],
                   [Functions convertDateToString:startOfMonth format:@"yyyy-MM-dd HH:mm:ss"]];
        newsApi = [newsApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [objWebServices callApiWithParameters:nil apiName:newsApi type:GET_REQUEST loader:YES view:self];
    } else if (selectedIndex == 2) {
        //===== Total month News call ======//
        totalNewsApi = [NSString stringWithFormat:@"%@%@?category=%@",
                        BASE_URL,
                        NEWS_LIST,
                        @"News"];
        [objWebServices callApiWithParameters:nil apiName:totalNewsApi type:GET_REQUEST loader:YES view:self];
    }
}

- (void)retrieveOffers:(NSInteger)selectedIndex {
    offersArray = [[NSMutableArray alloc] init];
    if (selectedIndex == 0) {
        //===== Last month Offers call ======//
        lastMonthOffersApi = [NSString stringWithFormat:@"%@%@?category=%@&before=%@&after=%@",
                              BASE_URL,
                              NEWS_LIST,
                              @"Offers",
                              [Functions convertDateToString:endOfLastMonth format:@"yyyy-MM-dd HH:mm:ss"],
                              [Functions convertDateToString:startOfLastMonth format:@"yyyy-MM-dd HH:mm:ss"]];
        lastMonthOffersApi = [lastMonthOffersApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [objWebServices callApiWithParameters:nil apiName:lastMonthOffersApi type:GET_REQUEST loader:NO view:self];
    } else if (selectedIndex == 1) {
        //===== This month Offers call ======//
        offersApi = [NSString stringWithFormat:@"%@%@?category=%@&before=%@&after=%@",
                     BASE_URL,
                     NEWS_LIST,
                     @"Offers",
                     [Functions convertDateToString:endOfMonth format:@"yyyy-MM-dd HH:mm:ss"],
                     [Functions convertDateToString:startOfMonth format:@"yyyy-MM-dd HH:mm:ss"]];
        offersApi = [offersApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [objWebServices callApiWithParameters:nil apiName:offersApi type:GET_REQUEST loader:NO view:self];
    } else if (selectedIndex == 2) {
        //===== Total month Offers call ======//
        totalOffersApi = [NSString stringWithFormat:@"%@%@?category=%@", BASE_URL, NEWS_LIST, @"Offers"];
        [objWebServices callApiWithParameters:nil apiName:totalOffersApi type:GET_REQUEST loader:NO view:self];
    }
}

- (void)retrieveBook:(NSInteger)selectedIndex {
    bookArray = [[NSMutableArray alloc] init];
    if (selectedIndex == 0) {
        //===== Last month Books call ======//
        lastMonthBookApi = [NSString stringWithFormat:@"%@%@?before=%@&after=%@",
                    BASE_URL,
                    BOOK_SEARCH,
                    [Functions convertDateToString:endOfLastMonth format:@"yyyy-MM-dd HH:mm:ss"],
                    [Functions convertDateToString:startOfLastMonth format:@"yyyy-MM-dd HH:mm:ss"]];
        lastMonthBookApi = [lastMonthBookApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [objWebServices callApiWithParameters:nil apiName:lastMonthBookApi type:GET_REQUEST loader:NO view:self];
    } else if (selectedIndex == 1) {
        //===== This month Books call ======//
        booksApi = [NSString stringWithFormat:@"%@%@?before=%@&after=%@",
                    BASE_URL,
                    BOOK_SEARCH,
                    [Functions convertDateToString:endOfMonth format:@"yyyy-MM-dd HH:mm:ss"],
                    [Functions convertDateToString:startOfMonth format:@"yyyy-MM-dd HH:mm:ss"]];
        booksApi = [booksApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [objWebServices callApiWithParameters:nil apiName:booksApi type:GET_REQUEST loader:NO view:self];
    } else if (selectedIndex == 2) {
        //===== Total Books call ======//
        totalBookApi = [NSString stringWithFormat:@"%@%@",
                    BASE_URL,
                    BOOK_SEARCH];
        [objWebServices callApiWithParameters:nil apiName:totalBookApi type:GET_REQUEST loader:NO view:self];
    }
}

#pragma mark - webservice call delegate
-(void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:newsApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseNewsArray:responseDict purpose:THIS_MONTH];
                [feedArray addObjectsFromArray:newsArray];
                [self filterArray:THIS_MONTH];
                
                if (_isLoadTimePrompt == NO) {
                    _isLoadTimePrompt = YES;
                    [Functions showSuccessAlert:@"" message:[NSString stringWithFormat:@"Welcome back %@", [userInfo valueForKey:KEY_FIRSTNAME]] image:@"welcome_back"];
                    countDownApi = [NSString stringWithFormat:@"%@%@", BASE_URL, NEXT_COUNTDOWN];
                    [objWebServices callApiWithParameters:nil apiName:countDownApi type:GET_REQUEST loader:NO view:self];
                }
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:lastMonthNewsApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseNewsArray:responseDict purpose:LAST_MONTH];
                [feedArray addObjectsFromArray:newsArray];
                [self filterArray:LAST_MONTH];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:totalNewsApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseNewsArray:responseDict purpose:TOTAL_DAY];
                [feedArray addObjectsFromArray:newsArray];
                [self filterArray:TOTAL_DAY];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:offersApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseOffersArray:responseDict purpose:THIS_MONTH];
                [feedArray addObjectsFromArray:offersArray];
                [self filterArray:THIS_MONTH];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:lastMonthOffersApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseOffersArray:responseDict purpose:LAST_MONTH];
                [feedArray addObjectsFromArray:offersArray];
                [self filterArray:LAST_MONTH];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:totalOffersApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseOffersArray:responseDict purpose:TOTAL_DAY];
                [feedArray addObjectsFromArray:offersArray];
                [self filterArray:TOTAL_DAY];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:booksApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseBooksArray:responseDict purpose:THIS_MONTH];
                [feedArray addObjectsFromArray:bookArray];
                [self filterArray:THIS_MONTH];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:lastMonthBookApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseBooksArray:responseDict purpose:LAST_MONTH];
                [feedArray addObjectsFromArray:bookArray];
                [self filterArray:LAST_MONTH];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:totalBookApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseBooksArray:responseDict purpose:TOTAL_DAY];
                [feedArray addObjectsFromArray:bookArray];
                [self filterArray:TOTAL_DAY];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:countDownApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                NSDate *nextExamDate = [Functions convertStringToDate:[responseDict valueForKey:@"datetime"] format:MAIN_DATE_FORMAT];
                NSString *breakDownInterval = [nextExamDate differenceFromToday];
                [Functions showSuccessAlert:@"" message:[NSString stringWithFormat:@"%@ in just %@", [responseDict valueForKey:@"title"], breakDownInterval] image:@"stopwatch"];
                contactApi = [NSString stringWithFormat:@"%@%@", BASE_URL, CONTACT_DETAIL];
                [objWebServices callApiWithParameters:nil apiName:contactApi type:GET_REQUEST loader:NO view:self];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:contactApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                id dataObj = [responseDict valueForKey:@"data"];
                NSString *dateOfBirth = [Functions checkNullValue:[dataObj valueForKey:@"date_of_birth"]];
                NSString *todayStr = [Functions convertDateToString:[NSDate date] format:@"yyyy-MM-dd"];
                if ([dateOfBirth rangeOfString:todayStr].location != NSNotFound) {
                    [Functions showSuccessAlert:@"" message:[NSString stringWithFormat:@"Happy birthday %@", [userInfo valueForKey:KEY_FIRSTNAME]] image:@"wedding-cake"];
                }
                ContactData *contactData = [[ContactData alloc] init];
                contactData.user_id = [Functions checkNullValue:[dataObj valueForKey:@"id"]];
                contactData.first_name = [Functions checkNullValue:[dataObj valueForKey:@"first_name"]];
                contactData.last_name = [Functions checkNullValue:[dataObj valueForKey:@"last_name"]];
                contactData.date_of_birth = [Functions checkNullValue:[dataObj valueForKey:@"date_of_birth"]];
                contactData.school_id = [Functions checkNullValue:[dataObj valueForKey:@"school_id"]];
                contactData.year_id = [Functions checkNullValue:[dataObj valueForKey:@"year_id"]];
                contactData.academic_year_id = [Functions checkNullValue:[dataObj valueForKey:@"academic_year_id"]];
                contactData.nationality = [Functions checkNullValue:[dataObj valueForKey:@"nationality"]];
                contactData.gender = [Functions checkNullValue:[dataObj valueForKey:@"gender"]];
                contactData.title = [Functions checkNullValue:[dataObj valueForKey:@"title"]];
                contactData.date_created = [Functions checkNullValue:[dataObj valueForKey:@"date_created"]];
                contactData.cycle = [Functions checkNullValue:[dataObj valueForKey:@"cycle"]];
                contactData.points = [Functions checkNullValue:[dataObj valueForKey:@"points_required"]];
                contactData.courses_i_would_like = [Functions checkNullValue:[dataObj valueForKey:@"courses_i_would_like"]];
                
                NSDictionary *addressObj = [dataObj valueForKey:@"address"];
                contactData.address1 = [addressObj valueForKey:@"address1"];
                contactData.address2 = [addressObj valueForKey:@"address2"];
                contactData.address3 = [addressObj valueForKey:@"address3"];
                contactData.country = [Functions checkNullValue:[addressObj valueForKey:@"country"]];
                contactData.county = [Functions checkNullValue:[addressObj valueForKey:@"county"]];
                contactData.town = [addressObj valueForKey:@"town"];
                contactData.postcode = [addressObj valueForKey:@"postcode"];
                
                NSArray *contactDetailArray = [dataObj valueForKey:@"notifications"];
                contactData.contactDetails = [[NSMutableArray alloc] init];
                for (NSDictionary *obj in contactDetailArray) {
                    ContactNotification *contactDetail = [[ContactNotification alloc] init];
                    contactDetail.detail_id = [obj valueForKey:@"id"];
                    contactDetail.type_id = [obj valueForKey:@"type_id"];
                    contactDetail.value = [obj valueForKey:@"value"];
                    [contactData.contactDetails addObject:contactDetail];
                }
                
                NSArray *preferencesArray = [dataObj valueForKey:@"preferences"];
                contactData.preferenceArray = [[NSMutableArray alloc] init];
                for (NSDictionary *obj in preferencesArray) {
                    PreferenceType *pType = [[PreferenceType alloc] init];
                    pType.preference_id = [obj valueForKey:@"preference_id"];
                    //pType.value = [obj valueForKey:@"value"];
                    [contactData.preferenceArray addObject:pType];
                }
                
                NSArray *subjectArray = [dataObj valueForKey:@"subject_preferences"];
                contactData.subjectArray = [[NSMutableArray alloc] init];
                for (NSDictionary *obj in subjectArray) {
                    SubjectModel *subjectModel = [[SubjectModel alloc] init];
                    subjectModel.subject_id = [obj valueForKey:@"subject_id"];
                    subjectModel.level_id = [obj valueForKey:@"level_id"];
                    [contactData.subjectArray addObject:subjectModel];
                }
                
                appDelegate.contactData = [[ContactData alloc] init];
                appDelegate.contactData = contactData;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SETTING_USERINFO object:self];
                
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

- (void)parseNewsArray: (id)responseObject purpose:(NSString *)purpose
{
    NSArray* newsObject = [responseObject valueForKey:@"news"];
    for (NSDictionary *obj in newsObject) {
        NewsModel *newsModel = [[NewsModel alloc] init];
        newsModel._id = [obj valueForKey:@"id"];
        newsModel.category_id = [obj valueForKey:@"category_id"];
        newsModel.title = [obj valueForKey:@"title"];
        newsModel.summary = [obj valueForKey:@"summary"];
        newsModel.category = [obj valueForKey:@"category"];
        newsModel.content = [obj valueForKey:@"content"];
        newsModel.event_date = [obj valueForKey:@"event_date"];
        newsModel.image = [NSString stringWithFormat:@"%@media/photos/news/%@", BASE_URL, [obj valueForKey:@"image"]];
        newsModel.timebar = purpose;
        
        NSDate *eventDateTime = [Functions convertStringToDate:[Functions checkNullValueWithDate:[obj valueForKey:@"event_date"]] format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dayOfWeek = [Functions convertDateToString:eventDateTime format:@"ccc"];
        NSString *month = [Functions convertDateToString:eventDateTime format:@"LLL"];
        NSString *day = [Functions convertDateToString:eventDateTime format:@"dd"];
        newsModel.dayOfWeek = dayOfWeek;
        newsModel.month = month;
        newsModel.day = day;
        
        [newsArray addObject:newsModel];
    }
}

- (void)parseOffersArray: (id)responseObject purpose:(NSString *)purpose
{
    NSArray* offersObject = [responseObject valueForKey:@"news"];
    for (NSDictionary *obj in offersObject) {
        NewsModel *newsModel = [[NewsModel alloc] init];
        newsModel._id = [obj valueForKey:@"id"];
        newsModel.category_id = [obj valueForKey:@"category_id"];
        newsModel.title = [obj valueForKey:@"title"];
        newsModel.summary = [obj valueForKey:@"summary"];
        newsModel.category = [obj valueForKey:@"category"];
        newsModel.content = [obj valueForKey:@"content"];
        newsModel.event_date = [obj valueForKey:@"event_date"];
        newsModel.image = [NSString stringWithFormat:@"%@media/photos/news/%@", BASE_URL, [obj valueForKey:@"image"]];
        newsModel.timebar = purpose;
        
        NSDate *eventDateTime = [Functions convertStringToDate:[Functions checkNullValueWithDate:[obj valueForKey:@"event_date"]] format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dayOfWeek = [Functions convertDateToString:eventDateTime format:@"ccc"];
        NSString *month = [Functions convertDateToString:eventDateTime format:@"LLL"];
        NSString *day = [Functions convertDateToString:eventDateTime format:@"dd"];
        newsModel.dayOfWeek = dayOfWeek;
        newsModel.month = month;
        newsModel.day = day;
        
        [offersArray addObject:newsModel];
    }
}

- (void)parseBooksArray: (id)responseObject purpose:(NSString *)purpose
{
    NSArray* booksObject = [responseObject valueForKey:@"bookings"];
    for (NSDictionary *obj in booksObject) {
        NewsModel *bookModel = [[NewsModel alloc] init];
        bookModel.room = [obj valueForKey:@"room"];
        bookModel.schedule = [obj valueForKey:@"schedule"];
        bookModel.trainer = [obj valueForKey:@"trainer"];
        bookModel.course = [obj valueForKey:@"course"];
        bookModel.start_date = [obj valueForKey:@"start_date"];
        bookModel.end_date = [obj valueForKey:@"end_date"];
        bookModel.schedule_id = [obj valueForKey:@"schedule_id"];
        bookModel.category = @"Bookings";
        bookModel.timebar = purpose;
        
        NSDate *startDateTime = [Functions convertStringToDate:[obj valueForKey:@"start_date"] format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *startTimeStr = [[Functions convertDateToString:startDateTime format:@"h:mm a"] lowercaseString];
        NSDate *endDateTime = [Functions convertStringToDate:[obj valueForKey:@"end_date"] format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *endTimeStr = [[Functions convertDateToString:endDateTime format:@"h:mm a"] lowercaseString];
        bookModel.start_to_end = [NSString stringWithFormat:@"%@ - %@", startTimeStr, endTimeStr];
        
        NSString *dayOfWeek = [Functions convertDateToString:startDateTime format:@"ccc"];
        NSString *month = [Functions convertDateToString:startDateTime format:@"LLL"];
        NSString *day = [Functions convertDateToString:startDateTime format:@"dd"];
        bookModel.dayOfWeek = dayOfWeek;
        bookModel.month = month;
        bookModel.day = day;
        bookModel.time_prompt = [startDateTime timeAgo];
        
        [bookArray addObject:bookModel];
    }
}

- (void)filterArray:(NSString*)timeBar {
    
    filterFeedArray = [[NSMutableArray alloc] init];
    filterNewsArray = [[NSMutableArray alloc] init];
    filterOffersArray = [[NSMutableArray alloc] init];
    filterBookArray = [[NSMutableArray alloc] init];
    
    for (NewsModel *obj in feedArray) {
        if ([obj.timebar isEqualToString:timeBar]) {
            [filterFeedArray addObject:obj];
        }
    }
    
    for (NewsModel *obj in newsArray) {
        if ([obj.timebar isEqualToString:timeBar]) {
            [filterNewsArray addObject:obj];
        }
    }
    
    for (NewsModel *obj in offersArray) {
        if ([obj.timebar isEqualToString:timeBar]) {
            [filterOffersArray addObject:obj];
        }
    }
    
    for (NewsModel *obj in bookArray) {
        if ([obj.timebar isEqualToString:timeBar]) {
            [filterBookArray addObject:obj];
        }
    }
    
    NSLog(@"filterNewsArray count: %lu", (unsigned long)filterNewsArray.count);
    NSLog(@"filterOffersArray count: %lu", (unsigned long)filterOffersArray.count);
    NSLog(@"filterBookArray count: %lu", (unsigned long)filterBookArray.count);
    [self.tableView reloadData];
}

- (void)showNoPromptMessage:(NSString *)message {
    _noPromptLbl.hidden = NO;
    _tableView.hidden = YES;
    _noPromptLbl.text = message;
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
        view.contentMode = UIViewContentModeCenter;
        //CGRect rectLabel = view.bounds;
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, _height*0.7)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Roboto-Medium" size:30];
        label.tag = 1;
        
        catLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _height*0.5, _width, _height*0.4)];
        catLabel.textAlignment = NSTextAlignmentCenter;
        catLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        catLabel.tag = 2;
        
        [view addSubview:label];
        [view addSubview:catLabel];
    }
    else
    {
        label = (UILabel *)[view viewWithTag:1];
        catLabel = (UILabel *)[view viewWithTag:2];
    }
    
    if(_selectedIndex == index)
    {
        view.backgroundColor = _selectItemColor;
        label.textColor = _selectedTextColor;
        catLabel.textColor = _selectedTextColor;
    }
    else
    {
        view.backgroundColor = _normalItemColor;
        label.textColor = _normalTextColor;
        label.font = [UIFont fontWithName:@"Roboto-Medium" size:18];
        catLabel.textColor = _normalTextColor;
    }
    
    label.text = [NSString stringWithFormat:@"%@",aryPrice[index]];
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
    if (option == iCarouselOptionSpacing) {
        return value * 1.1;
    } else if (option == iCarouselOptionWrap) {
        return YES;
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
        [self retrieveFeed:nil];
    }
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    _selectedIndex = carousel.currentItemIndex;
    [_carousel reloadData];
    [self retrieveFeed:nil];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if(_isClicked)
    {
        _isClicked = FALSE;
        _selectedIndex = carousel.currentItemIndex;
        [_carousel reloadData];
        [self retrieveFeed:nil];
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    _isClicked = TRUE;
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.hidden = NO;
    self.noPromptLbl.hidden = YES;
    
    if ([category isEqualToString:@"News"]) {
        if ([filterNewsArray count] == 0) {
            [self showNoPromptMessage:@"There are no news articles for this time range"];
            return 0;
        } else
            return [filterNewsArray count];
    } else if ([category isEqualToString:@"Offers"]) {
        if ([filterOffersArray count] == 0) {
            [self showNoPromptMessage:@"There are no offers for this time range"];
            return 0;
        } else
            return [filterOffersArray count];
    } else if ([category isEqualToString:@"Bookings"]) {
        if ([filterBookArray count] == 0) {
            [self showNoPromptMessage:@"There are no bookings for this time range"];
            return 0;
        } else
            return [filterBookArray count];
    } else if ([category isEqualToString:@"View"]) {
        if ([filterFeedArray count] == 0) {
            [self showNoPromptMessage:@"There are no items for this time range"];
            return 0;
        } else
            return [filterFeedArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"FeedCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImageView *headerImg = (UIImageView*)[cell viewWithTag:9];
    UIImageView *roomImg = (UIImageView*)[cell viewWithTag:10];
    UIImageView *timeImg = (UIImageView*)[cell viewWithTag:11];
    UIImageView *personImg = (UIImageView*)[cell viewWithTag:12];
    UILabel *dayOfWeeklbl = (UILabel*)[cell viewWithTag:20];
    UILabel *daylbl = (UILabel*)[cell viewWithTag:26];
    UILabel *monthlbl = (UILabel*)[cell viewWithTag:27];
    UILabel *titlelbl = (UILabel*)[cell viewWithTag:21];
    UILabel *roomlbl = (UILabel*)[cell viewWithTag:22];
    UILabel *timelbl = (UILabel*)[cell viewWithTag:23];
    UILabel *personlbl = (UILabel*)[cell viewWithTag:24];
    UILabel *contentlbl = (UILabel*)[cell viewWithTag:25];
    
    if ([category isEqualToString:@"News"]) {
        [headerImg setImage:[UIImage imageNamed:@"newspaper.png"]];
        roomImg.hidden = YES;
        timeImg.hidden = YES;
        personImg.hidden = YES;
        roomlbl.hidden = YES;
        timelbl.hidden = YES;
        personlbl.hidden = YES;
        contentlbl.hidden = NO;
        
        if ([filterNewsArray count] > 0) {
            NewsModel *item = [filterNewsArray objectAtIndex:indexPath.row];
            dayOfWeeklbl.text = item.dayOfWeek;
            daylbl.text = item.day;
            monthlbl.text = item.month;
            titlelbl.text = item.title;
            contentlbl.text = item.summary;
            [contentlbl sizeToFit];
        }
    } else if ([category isEqualToString:@"Offers"]) {
        [headerImg setImage:[UIImage imageNamed:@"thumbs_up.png"]];
        roomImg.hidden = YES;
        timeImg.hidden = YES;
        personImg.hidden = YES;
        roomlbl.hidden = YES;
        timelbl.hidden = YES;
        personlbl.hidden = YES;
        contentlbl.hidden = NO;
        
        if ([filterOffersArray count] > 0) {
            NewsModel *item = [filterOffersArray objectAtIndex:indexPath.row];
            dayOfWeeklbl.text = item.dayOfWeek;
            daylbl.text = item.day;
            monthlbl.text = item.month;
            titlelbl.text = item.title;
            contentlbl.text = item.summary;
            [contentlbl sizeToFit];
        }
    } else if ([category isEqualToString:@"Bookings"]) {
        [headerImg setImage:[UIImage imageNamed:@"calendar.png"]];
        roomImg.hidden = NO;
        timeImg.hidden = NO;
        personImg.hidden = NO;
        roomlbl.hidden = NO;
        timelbl.hidden = NO;
        personlbl.hidden = NO;
        contentlbl.hidden = YES;
        
        if ([filterBookArray count] > 0) {
            NewsModel *item = [filterBookArray objectAtIndex:indexPath.row];
            dayOfWeeklbl.text = item.dayOfWeek;
            daylbl.text = item.day;
            monthlbl.text = item.month;
            titlelbl.text = item.course;
            roomlbl.text = item.room;
            timelbl.text = item.start_to_end;
            personlbl.text = item.trainer;
        }
    } else if ([category isEqualToString:@"View"]) {
        NewsModel *item = [filterFeedArray objectAtIndex:indexPath.row];
        if ([item.category isEqualToString:@"News"] || [item.category isEqualToString:@"Offers"]) {
            if ([item.category isEqualToString:@"News"]) {
                [headerImg setImage:[UIImage imageNamed:@"newspaper.png"]];
            } else
                [headerImg setImage:[UIImage imageNamed:@"thumbs_up.png"]];
            
            roomImg.hidden = YES;
            timeImg.hidden = YES;
            personImg.hidden = YES;
            roomlbl.hidden = YES;
            timelbl.hidden = YES;
            personlbl.hidden = YES;
            contentlbl.hidden = NO;
            
            dayOfWeeklbl.text = item.dayOfWeek;
            daylbl.text = item.day;
            monthlbl.text = item.month;
            titlelbl.text = item.title;
            contentlbl.text = item.summary;
            [contentlbl sizeToFit];
        } else if ([item.category isEqualToString:@"Bookings"]) {
            [headerImg setImage:[UIImage imageNamed:@"calendar.png"]];
            roomImg.hidden = NO;
            timeImg.hidden = NO;
            personImg.hidden = NO;
            roomlbl.hidden = NO;
            timelbl.hidden = NO;
            personlbl.hidden = NO;
            contentlbl.hidden = YES;
            
            dayOfWeeklbl.text = item.dayOfWeek;
            daylbl.text = item.day;
            monthlbl.text = item.month;
            titlelbl.text = item.course;
            roomlbl.text = item.room;
            timelbl.text = item.start_to_end;
            personlbl.text = item.trainer;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *item = [[NewsModel alloc] init];
    if ([category isEqualToString:@"News"]) {
        item = [filterNewsArray objectAtIndex:indexPath.row];
        //Go news detail
    } else if ([category isEqualToString:@"Offers"]) {
        item = [filterOffersArray objectAtIndex:indexPath.row];
        //Go news detail
    } else if ([category isEqualToString:@"Bookings"]) {
        //Go book detail
        item = [filterBookArray objectAtIndex:indexPath.row];
        NSDictionary* info = @{@"itemObj": item};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CLASS_DETAIL object:self userInfo:info];
        return;
    } else if ([category isEqualToString:@"View"]) {
        item = [filterFeedArray objectAtIndex:indexPath.row];
        if ([item.category isEqualToString:@"News"] || [item.category isEqualToString:@"Offers"]) {
            //Go news detail
        } else if ([item.category isEqualToString:@"Bookings"]) {
            //Go book detail
            NSDictionary* info = @{@"itemObj": item};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CLASS_DETAIL object:self userInfo:info];
            return;
        } else
            return;
    } else
        return;
    
    //Go news detail
    NewsMoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newsmore"];
    controller.newsObj = item;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - IBAction
- (IBAction)OnCategoryChanged:(id)sender {
    _noPromptLbl.hidden = YES;
    _tableView.hidden = NO;
    
    if (_categorySeg.selectedSegmentIndex == 0) {
        category = @"View";
        if (filterFeedArray.count > 0) {
            [self.tableView reloadData];
        } else {
            [self showNoPromptMessage:@"There are no items for this time range"];
        }
    } else if (_categorySeg.selectedSegmentIndex == 1) {
        category = @"Bookings";
        if (filterBookArray.count > 0) {
            [self.tableView reloadData];
        } else {
            [self showNoPromptMessage:@"There are no bookings for this time range"];
        }
    } else if (_categorySeg.selectedSegmentIndex == 2) {
        category = @"News";
        if (filterNewsArray.count > 0) {
            [self.tableView reloadData];
        } else {
            [self showNoPromptMessage:@"There are no news articles for this time range"];
        }
    } else if (_categorySeg.selectedSegmentIndex == 3) {
        category = @"Offers";
        if (filterOffersArray.count > 0) {
            [self.tableView reloadData];
        } else {
            [self showNoPromptMessage:@"There are no offers for this time range"];
        }
    }
}
@end
