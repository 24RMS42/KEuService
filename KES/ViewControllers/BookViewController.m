//
//  BookViewController.m
//  KES
//
//  Created by matata on 2/19/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController ()

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Init
    appDelegate.topicArray = [[NSMutableArray alloc] init];
    appDelegate.locationArray = [[NSMutableArray alloc] init];
    appDelegate.categoryArray = [[NSMutableArray alloc] init];
    appDelegate.subjectArray = [[NSMutableArray alloc] init];
    
    [_TopView setBackgroundColor:[UIColor colorWithHex:COLOR_PRIMARY]];
    [self setForm];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    topicApi = [NSString stringWithFormat:@"%@%@", BASE_URL, COURSE_TOPICS];
    locationApi = [NSString stringWithFormat:@"%@%@", BASE_URL, COURSE_LOCATIONS];
    categoryApi = [NSString stringWithFormat:@"%@%@", BASE_URL, COURSE_CATEGORY];
    subjectApi = [NSString stringWithFormat:@"%@%@", BASE_URL, COURSE_SUBJECTS];
    [objWebServices callApiWithParameters:nil apiName:topicApi type:GET_REQUEST loader:NO view:self];
    [objWebServices callApiWithParameters:nil apiName:locationApi type:GET_REQUEST loader:NO view:self];
    [objWebServices callApiWithParameters:nil apiName:categoryApi type:GET_REQUEST loader:NO view:self];
    [objWebServices callApiWithParameters:nil apiName:subjectApi type:GET_REQUEST loader:NO view:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewUpBook:)
                                                 name:NOTIFICATION_UPBOOK
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setForm
{
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    UIViewController *upController = [self.storyboard instantiateViewControllerWithIdentifier:@"upbook"];
    upController.title = @"Upcoming";
    UIViewController *pastController = [self.storyboard instantiateViewControllerWithIdentifier:@"pastbook"];
    pastController.title = @"Past";
    [controllerArray addObject:upController];
    [controllerArray addObject:pastController];
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithHex:COLOR_PRIMARY],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithHex:0xFFFFFF],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithHex:COLOR_THIRD],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor colorWithHex:0x99e8f8],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"Roboto-Regular" size:PageMenuOptionMenuItemFont],
                                 CAPSPageMenuOptionMenuHeight: @(PageMenuOptionMenuHeight),
                                 CAPSPageMenuOptionSelectionIndicatorHeight : @(PageMenuOptionSelectionIndicatorHeight),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionMenuItemWidth: @(SCREEN_WIDTH/2 - 30)
                                 };
    
    CGFloat offset = [Functions isiPhoneX] ? 20 : 0;
    _pagemenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, _TopView.frame.origin.y + _TopView.frame.size.height + offset, self.view.frame.size.width, self.view.frame.size.height) options:parameters];//Add 20 for timing issue
    
    [self.view addSubview:_pagemenu.view];
}

- (void)viewUpBook:(NSNotification*)notification {
    NSInteger currentIndex = _pagemenu.currentPageIndex;
    if (currentIndex > 0) {
        [_pagemenu moveToPage:currentIndex - 1];
    }
}

- (void)parseTopics:(id)responseObject {
    id topicArray = [responseObject valueForKey:@"topics"];
    for (NSDictionary *obj in topicArray) {
        TopicModel *topicObj = [[TopicModel alloc] init];
        topicObj.name = [obj valueForKey:@"name"];
        topicObj.descript = [obj valueForKey:@"description"];
        
        [appDelegate.topicArray addObject:topicObj];
    }
    NSLog(@"------- topic array count:%lu", (unsigned long)appDelegate.topicArray.count);
}

- (void)parseLocation:(id)responseObject {
    id locationArray = [responseObject valueForKey:@"locations"];
    for (NSDictionary *obj in locationArray) {
        LocationModel *locationObj = [[LocationModel alloc] init];
        locationObj.location_id = [Functions checkNullValue:[obj valueForKey:@"id"]];
        locationObj.parent_id = [Functions checkNullValue:[obj valueForKey:@"parent_id"]];
        locationObj.name = [obj valueForKey:@"name"];
        locationObj.directions = [Functions checkNullValue:[obj valueForKey:@"directions"]];
        locationObj.lat = 52.662529;//[[obj valueForKey:@"lat"] floatValue];
        locationObj.lng = -8.6306817;//[[obj valueForKey:@"lng"] floatValue];
        
        [appDelegate.locationArray addObject:locationObj];
    }
    NSLog(@"------- location array count:%lu", (unsigned long)appDelegate.locationArray.count);
}

- (void)parseCategories:(id)responseObject {
    id categoryArray = [responseObject valueForKey:@"categories"];
    for (NSDictionary *obj in categoryArray) {
        CategoryModel *categoryObj = [[CategoryModel alloc] init];
        categoryObj.category_id = [obj valueForKey:@"id"];
        categoryObj.category = [obj valueForKey:@"category"];
        
        [appDelegate.categoryArray addObject:categoryObj];
    }
    NSLog(@"------- category array count:%lu", (unsigned long)appDelegate.categoryArray.count);
}

- (void)parseSubjects:(id)responseObject {
    id subjectArray = [responseObject valueForKey:@"subjects"];
    for (NSDictionary *obj in subjectArray) {
        SubjectModel *subjectObj = [[SubjectModel alloc] init];
        subjectObj.subject_id = [obj valueForKey:@"id"];
        subjectObj.color = [obj valueForKey:@"color"];
        subjectObj.name = [obj valueForKey:@"name"];
        subjectObj.cycle = [Functions checkNullValue:[obj valueForKey:@"cycle"]];
        
        [appDelegate.subjectArray addObject:subjectObj];
    }
    NSLog(@"------- subject array count:%lu", (unsigned long)appDelegate.subjectArray.count);
}

- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:topicApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseTopics:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:locationApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseLocation:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:categoryApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseCategories:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:subjectApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseSubjects:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

@end
