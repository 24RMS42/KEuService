//
//  ScheduleModel.h
//  KES
//
//  Created by matata on 2/22/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleModel : NSObject

@property (strong ,nonatomic) NSString *schedule_id;
@property (strong ,nonatomic) NSString *course_id;
@property (assign ,nonatomic) NSInteger fee_amount;
@property (strong ,nonatomic) NSString *booking_type;
@property (strong ,nonatomic) NSString *payment_type;
@property (strong ,nonatomic) NSString *location_id;
@property (strong ,nonatomic) NSMutableArray *topicArray;

@end
