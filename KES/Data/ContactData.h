//
//  ContactData.h
//  KES
//
//  Created by matata on 3/14/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactNotification.h"

@interface ContactData : NSObject

@property (strong ,nonatomic) NSString *user_id;
@property (strong ,nonatomic) NSString *academic_year_id;
@property (strong ,nonatomic) NSString *first_name;
@property (strong ,nonatomic) NSString *last_name;
@property (strong ,nonatomic) NSString *school_id;
@property (strong ,nonatomic) NSString *year_id;
@property (strong ,nonatomic) NSString *title;
@property (strong ,nonatomic) NSString *date_of_birth;
@property (strong ,nonatomic) NSString *nationality;
@property (strong ,nonatomic) NSString *gender;
@property (strong ,nonatomic) NSString *country;
@property (strong ,nonatomic) NSString *county;
@property (strong ,nonatomic) NSString *town;
@property (strong ,nonatomic) NSString *postcode;
@property (strong ,nonatomic) NSString *address1;
@property (strong ,nonatomic) NSString *address2;
@property (strong ,nonatomic) NSString *address3;
@property (strong ,nonatomic) NSString *date_created;
@property (strong ,nonatomic) NSString *cycle;
@property (strong ,nonatomic) NSString *courses_i_would_like;
@property (strong ,nonatomic) NSString *points;
@property (strong ,nonatomic) NSMutableArray *contactDetails;
@property (strong ,nonatomic) NSMutableArray *preferenceArray;
@property (strong ,nonatomic) NSMutableArray *subjectArray;

@end
