//
//  StudentModel.h
//  KES
//
//  Created by matata on 9/5/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject

@property (strong ,nonatomic) NSString *booking_item_id;
@property (strong ,nonatomic) NSString *booking_id;
@property (strong ,nonatomic) NSString *timeslot_status;
@property (strong ,nonatomic) NSString *attending;
@property (strong ,nonatomic) NSString *contact_id;
@property (strong ,nonatomic) NSString *first_name;
@property (strong ,nonatomic) NSString *last_name;
@property (strong ,nonatomic) NSString *payment_type;
@property (strong ,nonatomic) NSString *fee_amount;
@property (strong ,nonatomic) NSString *outstanding;
@property (strong ,nonatomic) NSString *guardian_first_name;
@property (strong ,nonatomic) NSString *guardian_last_name;
@property (strong ,nonatomic) NSString *guardian_mobile;
@property (strong ,nonatomic) NSString *avatar;
@property (strong ,nonatomic) NSString *role;
@property (strong ,nonatomic) NSString *temporary_absences;
@end
