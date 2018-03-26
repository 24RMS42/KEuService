//
//  NSMutableDictionary+AddItem.m
//  KES
//
//  Created by matata on 3/18/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "NSMutableDictionary+AddItem.h"

@implementation NSMutableDictionary (AddItem)
-(void)addObjectWithoutReplacing:(id)obj forKey:(id)key {
    if ([self objectForKey:key] == nil)
        [self setObject:obj forKey:key];
}
@end
