//
//  MainTabViewController.h
//  KES
//
//  Created by matata on 2/13/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATabBarController.h"
#import "UIColor+ColorWithHex.h"
#import "BATabBarItem.h"
#import "macro.h"
#import "NewsModel.h"
#import "LGSideMenuController.h"

@interface MainTabViewController : UIViewController<BATabBarControllerDelegate, LGSideMenuDelegate>

@property (nonatomic, strong) BATabBarController* vc;

@end
