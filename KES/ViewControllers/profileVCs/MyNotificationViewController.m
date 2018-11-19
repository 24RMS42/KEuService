//
//  MyNotificationViewController.m
//  KES
//
//  Created by Piglet on 07.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "MyNotificationViewController.h"

@interface MyNotificationViewController ()

@end

@implementation MyNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tbNotifications registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"NotificationTableViewCell"];
    [self addRefreshControl];
    [self setTestData];
    [self performSelector:@selector(hideNoNotiView) withObject:nil afterDelay:3.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Functions
- (void) hideNoNotiView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewNoNoti.alpha = 0;
    }];
    
}
- (void) setTestData
{
    arrNotificationsRecent = [NSMutableArray new];
    arrNotificationsEarlier = [NSMutableArray new];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"imgSample.png" forKey:@"imgUser"];
    [dic setObject:@"Elizabeth Bennet" forKey:@"username"];
    [dic setObject:@"A new booking just completed!" forKey:@"content"];
    [dic setObject:@"See my booking" forKey:@"detail"];
    [dic setObject:@"2d" forKey:@"time"];
    [dic setObject:[NSNumber numberWithBool:true] forKey:@"recent"];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    [dic1 setObject:@"imgSample.png" forKey:@"imgUser"];
    [dic1 setObject:@"Julie Kilmartin" forKey:@"username"];
    [dic1 setObject:@"A booking change has been actioned" forKey:@"content"];
    [dic1 setObject:@"View changes" forKey:@"detail"];
    [dic1 setObject:@"2d" forKey:@"time"];
    [dic1 setObject:[NSNumber numberWithBool:true] forKey:@"recent"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    [dic2 setObject:@"imgSample.png" forKey:@"imgUser"];
    [dic2 setObject:@"Fitzwilliam Darcy" forKey:@"username"];
    [dic2 setObject:@"Pebbles who has Autism will be attending today" forKey:@"content"];
    [dic2 setObject:@"View booking" forKey:@"detail"];
    [dic2 setObject:@"1w" forKey:@"time"];
    [dic2 setObject:[NSNumber numberWithBool:true] forKey:@"recent"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    [dic3 setObject:@"imgSample.png" forKey:@"imgUser"];
    [dic3 setObject:@"Fitzwilliam Darcy" forKey:@"username"];
    [dic3 setObject:@"Happy birthday to Pebbles FlinStone today!" forKey:@"content"];
    [dic3 setObject:@"View booking" forKey:@"detail"];
    [dic3 setObject:@"2w" forKey:@"time"];
    [dic3 setObject:[NSNumber numberWithBool:false] forKey:@"recent"];
    
    [arrNotificationsRecent addObject:dic];
    [arrNotificationsRecent addObject:dic1];
    [arrNotificationsRecent addObject:dic2];
    [arrNotificationsEarlier addObject:dic3];
    
    [self.tbNotifications reloadData];
}
- (void) addRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor colorWithRed:174.0/255 green:174.0/255 blue:174.0/255 alpha:1.0];
    [self.refreshControl addTarget:self
                            action:@selector(pullToRefresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tbNotifications addSubview:self.refreshControl];
}

- (void) pullToRefresh
{
    [self performSelector:@selector(removeRefreshControlForTest) withObject:nil afterDelay:3.0];
}

- (void) removeRefreshControlForTest
{
    [self.refreshControl endRefreshing];
}
#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return arrNotificationsRecent.count;
    }
    else
        return arrNotificationsEarlier.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    UILabel *lblTitle = [[UILabel alloc] init];
    if (section == 0) {
        lblTitle.text = @"Recent";
    }
    else
        lblTitle.text = @"Earlier";
    [lblTitle setFont:[UIFont fontWithName:@"Roboto-Medium" size:16.0f]];
    [lblTitle setTextColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f]];
    lblTitle.frame = CGRectMake(20, 5, 150, 20);
    [view addSubview:lblTitle];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic;
    if (indexPath.section==0) {
        dic = [arrNotificationsRecent objectAtIndex:indexPath.row];
    }
    else
    {
        dic = [arrNotificationsEarlier objectAtIndex:indexPath.row];
    }
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationTableViewCell"];
    [cell configureCell:dic];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
#pragma mark - Actions
- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnSettings:(id)sender {
    NSDictionary* info = @{NOTI_SELECT_INDEX: @"3"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_GO_PROFILE object:self userInfo:info];
}
@end
