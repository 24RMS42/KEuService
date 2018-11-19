//
//  RecipientPersonalTableViewCell.h
//  KES
//
//  Created by Piglet on 22.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RecipientPersonalTableViewCellDelegate

- (void) onClickBtnSelect:(int) index;

@end
@interface RecipientPersonalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;

@property (nonatomic, strong) id <RecipientPersonalTableViewCellDelegate> delegate;

- (IBAction)onBtnSelect:(id)sender;
- (void) configureCell:(NSDictionary *) dic andIsSelect:(BOOL) isSelect;
@end
