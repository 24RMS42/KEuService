//
//  AnalyticsViewController.h
//  KES
//
//  Created by matata on 2/14/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CreolePriceSelectionView.h"
#import "iCarousel.h"
#import "CustomButton.h"

@interface AnalyticsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WebServicesDelegate, iCarouselDataSource, iCarouselDelegate>
{
    NSMutableArray *categoryArray, *subjectArray, *teacherArray;
    NSMutableArray *filterCategoryArray, *filterSubjectArray, *filterTeacherArray;
    WebServices *objWebServices;
    NSString *analyticsApi, *totalAnalyticsApi, *lastMonthAnalyticsApi;
    NSUserDefaults *userInfo;
    NSString *stat;
    NSMutableArray *aryPrice;
}

@property (weak, nonatomic) IBOutlet UILabel *titleTotalLbl;
@property (weak, nonatomic) IBOutlet UILabel *thisMonthHRLbl;
@property (weak, nonatomic) IBOutlet UILabel *AllHRLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthHRLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statSegment;
@property (weak, nonatomic) IBOutlet CreolePriceSelectionView *timeBarView;
@property (weak, nonatomic) IBOutlet UILabel *noPromptLbl;
@property (weak, nonatomic) IBOutlet CustomButton *viewUpBookingBtn;

@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) UIColor *selectItemColor, *normalItemColor, *selectedTextColor, *normalTextColor;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) BOOL isClicked;
@property (nonatomic, readwrite) float width;
@property (nonatomic, readwrite) float height;
@property (nonatomic, strong) NSString *lastMonthName;

- (IBAction)OnViewUpBookingsClicked:(id)sender;
- (IBAction)OnStatChanged:(id)sender;
@end
