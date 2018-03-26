//
//  SubjectViewController.m
//  KES
//
//  Created by matata on 3/20/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "SubjectViewController.h"

@interface SubjectViewController ()

@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    for (SubjectModel *subjectObj in appDelegate.contactData.subjectArray) {
        NSInteger tag = [subjectObj.subject_id integerValue];
        UISwitch *enabledSwitch = (UISwitch*)[self.view viewWithTag:tag];
        UISegmentedControl *enabledSeg = (UISegmentedControl*)[self.view viewWithTag:(tag+100)];
        [enabledSwitch setOn:YES];
        enabledSeg.hidden = NO;
        
        if ([subjectObj.level_id isEqualToString:@"9"]) {
            enabledSeg.selectedSegmentIndex = 0;
        } else if ([subjectObj.level_id isEqualToString:@"8"]) {
            enabledSeg.selectedSegmentIndex = 1;
        } else if ([subjectObj.level_id isEqualToString:@"4"]) {
            enabledSeg.selectedSegmentIndex = 2;
        }
    }
    
    _levelSegment.selectedSegmentIndex = [appDelegate.contactData.cycle isEqualToString:@"Senior"] ? 1 : 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSubjectValue {
    appDelegate.contactData.cycle = _levelSegment.selectedSegmentIndex == 0 ? @"Junior" : @"Senior";
    
    NSMutableArray *enabledValues = [[NSMutableArray alloc] init];
    appDelegate.contactData.subjectArray = [[NSMutableArray alloc] init];
    
    if (_accountingSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_accountingSwitch.tag]];
    }
    if (_agSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_agSwitch.tag]];
    }
    if (_mathSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_mathSwitch.tag]];
    }
    if (_artSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_artSwitch.tag]];
    }
    if (_biologySwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_biologySwitch.tag]];
    }
    if (_businessSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_businessSwitch.tag]];
    }
    if (_chemistrySwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_chemistrySwitch.tag]];
    }
    if (_dcgSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_dcgSwitch.tag]];
    }
    if (_englishSwitch.isOn) {
        [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)_englishSwitch.tag]];
    }
    
    for (SubjectModel *obj in appDelegate.subjectArray) {
        for (NSString *val in enabledValues) {
            if ([val isEqualToString:obj.subject_id]) {
                UISegmentedControl *enabledSeg = (UISegmentedControl*)[self.view viewWithTag:([val intValue]+100)];
                if (enabledSeg.selectedSegmentIndex == 0) {
                    obj.level_id = @"9";
                } else if (enabledSeg.selectedSegmentIndex == 1) {
                    obj.level_id = @"8";
                } else if (enabledSeg.selectedSegmentIndex == 2) {
                    obj.level_id = @"4";
                }
                [appDelegate.contactData.subjectArray addObject:obj];
            }
        }
    }
    NSLog(@"~~~~~~~ %lu", (unsigned long)appDelegate.contactData.subjectArray.count);
}

- (void)changeLevelState:(id)sender {
    UISwitch *sentControl = (UISwitch*)sender;
    UISegmentedControl *seg = (UISegmentedControl*)[self.view viewWithTag:(sentControl.tag+100)];
    if (sentControl.isOn) {
        seg.hidden = NO;
    } else
        seg.hidden = YES;
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:updateProfileApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                
            } else {
                [Functions checkError:responseDict];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - IBAction
- (IBAction)OnBackClicked:(id)sender {
    [self updateSubjectValue];
    
    NSMutableDictionary *parameter = [Functions getProfileParameter];
    updateProfileApi = [NSString stringWithFormat:@"%@%@", BASE_URL, CONTACT_DETAIL];
    [objWebServices callApiWithParameters:parameter apiName:updateProfileApi type:POST_REQUEST loader:YES view:self];
}

- (IBAction)switchChanged:(id)sender {
    [self changeLevelState:sender];
}
@end
