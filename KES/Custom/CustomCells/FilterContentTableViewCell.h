//
//  FilterContentTableViewCell.h
//  KES
//
//  Created by Piglet on 24.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FilterContentTableViewCellDelegate
- (void) clickCheck:(id) cell;
@end
@interface FilterContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (nonatomic, strong) id <FilterContentTableViewCellDelegate> delegate;

- (void) configureCell:(NSString *) strTxt isSelected:(BOOL) isSelect;
- (IBAction)onBtnCheck:(id)sender;

@end
