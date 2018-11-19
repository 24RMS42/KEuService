//
//  NotificationTableViewCell.m
//  KES
//
//  Created by Piglet on 07.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgUser.layer.cornerRadius = 15.0f;
    self.imgUser.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (void) configureCell:(NSDictionary *) dic
{
    [self.imgUser setImage:[UIImage imageNamed:dic[@"imgUser"]]];
    self.lblTIme.text = dic[@"time"];
    self.lblUsername.text = dic[@"username"];
    self.lblContent.text = dic[@"content"];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:dic[@"detail"]];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    self.lblDetailUnderline.attributedText = attributeString;
    
//    self.lblDetailUnderline.text = dic[@"detail"];
    if ([dic[@"recent"] boolValue] == true) {
        self.constraint_lblDetail_height.constant = 19.0f;
    }
    else
        self.constraint_lblDetail_height.constant = 0.0f;
}

- (IBAction)onBtnUnderline:(id)sender {
    [self.delegate selectDetail:self];
}
@end
