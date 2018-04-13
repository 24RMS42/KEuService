//
//  CustomButton.m
//  KES
//
//  Created by matata on 2/23/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setBackgroundColor:[UIColor colorWithHex:COLOR_SECONDARY]];
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:16.0f];
        
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 2.0;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        
        CGRect frame = self.frame;
        frame.size = CGSizeMake(frame.size.width, 50);
        self.frame = frame;
    }
    return self;
}

@end
