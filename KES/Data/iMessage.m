//
//  iMessage.m
//  KES
//
//  Created by Piglet on 01.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "iMessage.h"

@implementation iMessage
-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type
{
    self = [super init];
    if(self)
    {
        self.userName = name;
        self.userMessage = message;
        self.userTime = time;
        self.messageType = type;
    }
    
    return self;
}
@end
