//
//  NewsModel.h
//  KES
//
//  Created by matata on 2/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsModel : NSObject

//News model
@property (strong ,nonatomic) NSString *_id;
@property (strong ,nonatomic) NSString *category_id;
@property (strong ,nonatomic) NSString *title;
@property (strong ,nonatomic) NSString *summary;
@property (strong ,nonatomic) NSString *category;
@property (strong ,nonatomic) NSString *content;
@property (strong ,nonatomic) NSString *event_date;
@property (strong ,nonatomic) NSString *image;
@property (strong ,nonatomic) NSString *timebar;

//Book model
@property (strong ,nonatomic) NSString *timeslot_id;
@property (strong ,nonatomic) NSString *booking_id;
@property (strong ,nonatomic) NSString *schedule_id;
@property (strong ,nonatomic) NSString *schedule;
@property (strong ,nonatomic) NSString *room;
@property (strong ,nonatomic) NSString *building;
@property (strong ,nonatomic) NSString *start_date;
@property (strong ,nonatomic) NSString *end_date;
@property (strong ,nonatomic) NSString *trainer;
@property (strong ,nonatomic) NSString *trainer_id;
@property (strong ,nonatomic) NSString *course;
@property (strong ,nonatomic) NSString *profile_img_url;
@property (strong ,nonatomic) NSString *time_prompt;
@property (strong ,nonatomic) NSString *slot_start_date;
@property (strong ,nonatomic) NSString *slot_end_date;
@property (strong ,nonatomic) NSString *max_capacity;
@property (strong ,nonatomic) NSString *booking_count;
@property (strong ,nonatomic) UIColor *color;

@property (strong ,nonatomic) NSString *start_to_end;
@property (strong ,nonatomic) NSString *format_date;
@property (strong ,nonatomic) NSString *format_start_date;
@property (strong ,nonatomic) NSString *month;
@property (strong ,nonatomic) NSString *dayOfWeek;
@property (strong ,nonatomic) NSString *day;

//trainer booking dashboard
@property (strong ,nonatomic) NSString *bookings;
@property (strong ,nonatomic) NSString *confirmed;
@property (strong ,nonatomic) NSString *paid;
@property (strong ,nonatomic) NSString *topics;
@property (strong ,nonatomic) NSString *receipts;
@property (strong ,nonatomic) NSString *rental_due;

@end
