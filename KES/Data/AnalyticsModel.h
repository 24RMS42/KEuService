//
//  AnalyticsModel.h
//  KES
//
//  Created by matata on 2/19/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsModel : NSObject

@property (strong ,nonatomic) NSString *name;
@property (assign ,nonatomic) NSInteger minute;
@property (assign ,nonatomic) NSInteger income;
@property (assign ,nonatomic) NSInteger quantity;
@property (strong ,nonatomic) NSString *image;
@property (assign ,nonatomic) NSInteger total_minute;
@property (assign ,nonatomic) NSInteger total_quantity;
@property (assign ,nonatomic) NSInteger total_income;

@property (strong ,nonatomic) NSString *hour;
@property (strong ,nonatomic) NSString *percent;
@property (strong ,nonatomic) NSString *timebar;

@end
