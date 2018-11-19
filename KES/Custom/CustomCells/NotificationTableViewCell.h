//
//  NotificationTableViewCell.h
//  KES
//
//  Created by Piglet on 07.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NotificationTableViewCellDelegate
- (void) selectDetail:(id) cell;
@end

@interface NotificationTableViewCell : UITableViewCell

@property (nonatomic, strong) id <NotificationTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailUnderline;
@property (weak, nonatomic) IBOutlet UILabel *lblTIme;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_lblDetail_height;


- (void) configureCell:(NSDictionary *) dic;

- (IBAction)onBtnUnderline:(id)sender;


@end
