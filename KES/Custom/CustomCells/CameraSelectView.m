//
//  CameraSelectView.m
//  DIVERCITY
//
//  Created by Piglet on 03.07.18.
//  Copyright © 2018 DIVERCITY. All rights reserved.
//

#import "CameraSelectView.h"

@implementation CameraSelectView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewContain.layer.cornerRadius = 12.0f;
    self.viewContain.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.viewBlackBg addGestureRecognizer:tapGesture];
}

- (void) hideView
{
    [self.delegate hideCameraSelectView];
}
- (IBAction)onBtnTakePhoto:(id)sender {
    [self.delegate selectTakeAPhoto];
}

- (IBAction)onBtnOpenCameraRoll:(id)sender {
    [self.delegate selectGallery];
}
@end
