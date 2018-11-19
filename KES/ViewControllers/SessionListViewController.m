//
//  SessionListViewController.m
//  KES
//
//  Created by matata on 9/13/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "SessionListViewController.h"

@interface SessionListViewController ()

@end

@implementation SessionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dateLbl.text = _sessionDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_sessionArray count] == 0) {
        return 0;
    }
    else
        return [_sessionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SessionListCell";
    
    UITableViewCell *cell = [self.sessionTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *titlelbl = (UILabel*)[cell viewWithTag:39];
    UILabel *countlbl = (UILabel*)[cell viewWithTag:40];
    if ([_sessionArray count] > 0) {
        if (indexPath.row == _sessionIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        titlelbl.text = _sessionArray[indexPath.row];
    }
    
    if ([_sessionTimeSlotList count] > 0) {
        countlbl.text = [[_sessionTimeSlotList objectAtIndex:indexPath.row] valueForKey:@"booking_count"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.sessionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _sessionIndex = indexPath.row;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [self.sessionTableView reloadData];
    [self OnBackClicked:nil];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (IBAction)OnBackClicked:(id)sender {

    NSString *notificationName = [self.from isEqualToString:@"bookDetail"] ? NOTI_SESSIONED_BOOK : NOTI_SESSIONED_ATTENDANCE;
    NSDictionary* info = @{@"sessionId":@(_sessionIndex)};
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:info];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
