//
//  PPreferencesViewController.m
//  KES
//
//  Created by Piglet on 06.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "PPreferencesViewController.h"

@interface PPreferencesViewController ()

@end

@implementation PPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    heightTopOfParentView = 139;
    
    [self.tbDashboard registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    [self.tbHomepage registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    [self.tbOptions registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TypeTableViewCell"];
    
    
    arrDashboard = [NSMutableArray new];
    arrHompage = [NSMutableArray new];
    arrOptions = [NSMutableArray new];
    
    [arrDashboard addObject:@"dashboard1"];
    [arrDashboard addObject:@"dashboard2"];
    [arrDashboard addObject:@"dashboard3"];
    [arrDashboard addObject:@"dashboard4"];
    [arrDashboard addObject:@"dashboard5"];
    
    [arrHompage addObject:@"homepage1"];
    [arrHompage addObject:@"homepage2"];
    [arrHompage addObject:@"homepage3"];
    [arrHompage addObject:@"homepage4"];
    [arrHompage addObject:@"homepage5"];
    [arrHompage addObject:@"homepage6"];
    
    [arrOptions addObject:@"option1"];
    [arrOptions addObject:@"option2"];
    [arrOptions addObject:@"option3"];
    [arrOptions addObject:@"option4"];
    [arrOptions addObject:@"option5"];
    [arrOptions addObject:@"option6"];
    [arrOptions addObject:@"option7"];
    
    
    [self setUI];
    [self setButtonsView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBlackView)
                                                 name:NOTI_SHOW_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:NOTI_HIDE_SUB_BLACK
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - functions
- (void) setButtonsView
{
    [Functions setBoundsWithView:self.viewResult];
}

- (void) setUI
{
    [Functions setBoundsWithView:self.tfDashboard];
    
    [Functions setBoundsWithView:self.tfHomepage];
    
    [Functions setBoundsWithView:self.tfOptions];
    
    [Functions setBoundsWithView:self.tbDashboard];
    
    [Functions setBoundsWithView:self.tbHomepage];
    
    [Functions setBoundsWithView:self.tbOptions];
    
}
- (void) changeScrollWhenSelectBtn:(UIButton *) button andHeightOfShownView:(CGFloat) height
{
    mtfposition = button.frame.origin.y;
    mtfHeight = button.frame.size.height;
    
    if (height + mtfHeight + mtfposition + heightTopOfParentView > self.view.frame.size.height) {
        float d_height = height + mtfHeight + mtfposition + heightTopOfParentView - self.view.frame.size.height;
        [UIView animateWithDuration:0.5f animations:^{
            self.scContainer.contentOffset = CGPointMake(0, d_height);
        }];
    }
}
- (void) showBlackViewsForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_SHOW object:nil];
    [self showBlackView];
}

- (void) showBlackView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.viewBlackOpaque.alpha = 0.7f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }];
}

- (void) hideBlackViewForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_HIDE object:nil];
    [self hideBlackView];
}

- (void) hideBlackView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.viewBlackOpaque.alpha = 0.0f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0f]];
    }];
}

- (void) showTBDashboard:(UIButton *) btn
{
    CGFloat heightOfTB = 160.0f;
    self.constraint_tbdashboard_height.constant = heightOfTB;
    [self changeScrollWhenSelectBtn:btn andHeightOfShownView:heightOfTB];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showBlackViewsForBoth];
    });
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [self.imgChevronForDashboard setImage:[UIImage imageNamed:@"chevron-up.png"]];
        [self.tbDashboard.superview bringSubviewToFront:self.tbDashboard];
    }];
    [self.tbDashboard reloadData];
}

- (void) hideTBDashboard
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBlackViewForBoth];
    });
    self.constraint_tbdashboard_height.constant = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5f animations:^{
            self.scContainer.contentOffset = CGPointMake(0, 0);
        }];
        [self.imgChevronForDashboard setImage:[UIImage imageNamed:@"chevron-down.png"]];
    }];

}

- (void) showTBHomepage:(UIButton *) btn
{
    CGFloat heightOfTB = 160.0f;
    self.constraint_tbHomepage_height.constant = heightOfTB;
    [self changeScrollWhenSelectBtn:btn andHeightOfShownView:heightOfTB];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showBlackViewsForBoth];
    });
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [self.imgChevronForHomepage setImage:[UIImage imageNamed:@"chevron-up.png"]];
        [self.tbHomepage.superview bringSubviewToFront:self.tbHomepage];
    }];
    [self.tbHomepage reloadData];
}

- (void) hideTBHomepage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBlackViewForBoth];
    });
    self.constraint_tbHomepage_height.constant = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5f animations:^{
            self.scContainer.contentOffset = CGPointMake(0, 0);
        }];
        [self.imgChevronForHomepage setImage:[UIImage imageNamed:@"chevron-down.png"]];
    }];
}

- (void) showTBOptions:(UIButton *) btn
{
    CGFloat heightOfTB = 160.0f;
    self.constraint_tbOptions_height.constant = heightOfTB;
    [self changeScrollWhenSelectBtn:btn andHeightOfShownView:heightOfTB];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showBlackViewsForBoth];
    });
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [self.imgChevronForOptions setImage:[UIImage imageNamed:@"chevron-up.png"]];
        [self.tbOptions.superview bringSubviewToFront:self.tbOptions];
    }];
    [self.tbOptions reloadData];
}

- (void) hideTBOptions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBlackViewForBoth];
    });
    self.constraint_tbOptions_height.constant = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5f animations:^{
            self.scContainer.contentOffset = CGPointMake(0, 0);
        }];
        [self.imgChevronForOptions setImage:[UIImage imageNamed:@"chevron-down.png"]];
    }];
}

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.tbDashboard]) {
        return arrDashboard.count;
    }
    else if([tableView isEqual:self.tbHomepage])
        return arrHompage.count;
    else if ([tableView isEqual:self.tbOptions])
        return arrOptions.count;
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
    if ([tableView isEqual:self.tbDashboard]) {
        
        NSString *strDashboard = [arrDashboard objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strDashboard;
        if ([strDashboard isEqualToString:strSelectedDashboard]) {
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        }
        else
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:48.0f/255 green:48.0f/255 blue:48.0f/255 alpha:1.0f]];
        return cell;
    }
    else if ([tableView isEqual:self.tbHomepage])
    {
        NSString *strHomepage = [arrHompage objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strHomepage;
        if ([strHomepage isEqualToString:strSelectedHomepage]) {
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        }
        else
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:48.0f/255 green:48.0f/255 blue:48.0f/255 alpha:1.0f]];
        return cell;
    }
    else if ([tableView isEqual:self.tbOptions])
    {
        NSString *strOption = [arrOptions objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strOption;
        if ([strOption isEqualToString:strSelectedOption]) {
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        }
        else
            [cell.lblTypeName setTextColor:[UIColor colorWithRed:48.0f/255 green:48.0f/255 blue:48.0f/255 alpha:1.0f]];
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    isShowingTBCountry = false;
//    NSDictionary *dic = [arrCountries objectAtIndex:indexPath.row];
//    strSelectedCountry = dic[@"name"];
//    self.tfCountry.text = strSelectedCountry;
//    [self hideTBCountry];
    if ([tableView isEqual:self.tbDashboard]) {
        isShowingTBDashboard = false;
        NSString *strDashboard = [arrDashboard objectAtIndex:indexPath.row];
        strSelectedDashboard = strDashboard;
        self.tfDashboard.text = strDashboard;
        [self hideTBDashboard];
    }
    else if([tableView isEqual:self.tbHomepage])
    {
        isShowingTBHomepage = false;
        NSString *strHomepage = [arrHompage objectAtIndex:indexPath.row];
        strSelectedHomepage = strHomepage;
        self.tfHomepage.text = strHomepage;
        [self hideTBHomepage];
    }
    else if([tableView isEqual:self.tbOptions])
    {
        isShowingTBOption = false;
        NSString *strOption = [arrOptions objectAtIndex:indexPath.row];
        strSelectedOption = strOption;
        self.tfOptions.text = strOption;
        [self hideTBOptions];
    }
}


#pragma mark - Actions

- (IBAction)onBtnDashboard:(id)sender {
    isShowingTBDashboard = !isShowingTBDashboard;
    if (isShowingTBDashboard) {
        [self showTBDashboard:(UIButton *) sender];
        
    }
    else
    {
        [self hideTBDashboard];
    }
}

- (IBAction)onBtnHomepage:(id)sender
{
    isShowingTBHomepage = !isShowingTBHomepage;
    if (isShowingTBHomepage) {
        [self showTBHomepage:(UIButton *) sender];
    }
    else
    {
        [self hideTBHomepage];
    }
    
}

- (IBAction)onBtnOptions:(id)sender
{
    isShowingTBOption = !isShowingTBOption;
    if (isShowingTBOption) {
        [self showTBOptions:(UIButton *) sender];
    }
    else
        [self hideTBOptions];
}
- (IBAction)onBtnSave:(id)sender
{
    // save here
    
    //
    
    [self.delegate goBackFromPPreferencesVC];
}
- (IBAction)onBtnReset:(id)sender
{
    
}
- (IBAction)onBtnCancel:(id)sender
{
    [self.delegate goBackFromPPreferencesVC];
}

@end
