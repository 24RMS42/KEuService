//
//  MsgListTableViewCell.h
//  KES
//
//  Created by Piglet on 21.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MsgListTableViewCellDelegate
- (void) onBtnRead:(id) cell;
- (void) onBtnMute:(id) cell;
- (void) onBtnArchive:(id) cell;
@end
@interface MsgListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTIme;
@property (weak, nonatomic) IBOutlet UIButton *btnChevron;
@property (weak, nonatomic) IBOutlet UILabel *lblunreadCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgUnread;
@property (weak, nonatomic) IBOutlet UILabel *lblUnread;
@property (weak, nonatomic) IBOutlet UILabel *lblMute;
@property (weak, nonatomic) IBOutlet UIImageView *imgMute;
@property (nonatomic, strong) id <MsgListTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_lblUnreadCount_width;

- (IBAction)onBtnChevron:(id)sender;
- (void) configureCell:(NSDictionary *) dic andStrSearch:(NSString *) strSearch;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewUnread_width;  // 55
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewMute_width;    // 55
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewArchive_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewUnread_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewArchive_right;

- (IBAction)onBtnRead:(id)sender;
- (IBAction)onBtnMute:(id)sender;
- (IBAction)onBtnArchive:(id)sender;



@end
