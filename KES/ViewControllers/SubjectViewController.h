//
//  SubjectViewController.h
//  KES
//
//  Created by matata on 3/20/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"
#import "AppDelegate.h"

@interface SubjectViewController : UIViewController<WebServicesDelegate>
{
    WebServices *objWebServices;
    NSString *updateProfileApi;
    int offset;
    NSMutableArray *subjectTagLists;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *sInnerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *levelSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *accountingSegment;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UISwitch *accountingSwitch;
@property (weak, nonatomic) IBOutlet UITextView *explainTxt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_scContainer_height;

- (IBAction)OnBackClicked:(id)sender;
- (IBAction)switchChanged:(id)sender;
- (IBAction)cycleChanged:(id)sender;

@end
