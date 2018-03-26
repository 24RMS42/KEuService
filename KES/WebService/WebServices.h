//
//  WebService.h
//  KES
//
//  Created by matata on 2/9/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utility.h"
#import "Functions.h"

@class WebServices;

// protocol to get the response of API call
@protocol WebServicesDelegate <NSObject>
@required
-(void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error;

@end

@interface WebServices : NSObject

//Shared Instance
+(instancetype)sharedInstance;

//Delegate
@property(nonatomic, weak) id <WebServicesDelegate> delegate;


//Api Call
-(void)callApiWithParameters:(NSDictionary *)parameters apiName:(NSString *)apiName type:(NSString*)type loader:(BOOL)isLoaderNeed view:(UIViewController *)view;


@end
