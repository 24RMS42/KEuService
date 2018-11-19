//
//  ProfileSubViewController.h
//  KES
//
//  Created by Piglet on 03.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPSPageMenu.h"
#import "PNotiViewController.h"
#import "PProfileViewController.h"
#import "PEmailViewController.h"
#import "PAddressViewController.h"
#import "PPasswordViewController.h"
#import "PFamilyViewController.h"
#import "PEducationViewController.h"
#import "PPreferencesViewController.h"
#import "macro.h"

@protocol ProfileSubViewControllerDelegate
- (void) goBackForParentView;
@end
@interface ProfileSubViewController : UIViewController<CAPSPageMenuDelegate, PNotiViewControllerDelegate, PProfileViewControllerDelegate, PEmailViewControllerDelegate, PAddressViewControllerDelegate, PPasswordViewControllerDelegate, PFamilyViewControllerDelegate, PPreferencesViewControllerDelegate, PEducationViewControllerDelegate>
{
    NSMutableArray *controllerArray;
}
@property (nonatomic, strong) id <ProfileSubViewControllerDelegate> delegate;
@property (nonatomic) CAPSPageMenu *pagemenu;

@end
