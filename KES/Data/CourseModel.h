//
//  CourseModel.h
//  KES
//
//  Created by matata on 2/22/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseModel : NSObject

@property (strong ,nonatomic) NSString *course_id;
@property (strong ,nonatomic) NSString *category_id;
@property (strong ,nonatomic) NSString *type_id;
@property (strong ,nonatomic) NSString *summary;
@property (strong ,nonatomic) NSString *descript;
@property (strong ,nonatomic) NSString *banner;

@end
