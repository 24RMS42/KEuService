//
//  PastEventViewController.h
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "NSDate+TimeAgo.h"

@interface PastBookViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WebServicesDelegate>
{
    NSMutableArray *bookArray, *originArray;
    UIRefreshControl *refreshControl;
    int offset;
    WebServices *objWebServices;
    NSString *bookApi, *bookFilterApi;
}
@property (nonatomic, assign) bool whileSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UITextField *SearchField;
@property (weak, nonatomic) IBOutlet UIView *SearchView;
@property (weak, nonatomic) IBOutlet UIButton *SearchButton;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;

- (IBAction)OnUpEventClicked:(id)sender;
- (IBAction)OnSearchClicked:(id)sender;
- (IBAction)OnCancelClicked:(id)sender;
@end
