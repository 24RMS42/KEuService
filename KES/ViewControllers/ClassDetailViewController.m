//
//  ClassDetailViewController.m
//  KES
//
//  Created by matata on 2/21/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "ClassDetailViewController.h"

@interface ClassDetailViewController ()

@end

@implementation ClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    [button setBackgroundColor:[UIColor colorWithHex:COLOR_PRIMARY]];
    [_titleView setHidden:_isContained];
    
    topicArray = [[NSMutableArray alloc] init];
    for (TopicModel *obj in appDelegate.topicArray) {
        if ([obj.topic_id isEqualToString:@"7"] || [obj.topic_id isEqualToString:@"8"] || [obj.topic_id isEqualToString:@"75"] || [obj.topic_id isEqualToString:@"19"] || [obj.topic_id isEqualToString:@"240"]) {
            [topicArray addObject:obj];
        }
    }
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    scheduleApi = [NSString stringWithFormat:@"%@%@%@", strMainBaseUrl, SCHEDULE_DETAIL, _objBook.schedule_id];
    [objWebServices callApiWithParameters:nil apiName:scheduleApi type:GET_REQUEST loader:YES view:self];
    
    _selectedIndex = 0;
    _width = (self.view.frame.size.width-6)/3;
    _height = self.carousel.frame.size.height;
    
    _pageControll.numberOfPages = topicArray.count;
    _carousel.pagingEnabled = FALSE;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeLinear;
    [_carousel scrollToItemAtIndex:_selectedIndex animated:NO];
    [_carousel reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parseSchedule:(id)responseObject {
    ScheduleModel *scheduleObj = [[ScheduleModel alloc] init];
    
    id scheduleObject = [responseObject valueForKey:@"schedule"];
    scheduleObj.booking_type = [scheduleObject valueForKey:@"booking_type"];
    scheduleObj.course_id = [scheduleObject valueForKey:@"course_id"];
    scheduleObj.payment_type = [scheduleObject valueForKey:@"payment_type"];
    scheduleObj.location_id = [scheduleObject valueForKey:@"location_id"];
    scheduleObj.fee_amount = [[Functions checkNullValueWithZero:[scheduleObject valueForKey:@"fee_amount"]] integerValue];
    scheduleObj.topicArray = [scheduleObject objectForKey:@"topics"];
    
    locationId = scheduleObj.location_id;
    
    //Fill data
    if ([scheduleObj.payment_type isEqualToString:@"1"]) {
        [self showGrindView];
    } else
        [self showRevisionView];
    
    NSDate *startDate = [Functions convertStringToDate:IS_STUDENT ? _objBook.slot_start_date:_objBook.start_date format:MAIN_DATE_FORMAT];
    NSDate *endDate = [Functions convertStringToDate:IS_STUDENT ? _objBook.slot_end_date:_objBook.end_date format:MAIN_DATE_FORMAT];
    NSString *startDateStr = [Functions convertDateToString:startDate format:@"LLLL ccc d"];
    NSString *startTimeStr = [Functions convertDateToString:startDate format:@"HH:mm"];
    NSString *endTimeStr = [Functions convertDateToString:endDate format:@"HH:mm"];
    
    _titleLbl.text = _objBook.schedule;
    _dateLbl.text = startDateStr;
    _startTimeLbl.text = startTimeStr;
    _endTimeLbl.text = endTimeStr;
    _roomLbl.text = _objBook.room;
    _buildingLbl.text = _objBook.building;
    _teacherLbl.text = _objBook.trainer;
    _costLbl.text = [NSString stringWithFormat:@"€%ld/slot", (long)scheduleObj.fee_amount];
    if ([_objBook.time_prompt isEqualToString:@""]) {
        _timePromptLbl.text = @"";
    } else {
        _timePromptLbl.text = [NSString stringWithFormat:@"Starts in %@", _objBook.time_prompt];
    }
    
    //Call course_detail api
    courseApi = [NSString stringWithFormat:@"%@%@%@", strMainBaseUrl, COURSE_DETAIL, scheduleObj.course_id];
    [objWebServices callApiWithParameters:nil apiName:courseApi type:GET_REQUEST loader:NO view:self];
}

- (void)parseCourse:(id)responseObject {
    CourseModel *courseObj = [[CourseModel alloc] init];
    
    @try {
    id courseObject = [responseObject valueForKey:@"course"];
    courseObj.course_id = [courseObject valueForKey:@"id"];
    courseObj.category_id = [courseObject valueForKey:@"category_id"];
    courseObj.type_id = [courseObject valueForKey:@"type_id"];
    courseObj.summary = [Functions checkNullValue:[courseObject valueForKey:@"summary"]];
    courseObj.descript = [Functions checkNullValue:[courseObject valueForKey:@"description"]];
    NSString *bannerUrl = [Functions checkNullValue:[courseObject valueForKey:@"banner"]];
    courseObj.banner = [NSString stringWithFormat:@"%@media/photos/courses/%@", strMainBaseUrl, bannerUrl];
    
    //Fill data
    [_imageView sd_setImageWithURL:[NSURL URLWithString:courseObj.banner]];
        if ([bannerUrl isEqualToString:@""]) {
            CGRect frame = self.detailView.frame;
            frame.origin.y = _titleView.frame.size.height;
            self.detailView.frame = frame;
        }
    NSAttributedString *summaryAttributedString = [[NSAttributedString alloc]
                                                   initWithData: [courseObj.summary dataUsingEncoding:NSUnicodeStringEncoding]
                                                   options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                   documentAttributes: nil
                                                   error: nil
                                                   ];
    _summaryTxt.attributedText = summaryAttributedString;
    [_summaryTxt setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
//    _summaryTxtView.text = courseObj.summary;
//    _detailTxtView.text = courseObj.descript;
    
    _objBook.title = _objBook.schedule;
    _objBook.summary = courseObj.summary;
    _objBook.content = courseObj.descript;
    
    //Set course type
    for (CategoryModel *obj in appDelegate.categoryArray) {
        if ([obj.category_id isEqualToString:courseObj.category_id]) {
            _courseTypeLbl.text = obj.category;
        }
    }
    
    if ([courseObj.summary isEqualToString:@""] && [courseObj.descript isEqualToString:@""]) {
        _readMoreBtn.hidden = YES;
        _viewSummaryBtn.hidden = YES;
    }
    }
    @catch (NSException *exception) {
        [Functions showAlert:@"ClassDetail:parseCourse" message:exception.reason];
    }
}

- (void)showGrindView {
    _grindView.hidden = NO;
    _costLbl.hidden = NO;
    _costDesLbl.hidden = NO;
    
    _revisionView.hidden = YES;
}

- (void)showRevisionView {
    _grindView.hidden = YES;
    _costLbl.hidden = YES;
    _costDesLbl.hidden = YES;
    
    _revisionView.hidden = NO;
}

- (void)viewSlideInFromBottomToTop:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:scheduleApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseSchedule:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:courseApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseCourse:responseDict];
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
    return [topicArray count];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return _width-10;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
        view.backgroundColor = UIColor.clearColor;
        view.contentMode = UIViewContentModeCenter;
        if (_selectedIndex == index)
            label = [[UILabel alloc] initWithFrame:CGRectMake(-_width*0.1, _height*0.1, _width*1.2, _height*0.8)];
        else
            label = [[UILabel alloc] initWithFrame:CGRectMake(_width*0.1, _height*0.2, _width*0.8, _height*0.6)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.font = [UIFont fontWithName:@"Roboto-Light" size:20];
        label.tag = 1;
        
        [view addSubview:label];
    } else {
        label = (UILabel *)[view viewWithTag:1];
    }
    
    if(_selectedIndex == index) {
        label.backgroundColor = UIColor.whiteColor;
        label.textColor = UIColor.blackColor;
    } else {
        label.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        label.textColor = UIColor.grayColor;
        label.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    }
    
    [Functions makeBorderView:label];
    [Functions makeShadowView:label];
    TopicModel *topicItem = [topicArray objectAtIndex:index];
    label.text = topicItem.name;
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing) {
        return value * 1.3;
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
        [_pageControll setCurrentPage:_selectedIndex];
        [_carousel reloadData];
    }
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    _selectedIndex = carousel.currentItemIndex;
    [_pageControll setCurrentPage:_selectedIndex];
    [_carousel reloadData];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if(_isClicked)
    {
        _isClicked = FALSE;
        _selectedIndex = carousel.currentItemIndex;
        [_pageControll setCurrentPage:_selectedIndex];
        [_carousel reloadData];
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    _isClicked = TRUE;
}

#pragma mark - IBAction
- (IBAction)OnGetDirectionClicked:(id)sender {
    MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
    controller.locationId = locationId;
    [self presentViewController:controller animated:YES completion:nil];
    //[self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)OnReadmoreClicked:(id)sender {
//    _contentView.hidden = NO;
//    [self viewSlideInFromBottomToTop:_contentView];
    NewsMoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newsmore"];
    controller.newsObj = _objBook;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)OnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnPageChanged:(id)sender {
    _selectedIndex = _pageControll.currentPage;
    [_carousel scrollToItemAtIndex:_selectedIndex animated:YES];
    [_carousel reloadData];
}
@end
