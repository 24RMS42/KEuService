//
//  AppDelegate.m
//  KES
//
//  Created by matata on 2/9/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:COLOR_GRAY]} forState:UIControlStateNormal];
    _topicArray = [[NSMutableArray alloc] init];
    _locationArray = [[NSMutableArray alloc] init];
    _categoryArray = [[NSMutableArray alloc] init];
    _subjectArray = [[NSMutableArray alloc] init];
    _countryArray = [[NSMutableArray alloc] init];
    _countyArray = [[NSMutableArray alloc] init];
    _nationalityArray = [[NSMutableArray alloc] init];
    _UserArray = [[NSMutableArray alloc]init];
    _UserEmailArray = [[NSMutableArray alloc]init];
    _schoolArray = [[NSMutableArray alloc]init];
    _yearArray = [[NSMutableArray alloc]init];
    _academicYearArray = [[NSMutableArray alloc]init];
    _preferenceTypeArray = [[NSMutableArray alloc]init];
    _contactData = [[ContactData alloc] init];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"ed1703e474d74b21ac6efab2de10e685"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    //[[BITHockeyManager sharedHockeyManager].feedbackManager showFeedbackComposeView];
    
    application.applicationSupportsShakeToEdit = YES;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
