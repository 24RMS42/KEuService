//
//  LeftMenuViewController.h
//  KES
//
//  Created by Monkey on 7/25/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "WebServices.h"

@interface LeftMenuViewController : UIViewController<WebServicesDelegate>
{
    NSUserDefaults *userInfo;
    WebServices *objWebServices;
    NSString *countryApi, *nationalityApi, *schoolApi, *yearApi, *academicYearApi, *preferenceApi, *countyApi, *calendarEventApi, *familyMemberApi, *notificationTypeApi;
}
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnBookCourse;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;


- (IBAction)onBtnTimetable:(id)sender;
- (IBAction)onBtnMessaging:(id)sender;
- (IBAction)onBtnNotification:(id)sender;
- (IBAction)onBtnSubject:(id)sender;
- (IBAction)onBtnSendFeedback:(id)sender;
- (IBAction)onBtnShakeSendFeedback:(id)sender;
- (IBAction)onBtnRateus:(id)sender;
- (IBAction)onBtnHelp:(id)sender;
- (IBAction)onBtnContactUs:(id)sender;
- (IBAction)onBtnShareAppWithFriends:(id)sender;
- (IBAction)onBtnBeABetaTester:(id)sender;
- (IBAction)onBtnAboutMyKes:(id)sender;
- (IBAction)onBtnLogout:(id)sender;
- (IBAction)onBtnBookCourse:(id)sender;



@end
