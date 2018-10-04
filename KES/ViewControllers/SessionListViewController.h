//
//  SessionListViewController.h
//  KES
//
//  Created by matata on 9/13/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"

@interface SessionListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *from;
@property (nonatomic, retain) NSArray *sessionArray;
@property (nonatomic, retain) NSString *sessionDate;
@property (nonatomic, assign) NSInteger sessionIndex;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UITableView *sessionTableView;

- (IBAction)OnBackClicked:(id)sender;
@end
