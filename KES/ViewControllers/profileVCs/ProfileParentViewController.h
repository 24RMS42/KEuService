//
//  ProfileParentViewController.h
//  KES
//
//  Created by Piglet on 03.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileSubViewController.h"
#import "MemberTableViewCell.h"
#import "Functions.h"
#import "CameraSelectView.h"

@interface ProfileParentViewController : UIViewController<ProfileSubViewControllerDelegate, CameraSelectViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSArray *arrCategories;
}
@property (strong, nonatomic) ProfileSubViewController *profileSubVC;
@property (nonatomic, strong) CameraSelectView *cameraSelectView;

@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;

@property (weak, nonatomic) IBOutlet UILabel *lblProfileType;
@property (weak, nonatomic) IBOutlet UIImageView *imgChevron;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UIView *viewSubContain;

@property (weak, nonatomic) IBOutlet UITableView *tbCategories;

- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnCategoryClicked:(id)sender;

@end
