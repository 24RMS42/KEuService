//
//  ClassDetailViewController.h
//  KES
//
//  Created by matata on 2/21/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "iCarousel.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "NewsMoreViewController.h"
#import "CustomButton.h"

@interface ClassDetailViewController : UIViewController<WebServicesDelegate, CAAnimationDelegate, iCarouselDataSource, iCarouselDelegate>
{
    WebServices *objWebServices;
    NSString *scheduleApi, *courseApi;
    NSString *locationId;
}

@property (nonatomic, retain) NewsModel *objBook;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *courseTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *costLbl;
@property (weak, nonatomic) IBOutlet UILabel *costDesLbl;
@property (weak, nonatomic) IBOutlet UILabel *buildingLbl;
@property (weak, nonatomic) IBOutlet UILabel *roomLbl;
@property (weak, nonatomic) IBOutlet UILabel *teacherLbl;
@property (weak, nonatomic) IBOutlet UILabel *timePromptLbl;

@property (weak, nonatomic) IBOutlet UIView *grindView;
@property (weak, nonatomic) IBOutlet UITextView *summaryTxt;
@property (weak, nonatomic) IBOutlet UIButton *readMoreBtn;

@property (weak, nonatomic) IBOutlet UIView *revisionView;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIView *carouselContainView;
@property (weak, nonatomic) IBOutlet UILabel *carouselLabel;
@property (weak, nonatomic) IBOutlet CustomButton *viewSummaryBtn;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *summaryTxtView;
@property (weak, nonatomic) IBOutlet UITextView *detailTxtView;

- (IBAction)OnGetDirectionClicked:(id)sender;
- (IBAction)OnReadmoreClicked:(id)sender;
- (IBAction)OnBackClicked:(id)sender;
@end
