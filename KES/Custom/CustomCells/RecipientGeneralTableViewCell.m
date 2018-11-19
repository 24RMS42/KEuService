//
//  RecipientGeneralTableViewCell.m
//  KES
//
//  Created by Piglet on 22.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "RecipientGeneralTableViewCell.h"

@implementation RecipientGeneralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCell:(NSDictionary *) dic
{
    self.lblTitle.text = [dic objectForKey:@"recipient_title"];
    self.lblConnectionsCount.text = [NSString stringWithFormat:@"%@ connections", [dic objectForKey:@"recipient_count"]];
    if ([[dic objectForKey:@"recipient_yes"] isEqualToString:@"NO"]) {
        self.lblConnectionsCount.text = @"";
        self.viewLine.hidden = YES;
        self.btnChevron.hidden = YES;
    }
    
    
}

- (IBAction)onBtnChevron:(id)sender {
    UIButton *btn = (UIButton *) sender;
    [self.delegate onBtnChevronGo:(int) btn.tag];
}
@end
