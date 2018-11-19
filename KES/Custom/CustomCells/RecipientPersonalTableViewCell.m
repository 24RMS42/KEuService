//
//  RecipientPersonalTableViewCell.m
//  KES
//
//  Created by Piglet on 22.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "RecipientPersonalTableViewCell.h"

@implementation RecipientPersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgUser.layer.cornerRadius = 23.0f;
    self.imgUser.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) configureCell:(NSDictionary *) dic andIsSelect:(BOOL) isSelect
{
    NSString *strImgName = [dic objectForKey:@"recipient_personal_img"];
    NSString *strUsername = [dic objectForKey:@"recipient_personal_name"];
    NSString *strContent = [dic objectForKey:@"recipient_personal_content"];
    
    [self.imgUser setImage:[UIImage imageNamed:strImgName]];
    self.lblTitle.text = strUsername;
    self.lblContent.text = strContent;
    if (isSelect) {
        [self.btnSelect setImage:[UIImage imageNamed:@"check_color.png"] forState:UIControlStateNormal];
    }
    else
        [self.btnSelect setImage:[UIImage imageNamed:@"check_grey.png"] forState:UIControlStateNormal];
}

- (IBAction)onBtnSelect:(id)sender {
    UIButton *btnSelect = (UIButton *) sender;
    [self.delegate onClickBtnSelect:(int) btnSelect.tag];
}

@end
