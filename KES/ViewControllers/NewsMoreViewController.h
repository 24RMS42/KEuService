//
//  NewsMoreViewController.h
//  KES
//
//  Created by matata on 2/19/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "macro.h"

@interface NewsMoreViewController : UIViewController

@property (nonatomic, retain) NewsModel *newsObj;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UITextView *detailTxt;
@property (weak, nonatomic) IBOutlet UITextView *summaryTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

- (IBAction)OnCloseClicked:(id)sender;

@end
