//
//  BookViewController.h
//  KES
//
//  Created by matata on 2/19/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import "CAPSPageMenu.h"
#import "UIColor+ColorWithHex.h"
#import "WebServices.h"
#import "AppDelegate.h"

@interface BookViewController : UIViewController<WebServicesDelegate, CAPSPageMenuDelegate>
{
    WebServices *objWebServices;
    NSString *topicApi, *locationApi, *categoryApi, *subjectApi;
}

@property (nonatomic) CAPSPageMenu *pagemenu;
@property (weak, nonatomic) IBOutlet UIView *TopView;

@end
