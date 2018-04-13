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
                //[[Utility sharedInstance] ShowProgress];
                [self showAnimatedView:view];
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
                      //[[Utility sharedInstance] hideProgress];
                      [self hideAnimatedView];
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
                      //[[Utility sharedInstance] hideProgress];
                      [self hideAnimatedView];
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
                //[[Utility sharedInstance] ShowProgress];
                [self showAnimatedView:view];
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
                     //[[Utility sharedInstance] hideProgress];
                     [self hideAnimatedView];
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
                     //[[Utility sharedInstance] hideProgress];
                     [self hideAnimatedView];
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

- (void)showAnimatedView:(UIViewController *)vc {
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWindow.frame.size.width, mainWindow.frame.size.height)];
    //self.loadingView.backgroundColor = [UIColor lightGrayColor];
    //self.loadingView.alpha = 0.25;
    
    NSArray *imageNames = @[@"l1.png", @"l2.png", @"l3.png",@"l4.png", @"l5.png", @"l6.png",@"l7.png", @"l8.png", @"l9.png"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++)
    {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake((375 - 120)/2, 230, 120, 120)];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 1.0;
    [self.loadingView addSubview:animationImageView];
    [animationImageView startAnimating];
    
    [mainWindow addSubview:self.loadingView];
}

- (void)hideAnimatedView {
    [self.loadingView removeFromSuperview];
}

@end
