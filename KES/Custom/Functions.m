//
//  Functions.m
//  KES
//
//  Created by matata on 11/23/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "Functions.h"
//#import "UIAlertController+Window.h"

@implementation Functions

+ (Functions *)sharedInstance {
    static dispatch_once_t onceToken;
    static Functions *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Functions alloc] init];
    });
    return instance;
}

+ (id)checkNullValueWithDate:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value==nil)
    {
        value = @"1991-02-24 05:00:00";
    }
    NSString * str =[NSString stringWithFormat:@"%@",value];
    
    return str;
}

+(id)checkNullValueWithZero:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value==nil)
    {
        value = @"0";
    }
    NSString * str =[NSString stringWithFormat:@"%@",value];
    
    return str;
}

+ (id)checkNullValue:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value==nil)
    {
        value = @"";
    }
    NSString * str =[NSString stringWithFormat:@"%@",value];
    
    return str;
}

+ (void)showAlert: (NSString*)title message:(NSString*)message
{
    /*UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [alert show];*/
    [TSMessage showNotificationInViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                          title:title
                                       subtitle:message
                                           type:TSMessageNotificationTypeError
                                       duration:3.0];
}

+ (void)showSuccessAlert: (NSString*)title message:(NSString*)message image:(NSString*)image
{
    [TSMessage showNotificationInViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                          title:title
                                       subtitle:message
                                          image:[UIImage imageNamed:image]
                                           type:TSMessageNotificationTypeSuccess
                                       duration:5.0
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}

+ (void)makeFloatingField:(JVFloatLabeledTextField *)textfield placeholder:(NSString *)placeholder
{
    UIColor *floatingLabelColor = [UIColor colorWithHex:COLOR_FONT];
    
    textfield.font = [UIFont fontWithName:@"Roboto-Light" size:kJVFieldFontSize];
    textfield.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:placeholder
                                    attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:COLOR_FONT]}];
    textfield.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    textfield.floatingLabelTextColor = floatingLabelColor;
    textfield.placeholderColor = [UIColor grayColor];
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
}

+ (void)makeShadowLabel:(UILabel *)label
{
    label.layer.shadowOpacity = 1.0;
    label.layer.shadowRadius = 0.0;
    label.layer.shadowColor = [UIColor grayColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(1.0, 1.0);
}

+ (void)makeRoundShadowView:(UIView *)view
{
    view.layer.cornerRadius = 0.5f;
    view.layer.masksToBounds = NO;
    
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:0.5f];
    
    view.layer.shadowOpacity = 1.0;
    view.layer.shadowRadius = 2.0;
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(1.0, 1.0);
}

+ (void)makeRoundImageView:(UIImageView *)imageView {
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.masksToBounds = YES;
}

+ (void)makeBorderView:(UIView *)view {
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:0.5f];
}

+ (NSString*)getCurrentDateTime {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSDate*)convertStringToDate: (NSString*)strDate format:(NSString*)format {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *dateTime = [formatter dateFromString:strDate];
    return dateTime;
}

+ (NSString*)convertDateToString: (NSDate*)date format:(NSString*)format {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString  *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSDate *)startDateOfMonth {
    NSCalendar *current = [NSCalendar currentCalendar];
    NSDate *startOfDay = [current startOfDayForDate:[NSDate date]];
    NSDateComponents *components = [current components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:startOfDay];
    NSDate *startOfMonth = [current dateFromComponents:components];
    
    return startOfMonth;
}

+ (NSDate *)endDateOfMonth {
    NSCalendar *current = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    components.day = -1;
    NSDate *endOfMonth = [current dateByAddingComponents:components toDate:[self startDateOfMonth] options:NSCalendarSearchBackwards];
    
    return endOfMonth;
}

+ (NSDate *)startDateOfLastMonth {
    //Substract one month
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1];
    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    //End
    
    NSCalendar *current = [NSCalendar currentCalendar];
    NSDate *startOfDay = [current startOfDayForDate:endOfWorldWar3];
    NSDateComponents *components = [current components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:startOfDay];
    NSDate *startOfMonth = [current dateFromComponents:components];
    
    return startOfMonth;
}

+ (NSDate *)endDateOfLastMonth {
    NSCalendar *current = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    components.day = -1;
    NSDate *endOfMonth = [current dateByAddingComponents:components toDate:[self startDateOfLastMonth] options:NSCalendarSearchBackwards];
    
    return endOfMonth;
}

+ (UIColor*)convertToHexColor:(NSString*)colorValue {
    NSString *haystackPrefix = @"rgb(";
    NSString *haystackSuffix = @")";
    NSRange needleRange = NSMakeRange(haystackPrefix.length,
                                      colorValue.length - haystackPrefix.length - haystackSuffix.length);
    NSString *needle = [colorValue substringWithRange:needleRange];
    //needle = [needle stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *items = [needle componentsSeparatedByString:@", "];
    UIColor *color = [UIColor colorWithRed:[items[0] floatValue]/255 green:[items[1] floatValue]/255 blue:[items[2] floatValue]/255 alpha:1.0];
    return color;
}

+ (NSMutableDictionary*)getProfileParameter {
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:appDelegate.contactData.title forKey:@"title"];
    [parameters setValue:appDelegate.contactData.first_name forKey:@"first_name"];
    [parameters setValue:appDelegate.contactData.last_name forKey:@"last_name"];
    [parameters setValue:appDelegate.contactData.date_of_birth forKey:@"date_of_birth"];
    [parameters setValue:appDelegate.contactData.nationality forKey:@"nationality"];
    [parameters setValue:appDelegate.contactData.gender forKey:@"gender"];
    
    [parameters setValue:appDelegate.contactData.academic_year_id forKey:@"academic_year_id"];
    [parameters setValue:appDelegate.contactData.school_id forKey:@"school_id"];
    [parameters setValue:appDelegate.contactData.year_id forKey:@"year_id"];
    [parameters setValue:appDelegate.contactData.courses_i_would_like forKey:@"courses_i_would_like"];
    [parameters setValue:appDelegate.contactData.points forKey:@"points_required"];
    [parameters setValue:appDelegate.contactData.cycle forKey:@"cycle"];
    
    [parameters setValue:appDelegate.contactData.country forKey:@"country"];
    [parameters setValue:appDelegate.contactData.address1 forKey:@"address1"];
    [parameters setValue:appDelegate.contactData.address2 forKey:@"address2"];
    [parameters setValue:appDelegate.contactData.address3 forKey:@"address3"];
    [parameters setValue:appDelegate.contactData.town forKey:@"town"];
    [parameters setValue:appDelegate.contactData.county forKey:@"county"];
    [parameters setValue:appDelegate.contactData.postcode forKey:@"postcode"];
    
    [parameters setValue:@"13" forKey:@"course_type_preferences[]"];
    //[parameters setValue:@"test" forKey:@"note"];
    
    for (int i = 0; i < appDelegate.contactData.subjectArray.count; i++) {
        SubjectModel *subjectModel = [appDelegate.contactData.subjectArray objectAtIndex:i];
        [parameters setValue:subjectModel.subject_id forKey:[NSString stringWithFormat:@"subject_preferences[%d][subject_id]", i]];
        [parameters setValue:subjectModel.level_id forKey:[NSString stringWithFormat:@"subject_preferences[%d][level_id]", i]];
    }
    
    for (int i = 0; i < appDelegate.contactData.preferenceArray.count; i++) {
        PreferenceType *pType = [appDelegate.contactData.preferenceArray objectAtIndex:i];
        [parameters setValue:pType.preference_id forKey:[NSString stringWithFormat:@"preferences[%d]", i]];
    }
    
    for (int i = 0; i < appDelegate.contactData.contactDetails.count; i++) {
        ContactNotification *obj = [appDelegate.contactData.contactDetails objectAtIndex:i];
        [parameters setValue:obj.detail_id forKey:[NSString stringWithFormat:@"contactdetail_id[%d]", i]];
        [parameters setValue:obj.type_id forKey:[NSString stringWithFormat:@"contactdetail_type_id[%d]", i]];
        [parameters setValue:obj.value forKey:[NSString stringWithFormat:@"contactdetail_value[%d]", i]];
    }
    
    return parameters;
}

+ (void)parseError:(NSError*)error {
    NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (errorData == nil || [errorData isKindOfClass:[NSNull class]]) {
        [self showAlert:@"Alert" message:NETWORK_ERROR];
    }
    else
    {
        id json = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];
        NSString *msg = [json valueForKey:@"msg"];
        if ([msg isEqualToString:@""] || msg == nil || [msg isEqual:[NSNull null]] || [msg length] == 0) {
            msg = ERROR_MSG;
        }
        
        if ([BUILD_MODE isEqualToString:@"LIVE"]) {
            [self showAlert:@"ERROR" message:ERROR_MSG];
        }
        else
            [self showAlert:@"ERROR" message:msg];
    }
}

+ (void)checkError:(id)responseObject {
    NSString *msg = [responseObject valueForKey:@"msg"];
    if ([msg isEqualToString:@"Access Denied"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT object:self];
    }
    
    if ([BUILD_MODE isEqualToString:@"LIVE"]) {
        [self showAlert:@"Error" message:ERROR_MSG];
    }
    else {
        [self showAlert:@"Error" message:msg];
    }
}
@end
