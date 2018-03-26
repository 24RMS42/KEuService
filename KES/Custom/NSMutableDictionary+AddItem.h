//
//  NSMutableDictionary+AddItem.h
//  KES
//
//  Created by matata on 3/18/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (AddItem)
-(void)addObjectWithoutReplacing:(id)obj forKey:(id)key;
@end
