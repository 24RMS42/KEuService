//
//  TodoActivityTableViewCell.m
//  KES
//
//  Created by Piglet on 21.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "TodoActivityTableViewCell.h"

@implementation TodoActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgPhoto.layer.cornerRadius = 15.0f;
    self.imgPhoto.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void) configureCell:(NSDictionary *) dic
{
    [self.imgPhoto setImage:[UIImage imageNamed:dic[@"image"]]];
    self.lblName.text = dic[@"username"];
    self.lblTime.text = dic[@"time"];
    self.lblDetail.text = dic[@"detail"];
}
@end
