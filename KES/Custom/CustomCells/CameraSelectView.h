//
//  CameraSelectView.h
//  DIVERCITY
//
//  Created by Piglet on 03.07.18.
//  Copyright © 2018 DIVERCITY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CameraSelectViewDelegate
- (void) hideCameraSelectView;
- (void) selectTakeAPhoto;
- (void) selectGallery;
@end
@interface CameraSelectView : UIView

@property (weak, nonatomic) IBOutlet UIView *viewBlackBg;
@property (weak, nonatomic) IBOutlet UIView *viewContain;

@property (nonatomic, strong) id <CameraSelectViewDelegate> delegate;

- (IBAction)onBtnTakePhoto:(id)sender;
- (IBAction)onBtnOpenCameraRoll:(id)sender;


@end
