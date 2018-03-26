//
//  FeedbackViewController.h
//  KES
//
//  Created by matata on 3/16/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"

@interface FeedbackViewController : UIViewController<WebServicesDelegate, UITextViewDelegate>
{
    WebServices *objWebServices;
    NSString *sendFeedbackApi;
    NSString *msgPlaceHolder;
    NSUserDefaults *userInfo;
}
@property (nonatomic, retain) UIImage *screenshot;
@property (weak, nonatomic) IBOutlet UITextView *messageField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)onCancelClicked:(id)sender;
- (IBAction)OnSendClicked:(id)sender;

@end
