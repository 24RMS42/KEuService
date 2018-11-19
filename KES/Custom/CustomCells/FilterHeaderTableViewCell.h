//
//  FilterHeaderTableViewCell.h
//  KES
//
//  Created by Piglet on 24.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnCollapse;
@property (weak, nonatomic) IBOutlet UIButton *btnOverwrap;



@end
