//
//  Utility.m
//  KES
//
//  Created by matata on 2/9/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (instancetype)sharedInstance
{
    static Utility *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Utility alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

//Show progress
- (void)ShowProgress
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"Please wait.."];
}

//Hide progress
- (void)hideProgress
{
    [SVProgressHUD dismiss];

}

@end
