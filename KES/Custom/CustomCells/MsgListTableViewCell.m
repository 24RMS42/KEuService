//
//  MsgListTableViewCell.m
//  KES
//
//  Created by Piglet on 21.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "MsgListTableViewCell.h"

@implementation MsgListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgUser.layer.cornerRadius = 23.0f;
    self.imgUser.layer.masksToBounds = YES;
    self.lblunreadCount.layer.cornerRadius = 7.5f;
    self.lblunreadCount.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCell:(NSDictionary *) dic andStrSearch:(NSString *) strSearch
{
    self.lblTitle.text = [dic objectForKey:@"msg_title"];
    self.lblTIme.text = [dic objectForKey:@"msg_time"];
    NSString *strMsgContent = [dic objectForKey:@"msg_content"];
    if (strSearch.length > 0) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: self.lblContent.textColor,
                                  NSFontAttributeName: self.lblContent.font
                                  };

        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:strMsgContent
                                               attributes:attribs];

        // green text attributes
        UIColor *greenColor = [UIColor colorWithRed:0 green:198.0/255 blue:238.0/255 alpha:1.0];
        NSRange greenTextRange = [[strMsgContent lowercaseString] rangeOfString:[strSearch lowercaseString]];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:greenColor}
                                range:greenTextRange];
        self.lblContent.attributedText = attributedText;

    }
    else
    {
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: self.lblContent.textColor,
                                  NSFontAttributeName: self.lblContent.font
                                  };
        
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:strMsgContent
                                               attributes:attribs];
        self.lblContent.attributedText = attributedText;
    }
    NSString *strImgName = [dic objectForKey:@"msg_img"];
    [self.imgUser setImage:[UIImage imageNamed:strImgName]];
    NSInteger unreadCount = [[dic objectForKey:@"msg_unread"] integerValue];
    
    self.lblunreadCount.text = [NSString stringWithFormat:@"%ld", (long)unreadCount];
    
    if (unreadCount > 0) {
        [self.lblTitle setFont:[UIFont fontWithName:@"Roboto-Bold" size:16.0f]];
        [self.lblTIme setFont:[UIFont fontWithName:@"Roboto-Bold" size:12.0f]];
        self.constraint_lblUnreadCount_width.constant = 15.0f;
        self.lblUnread.text = @"Mark as read";
        [self.imgUnread setImage:[UIImage imageNamed:@"mail_unread.png"]];
    }
    else
    {
        [self.lblTitle setFont:[UIFont fontWithName:@"Roboto-Regular" size:16.0f]];
        [self.lblTIme setFont:[UIFont fontWithName:@"Roboto-Light" size:12.0f]];
        self.constraint_lblUnreadCount_width.constant = 0.0f;
        self.lblUnread.text = @"Mark as unread";
        [self.imgUnread setImage:[UIImage imageNamed:@"mail_read.png"]];
    }
    
    BOOL mute = [[dic objectForKey:@"mute"] boolValue];
    if (mute) {
        self.lblMute.text = @"Unmute";
        [self.imgMute setImage:[UIImage imageNamed:@"stop.png"]];
    }
    else
    {
        self.lblMute.text = @"Mute";
        [self.imgMute setImage:[UIImage imageNamed:@"more_mute_white.png"]];
    }
}

- (IBAction)onBtnRead:(id)sender {
    [self.delegate onBtnRead:self];
}

- (IBAction)onBtnMute:(id)sender {
    [self.delegate onBtnMute:self];
}

- (IBAction)onBtnArchive:(id)sender {
    [self.delegate onBtnArchive:self];
}

- (IBAction)onBtnChevron:(id)sender {
}
@end
