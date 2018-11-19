//
//  PEducationViewController.m
//  KES
//
//  Created by Piglet on 06.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "PEducationViewController.h"

@interface PEducationViewController ()

@end

@implementation PEducationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selected_level_num = 0;
    heightTopOfParentView = 139;
    [self setTestData];
    [self setUI];
    [self setButtonsView];
    [self setupKeyboardToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBlackView)
                                                 name:NOTI_SHOW_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:NOTI_HIDE_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:HIDE_BLACKVIEW_SUPER
                                               object:nil];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBlackViewForBoth)];
    [self.viewBlackOpaque addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Functions
- (void) setupKeyboardToolBar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    [numberToolbar setBackgroundColor:[UIColor colorWithRed:220.0/255.0f green:220.0/255.0f blue:220.0/255.0f alpha:1.0f]];
    self.tfAcademicYear.inputAccessoryView = numberToolbar;
    self.tfSchoolyear.inputAccessoryView = numberToolbar;
}
-(void)doneWithNumberPad{
    [tmpTf resignFirstResponder];
    
}
- (void) showFlexiStudent
{
    NSString *strImgName;
    if (isFlexiStudent) {
        strImgName = @"switch_on.png";
    }
    else
    {
        strImgName = @"switch_off.png";
    }
    [UIView animateWithDuration:0.5f animations:^{
       [self.btnFlexiStudent setImage:[UIImage imageNamed:strImgName] forState:UIControlStateNormal];
    }];
}
- (void) showData
{
    NSDictionary *dicTmp;
    switch (selected_level_num) {
        case 0:
        {
            dicTmp = [NSDictionary dictionaryWithDictionary:dicJuniors];
        }
            break;
        case 1:
        {
            dicTmp = [NSDictionary dictionaryWithDictionary:dicTransitions];
        }
            break;
        case 2:
        {
            dicTmp = [NSDictionary dictionaryWithDictionary:dicSeniors];
        }
            break;
        default:
            break;
    }
    
    NSDictionary *dicAccounting = [dicTmp objectForKey:EDU_ACCOUNTING];
    NSNumber *numSelectedForAccounting = [dicAccounting objectForKey:EDU_SELECTED];
    if ([numSelectedForAccounting integerValue] == 0) {
        [self.btnAccounting setBackgroundColor:[UIColor whiteColor]];
        [self.btnAccounting setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        self.segAccounting.alpha  = 0.0f;
    }
    else
    {
        [self.btnAccounting setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnAccounting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.segAccounting.alpha  = 1.0;

        int numSelectedValue = [[dicAccounting objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segAccounting setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segAccounting setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segAccounting setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicAppliedMaths = [dicTmp objectForKey:EDU_APPLIED_MATHS];
    NSNumber *numSelectedForAppliedMath = [dicAppliedMaths objectForKey:EDU_SELECTED];
    if ([numSelectedForAppliedMath integerValue] == 0) {
        [self.btnAppliedMaths setBackgroundColor:[UIColor whiteColor]];
        [self.btnAppliedMaths setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        self.segAppliedMaths.alpha  = 0.0f;
    }
    else
    {
        [self.btnAppliedMaths setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnAppliedMaths setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.segAppliedMaths.alpha  = 1.0;

        int numSelectedValue = [[dicAppliedMaths objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segAppliedMaths setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segAppliedMaths setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segAppliedMaths setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicBiology = [dicTmp objectForKey:EDU_BIOLOGY];
    NSNumber *numSelectedForBiology = [dicBiology objectForKey:EDU_SELECTED];
    if ([numSelectedForBiology integerValue] == 0) {
        [self.btnBiology setBackgroundColor:[UIColor whiteColor]];
        [self.btnBiology setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segBiology.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnBiology setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnBiology setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segBiology.alpha  = 1.0f;
        }];
        int numSelectedValue = [[dicBiology objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segBiology setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segBiology setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segBiology setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicChemistry = [dicTmp objectForKey:EDU_CHEMISTRY];
    NSNumber *numSelectedForChemistry = [dicChemistry objectForKey:EDU_SELECTED];
    if ([numSelectedForChemistry integerValue] == 0) {
        [self.btnChemistry setBackgroundColor:[UIColor whiteColor]];
        [self.btnChemistry setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segChemistry.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnChemistry setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnChemistry setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segChemistry.alpha  = 1.0f;
        }];
        int numSelectedValue = [[dicChemistry objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segChemistry setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segChemistry setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segChemistry setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicDCG = [dicTmp objectForKey:EDU_DCG];
    NSNumber *numSelectedForDCG = [dicDCG objectForKey:EDU_SELECTED];
    if ([numSelectedForDCG integerValue] == 0) {
        [self.btnDCG setBackgroundColor:[UIColor whiteColor]];
        [self.btnDCG setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            self.segDCG.alpha  = 0.0f;
        }];
        
    }
    else
    {
        [self.btnDCG setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnDCG setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segDCG.alpha  = 1.0f;
        }];
        int numSelectedValue = [[dicDCG objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segDCG setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segDCG setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segDCG setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicEnglish = [dicTmp objectForKey:EDU_ENGLISH];
    NSNumber *numSelectedForEnglish = [dicEnglish objectForKey:EDU_SELECTED];
    if ([numSelectedForEnglish integerValue] == 0) {
        [self.btnEnglish setBackgroundColor:[UIColor whiteColor]];
        [self.btnEnglish setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segEnglish.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnEnglish setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnEnglish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segEnglish.alpha  = 1.0f;
        }];
        int numSelectedValue = [[dicEnglish objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segEnglish setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segEnglish setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segEnglish setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicGeography = [dicTmp objectForKey:EDU_GEOGRAPHY];
    NSNumber *numSelectedForGeography = [dicGeography objectForKey:EDU_SELECTED];
    if ([numSelectedForGeography integerValue] == 0) {
        [self.btnGeography setBackgroundColor:[UIColor whiteColor]];
        [self.btnGeography setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segGeography.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnGeography setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnGeography setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segGeography.alpha  = 1.0f;
        }];

        int numSelectedValue = [[dicGeography objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segGeography setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segGeography setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segGeography setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicHistory = [dicTmp objectForKey:EDU_HISTORY];
    NSNumber *numSelectedForHistory = [dicHistory objectForKey:EDU_SELECTED];
    if ([numSelectedForHistory integerValue] == 0) {
        [self.btnHistory setBackgroundColor:[UIColor whiteColor]];
        [self.btnHistory setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segHistory.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnHistory setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnHistory setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segHistory.alpha  = 1.0f;
        }];
        int numSelectedValue = [[dicHistory objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segHistory setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segHistory setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segHistory setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicHpat = [dicTmp objectForKey:EDU_HPAT];
    NSNumber *numSelectedForHpat = [dicHpat objectForKey:EDU_SELECTED];
    if ([numSelectedForHpat integerValue] == 0) {
        [self.btnHpat setBackgroundColor:[UIColor whiteColor]];
        [self.btnHpat setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segHpat.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnHpat setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnHpat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segHpat.alpha  = 1.0f;
        }];
        int numSelectedValue = [[dicHpat objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segHpat setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segHpat setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segHpat setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicLCVP = [dicTmp objectForKey:EDU_LCVP];
    NSNumber *numSelectedForLCVP = [dicLCVP objectForKey:EDU_SELECTED];
    if ([numSelectedForLCVP integerValue] == 0) {
        [self.btnLCVP setBackgroundColor:[UIColor whiteColor]];
        [self.btnLCVP setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segLCVP.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnLCVP setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnLCVP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segLCVP.alpha  = 1.0f;
        }];
        int numSelectedValue = [[dicLCVP objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segLCVP setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segLCVP setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segLCVP setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicMusic = [dicTmp objectForKey:EDU_MUSIC];
    NSNumber *numSelectedForMusic = [dicMusic objectForKey:EDU_SELECTED];
    if ([numSelectedForMusic integerValue] == 0) {
        [self.btnMusic setBackgroundColor:[UIColor whiteColor]];
        [self.btnMusic setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segMusic.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnMusic setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnMusic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segMusic.alpha  = 1.0f;
        }];
        int numSelectedValue = [[dicMusic objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segMusic setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segMusic setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segMusic setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicReligion = [dicTmp objectForKey:EDU_RELIGION];
    NSNumber *numSelectedForReligion = [dicReligion objectForKey:EDU_SELECTED];
    if ([numSelectedForReligion integerValue] == 0) {
        [self.btnReligion setBackgroundColor:[UIColor whiteColor]];
        [self.btnReligion setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segReligion.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnReligion setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnReligion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segReligion.alpha  = 1.0f;
        }];
        int numSelectedValue = [[dicReligion objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segReligion setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segReligion setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segReligion setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicSpanish = [dicTmp objectForKey:EDU_SPANISH];
    NSNumber *numSelectedForSpanish = [dicSpanish objectForKey:EDU_SELECTED];
    if ([numSelectedForSpanish integerValue] == 0) {
        [self.btnSpanish setBackgroundColor:[UIColor whiteColor]];
        [self.btnSpanish setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segSpanish.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnSpanish setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnSpanish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segSpanish.alpha  = 1.0;
        }];
        int numSelectedValue = [[dicSpanish objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segSpanish setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segSpanish setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segSpanish setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
    NSDictionary *dicTechGraphics = [dicTmp objectForKey:EDU_TECH_GRAPHICS];
    NSNumber *numSelectedForTechGraphics = [dicTechGraphics objectForKey:EDU_SELECTED];
    if ([numSelectedForTechGraphics integerValue] == 0) {
        [self.btnTechGraphics setBackgroundColor:[UIColor whiteColor]];
        [self.btnTechGraphics setTitleColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segTechGraphic.alpha  = 0.0f;
        }];
    }
    else
    {
        [self.btnTechGraphics setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
        [self.btnTechGraphics setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.segTechGraphic.alpha  = 1.0;
        }];
        int numSelectedValue = [[dicTechGraphics objectForKey:EDU_SELECTED_VALUE] intValue];
        switch (numSelectedValue) {
            case 0:
                [self.segTechGraphic setSelectedSegmentIndex:0];
                break;
            case 1:
                [self.segTechGraphic setSelectedSegmentIndex:1];
                break;
            case 2:
                [self.segTechGraphic setSelectedSegmentIndex:2];
                break;
            default:
                break;
        }
    }
    
}
- (void) setTestData
{
    dicJuniors = [[NSMutableDictionary alloc] init];
    dicTransitions = [[NSMutableDictionary alloc] init];
    dicSeniors = [[NSMutableDictionary alloc] init];
    
    // ----- Junior -----
    
    NSMutableDictionary *dicAccounting = [NSMutableDictionary new];
    [dicAccounting setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicAccounting setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicAccounting forKey:EDU_ACCOUNTING];
    
    NSMutableDictionary *dicAppliedMaths = [NSMutableDictionary new];
    [dicAppliedMaths setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicAppliedMaths setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicAppliedMaths forKey:EDU_APPLIED_MATHS];
    
    NSMutableDictionary *dicBiology = [NSMutableDictionary new];
    [dicBiology setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicBiology setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicBiology forKey:EDU_BIOLOGY];
    
    NSMutableDictionary *dicChemistry = [NSMutableDictionary new];
    [dicChemistry setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicChemistry setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicChemistry forKey:EDU_CHEMISTRY];
    
    NSMutableDictionary *dicDCG = [NSMutableDictionary new];
    [dicDCG setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicDCG setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicDCG forKey:EDU_DCG];
    
    NSMutableDictionary *dicEnglish = [NSMutableDictionary new];
    [dicEnglish setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicEnglish setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicEnglish forKey:EDU_ENGLISH];
    
    NSMutableDictionary *dicGeography = [NSMutableDictionary new];
    [dicGeography setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicGeography setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicGeography forKey:EDU_GEOGRAPHY];
    
    NSMutableDictionary *dicHistory = [NSMutableDictionary new];
    [dicHistory setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicHistory setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicHistory forKey:EDU_HISTORY];
    
    NSMutableDictionary *dicHpat = [NSMutableDictionary new];
    [dicHpat setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicHpat setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicHpat forKey:EDU_HPAT];
    
    NSMutableDictionary *dicLCVP = [NSMutableDictionary new];
    [dicLCVP setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicLCVP setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicLCVP forKey:EDU_LCVP];
    
    NSMutableDictionary *dicMusic = [NSMutableDictionary new];
    [dicMusic setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicMusic setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicMusic forKey:EDU_MUSIC];
    
    NSMutableDictionary *dicReligion = [NSMutableDictionary new];
    [dicReligion setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicReligion setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicReligion forKey:EDU_RELIGION];
    
    NSMutableDictionary *dicSpanish = [NSMutableDictionary new];
    [dicSpanish setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicSpanish setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicSpanish forKey:EDU_SPANISH];
    
    NSMutableDictionary *dicTechGrphics = [NSMutableDictionary new];
    [dicTechGrphics setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED];
    [dicTechGrphics setValue:[NSNumber numberWithInt:0] forKey:EDU_SELECTED_VALUE];
    [dicJuniors setObject:dicTechGrphics forKey:EDU_TECH_GRAPHICS];
    
    // ----------
    
    
    // ----- Transition -----
    
    [dicTransitions setObject:[dicAccounting mutableCopy] forKey:EDU_ACCOUNTING];
    [dicTransitions setObject:[dicAppliedMaths mutableCopy] forKey:EDU_APPLIED_MATHS];
    [dicTransitions setObject:[dicBiology mutableCopy] forKey:EDU_BIOLOGY];
    [dicTransitions setObject:[dicChemistry mutableCopy] forKey:EDU_CHEMISTRY];
    [dicTransitions setObject:[dicDCG mutableCopy] forKey:EDU_DCG];
    [dicTransitions setObject:[dicEnglish mutableCopy] forKey:EDU_ENGLISH];
    [dicTransitions setObject:[dicGeography mutableCopy] forKey:EDU_GEOGRAPHY];
    [dicTransitions setObject:[dicHistory mutableCopy] forKey:EDU_HISTORY];
    [dicTransitions setObject:[dicHpat mutableCopy] forKey:EDU_HPAT];
    [dicTransitions setObject:[dicLCVP mutableCopy] forKey:EDU_LCVP];
    [dicTransitions setObject:[dicMusic mutableCopy] forKey:EDU_MUSIC];
    [dicTransitions setObject:[dicReligion mutableCopy] forKey:EDU_RELIGION];
    [dicTransitions setObject:[dicSpanish mutableCopy] forKey:EDU_SPANISH];
    [dicTransitions setObject:[dicTechGrphics mutableCopy] forKey:EDU_TECH_GRAPHICS];
    
    // ----------
    
    // ----- Senior -----
    
    [dicSeniors setObject:[dicAccounting mutableCopy] forKey:EDU_ACCOUNTING];
    [dicSeniors setObject:[dicAppliedMaths mutableCopy] forKey:EDU_APPLIED_MATHS];
    [dicSeniors setObject:[dicBiology mutableCopy] forKey:EDU_BIOLOGY];
    [dicSeniors setObject:[dicChemistry mutableCopy] forKey:EDU_CHEMISTRY];
    [dicSeniors setObject:[dicDCG mutableCopy] forKey:EDU_DCG];
    [dicSeniors setObject:[dicEnglish mutableCopy] forKey:EDU_ENGLISH];
    [dicSeniors setObject:[dicGeography mutableCopy] forKey:EDU_GEOGRAPHY];
    [dicSeniors setObject:[dicHistory mutableCopy] forKey:EDU_HISTORY];
    [dicSeniors setObject:[dicHpat mutableCopy] forKey:EDU_HPAT];
    [dicSeniors setObject:[dicLCVP mutableCopy] forKey:EDU_LCVP];
    [dicSeniors setObject:[dicMusic mutableCopy] forKey:EDU_MUSIC];
    [dicSeniors setObject:[dicReligion mutableCopy] forKey:EDU_RELIGION];
    [dicSeniors setObject:[dicSpanish mutableCopy] forKey:EDU_SPANISH];
    [dicSeniors setObject:[dicTechGrphics mutableCopy] forKey:EDU_TECH_GRAPHICS];
    
    // ----------
}

- (void) setButtonsView
{
    [Functions setBoundsWithView:self.viewResult];
}

- (void) setUI
{
    [Functions setBoundsWithView:self.tfAcademicYear];
    
    [Functions setBoundsWithView:self.tfSchool];
    
    [Functions setBoundsWithView:self.tfSchoolyear];
    
    [Functions setBoundsWithView:self.tfCourses];
    
    [Functions setBoundsWithView:self.tfPoints];
    
    [Functions setBoundsWithView:self.btnAccounting];
    
    [Functions setBoundsWithView:self.btnAppliedMaths];
    
    [Functions setBoundsWithView:self.btnBiology];
    
    [Functions setBoundsWithView:self.btnChemistry];
    
    [Functions setBoundsWithView:self.btnDCG];
    
    [Functions setBoundsWithView:self.btnEnglish];
    
    [Functions setBoundsWithView:self.btnGeography];
    
    [Functions setBoundsWithView:self.btnHistory];
    
    [Functions setBoundsWithView:self.btnHpat];
    
    [Functions setBoundsWithView:self.btnLCVP];
    
    [Functions setBoundsWithView:self.btnMusic];
    
    [Functions setBoundsWithView:self.btnReligion];
    
    [Functions setBoundsWithView:self.btnSpanish];
    
    [Functions setBoundsWithView:self.btnTechGraphics];
    
}

- (void) changeBtnStatus:(NSString *) strKey
{
    NSDictionary *dicTmp;
    switch (selected_level_num) {
        case 0:
        {
            dicTmp = [NSDictionary dictionaryWithDictionary:dicJuniors];
        }
            break;
        case 1:
        {
            dicTmp = [NSDictionary dictionaryWithDictionary:dicTransitions];
        }
            break;
        case 2:
        {
            dicTmp = [NSDictionary dictionaryWithDictionary:dicSeniors];
        }
            break;
        default:
            break;
    }
    NSMutableDictionary *dicBiology = [dicTmp objectForKey:strKey];
    NSNumber *numSelectedForAccounting = [dicBiology objectForKey:EDU_SELECTED];
    if ([numSelectedForAccounting integerValue] == 0) {
        numSelectedForAccounting = [NSNumber numberWithInt:1];
    }
    else
        numSelectedForAccounting = [NSNumber numberWithInt:0];
    [dicBiology setObject:numSelectedForAccounting forKey:EDU_SELECTED];
    
    if (selected_level_num == 0) {
        [dicJuniors setObject:dicBiology forKey:strKey];
    }
    else if(selected_level_num == 1)
    {
        [dicTransitions setObject:dicBiology forKey:strKey];
    }
    else if(selected_level_num == 2)
    {
        [dicSeniors setObject:dicBiology forKey:strKey];
    }
    
    [self showData];
}

- (void) changeSelectedValueWithString:(NSString *) strKey andSelectedValue:(NSInteger) selectedValue
{
    NSDictionary *dicTmp;
    switch (selected_level_num) {
        case 0:
        {
            dicTmp = [NSDictionary dictionaryWithDictionary:dicJuniors];
        }
            break;
        case 1:
        {
            dicTmp = [NSDictionary dictionaryWithDictionary:dicTransitions];
        }
            break;
        case 2:
        {
            dicTmp = [NSDictionary dictionaryWithDictionary:dicSeniors];
        }
            break;
        default:
            break;
    }
    NSMutableDictionary *dicAccounting = [dicTmp objectForKey:strKey];
    
    
    NSNumber *numberSelected = [NSNumber numberWithInteger:selectedValue];
    [dicAccounting setObject:numberSelected forKey:EDU_SELECTED_VALUE];
    
    if (selected_level_num == 0) {
        [dicJuniors setObject:dicAccounting forKey:strKey];
    }
    else if(selected_level_num == 1)
    {
        [dicTransitions setObject:dicAccounting forKey:strKey];
    }
    else if(selected_level_num == 2)
    {
        [dicSeniors setObject:dicAccounting forKey:strKey];
    }
    
    [self showData];
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

#pragma mark - Keyboard Notification

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat keyboardHeight = kbSize.height;
    
    if (keyboardHeight + mtfHeight + mtfposition + heightTopOfParentView > self.view.frame.size.height) {
        float d_height = keyboardHeight + mtfHeight + mtfposition + heightTopOfParentView - self.view.frame.size.height;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
            self.scContainer.contentOffset = CGPointMake(0, d_height);
        }];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    mtfposition = textField.frame.origin.y;
    mtfHeight = textField.frame.size.height;
    tmpTf = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (void) textFieldDidChange:(UITextField *)textField
{
    NSString *strTxt = textField.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Actions
- (IBAction)onBtnFlexiStudent:(id)sender {
    isFlexiStudent = !isFlexiStudent;
    [self showFlexiStudent];
}

- (IBAction)categoryChanged:(id)sender {
    
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    selected_level_num = (int)segControl.selectedSegmentIndex;
    [self showData];
}

- (IBAction)onBtnAccounting:(id)sender {
    [self changeBtnStatus:EDU_ACCOUNTING];
}

- (IBAction)segAccountingChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_ACCOUNTING andSelectedValue:segControl.selectedSegmentIndex];
}

- (IBAction)onBtnAppliedMaths:(id)sender {
    [self changeBtnStatus:EDU_APPLIED_MATHS];
}

- (IBAction)segAppliedMathsChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_APPLIED_MATHS andSelectedValue:segControl.selectedSegmentIndex];
}

- (IBAction)onBtnBiology:(id)sender {
    [self changeBtnStatus:EDU_BIOLOGY];
}

- (IBAction)segBiologyChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_BIOLOGY andSelectedValue:segControl.selectedSegmentIndex];
}

- (IBAction)onBtnChemistry:(id)sender {
    [self changeBtnStatus:EDU_CHEMISTRY];
}

- (IBAction)segChemistryChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_CHEMISTRY andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnDCG:(id)sender {
    [self changeBtnStatus:EDU_DCG];
}

- (IBAction)segDCGChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_DCG andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnEnglish:(id)sender {
    [self changeBtnStatus:EDU_ENGLISH];
}

- (IBAction)segEnglishChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_ENGLISH andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnGeography:(id)sender {
    [self changeBtnStatus:EDU_GEOGRAPHY];
}

- (IBAction)segGeographyChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_GEOGRAPHY andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnHistory:(id)sender {
    [self changeBtnStatus:EDU_HISTORY];
}

- (IBAction)segHistoryChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_HISTORY andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnHpat:(id)sender {
    [self changeBtnStatus:EDU_HPAT];
}

- (IBAction)segHpatChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_HPAT andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnLCVP:(id)sender {
    [self changeBtnStatus:EDU_LCVP];
}

- (IBAction)segLCVPChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_LCVP andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnMusic:(id)sender {
    [self changeBtnStatus:EDU_MUSIC];
}

- (IBAction)segMusicChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_MUSIC andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnReligion:(id)sender {
    [self changeBtnStatus:EDU_RELIGION];
}

- (IBAction)segReligionChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_RELIGION andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnSpanish:(id)sender {
    [self changeBtnStatus:EDU_SPANISH];
}

- (IBAction)segSpanishChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_SPANISH andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnTechGraphics:(id)sender {
    [self changeBtnStatus:EDU_TECH_GRAPHICS];
}

- (IBAction)segTechGraphicChanged:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    [self changeSelectedValueWithString:EDU_TECH_GRAPHICS andSelectedValue:segControl.selectedSegmentIndex];

}

- (IBAction)onBtnSave:(id)sender
{
    // Save values here
    
    //
    
    [self.delegate goBackFromEducationVC];
}
- (IBAction)onBtnReset:(id)sender
{
    
}
- (IBAction)onBtnCancel:(id)sender
{
    [self.delegate goBackFromEducationVC];
}
@end
