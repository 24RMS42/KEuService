//
//  UpEventViewController.m
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "UpBookViewController.h"
#import "CircleProgressBar.h"

@interface UpBookViewController ()

@end

@implementation UpBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (strMainBaseUrl.length == 0) {
        strMainBaseUrl = BASE_URL;
    }

    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    offset = 0;
    originArray = [[NSMutableArray alloc]init];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [_SearchField addTarget:self
                  action:@selector(textFieldDidChanged:)
        forControlEvents:UIControlEventEditingChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startSearch:)
                                                 name:NOTIFICATION_SEARCH_BOOK
                                               object:nil];
    _bookHelplbl.text = @"Please contact us to schedule some.";
    bookSearchApiEnd = IS_STUDENT ? BOOK_SEARCH : RC_TIMESLOTS;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)refreshTable {
    
    _SearchField.text = @"";
    [_SearchButton setHidden:NO];
    [_CancelButton setHidden:YES];
    originArray = [[NSMutableArray alloc]init];
    offset = 0;
    _whileSearch = NO;
    
    [self searchEvents:NO];
}

- (void)startSearch:(NSNotification *)notification {
    originArray = [[NSMutableArray alloc]init];
    [self searchEvents:YES];
}

- (void)searchEvents:(BOOL)withStatusBar {
    
    NSString *currentDateStr = [Functions convertDateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    bookApi = [NSString stringWithFormat:@"%@%@?after=%@&booked=1", strMainBaseUrl, bookSearchApiEnd, currentDateStr];
    bookApi = [bookApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [objWebServices callApiWithParameters:nil apiName:bookApi type:GET_REQUEST loader:withStatusBar view:self];
}

- (void)searchEventsByKeyword:(NSString*)keyword{
    NSString *currentDateStr = [Functions convertDateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    bookFilterApi = [NSString stringWithFormat:@"%@%@?after=%@&keyword=%@&booked=1", strMainBaseUrl, bookSearchApiEnd, currentDateStr, keyword];
    bookFilterApi = [bookFilterApi stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [objWebServices callApiWithParameters:nil apiName:bookFilterApi type:GET_REQUEST loader:NO view:self];
}

- (void)parseBooksArray:(id)responseObject
{
    if (IS_STUDENT) {
        NSArray* booksObject = [responseObject valueForKey:@"bookings"];
        for (NSDictionary *obj in booksObject) {
            @try {
                NewsModel *bookModel = [[NewsModel alloc] init];
                bookModel.schedule_id = [Functions checkNullValue:[obj valueForKey:@"schedule_id"]];
                bookModel.schedule = [Functions checkNullValue:[obj valueForKey:@"schedule"]];
                bookModel.room = [Functions checkNullValue:[obj valueForKey:@"room"]];
                bookModel.building = [Functions checkNullValue:[obj valueForKey:@"building"]];
                bookModel.trainer = [Functions checkNullValue:[obj valueForKey:@"trainer"]];
                bookModel.course = [Functions checkNullValue:[obj valueForKey:@"course"]];
                bookModel.start_date = [Functions checkNullValue:[obj valueForKey:@"start_date"]];
                bookModel.end_date = [Functions checkNullValue:[obj valueForKey:@"end_date"]];
                bookModel.profile_img_url = [Functions checkNullValue:[obj valueForKey:@"profile_image_url"]];
                bookModel.color = [Functions convertToHexColor:[Functions checkNullValue:[obj valueForKey:@"color"]]];
                
                NSArray *timeSlots = [obj objectForKey:@"timeslots"];
                NSDictionary *slotObj = [timeSlots objectAtIndex:0];
                bookModel.slot_start_date = [slotObj valueForKey:@"start_date"];
                bookModel.slot_end_date = [slotObj valueForKey:@"end_date"];
                
                NSDate *startDateTime = [Functions convertStringToDate:bookModel.slot_start_date format:MAIN_DATE_FORMAT];
                NSString *startTimeStr = [Functions convertDateToString:startDateTime format:@"ccc d LLL yyyy @ h:mm a"];
                bookModel.format_start_date = startTimeStr;
                bookModel.time_prompt = [startDateTime timeAgo];
                
                [bookArray addObject:bookModel];
            }
            @catch (NSException *exception) {
                [Functions showAlert:@"UpBookView:parseBooksArray" message:exception.reason];
            }
        }
    } else {
        NSArray* timeSlotObject = [responseObject valueForKey:@"timeslots"];
        for (NSDictionary *obj in timeSlotObject) {
            @try {
                NewsModel *bookModel = [[NewsModel alloc] init];
                bookModel.timeslot_id = [Functions checkNullValue:[obj valueForKey:@"id"]];
                bookModel.schedule_id = [Functions checkNullValue:[obj valueForKey:@"schedule_id"]];
                bookModel.schedule = [Functions checkNullValue:[obj valueForKey:@"schedule"]];
                bookModel.room = [Functions checkNullValue:[obj valueForKey:@"room"]];
                bookModel.building = [Functions checkNullValue:[obj valueForKey:@"building"]];
                bookModel.trainer = [Functions checkNullValue:[obj valueForKey:@"trainer"]];
                bookModel.trainer_id = [Functions checkNullValue:[obj valueForKey:@"trainer_id"]];
                bookModel.course = [Functions checkNullValue:[obj valueForKey:@"course"]];
                bookModel.start_date = [Functions checkNullValue:[obj valueForKey:@"datetime_start"]];
                bookModel.end_date = [Functions checkNullValue:[obj valueForKey:@"datetime_end"]];
                bookModel.profile_img_url = [Functions checkNullValue:[obj valueForKey:@"profile_image_url"]];
                bookModel.color = [Functions convertToHexColor:[Functions checkNullValue:[obj valueForKey:@"color"]]];
                bookModel.max_capacity = [Functions checkNullValue:[obj valueForKey:@"max_capacity"]];
                bookModel.booking_count = [Functions checkNullValue:[obj valueForKey:@"booking_count"]];
                
                if ([bookModel.max_capacity isEqualToString:@""]) {
                    bookModel.max_capacity = @"1";
                }
                
                NSDate *startDateTime = [Functions convertStringToDate:bookModel.start_date format:MAIN_DATE_FORMAT];
                NSString *startTimeStr = [Functions convertDateToString:startDateTime format:@"ccc d LLL yyyy @ h:mm a"];
                bookModel.format_start_date = startTimeStr;
                bookModel.time_prompt = [startDateTime timeAgo];
                
                [bookArray addObject:bookModel];
            }
            @catch (NSException *exception) {
                [Functions showAlert:@"UpBookView:parseBooksArray" message:exception.reason];
            }
        }
    }
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:bookApi])
    {
        if(responseDict != nil)
        {
            [refreshControl endRefreshing];
            bookArray = [[NSMutableArray alloc] init];
            
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self parseBooksArray:responseDict];
                
                [originArray addObjectsFromArray:bookArray];
                
                bookArray = [[NSMutableArray alloc] init];
                [bookArray addObjectsFromArray:originArray];
                NSLog(@"======== upbook count===%lu", (unsigned long)bookArray.count);
                
                [self.tableView reloadData];
                
                if ([bookArray count] == 0) {
                    [self.tableView setHidden:YES];
                    [self.SearchView setHidden:YES];
                } else {
                    [self.tableView setHidden:NO];
                    [self.SearchView setHidden:NO];
                }
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
    else if ([apiName isEqualToString:bookFilterApi])
    {
        if(responseDict != nil)
        {
            bookArray = [[NSMutableArray alloc] init];
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                if (_whileSearch == NO) {
                    return;
                }
                
                [self parseBooksArray:responseDict];
                [self.tableView reloadData];
            }
        }
    }
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([bookArray count] == 0) {
        return 0;
    }
    else
        return [bookArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BookCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImageView *headerImg = (UIImageView*)[cell viewWithTag:10];
    UILabel *titlelbl = (UILabel*)[cell viewWithTag:21];
    UILabel *timelbl = (UILabel*)[cell viewWithTag:22];
    UILabel *locationlbl = (UILabel*)[cell viewWithTag:23];
    UILabel *personlbl = (UILabel*)[cell viewWithTag:24];
    UILabel *timePromptlbl = (UILabel*)[cell viewWithTag:26];
    
    CircleProgressBar *progBar = (CircleProgressBar*) [cell viewWithTag:11];
    [progBar setProgressBarWidth:3];
    [progBar setProgressBarTrackColor: [UIColor colorWithHex:COLOR_GRAY]];
    [progBar setProgressBarProgressColor: [UIColor colorWithHex:COLOR_PRIMARY]];
    [progBar setStartAngle:-90];
    progBar.hintTextColor = [UIColor colorWithHex:COLOR_PRIMARY];
    progBar.hintTextFont = [UIFont fontWithName:@"Roboto-Regular" size:14];
    progBar.hintViewBackgroundColor = [UIColor clearColor];
    
    [headerImg setHidden:!IS_STUDENT];
    [progBar setHidden:IS_STUDENT];
    
    UILabel *colorlbl = (UILabel*)[cell viewWithTag:27];
    UIFont *titleFont = [UIFont fontWithName:@"Roboto-Medium" size:19.0f];
    NSDictionary *userAttributes = @{NSFontAttributeName: titleFont,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    
    @try {
        if ([bookArray count] > 0) {
            NewsModel *item = [bookArray objectAtIndex:indexPath.row];
            [Functions makeRoundImageView:headerImg];
            [headerImg sd_setImageWithURL:[NSURL URLWithString:item.profile_img_url] placeholderImage:[UIImage imageNamed:@"person.png"]];
            titlelbl.text = item.course;
            locationlbl.text = [NSString stringWithFormat:@"%@, %@", item.building, item.room];
            timelbl.text = item.format_start_date;
            if (IS_STUDENT) {
                personlbl.text = item.trainer;
            } else {
                personlbl.text = [NSString stringWithFormat:@"%@/%@ (%@ bookings)", item.booking_count, item.max_capacity, item.max_capacity];
            }
            timePromptlbl.text = item.time_prompt;
            [progBar setProgress:item.booking_count.floatValue/item.max_capacity.floatValue animated:true];

            CGSize titleSize = [item.course sizeWithAttributes:userAttributes];
            CGRect frame = colorlbl.frame;
            frame.size = CGSizeMake(titleSize.width, 1);
            colorlbl.frame = frame;
            colorlbl.backgroundColor = item.color;
        }
    }
    @catch (NSException *exception) {
        [Functions showAlert:@"UpBookView:cellForRowAtIndexPath" message:exception.reason];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([bookArray count] > 0 && !_whileSearch) { //disable pagination while search
//        if(indexPath.row >= (offset + 9) && indexPath.row == bookArray.count-1)
//        {
//            NSLog(@"row:%ld", (long)indexPath.row);
//            offset += 10;
//            [self searchEvents:YES];
//        }
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *itemObj = [bookArray objectAtIndex:indexPath.row];
    NSDictionary* info = @{@"itemObj": itemObj,
                           @"from": @"after"
                           };
    NSString *notiName = IS_STUDENT ? NOTI_CLASS_DETAIL : NOTI_BOOK_DETAIL;
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:self userInfo:info];
}

#pragma mark - IBAction
- (IBAction)OnCreateEventClicked:(id)sender {
    [self openURl:CREATE_BOOK_URL];
}

- (IBAction)OnSearchClicked:(id)sender {
}

- (IBAction)OnCancelClicked:(id)sender {
    _SearchField.text = @"";
    [self textFieldDidChanged:_SearchField];
}

- (void)textFieldDidChanged: (UITextField*)textField
{
    bookArray = [[NSMutableArray alloc]init];
    
    if (_SearchField.text.length == 0) {
        _whileSearch = NO;
        [bookArray addObjectsFromArray:originArray];
        [_SearchButton setHidden:NO];
        [_CancelButton setHidden:YES];
    }
    else
    {
        _whileSearch = YES;
        [self searchEventsByKeyword:_SearchField.text];
        [_SearchButton setHidden:YES];
        [_CancelButton setHidden:NO];
    }
    
    [self.tableView reloadData];
}

- (void)openURl:(NSString*)url {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}
@end
