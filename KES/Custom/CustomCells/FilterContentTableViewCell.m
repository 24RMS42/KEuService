//
//  FilterContentTableViewCell.m
//  KES
//
//  Created by Piglet on 24.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "FilterContentTableViewCell.h"

@implementation FilterContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) configureCell:(NSString *) strTxt isSelected:(BOOL) isSelect
{
    self.lblTitle.text = strTxt;
    if (isSelect) {
        [self.lblTitle setTextColor:[UIColor colorWithRed:23.0/255.0f green:186.0f/255.0f blue:233.0f/255 alpha:1.0f]];
        [self.btnCheck setImage:[UIImage imageNamed:@"check1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.lblTitle setTextColor: [UIColor colorWithRed:120.0f/255 green:120.0f/255 blue:120.0f/255 alpha:1.0f]];
        [self.btnCheck setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)onBtnCheck:(id)sender {
    [self.delegate clickCheck:self];
}
@end
