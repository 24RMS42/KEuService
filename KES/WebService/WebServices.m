//
//  WebService.m
//  KES
//
//  Created by matata on 2/9/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "WebServices.h"
#import "AppDelegate.h"

@implementation WebServices
+(instancetype)sharedInstance
{
    static WebServices * webservices;
//    if (webservices == nil)
//    {
        webservices = [[WebServices alloc]init];
//    }
    return webservices;
}

-(void)callApiWithParameters:(NSDictionary *)parameters apiName:(NSString *)apiName type:(NSString*)type loader:(BOOL)isLoaderNeed view:(UIViewController *)view
{
//    if([[AppDelegate sharedAppDelegate] checkInternetConnection])
//    {
        if ([type isEqualToString:POST_REQUEST])
        {
            __block NSDictionary * dictResponse = nil;
            
            if (isLoaderNeed == YES)
            {
                [[Utility sharedInstance] ShowProgress];
            }
            else
            {
                UIApplication* networkProgress = [UIApplication sharedApplication];
                networkProgress.networkActivityIndicatorVisible = YES;
            }
            
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [manager POST:apiName parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
            {
                 NSError *jsonError;
                 dictResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&jsonError];
                 
                  /********API LOG ERROR*********/
                  NSLog(@"------------- API NAME -------------");
                  NSLog(@"API NAME: %@",apiName);
                  NSLog(@"------------- PARAMETERS -------------");
                  NSLog(@"PARAMETERS: %@",parameters);
                  NSLog(@"------------- RESPONSE -------------");
                  NSLog(@"RESPONCE: %@",dictResponse);
                  /********API LOG ERROR*********/
 
                  if (isLoaderNeed == YES)
                  {
                      [[Utility sharedInstance] hideProgress];
                  }
                  else
                  {
                      UIApplication* networkProgress = [UIApplication sharedApplication];
                      networkProgress.networkActivityIndicatorVisible = NO;
                  }
                [_delegate response:dictResponse apiName:apiName ifAnyError:nil];
            }
            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
            {
                 
                 /********API LOG ERROR*********/
                 NSLog(@"------------- API NAME -------------");
                 NSLog(@"API NAME: %@",apiName);
                 NSLog(@"------------- PARAMETERS -------------");
                 NSLog(@"PARAMETERS: %@",parameters);
                 NSLog(@"------------- RESPONSE -------------");
                 NSLog(@"RESPONCE: %@",dictResponse);
                 /********API LOG ERROR*********/
 
                  if (isLoaderNeed == YES)
                  {
                      [[Utility sharedInstance] hideProgress];
                  }
                  else
                  {
                      UIApplication* networkProgress = [UIApplication sharedApplication];
                      networkProgress.networkActivityIndicatorVisible = NO;
                  }
                [Functions parseError:error];
            }];
        }
        else if ([type isEqualToString:GET_REQUEST])
        {
            __block NSDictionary * dictResponse = nil;
            if (isLoaderNeed == YES)
            {
                [[Utility sharedInstance] ShowProgress];
            }
            else
            {
                UIApplication* networkProgress = [UIApplication sharedApplication];
                networkProgress.networkActivityIndicatorVisible = YES;
            }
            
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            [manager GET:apiName parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 NSError *jsonError;
                 dictResponse = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jsonError];
                 //dictResponse = (NSDictionary *)responseObject;
                 
                 /********API LOG ERROR*********/
                 NSLog(@"------------- API NAME -------------");
                 NSLog(@"API NAME: %@",apiName);
                 NSLog(@"------------- PARAMETERS -------------");
                 NSLog(@"PARAMETERS: %@",parameters);
                 NSLog(@"------------- RESPONSE -------------");
                 NSLog(@"RESPONCE: %@",dictResponse);
                 /********API LOG ERROR*********/
                 
                 if (isLoaderNeed == YES)
                 {
                     [[Utility sharedInstance] hideProgress];
                 }
                 else
                 {
                     UIApplication* networkProgress = [UIApplication sharedApplication];
                     networkProgress.networkActivityIndicatorVisible = NO;
                 }
                 [_delegate response:dictResponse apiName:apiName ifAnyError:nil];
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 
                 /********API LOG ERROR*********/
                 NSLog(@"------------- API NAME -------------");
                 NSLog(@"API NAME: %@",apiName);
                 NSLog(@"------------- PARAMETERS -------------");
                 NSLog(@"PARAMETERS: %@",parameters);
                 NSLog(@"------------- RESPONSE -------------");
                 NSLog(@"RESPONCE: %@",dictResponse);
                 /********API LOG ERROR*********/
                 
                 if (isLoaderNeed == YES)
                 {
                     [[Utility sharedInstance] hideProgress];
                 }
                 else
                 {
                     UIApplication* networkProgress = [UIApplication sharedApplication];
                     networkProgress.networkActivityIndicatorVisible = NO;
                 }
                 [Functions parseError:error];
             }];
        }
//    }
//    else
//    {
//        NSLog(@"Please connect to internet.");
//    }
}

@end
