//
//  AttendanceMoreViewController.h
//  KES
//
//  Created by Monkey on 7/30/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "WebServices.h"
#import "LSLDatePickerDialog.h"
#import "NSDate+TimeAgo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SessionListViewController.h"

@interface AttendanceMoreViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, WebServicesDelegate> {
    NSMutableArray *totalTimeTableArray, *monthTTArray, *dayTTArray;
    NSMutableDictionary *groupTTDic;
    NSMutableArray *groupTitleArray;

    UITextField *planArrival, *planDeparture, *actualArrival, *actualLate, *expectDeparture, *expectReturn;
    LSLDatePickerDialog *dpDialog;
    UILabel *noPaymentLbl, *arrivedLateLbl, *leftEarlyLbl, *temporaryAbsenseLbl;
    UITextView *noPaymentText, *temporaryAbsenseText;
    WebServices *objWebServices;
    NSString *rcStudentApi, *rcStudentUpdateApi, *rcTimeSlotsApi, *rcDatesApi;
    NSString *lastUsedTimeslotId;
    NSString *shortBookDateLbl;
    StudentModel *currentStudent;
}
@property (nonatomic, strong) NewsModel *objBook;
@property (nonatomic, retain) StudentModel *objStudent;
@property (nonatomic, retain) NSMutableArray *sessionList, *studentList;
@property (nonatomic, retain) NSArray *dateList, *sessionTimeSlotList;
@property (nonatomic, assign) NSInteger currentDateIndex, currentSessionIndex;


@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bookDateLbl;
@property (weak, nonatomic) IBOutlet UIImageView *studentAvatarView;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLbl;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *threeFeatureTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *threeDetailTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *oneFeatureTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *oneDetailViewHeight;
@property (strong, nonatomic) IBOutlet UIView *preApprovedView;
@property (strong, nonatomic) IBOutlet UIView *threeDetailView;
@property (strong, nonatomic) IBOutlet UIView *threeFeatureView;
@property (strong, nonatomic) IBOutlet UIView *oneFeatureView;
@property (strong, nonatomic) IBOutlet UIView *oneDetailView;
@property (strong, nonatomic) IBOutlet UIView *noPaymentView;
@property (strong, nonatomic) IBOutlet UIView *arrivedLateView;
@property (strong, nonatomic) IBOutlet UIView *leftEarlyView;
@property (strong, nonatomic) IBOutlet UIView *temporaryAbsenceView;
@property (strong, nonatomic) IBOutlet UILabel *actualLabel;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)OnBackClicked:(id)sender;
- (IBAction)OnTypeChanged:(id)sender;
- (IBAction)OnPrevClicked:(id)sender;
- (IBAction)OnNextClicked:(id)sender;

@end
