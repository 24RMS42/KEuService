//
//  PEducationViewController.h
//  KES
//
//  Created by Piglet on 06.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "Functions.h"
@protocol PEducationViewControllerDelegate
- (void) goBackFromEducationVC;
@end
@interface PEducationViewController : UIViewController<UITextFieldDelegate>
{
    NSMutableDictionary *dicJuniors;
    NSMutableDictionary *dicTransitions;
    NSMutableDictionary *dicSeniors;
    
    CGFloat mtfposition;
    CGFloat mtfHeight;
    
    UITextField *tmpTf;
    int selected_level_num; // default is 0, Junior
    BOOL isFlexiStudent;
    CGFloat heightTopOfParentView;
    
}

@property (nonatomic, strong) id <PEducationViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scContainer;
@property (weak, nonatomic) IBOutlet UITextField *tfAcademicYear;
@property (weak, nonatomic) IBOutlet UIButton *btnFlexiStudent;
@property (weak, nonatomic) IBOutlet UITextField *tfSchool;
@property (weak, nonatomic) IBOutlet UITextField *tfSchoolyear;
@property (weak, nonatomic) IBOutlet UITextField *tfCourses;
@property (weak, nonatomic) IBOutlet UITextField *tfPoints;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySeg;
@property (weak, nonatomic) IBOutlet UIButton *btnAccounting;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segAccounting;
@property (weak, nonatomic) IBOutlet UIButton *btnAppliedMaths;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segAppliedMaths;
@property (weak, nonatomic) IBOutlet UIButton *btnBiology;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segBiology;
@property (weak, nonatomic) IBOutlet UIButton *btnChemistry;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segChemistry;
@property (weak, nonatomic) IBOutlet UIButton *btnDCG;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segDCG;
@property (weak, nonatomic) IBOutlet UIButton *btnEnglish;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segEnglish;
@property (weak, nonatomic) IBOutlet UIButton *btnGeography;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segGeography;
@property (weak, nonatomic) IBOutlet UIButton *btnHistory;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnHpat;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segHpat;
@property (weak, nonatomic) IBOutlet UIButton *btnLCVP;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segLCVP;
@property (weak, nonatomic) IBOutlet UIButton *btnMusic;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segMusic;
@property (weak, nonatomic) IBOutlet UIButton *btnReligion;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segReligion;
@property (weak, nonatomic) IBOutlet UIButton *btnSpanish;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segSpanish;
@property (weak, nonatomic) IBOutlet UIButton *btnTechGraphics;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segTechGraphic;



- (IBAction)onBtnFlexiStudent:(id)sender;
- (IBAction)categoryChanged:(id)sender;
- (IBAction)onBtnAccounting:(id)sender;
- (IBAction)segAccountingChanged:(id)sender;
- (IBAction)onBtnAppliedMaths:(id)sender;
- (IBAction)segAppliedMathsChanged:(id)sender;
- (IBAction)onBtnBiology:(id)sender;
- (IBAction)segBiologyChanged:(id)sender;
- (IBAction)onBtnChemistry:(id)sender;
- (IBAction)segChemistryChanged:(id)sender;
- (IBAction)onBtnDCG:(id)sender;
- (IBAction)segDCGChanged:(id)sender;
- (IBAction)onBtnEnglish:(id)sender;
- (IBAction)segEnglishChanged:(id)sender;
- (IBAction)onBtnGeography:(id)sender;
- (IBAction)segGeographyChanged:(id)sender;
- (IBAction)onBtnHistory:(id)sender;
- (IBAction)segHistoryChanged:(id)sender;
- (IBAction)onBtnHpat:(id)sender;
- (IBAction)segHpatChanged:(id)sender;
- (IBAction)onBtnLCVP:(id)sender;
- (IBAction)segLCVPChanged:(id)sender;
- (IBAction)onBtnMusic:(id)sender;
- (IBAction)segMusicChanged:(id)sender;
- (IBAction)onBtnReligion:(id)sender;
- (IBAction)segReligionChanged:(id)sender;
- (IBAction)onBtnSpanish:(id)sender;
- (IBAction)segSpanishChanged:(id)sender;
- (IBAction)onBtnTechGraphics:(id)sender;
- (IBAction)segTechGraphicChanged:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *viewBlackOpaque;
@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnReset:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
@end
