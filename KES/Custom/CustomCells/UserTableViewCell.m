//
//  UserTableViewCell.m
//  KES
//
//  Created by Piglet on 01.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) configureCell:(NSDictionary *) dic isIncluding:(BOOL) isIncluding
{
    [self.imgUser setImage:[UIImage imageNamed:dic[@"image"]]];
    self.lblUsername.text = dic[@"name"];
    self.lblDescription.text = dic[@"roll"];
    if (isIncluding) {
        [self.btnCheck setImage:[UIImage imageNamed:@"check1.png"] forState:UIControlStateNormal];
    }
    else
        [self.btnCheck setImage:nil forState:UIControlStateNormal];
}
@end
