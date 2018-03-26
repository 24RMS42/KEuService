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
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    [button setBackgroundColor:[UIColor colorWithHex:COLOR_PRIMARY]];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    scheduleApi = [NSString stringWithFormat:@"%@%@%@", BASE_URL, SCHEDULE_DETAIL, _objBook.schedule_id];
    [objWebServices callApiWithParameters:nil apiName:scheduleApi type:GET_REQUEST loader:YES view:self];
    
    _carousel.type = iCarouselTypeLinear;
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
    scheduleObj.fee_amount = [[scheduleObject valueForKey:@"fee_amount"] integerValue];
    
    locationId = scheduleObj.location_id;
    
    //Fill data
    if ([scheduleObj.payment_type isEqualToString:@"1"]) {
        [self showGrindView];
    } else
        [self showRevisionView];
    
    NSDate *startDate = [Functions convertStringToDate:_objBook.start_date format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [Functions convertStringToDate:_objBook.end_date format:@"yyyy-MM-dd HH:mm:ss"];
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
    _timePromptLbl.text = [NSString stringWithFormat:@"Starts in %@", _objBook.time_prompt];
    
    //Call course_detail api
    courseApi = [NSString stringWithFormat:@"%@%@%@", BASE_URL, COURSE_DETAIL, scheduleObj.course_id];
    [objWebServices callApiWithParameters:nil apiName:courseApi type:GET_REQUEST loader:NO view:self];
}

- (void)parseCourse:(id)responseObject {
    CourseModel *courseObj = [[CourseModel alloc] init];
    
    id courseObject = [responseObject valueForKey:@"course"];
    courseObj.course_id = [courseObject valueForKey:@"id"];
    courseObj.category_id = [courseObject valueForKey:@"category_id"];
    courseObj.type_id = [courseObject valueForKey:@"type_id"];
    courseObj.summary = [Functions checkNullValue:[courseObject valueForKey:@"summary"]];
    courseObj.descript = [Functions checkNullValue:[courseObject valueForKey:@"description"]];
    courseObj.banner = [NSString stringWithFormat:@"%@media/photos/courses/%@", BASE_URL, [courseObject valueForKey:@"banner"]];
    
    //Fill data
    [_imageView sd_setImageWithURL:[NSURL URLWithString:courseObj.banner]];
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
    return [appDelegate.topicArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 120, 180, 170)];
        UIGraphicsBeginImageContext(view.frame.size);
        [[UIImage imageNamed:@"page.png"] drawInRect:view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        view.backgroundColor = [UIColor colorWithPatternImage:image];

        //((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 170)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [label.font fontWithSize:13];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    TopicModel *topicItem = [appDelegate.topicArray objectAtIndex:index];
    label.text = topicItem.name;
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}

#pragma mark - IBAction
- (IBAction)OnGetDirectionClicked:(id)sender {
    MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
    controller.locationId = locationId;
    [self.navigationController pushViewController:controller animated:YES];
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
@end
