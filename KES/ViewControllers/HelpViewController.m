//
//  HelpViewController.m
//  KES
//
//  Created by matata on 3/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    NSString *pageId = @"";
    if ([_info isEqualToString:@"Help"]) {
        _titleLbl.text = @"Help";
        [self showBanner];
        pageId = @"help";
    } else {
        _titleLbl.text = @"About Julie";
        [self getBuildVersion];
        pageId = @"history";
    }
    
    contentApi = [NSString stringWithFormat:@"%@%@?id=%@", BASE_URL, PAGE_CONTENT, pageId];
    [objWebServices callApiWithParameters:nil apiName:contentApi type:GET_REQUEST loader:NO view:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getBuildVersion {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [_versionView setHidden:NO];
    [_versionLbl setText:[NSString stringWithFormat:@"Version %@ (%@)", version, build]];
    
    CGRect frame = self.webView.frame;
    frame.size.height -= self.versionView.frame.size.height;
    self.webView.frame = frame;
}

- (void)showBanner {
    CGRect frame = self.webView.frame;
    frame.origin.y = self.bannerImgView.frame.origin.y + self.bannerImgView.frame.size.height;
    frame.size.height -= self.bannerImgView.frame.size.height;
    self.webView.frame = frame;
}

- (void)loadContent:(id)responseObject {
    @try{
        NSDictionary *pageObj = [responseObject objectForKey:@"page"];
        NSString *content = [pageObj valueForKey:@"content"];
        NSString *htmlString = [NSString stringWithFormat:@"<font face='Roboto-Regular'>%@", content];
        [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:BASE_URL]];
    
        NSArray *banner_slides = [pageObj valueForKey:@"banner_slides"];
        NSDictionary *slideObj = [banner_slides objectAtIndex:0];
        NSString *banner_image = [slideObj valueForKey:@"image"];
        [_bannerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@media/photos/banners/%@", BASE_URL, banner_image]]];
    }
    @catch (NSException *exception) {
    }
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:contentApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [self loadContent:responseDict];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

- (IBAction)OnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
