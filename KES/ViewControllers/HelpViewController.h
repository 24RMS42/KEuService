//
//  HelpViewController.h
//  KES
//
//  Created by matata on 3/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "WebServices.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HelpViewController : UIViewController<WebServicesDelegate>
{
    WebServices *objWebServices;
    NSString *contentApi;
}

@property (nonatomic, strong) NSString *info;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *versionView;
@property (weak, nonatomic) IBOutlet UILabel *versionLbl;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImgView;

- (IBAction)OnBackClicked:(id)sender;
@end
