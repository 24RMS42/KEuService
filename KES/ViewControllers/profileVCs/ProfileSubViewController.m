//
//  ProfileSubViewController.m
//  KES
//
//  Created by Piglet on 03.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "ProfileSubViewController.h"

@interface ProfileSubViewController ()

@end

@implementation ProfileSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    controllerArray = [NSMutableArray array];
    [self addSubVC];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectIndex:)
                                                 name:NOTI_SELECT_INDEX
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Functions
- (void) selectIndex:(NSNotification *) notification
{
    NSDictionary* info = notification.userInfo;
    NSString *selectedIndex = [info objectForKey:NOTI_SELECT_INDEX];
    [self.pagemenu moveToPage:[selectedIndex integerValue]];
}

- (void) addSubVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    PProfileViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"PProfileViewController"];
    vc1.delegate = self;
    [controllerArray addObject:vc1];
    
    PAddressViewController *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"PAddressViewController"];
    vc2.delegate = self;
    [controllerArray addObject:vc2];
    
    PFamilyViewController *vc3 = [storyboard instantiateViewControllerWithIdentifier:@"PFamilyViewController"];
    vc3.delegate = self;
    [controllerArray addObject:vc3];
    
    PNotiViewController *vc4 = [storyboard instantiateViewControllerWithIdentifier:@"PNotiViewController"];
    vc4.delegate = self;
    [controllerArray addObject:vc4];

    PEducationViewController *vc5 = [storyboard instantiateViewControllerWithIdentifier:@"PEducationViewController"];
    vc5.delegate = self;
    //[controllerArray addObject:vc5];
    
    PPasswordViewController *vc6 = [storyboard instantiateViewControllerWithIdentifier:@"PPasswordViewController"];
    vc6.delegate = self;
    [controllerArray addObject:vc6];

    PEmailViewController *vc7 = [storyboard instantiateViewControllerWithIdentifier:@"PEmailViewController"];
    vc7.delegate = self;
    //[controllerArray addObject:vc7];

    PPreferencesViewController *vc8 = [storyboard instantiateViewControllerWithIdentifier:@"PPreferencesViewController"];
    vc8.delegate = self;
    //[controllerArray addObject:vc8];
    
    
    NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorWidth: @(8),
                                 CAPSPageMenuOptionMenuHeight: @(0.0),
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor blackColor],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor lightGrayColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor blueColor],
                                 CAPSPageMenuOptionSelectionIndicatorHeight: @(0.0),
                                 CAPSPageMenuOptionMenuItemFont : [UIFont systemFontOfSize:14.0f],
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @YES,
                                 CAPSPageMenuOptionCenterMenuItems : @YES,
                                 CAPSPageMenuOptionMenuItemWidthBasedOnTitleTextWidth: @YES
                                 };
    
    // Initialize page menu with controller array, frame, and optional parameters
    self.pagemenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [self.view addSubview:self.pagemenu.view];
    self.pagemenu.delegate = self;
}

- (void) goToView:(NSNotification *) notification
{
    NSDictionary *info = notification.userInfo;
}

#pragma mark - PNotiViewControllerDelegate
- (void) goBackFromNotiViewController
{
    [self.delegate goBackForParentView];
}
#pragma mark - PProfileViewControllerDelegate
- (void) goBackFromPProfileViewController
{
   [self.delegate goBackForParentView];
}

#pragma mark - PEmailViewControllerDelegate
- (void) goBackFromPEmailVC
{
    [self.delegate goBackForParentView];
}

#pragma mark - PAddressViewControllerDelegate

- (void) goBackFromPAddressVC
{
    [self.delegate goBackForParentView];
}

#pragma mark - PPasswordViewControllerDelegate

- (void) goBackFromPasswordVC
{
    [self.delegate goBackForParentView];
}

#pragma mark - PFamilyViewControllerDelegate

- (void) goBackFromPFamilyVC
{
    [self.delegate goBackForParentView];
}
#pragma mark - PPreferencesViewControllerDelegate
- (void) goBackFromPPreferencesVC
{
    [self.delegate goBackForParentView];
}

#pragma mark - PEducationViewControllerDelegate
- (void) goBackFromEducationVC
{
    [self.delegate goBackForParentView];
}
#pragma mark - CAPSPageMenuDelegate

- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index
{
    NSDictionary* info = @{NOTI_SELECT_INDEX: [NSString stringWithFormat:@"%ld", (long)index]};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SELECT_INDEX1 object:self userInfo:info];
}
@end
