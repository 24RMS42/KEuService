//
//  UserMngViewController.h
//  KES
//
//  Created by matata on 11/14/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WebServices.h"

@interface UserMngViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, WebServicesDelegate>
{
    NSUserDefaults *userInfo;
    WebServices *objWebServices;
    NSString *loginAsApi, *loginBackApi, *userListApi;
}

@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (weak, nonatomic) IBOutlet UIButton *userMngButton;
@property (weak, nonatomic) IBOutlet UIButton *logBackButton;

- (IBAction)OnBackClicked:(id)sender;
- (IBAction)UserMngClicked:(id)sender;
- (IBAction)LogBackClicked:(id)sender;
@end
