//
//  TodoActivityTableViewCell.h
//  KES
//
//  Created by Piglet on 21.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoActivityTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

- (void) configureCell:(NSDictionary *) dic;
@end

NS_ASSUME_NONNULL_END
