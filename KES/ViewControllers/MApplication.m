//
//  MApplication.m
//  KES
//
//  Created by matata on 3/21/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "MApplication.h"
#import "macro.h"

@implementation MApplication

- (void)sendEvent:(UIEvent *)event
{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *val = [userInfo valueForKey:KEY_SHAKE_APP];
    if ([val isEqualToString:@"1"]) {
        if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake ) {
            [userInfo setValue:@"0" forKey:KEY_SHAKE_APP];
            UIImage *screengrag = [self getScreenShot];
            NSDictionary* info = @{@"info": screengrag};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_FEEDBACK object:nil userInfo:info];
        }
    }
    
    [super sendEvent:event];
}

- (UIImage*)getScreenShot {
    // create graphics context with screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenRect.size.height = screenRect.size.width * 1.3;
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    // grab reference to our window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // transfer content into our context
    [window.layer renderInContext:ctx];
    UIImage *screengrab = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screengrab;
}

@end
