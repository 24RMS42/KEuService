//
//  UserTableViewCell.h
//  KES
//
//  Created by Piglet on 01.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

- (void) configureCell:(NSDictionary *) dic isIncluding:(BOOL) isIncluding;


@end
