//
//  PNotiViewController.h
//  KES
//
//  Created by matata on 10/11/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"

@protocol PNotiViewControllerDelegate
- (void) goBackFromNotiViewController;
@end

@interface PNotiViewController : UIViewController<WebServicesDelegate>
{
    WebServices *objWebServices;
    NSString *updateProfileApi;
    int offset;
}
@property (nonatomic, strong) id <PNotiViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)onBtnSave:(id)sender;
- (IBAction)onBtnReset:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
@end
