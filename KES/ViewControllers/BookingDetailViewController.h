//
//  BookingDetailViewController.h
//  KES
//
//  Created by Monkey on 7/27/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "WebServices.h"
#import "iCarousel.h"
#import "MGSwipeTableCell.h"
#import "RadioButton.h"
#import "ClassDetailViewController.h"
#import "SessionListViewController.h"
#import "UIButton+Extensions.h"
#import "NSDate+TimeAgo.h"

@interface BookingDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WebServicesDelegate, MGSwipeTableCellDelegate, UITextFieldDelegate>
{
    NSMutableArray *studentArray, *originArray;
    NSMutableArray *sessionList;
    NSArray *dateList, *sessionTimeSlotList;
    NSMutableArray *totalTimeTableArray, *monthTTArray, *dayTTArray;
    NSMutableDictionary *groupTTDic;
    NSMutableArray *groupTitleArray;
    WebServices *objWebServices;
    NSString *rcStudentApi, *rcStudentFilterApi, *analyticsApi, *rcStudentUpdateApi, *rcTimeSlotsApi, *rcDatesApi;
    NSMutableArray *aryPrice;
    NSInteger currentDateIndex, currentSessionIndex;
    NSString *updatedStudentStatus, *updatedStudentName;
    StudentModel *tempStudentModel;
    NSString *shortBookDateLbl;
    NSString *lastUsedTimeslotId;
}
@property (nonatomic, retain) NewsModel *objBook;
@property (nonatomic, strong) NSString *from;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *bookDateLbl;
@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;
@property (strong, nonatomic) IBOutlet UIView *detailsBackView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (strong, nonatomic) IBOutlet UITableView *attendTableView;

@property (weak, nonatomic) IBOutlet UITextField *SearchField;
@property (weak, nonatomic) IBOutlet UIView *SearchView;
@property (weak, nonatomic) IBOutlet UIButton *SearchButton;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;
@property (nonatomic, assign) bool whileSearch;
@property (strong, nonatomic) IBOutlet UIView *AttendanceView;
@property (strong, nonatomic) IBOutlet UIScrollView *DetailsView;
@property (weak, nonatomic) IBOutlet UIView *detailContentView;
@property (strong, nonatomic) IBOutlet UIView *classReceiptsView;
@property (strong, nonatomic) IBOutlet UIView *rentalDueView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *switchHeight;
@property (strong, nonatomic) IBOutlet UIView *switchView;
@property (strong, nonatomic) IBOutlet UIButton *btnPerDay;
@property (strong, nonatomic) IBOutlet UIButton *btnPerSession;

@property (weak, nonatomic) IBOutlet UIView *viewPresentAndPaid;
@property (weak, nonatomic) IBOutlet UITextField *tfRemaining;
@property (weak, nonatomic) IBOutlet UITextField *tfPaid;
- (IBAction)onBtnClosePresentAndPaid:(id)sender;




- (IBAction)OnTypeChanged:(id)sender;
- (IBAction)OnPrevClicked:(id)sender;
- (IBAction)OnNextClicked:(id)sender;
- (IBAction)OnSearchClicked:(id)sender;
- (IBAction)OnCancelClicked:(id)sender;
@end
