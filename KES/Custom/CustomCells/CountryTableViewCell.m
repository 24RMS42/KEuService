//
//  CountryTableViewCell.m
//  KES
//
//  Created by Piglet on 06.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "CountryTableViewCell.h"

@implementation CountryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgFlag.layer.cornerRadius = 3.0f;
    self.imgFlag.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void) configureCell:(NSDictionary *) dic andSelectedCountry:(NSString *) strCountry;
{
    NSString *strName = [dic objectForKey:@"name"];
    NSString *strCode = [dic objectForKey:@"code"];
    self.lblCountryname.text = strName;
    NSString *imgPath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", strCode];
    [self.imgFlag setImage:[UIImage imageNamed:imgPath]];
    
    if ([strName isEqualToString:strCountry]) {
        [self.lblCountryname setTextColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0f]];
    }
    else
        [self.lblCountryname setTextColor:[UIColor colorWithRed:48.0f/255 green:48.0f/255 blue:48.0f/255 alpha:1.0f]];
}
@end
