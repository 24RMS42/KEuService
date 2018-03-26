//
//  AppDelegate.h
//  KES
//
//  Created by matata on 2/9/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactData.h"
@import HockeySDK;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *topicArray;
@property (strong, nonatomic) NSMutableArray *locationArray;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *subjectArray;
@property (strong, nonatomic) NSMutableArray *countryArray;
@property (strong, nonatomic) NSMutableArray *countyArray;
@property (strong, nonatomic) NSMutableArray *nationalityArray;
@property (strong, nonatomic) NSMutableArray *schoolArray;
@property (strong, nonatomic) NSMutableArray *yearArray;
@property (strong, nonatomic) NSMutableArray *academicYearArray;
@property (strong, nonatomic) NSMutableArray *preferenceTypeArray;
@property (strong, nonatomic) ContactData *contactData;

@property (strong, nonatomic) NSMutableArray *UserArray;
@property (strong, nonatomic) NSMutableArray *UserEmailArray;
@property (nonatomic, strong) NSString *logAsUser;
@property (nonatomic, strong) NSString *logOriginUser;
@property (nonatomic, assign) BOOL isLogAs;

@end

