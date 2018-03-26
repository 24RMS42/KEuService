//
//  SubjectViewController.h
//  KES
//
//  Created by matata on 3/20/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"
#import "AppDelegate.h"

@interface SubjectViewController : UIViewController<WebServicesDelegate>
{
    WebServices *objWebServices;
    NSString *updateProfileApi;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *levelSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *accountingSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *agSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mathSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *artSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *biologSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *businessSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *chemistrySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dcgSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *englishSegment;

@property (weak, nonatomic) IBOutlet UISwitch *accountingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *agSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mathSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *artSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *biologySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *businessSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *chemistrySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dcgSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *englishSwitch;

- (IBAction)OnBackClicked:(id)sender;
- (IBAction)switchChanged:(id)sender;

@end
