//
//  RecipientGeneralTableViewCell.h
//  KES
//
//  Created by Piglet on 22.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RecipientGeneralTableViewCellDelegate
- (void) onBtnChevronGo:(int) index;
@end
@interface RecipientGeneralTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblConnectionsCount;
@property (weak, nonatomic) IBOutlet UIButton *btnChevron;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@property (nonatomic, strong) id <RecipientGeneralTableViewCellDelegate> delegate;
- (IBAction)onBtnChevron:(id)sender;
- (void) configureCell:(NSDictionary *) dic;



@end
