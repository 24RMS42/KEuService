//
//  TimeTableViewController.h
//  KES
//
//  Created by matata on 2/24/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "WebServices.h"

@interface TimeTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WebServicesDelegate>
{
    NSMutableArray *totalTimeTableArray, *monthTTArray;
    WebServices *objWebServices;
    NSString *bookApi;
}
@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *monthListSegment;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UIImageView *crossImgView;
@property (weak, nonatomic) IBOutlet UIView *classDetailView;
@property (weak, nonatomic) IBOutlet UILabel *noMonthItemLbl;
@property (weak, nonatomic) IBOutlet UILabel *noListItemLbl;

- (IBAction)OnMonthListChanged:(id)sender;
- (IBAction)OnPrevClicked:(id)sender;
- (IBAction)OnNextClicked:(id)sender;
- (IBAction)OnLogoClicked:(id)sender;
@end
