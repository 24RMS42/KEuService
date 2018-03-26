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
    
    NSURL *url = [NSURL URLWithString:HELP_URL];
    if ([_info isEqualToString:@"Help"]) {
        _titleLbl.text = @"Help";
    } else {
        _titleLbl.text = @"About";
        url = [NSURL URLWithString:ABOUT_URL];
    }
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
