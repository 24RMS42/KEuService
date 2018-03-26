//
//  PreferenceType.h
//  KES
//
//  Created by matata on 3/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferenceType : NSObject

@property (strong ,nonatomic) NSString *preference_id;
@property (strong ,nonatomic) NSString *label;
@property (strong ,nonatomic) NSString *required;
@property (strong ,nonatomic) NSString *value;

@end
