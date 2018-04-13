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
    
    [self retriveSubjects:appDelegate.contactData.cycle];
    
    _levelSegment.selectedSegmentIndex = [appDelegate.contactData.cycle isEqualToString:@"Senior"] ? 1 : 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retriveSubjects:(NSString *)cycle {
    //Remove existing subject views
    for (NSString *tag in subjectTagLists) {
        UIView *view = [self.sInnerView viewWithTag:[tag integerValue]];
        [view removeFromSuperview];
    }
    
    //Add news subject views
    offset = 0;
    subjectTagLists = [[NSMutableArray alloc] init];
    for (SubjectModel *subjectObj in appDelegate.subjectArray) {
        if ([subjectObj.cycle rangeOfString:cycle].location != NSNotFound) {
            NSLog(@"%@=====%@", subjectObj.cycle, cycle);
            NSInteger tag = [subjectObj.subject_id integerValue];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _subView.frame.origin.y + offset, _subView.frame.size.width, _subView.frame.size.height)];
            view.tag = tag + 200;
            
            [subjectTagLists addObject:@(tag + 200)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 2, 120, 36)];
            label.font = [UIFont fontWithName:@"Roboto-Light" size:15];
            label.textColor = [UIColor colorWithHex:COLOR_FONT];
            label.text = subjectObj.name;
            
            UISwitch *uswitch = [[UISwitch alloc] initWithFrame:CGRectMake(156, 4, 51, 31)];
            [uswitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            uswitch.tag = tag;
            
            NSArray *itemArray = [NSArray arrayWithObjects: @"F", @"O", @"H", nil];
            UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:itemArray];
            seg.frame = CGRectMake(227, 5, 126, 29);
            seg.tintColor = [UIColor colorWithHex:COLOR_THIRD];
            seg.selectedSegmentIndex = 0;
            seg.tag = tag + 100;
            seg.hidden = YES;
            
            [view addSubview:label];
            [view addSubview:uswitch];
            [view addSubview:seg];
            [self.sInnerView addSubview:view];
            offset += _subView.frame.size.height;
        }
    }
    
    CGRect frame = self.explainTxt.frame;
    frame.origin.y = self.subView.frame.origin.y + offset;
    self.explainTxt.frame = frame;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _explainTxt.frame.origin.y + _explainTxt.frame.size.height);
    
    for (SubjectModel *subjectObj in appDelegate.contactData.subjectArray) {
        NSInteger tag = [subjectObj.subject_id integerValue];
        UISwitch *enabledSwitch = (UISwitch*)[self.sInnerView viewWithTag:tag];
        UISegmentedControl *enabledSeg = (UISegmentedControl*)[self.sInnerView viewWithTag:(tag+100)];
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
}

- (void)updateSubjectValue {
    appDelegate.contactData.cycle = _levelSegment.selectedSegmentIndex == 0 ? @"Junior" : @"Senior";
    
    NSMutableArray *enabledValues = [[NSMutableArray alloc] init];
    appDelegate.contactData.subjectArray = [[NSMutableArray alloc] init];
    
    for (SubjectModel *subjectObj in appDelegate.subjectArray) {
        if ([subjectObj.cycle rangeOfString:appDelegate.contactData.cycle].location != NSNotFound) {
            NSInteger tag = [subjectObj.subject_id integerValue];
            UISwitch *enabledSwitch = (UISwitch*)[self.sInnerView viewWithTag:tag];
            if (enabledSwitch.isOn) {
                [enabledValues addObject:[NSString stringWithFormat:@"%ld", (long)enabledSwitch.tag]];
            }
        }
    }
    NSLog(@"enabled count is %lu", (unsigned long)enabledValues.count);
    
    for (SubjectModel *obj in appDelegate.subjectArray) {
        for (NSString *val in enabledValues) {
            if ([val isEqualToString:obj.subject_id]) {
                UISegmentedControl *enabledSeg = (UISegmentedControl*)[self.sInnerView viewWithTag:([val intValue]+100)];
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
    UISegmentedControl *seg = (UISegmentedControl*)[self.sInnerView viewWithTag:(sentControl.tag+100)];
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
                NSLog(@"Subject update success");
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

- (IBAction)cycleChanged:(id)sender {
    NSString *selectedCycle = _levelSegment.selectedSegmentIndex == 0 ? @"Junior" : @"Senior";
    [self retriveSubjects:selectedCycle];
}
@end
