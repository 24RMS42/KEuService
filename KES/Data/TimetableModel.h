//
//  TimetableModel.h
//  KES
//
//  Created by matata on 2/27/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimetableModel : NSObject

@property (strong ,nonatomic) NSString *booking_item_id;
@property (strong ,nonatomic) NSString *mytime_id;
@property (strong ,nonatomic) NSString *first_name;
@property (strong ,nonatomic) NSString *start;
@property (strong ,nonatomic) NSString *end;
@property (strong ,nonatomic) NSString *title;
@property (strong ,nonatomic) NSString *location;
@property (strong ,nonatomic) NSString *room;
@property (strong ,nonatomic) NSString *attending;
@property (strong ,nonatomic) NSString *schedule_id;
@property (strong ,nonatomic) NSString *trainer;

@property (strong ,nonatomic) NSString *date;
@property (strong ,nonatomic) NSString *format_date;
@property (strong ,nonatomic) NSString *dayOfWeek;
@property (strong ,nonatomic) NSString *month;
@end
