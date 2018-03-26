//
//  NotiViewController.h
//  KES
//
//  Created by matata on 3/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WebServices.h"
#import "NSMutableDictionary+AddItem.h"

@interface NotiViewController : UIViewController<WebServicesDelegate>
{
    WebServices *objWebServices;
    NSString *updateProfileApi;
}

@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *textMsgSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *phoneCallSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *marketUpdateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *marketReminderSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *marketSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *courseBookSwitch;

- (IBAction)OnBackClicked:(id)sender;
- (IBAction)group1Changed:(id)sender;
- (IBAction)group2Changed:(id)sender;
- (IBAction)childChanged:(id)sender;
@end
