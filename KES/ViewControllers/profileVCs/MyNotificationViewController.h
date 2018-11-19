//
//  MyNotificationViewController.h
//  KES
//
//  Created by Piglet on 07.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationTableViewCell.h"
#import "macro.h"

@interface MyNotificationViewController : UIViewController
{
    NSMutableArray *arrNotificationsRecent;
    NSMutableArray *arrNotificationsEarlier;
}
@property (weak, nonatomic) IBOutlet UIView *viewNoNoti;

@property (weak, nonatomic) IBOutlet UITableView *tbNotifications;
@property (nonatomic) UIRefreshControl *refreshControl;

- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnSettings:(id)sender;



@end
