//
//  LocationModel.h
//  KES
//
//  Created by matata on 2/23/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

@property (strong ,nonatomic) NSString *location_id;//room id
@property (strong ,nonatomic) NSString *parent_id;//building id
@property (strong ,nonatomic) NSString *name;
@property (strong ,nonatomic) NSString *directions;
@property (assign ,nonatomic) Float32 lat;
@property (assign ,nonatomic) Float32 lng;

@end
