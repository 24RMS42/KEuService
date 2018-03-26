//
//  Utility.h
//  KES
//
//  Created by matata on 2/9/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface Utility : NSObject

+ (instancetype)sharedInstance;
- (void)ShowProgress;
- (void)hideProgress;

@end
