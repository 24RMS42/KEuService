//
//  ProfileParentViewController.m
//  KES
//
//  Created by Piglet on 03.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "ProfileParentViewController.h"

@interface ProfileParentViewController ()

@end

@implementation ProfileParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileSubVC = self.childViewControllers.lastObject;
    self.profileSubVC.delegate = self;
    [self createCameraSelectView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBlackView)
                                                 name:NOTI_BLACKVIEW_SHOW
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:NOTI_BLACKVIEW_HIDE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndex:) name:NOTI_SELECT_INDEX1 object:nil];
    
    //arrCategories = @[@"Profile", @"Address", @"Family", @"Notifications", @"Education", @"Password", @"Email settings", @"Preferences"];
    arrCategories = @[@"Profile", @"Address", @"Family", @"Notifications", @"Password"];
    
    [self.tbCategories registerNib:[UINib nibWithNibName:@"MemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"MemberTableViewCell"];
    
    [Functions setBoundsWithView:self.tbCategories];
    [Functions setBoundsWithView:self.btnCategory];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCameraView)
                                                 name:NOTI_SHOW_CAMERAVIEW
                                               object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBlackViewWithTouch)];
    [self.viewBlackOpaque addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Functions

- (void) createCameraSelectView
{
    self.cameraSelectView = [NSBundle.mainBundle loadNibNamed:@"CameraSelectView" owner:self options:nil].firstObject;
    self.cameraSelectView.delegate = self;
    [self.view addSubview:self.cameraSelectView];
    self.cameraSelectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.cameraSelectView.alpha = 0.0;
}
- (void) showCameraView
{
    [Functions showStatusBarBlackView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:self.cameraSelectView];
        [UIView animateWithDuration:0.3 animations:^{
            self.cameraSelectView.alpha = 1.0;
        }];
    });
    
}

- (void) showBlackView
{
    [Functions showStatusBarBlackView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f animations:^{
            [self.view sendSubviewToBack:self.viewSubContain];
            [self.view sendSubviewToBack:self.btnCategory];
            
            self.viewBlackOpaque.alpha = 0.7f;
        }];
    });
    
}

- (void) showBlackViewForSelf
{
    [Functions showStatusBarBlackView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f animations:^{
            self.viewBlackOpaque.alpha = 0.7f;
        }];
    });
    
}

- (void) hideBlackViewWithTouch
{
    [self hideBlackView];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_BLACKVIEW_SUPER object:nil];
}

- (void) hideBlackView
{
    [Functions hideStatusBarBlackView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f animations:^{
            self.viewBlackOpaque.alpha = 0.0f;
            self.tbCategories.alpha = 0.0f;
        }];
    });
    

}
- (void) selectIndex:(NSNotification *) notification
{
    NSDictionary* info = notification.userInfo;
    NSString *selectedIndex = [info objectForKey:NOTI_SELECT_INDEX];
    [self setValueForLblType:[selectedIndex intValue]];
}

- (void) setValueForLblType:(int) index
{
    switch (index) {
        case 0:
            self.lblProfileType.text = @"Profile";
            break;
        case 1:
            self.lblProfileType.text = @"Address";
            break;
        case 2:
            self.lblProfileType.text = @"Family";
            break;
        case 3:
            self.lblProfileType.text = @"Notifications";
            break;
        case 4:
            self.lblProfileType.text = @"Password";
            break;
        default:
            break;
    }
}
#pragma mark - CameraSelectViewDelegate
- (void) hideCameraSelectView
{
    [Functions hideStatusBarBlackView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.cameraSelectView.alpha = 0.0f;
        }];
    });
    
    
}

- (void) selectTakeAPhoto
{
    [self hideCameraSelectView];
    @try
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerCameraDeviceFront;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        picker.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:picker animated:YES completion:nil];
        });
        
        
        
    }
    @catch (NSException *exception)
    {
        
    }
}
- (void) selectGallery
{
    [self hideCameraSelectView];
    @try
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        picker.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:picker animated:YES completion:nil];
        });
        
    }
    @catch (NSException *exception)
    {
        
    }
}
#pragma mark - UIImagePicker Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *imgAvatar = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *dicPhoto = @{@"photo" : imgAvatar};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SELECT_PROFILE_PHOTO object:nil userInfo:dicPhoto];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrCategories.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberTableViewCell"];
    NSString *strCategory = [arrCategories objectAtIndex:indexPath.row];
    cell.lblMemberName.text = strCategory;
    if ([strCategory isEqualToString:self.lblProfileType.text]) {
        [cell.lblMemberName setTextColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
    }
    else
        [cell.lblMemberName setTextColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* info = @{NOTI_SELECT_INDEX: [NSString stringWithFormat:@"%ld", (long)indexPath.row]};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SELECT_INDEX object:self userInfo:info];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.tbCategories.alpha = 0.0f;
    }];
    [self hideBlackView];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HIDE_SUB_BLACK object:nil];
}
#pragma mark - ProfileSubViewControllerDelegate

- (void) goBackForParentView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnCategoryClicked:(id)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.tbCategories.alpha = 1.0f;
    }];
    [self.tbCategories reloadData];
    [self.view bringSubviewToFront:self.btnCategory];
    [self.view bringSubviewToFront:self.viewSubContain];
    [self showBlackViewForSelf];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SHOW_SUB_BLACK object:nil];
}
@end
