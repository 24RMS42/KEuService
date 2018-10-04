//
//  Functions.h
//  KES
//
//  Created by matata on 11/23/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "JVFloatLabeledTextField.h"
#import "macro.h"
#import "AFNetworking.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+ColorWithHex.h"
#import "TSMessage.h"
#import "NewsModel.h"
#import "AnalyticsModel.h"
#import "ScheduleModel.h"
#import "CourseModel.h"
#import "TopicModel.h"
#import "LocationModel.h"
#import "CategoryModel.h"
#import "TimetableModel.h"
#import "UserModel.h"
#import "SubjectModel.h"
#import "CountryModel.h"
#import "SchoolModel.h"
#import "YearModel.h"
#import "AcademicYearModel.h"
#import "ContactData.h"
#import "ContactNotification.h"
#import "PreferenceType.h"
#import "CalendarEvent.h"
#import "StudentModel.h"
#import "AppDelegate.h"

extern NSString *strMainBaseUrl;

@interface Functions : NSObject

+ (Functions *)sharedInstance;
+ (id)checkNullValueWithZero:(id)value;
+ (id)checkNullValueWithDate:(id)value;
+ (id)checkNullValue:(id)value;
+ (void)showAlert: (NSString*)title message:(NSString*)message;
+ (void)showAlert: (NSString*)title message:(NSString*)message vc:(UIViewController*)vc;
+ (void)showSuccessAlert: (NSString*)title message:(NSString*)message image:(NSString*)image;
+ (void)makeFloatingField: (JVFloatLabeledTextField*)textfield placeholder:(NSString*)placeholder;
+ (void)makeShadowView: (UIView*)view;
+ (void)makeRoundShadowView: (UIView*)view;
+ (void)makeRoundImageView:(UIImageView*)imageView;
+ (void)makeBorderView:(UIView*)view;
+ (NSString*)getCurrentDateTime;
+ (NSDate*)convertStringToDate: (NSString*)strDate format:(NSString*)format;
+ (NSString*)convertDateToString: (NSDate*)date format:(NSString*)format;
+ (NSDate *)startDateOfMonth;
+ (NSDate *)endDateOfMonth;
+ (NSDate *)startDateOfLastMonth;
+ (NSDate *)endDateOfLastMonth;
+ (UIColor*)convertToHexColor:(NSString*)colorValue;
+ (NSMutableDictionary*)getProfileParameter;
+ (BOOL)isiPhoneX;
+ (BOOL)validateEmailField:(NSString*)targetStr;
+ (BOOL)validateNumberField:(NSString*)targetStr;
+ (BOOL)validateNormalField:(NSString*)targetStr;
+ (void)openURl:(NSString*)url;

+ (void)parseError: (NSError*)error;
+ (void)checkError: (id)responseObject;

@end
