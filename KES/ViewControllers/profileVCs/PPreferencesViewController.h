//
//  PPreferencesViewController.h
//  KES
//
//  Created by Piglet on 06.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "TypeTableViewCell.h"
#import "Functions.h"

@protocol PPreferencesViewControllerDelegate
- (void) goBackFromPPreferencesVC;
@end

@interface PPreferencesViewController : UIViewController
{
    NSMutableArray *arrDashboard;
    NSMutableArray *arrHompage;
    NSMutableArray *arrOptions;
    
    NSString *strSelectedDashboard;
    NSString *strSelectedHomepage;
    NSString *strSelectedOption;
    
    CGFloat mtfposition;
    CGFloat mtfHeight;
    CGFloat heightTopOfParentView;
    BOOL isShowingTBDashboard;
    BOOL isShowingTBHomepage;
    BOOL isShowingTBOption;
    
}

@property (nonatomic, strong) id <PPreferencesViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *tfDashboard;
@property (weak, nonatomic) IBOutlet UIImageView *imgChevronForDashboard;
@property (weak, nonatomic) IBOutlet UITextField *tfHomepage;
@property (weak, nonatomic) IBOutlet UIImageView *imgChevronForHomepage;
@property (weak, nonatomic) IBOutlet UITextField *tfOptions;
@property (weak, nonatomic) IBOutlet UIImageView *imgChevronForOptions;
@property (weak, nonatomic) IBOutlet UITableView *tbDashboard;
@property (weak, nonatomic) IBOutlet UITableView *tbHomepage;
@property (weak, nonatomic) IBOutlet UITableView *tbOptions;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tbdashboard_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tbHomepage_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tbOptions_height;

- (IBAction)onBtnDashboard:(id)sender;
- (IBAction)onBtnHomepage:(id)sender;
- (IBAction)onBtnOptions:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;
@property (weak, nonatomic) IBOutlet UIScrollView *scContainer;


@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnReset:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

@end
