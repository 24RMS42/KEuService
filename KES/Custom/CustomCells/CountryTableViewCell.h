//
//  CountryTableViewCell.h
//  KES
//
//  Created by Piglet on 06.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryname;


- (void) configureCell:(NSDictionary *) dic andSelectedCountry:(NSString *) strCountry;

@end
