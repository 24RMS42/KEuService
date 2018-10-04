//
//  MainTabViewController.m
//  KES
//
//  Created by matata on 2/13/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "MainTabViewController.h"
#import "LeftMenuViewController.h"
#import "BookingDetailViewController.h"
#import "ClassDetailViewController.h"
#import "HelpViewController.h"
#import "FeedbackViewController.h"

@interface MainTabViewController ()

@property (nonatomic, assign) bool firstTime;
@property (nonatomic, strong) UIButton* menuBtn;
@property (strong, nonatomic) UIViewController *viewController;

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTime = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewClassDetail:)
                                                 name:NOTI_CLASS_DETAIL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewBookDetail:)
                                                 name:NOTI_BOOK_DETAIL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goLogout:)
                                                 name:NOTIFICATION_LOGOUT
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goSettings:)
                                                 name:NOTIFICATION_SETTINGS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goHomeTab:)
                                                 name:NOTI_TAP_LOGO
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goBookings:)
                                                 name:NOTI_GO_BOOK
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goMyProfile:)
                                                 name:NOTI_PROFILE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goHelpPage:)
                                                 name:NOTI_HELP
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goFeedbackPage:)
                                                 name:NOTI_FEEDBACK
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goPreferencePage:)
                                                 name:NOTI_PREFERENCES
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickBetaTester:)
                                                 name:NOTI_BETATESTER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goContactUsPage:)
                                                 name:NOTI_CONTACTUS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goSubjectPage:)
                                                 name:NOTI_SUBJECTS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rateUs:)
                                                 name:NOTI_RATEUS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickShareWithFriends:)
                                                 name:NOTI_SHAREWITHFRIENDS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goTimeTableViewController:)
                                                 name:NOTI_GO_TIMETABLE
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    if(self.firstTime){
        
        BATabBarItem *tabBarItem, *tabBarItem2, *tabBarItem3, *tabBarItem5;
        UIViewController *homeController = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
        UIViewController *analyticsController = [self.storyboard instantiateViewControllerWithIdentifier:@"analytics"];
        UIViewController *bookController = [self.storyboard instantiateViewControllerWithIdentifier:@"book"];
//        UIViewController *timeTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"time_table"];
        UIViewController *settingsController = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
        
        NSMutableAttributedString *option1 = [[NSMutableAttributedString alloc] initWithString:@"Home"];
        [option1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:COLOR_GRAY] range:NSMakeRange(0,option1.length)];
        tabBarItem = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"home"] selectedImage:[UIImage imageNamed:@"home_select"] title:option1];
        
        NSMutableAttributedString *option2 = [[NSMutableAttributedString alloc] initWithString:@"Analytics"];
        [option2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:COLOR_GRAY] range:NSMakeRange(0,option2.length)];
        tabBarItem2 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"analytics"] selectedImage:[UIImage imageNamed:@"analytics_select"] title:option2];
        
        NSMutableAttributedString * option3 = [[NSMutableAttributedString alloc] initWithString:@"Bookings"];
        [option3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:COLOR_GRAY] range:NSMakeRange(0,option3.length)];
        tabBarItem3 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"book"] selectedImage:[UIImage imageNamed:@"book_select"] title:option3];
        
//        NSMutableAttributedString * option4 = [[NSMutableAttributedString alloc] initWithString:@"Timetable"];
//        [option4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:COLOR_GRAY] range:NSMakeRange(0,option4.length)];
//        tabBarItem4 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"timetable"] selectedImage:[UIImage imageNamed:@"timetable_select"] title:option4];
        
        NSMutableAttributedString * option5 = [[NSMutableAttributedString alloc] initWithString:@"Settings"];
        [option5 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:COLOR_GRAY] range:NSMakeRange(0,option5.length)];
        tabBarItem5 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"settings"] selectedImage:[UIImage imageNamed:@"settings_select"] title:option5];
        
        self.vc = [[BATabBarController alloc] init];
        self.vc.tabBarBackgroundColor = [UIColor colorWithHex:0xebebeb];
        self.vc.tabBarItemStrokeColor = [UIColor colorWithHex:COLOR_THIRD];
        self.vc.tabBarItemLineWidth = 1.5;
        
        //Hides the tab bar when true
//        self.vc.hidesBottomBarWhenPushed = NO;
//        self.vc.tabBar.hidden = NO;
        
        self.vc.viewControllers = @[homeController,analyticsController,bookController];
        self.vc.tabBarItems = @[tabBarItem,tabBarItem2,tabBarItem3];
        [self.vc setSelectedViewController:homeController animated:NO];
        
        self.vc.delegate = self;
        [self.view addSubview:self.vc.view];
        self.firstTime = NO;
        
        self.menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, [Functions isiPhoneX] ? 55 : 35, 25, 17)];
        [self.menuBtn setImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
        [self.menuBtn addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.menuBtn];
    }
}

- (void)toggleMenu:(id)sender {
    [appDelegate.sideMenuController toggleLeftViewAnimated];
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [UIView animateWithDuration: .2 animations:^{
        _menuBtn.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }];
}

- (void)willHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [UIView animateWithDuration: .2 animations:^{
        _menuBtn.transform = CGAffineTransformIdentity;
    }];
    
    LeftMenuViewController* leftMenuVC = (LeftMenuViewController*)appDelegate.sideMenuController.leftViewController;
    leftMenuVC.backView.alpha = 0;
    leftMenuVC.profileView.alpha = 0;
    [leftMenuVC.scrollView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:false];
}

- (void) hideLeftView
{
    [appDelegate.sideMenuController toggleLeftViewAnimated];
}

- (void)tabBarController:(BATabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSString *vcName = NSStringFromClass(viewController.class);
    if ([vcName isEqualToString:@"AnalyticsViewController"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RETRIEVE_ANALYTICS object:self];
    } else if ([vcName isEqualToString:@"BookViewController"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SEARCH_BOOK object:self];
    }
//    else if ([vcName isEqualToString:@"TimeTableViewController"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RETRIEVE_TIMETABLE object:self];
//    }
}

- (void)viewClassDetail:(NSNotification*)notification {
    if ([[notification name] isEqualToString:NOTI_CLASS_DETAIL])
    {
        NSDictionary* info = notification.userInfo;
        NewsModel *itemObj = [info valueForKey:@"itemObj"];
        ClassDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"class_detail"];
        controller.objBook = itemObj;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)viewBookDetail:(NSNotification*)notification {
    if ([[notification name] isEqualToString:NOTI_BOOK_DETAIL])
    {
        NSDictionary* info = notification.userInfo;
        NewsModel *itemObj = [info valueForKey:@"itemObj"];
        NSString *from = [info valueForKey:@"from"];
        BookingDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"booking_detail"];
        controller.objBook = itemObj;
        controller.from = from;
        [controller setModalPresentationStyle:UIModalPresentationOverCurrentContext];
//        [self.navigationController pushViewController:controller animated:YES];
        [self presentViewController:controller animated:true completion:nil];
    }
}

- (void)goLogout:(NSNotification *) notification {
    [self hideLeftView];
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setObject:@"no" forKey:KEY_REMEMBER];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goSettings:(NSNotification *) notification {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goHomeTab:(NSNotification *) notification{
    [self.vc.tabBar selectedTabItem:0 animated:YES];
    [[self.vc.tabBarItems objectAtIndex:3] hideOutline];
}

- (void)goBookings:(NSNotification *) notification{
    [self.vc.tabBar selectedTabItem:2 animated:YES];
    [[self.vc.tabBarItems objectAtIndex:1] hideOutline];
}

- (void)goMyProfile:(NSNotification *) notification {
    [self hideLeftView];
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goHelpPage:(NSNotification *) notification {
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    NSDictionary* info = notification.userInfo;
    HelpViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"help"];
    controller.info = [info valueForKey:@"info"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goFeedbackPage:(NSNotification *) notification {
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    NSDictionary* info = notification.userInfo;
    UIImage *screenshot = [info valueForKey:@"info"];
    FeedbackViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"feedback"];
    controller.screenshot = screenshot;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goPreferencePage:(NSNotification *) notification {
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goContactUsPage:(NSNotification *) notification {
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"contactus"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) clickBetaTester:(NSNotification *) notification
{
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    [self openURl:KES_BOARD];
}

- (void) goTimeTableViewController:(NSNotification *) notification
{
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"time_table"];
    [self.navigationController pushViewController:controller animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RETRIEVE_TIMETABLE object:self];
    });
    
}

- (void) clickShareWithFriends:(NSNotification *) notification
{
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    [self share];
}

- (void)goSubjectPage:(NSNotification *) notification {
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"subject"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) rateUs:(NSNotification *) notification
{
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    [self rateUS];
}

- (void)openURl:(NSString*)url {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}

- (void)share
{
    NSArray* sharedObjects=[NSArray arrayWithObjects:@"Here is app link", nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                     //UIActivityTypeMessage,
                                                     //UIActivityTypeMail,
                                                     //UIActivityTypePrint,
                                                     //UIActivityTypeCopyToPasteboard,
                                                     //UIActivityTypeAssignToContact,
                                                     //UIActivityTypeSaveToCameraRoll,
                                                     //UIActivityTypeAddToReadingList,
                                                     //UIActivityTypePostToFlickr,
                                                     //UIActivityTypePostToVimeo,
                                                     //UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypeAirDrop,
                                                     //UIActivityTypePostToFacebook
                                                     ];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}
- (void)rateUS {
    NSString *iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
    NSString *iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
    
    NSString *url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, APP_STORE_ID];
    [self openURl:url];
}
@end
