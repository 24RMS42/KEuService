//
//  HelpViewController.h
//  KES
//
//  Created by matata on 3/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"

@interface HelpViewController : UIViewController

@property (nonatomic, strong) NSString *info;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *versionView;
@property (weak, nonatomic) IBOutlet UILabel *versionLbl;

- (IBAction)OnBackClicked:(id)sender;
@end
