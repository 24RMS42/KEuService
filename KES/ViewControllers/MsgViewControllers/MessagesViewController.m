//
//  MessagesViewController.m
//  KES
//
//  Created by Piglet on 20.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "MessagesViewController.h"

@interface MessagesViewController ()
{
    NSMutableArray *arrSelectedSectionIndex;
    NSMutableArray *arrSetions;
    NSMutableArray *arrFilters;
    BOOL isMultipleExpansionAllowed;
    NSMutableArray *arrSelectedFilters;
    BOOL isSelectedForUnRead;
}
@end

@implementation MessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setPlusBtnUI];
    [self setFilterBtnUI];
    
    [self.tbMessaging registerNib:[UINib nibWithNibName:@"MsgListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MsgListTableViewCell"];
    [self.tbFilter registerNib:[UINib nibWithNibName:@"FilterHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"FilterHeaderTableViewCell"];
    [self.tbFilter registerNib:[UINib nibWithNibName:@"FilterContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"FilterContentTableViewCell"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideItemsInNewMsgView)];
    [self.viewNewMsg addGestureRecognizer:tapGesture];
    
    arrMsgs = [NSMutableArray new];
    arrTestData = [NSMutableArray new];
    [self setTestData];
    
    isMultipleExpansionAllowed = YES;
    arrSelectedSectionIndex = [[NSMutableArray alloc] init];
    arrSetions = [[NSMutableArray alloc] init];
    arrFilters = [[NSMutableArray alloc] init];
    arrSelectedFilters = [[NSMutableArray alloc] init];
    [self setTestDataForSection];
    
    isShowingFilterView = false;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFilterView)];
    [self.viewBlackOpaque addGestureRecognizer:tapGesture1];
    [self performSelector:@selector(hideNoMsg) withObject:nil afterDelay:3.0f];
    [self addRefreshControl];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    [swipeLeft setDirection: UISwipeGestureRecognizerDirectionLeft ];
    [self.tbMessaging addGestureRecognizer:swipeLeft];
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tbMessaging addGestureRecognizer:swipeRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Functions
- (void) addRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor colorWithRed:174.0/255 green:174.0/255 blue:174.0/255 alpha:1.0];
    [self.refreshControl addTarget:self
                            action:@selector(pullToRefresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tbMessaging addSubview:self.refreshControl];
}

- (void) pullToRefresh
{
    [self performSelector:@selector(removeRefreshControlForTest) withObject:nil afterDelay:3.0];
}

- (void) removeRefreshControlForTest
{
    [self.refreshControl endRefreshing];
}

- (void) hideNoMsg
{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewNoMsg.alpha = 0;
    }];
    
}
- (void) setTestData
{
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    [dic1 setObject:@"Elizabeth Bennet" forKey:@"msg_title"];
    [dic1 setValue:@NO forKey:@"mute"];
    [dic1 setValue:@NO forKey:@"archived"];
    [dic1 setObject:@"5 min ago" forKey:@"msg_time"];
    [dic1 setObject:@"You: Hi Fred, Pebbles was absent today due to andentist appointment. Just let you know" forKey:@"msg_content"];
    [dic1 setObject:[NSNumber numberWithInteger:5] forKey:@"msg_unread"];
    [dic1 setObject:@"men" forKey:@"type"];
    [dic1 setObject:@"Julie Kilmartin" forKey:@"type_name"];
    [dic1 setObject:@"imgSample.png" forKey:@"msg_img"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    [dic2 setObject:@"Test topic title" forKey:@"msg_title"];
    [dic2 setValue:@NO forKey:@"mute"];
    [dic2 setValue:@NO forKey:@"archived"];
    [dic2 setObject:@"9:15 am" forKey:@"msg_time"];
    [dic2 setObject:@"Julie: Hi all, please check your homework" forKey:@"msg_content"];
    [dic2 setObject:[NSNumber numberWithInteger:3] forKey:@"msg_unread"];
    [dic2 setObject:@"men" forKey:@"type"];
    [dic2 setObject:@"Me" forKey:@"type_name"];
    [dic2 setObject:@"imgSample.png" forKey:@"msg_img"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    [dic3 setObject:@"Fitzwilliam Darcy" forKey:@"msg_title"];
    [dic3 setValue:@NO forKey:@"mute"];
    [dic3 setValue:@NO forKey:@"archived"];
    [dic3 setObject:@"yesterday" forKey:@"msg_time"];
    [dic3 setObject:@"Julie: Hi Fitz, Elizabeth was absent today" forKey:@"msg_content"];
    [dic3 setObject:[NSNumber numberWithInteger:0] forKey:@"msg_unread"];
    [dic3 setObject:@"parent" forKey:@"type"];
    [dic3 setObject:@"Parent 1" forKey:@"type_name"];
    [dic3 setObject:@"imgSample.png" forKey:@"msg_img"];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    [dic4 setObject:@"Elizabeth Bennet" forKey:@"msg_title"];
    [dic4 setValue:@NO forKey:@"mute"];
    [dic4 setValue:@NO forKey:@"archived"];
    [dic4 setObject:@"5 min ago" forKey:@"msg_time"];
    [dic4 setObject:@"Fred: Hi Elizabeth pebbles was absent today" forKey:@"msg_content"];
    [dic4 setObject:[NSNumber numberWithInteger:0] forKey:@"msg_unread"];
    [dic4 setObject:@"parent" forKey:@"type"];
    [dic4 setObject:@"Parent 2" forKey:@"type_name"];
    [dic4 setObject:@"imgSample.png" forKey:@"msg_img"];
    
    NSMutableDictionary *dic5 = [NSMutableDictionary new];
    [dic5 setObject:@"EnglishLC 6th" forKey:@"msg_title"];
    [dic5 setValue:@NO forKey:@"mute"];
    [dic5 setValue:@NO forKey:@"archived"];
    [dic5 setObject:@"9:15 am" forKey:@"msg_time"];
    [dic5 setObject:@"You: Hi all, please check your homework" forKey:@"msg_content"];
    [dic5 setObject:[NSNumber numberWithInteger:0] forKey:@"msg_unread"];
    [dic5 setObject:@"student" forKey:@"type"];
    [dic5 setObject:@"Student 1" forKey:@"type_name"];
    [dic5 setObject:@"imgSample.png" forKey:@"msg_img"];
    
    NSMutableDictionary *dic6 = [NSMutableDictionary new];
    [dic6 setObject:@"Fitzwilliam Darcy" forKey:@"msg_title"];
    [dic6 setValue:@NO forKey:@"mute"];
    [dic6 setValue:@NO forKey:@"archived"];
    [dic6 setObject:@"yesterday" forKey:@"msg_time"];
    [dic6 setObject:@"You: Hi Fitz, Elizabeth was absent today" forKey:@"msg_content"];
    [dic6 setObject:[NSNumber numberWithInteger:0] forKey:@"msg_unread"];
    [dic6 setObject:@"student" forKey:@"type"];
    [dic6 setObject:@"Student 2" forKey:@"type_name"];
    [dic6 setObject:@"imgSample.png" forKey:@"msg_img"];
    
    [arrTestData addObject:dic1];
    [arrTestData addObject:dic2];
    [arrTestData addObject:dic3];
    [arrTestData addObject:dic4];
    [arrTestData addObject:dic5];
    [arrTestData addObject:dic6];
    [arrMsgs addObjectsFromArray:arrTestData];
    [self.tbMessaging reloadData];
}

- (void) setTestDataForSection
{
    [arrSetions removeAllObjects];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"Staff" forKey:@"section_title"];
    [dic setObject:@"" forKey:@"section_content"];
    
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"Parents" forKey:@"section_title"];
    [dic1 setObject:@"" forKey:@"section_content"];
    
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"Students" forKey:@"section_title"];
    [dic2 setObject:@"" forKey:@"section_content"];
    
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:@"Unread" forKey:@"section_title"];
    [dic3 setObject:@"" forKey:@"section_content"];
    
    [arrSetions addObject:dic];
    [arrSetions addObject:dic1];
    [arrSetions addObject:dic2];
    [arrSetions addObject:dic3];
    [self setTestDataForFilter];
}

- (void) setTestDataForFilter
{
    // Staf
    
    NSMutableArray *arrTm1 = [NSMutableArray new];
    for (int i=0; i<arrMsgs.count; i++) {
        NSDictionary *dic = [arrMsgs objectAtIndex:i];
        if ([dic[@"type"] isEqualToString:@"men"]) {
            [arrTm1 addObject:dic[@"type_name"]];
        }
    }
    [arrTm1 addObject:@"All staf"];
    
    NSMutableArray *arrParents1 = [NSMutableArray new];
    for (int i=0; i<arrMsgs.count; i++) {
        NSDictionary *dic = [arrMsgs objectAtIndex:i];
        if ([dic[@"type"] isEqualToString:@"parent"]) {
            [arrParents1 addObject:dic[@"type_name"]];
        }
    }

    [arrParents1 addObject:@"All parents"];
    
    NSMutableArray *arrStudnets = [NSMutableArray new];
    for (int i=0; i<arrMsgs.count; i++) {
        NSDictionary *dic = [arrMsgs objectAtIndex:i];
        if ([dic[@"type"] isEqualToString:@"student"]) {
            [arrStudnets addObject:dic[@"type_name"]];
        }
    }
    [arrStudnets addObject:@"All students"];
    
    [arrFilters addObject:arrTm1];
    [arrFilters addObject:arrParents1];
    [arrFilters addObject:arrStudnets];
}

- (void) setPlusBtnUI
{
    self.btnPlus.layer.cornerRadius = 32.0f;
    self.btnPlus.layer.masksToBounds = YES;
}

- (void) setFilterBtnUI
{
    self.viewSearchBg.layer.cornerRadius = 3.0f;
    self.viewSearchBg.layer.masksToBounds = YES;
    
    [self.btnFilter setBackgroundImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
    
}

- (void) showFilterView
{
    if (isShowingFilterView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.btnFilter setImage:[UIImage imageNamed:@"filter_press.png"] forState:UIControlStateNormal];
            self.viewFilterParent.alpha = 1.0f;
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.viewFilterParent.alpha = 0.0f;
            [self.btnFilter setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
            [self.view layoutIfNeeded];
        }];
    }
    
}

- (void) showBlackOpaqueView
{
    if (isShowingFilterView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.viewBlackOpaque.alpha = 0.3f;
        }];
    }
    else
        [UIView animateWithDuration:0.3 animations:^{
            self.viewBlackOpaque.alpha = 0.0f;
        }];
    
}

- (void) showNewMsgView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewNewMsg.alpha = 1.0f;
        
    }];
    [self performSelector:@selector(showItemsInNewMsgView) withObject:nil afterDelay:0.3];
}

- (void) showItemsInNewMsgView
{
    self.constraint_btnTmp_height.constant = 64;
    self.constraint_btnComposeOne_bottom.constant = 40;
    self.constraint_btnComposeOne_height.constant = 50;
    self.constraint_btnComposeGroup_bottom.constant = 30;
    self.constraint_btnComposeGroup_height.constant = 50;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.lblComposeOne.alpha = 1.0f;
        self.lblComposeGroup.alpha = 1.0f;
        self.btnTmp.alpha = 1.0f;
        self.btnComposeOne.alpha = 1.0f;
        self.btnComposeGroup.alpha = 1.0f;
        [self.btnPlus setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:186.0/255.0 blue:233.0/255.0 alpha:1.0f]];
        [self.view layoutIfNeeded];
    }];
}

- (void) hideItemsInNewMsgView
{
    self.constraint_btnTmp_height.constant = 32;
    self.constraint_btnComposeOne_bottom.constant = 0;
    self.constraint_btnComposeOne_height.constant = 0;
    self.constraint_btnComposeGroup_bottom.constant = 0;
    self.constraint_btnComposeGroup_height.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.lblComposeOne.alpha = 0.0f;
        self.lblComposeGroup.alpha = 0.0f;
        self.btnTmp.alpha = 0.0f;
        self.btnComposeOne.alpha = 0.0f;
        self.btnComposeGroup.alpha = 0.0f;
        [self.view layoutIfNeeded];
    }];
    
    [self performSelector:@selector(hideNewMsgView) withObject:nil afterDelay:0.5];
}

- (void) hideNewMsgView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.viewNewMsg.alpha = 0.0f;
        [self.btnPlus setBackgroundColor:[UIColor colorWithRed:16.0/255.0 green:42.0/255.0 blue:108.0/255.0 alpha:1.0f]];
    }];
}

- (void) setLblClearallWithCount
{
    if (arrSelectedFilters.count > 0) {
        self.lblClearall.text = [NSString stringWithFormat:@"Clear all(%lu)", (unsigned long)arrSelectedFilters.count];
    }
    else
        self.lblClearall.text = @"Clear all";
    [self setMsgArrayWithSearchAndFilter];
}

-(void)rightSwipe:(UISwipeGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.tbMessaging];
    NSIndexPath * indexPath = [self.tbMessaging indexPathForRowAtPoint:location];
    
    if(indexPath){
        MsgListTableViewCell * cell = (MsgListTableViewCell *)[self.tbMessaging cellForRowAtIndexPath:indexPath];
        if (cell.constraint_viewMute_width.constant != 0.0f) {
            cell.constraint_viewMute_width.constant = 0.0f;
            cell.constraint_viewArchive_width.constant = 0.0f;
            cell.constraint_viewUnread_left.constant = 0.0f;
        }
        else
        {
            if (cell.constraint_viewUnread_width.constant == 0) {
                cell.constraint_viewUnread_width.constant = 55.0f;
                cell.constraint_viewArchive_right.constant = -55.0f;
            }
            else
            {
                cell.constraint_viewUnread_width.constant = 0.0f;
                cell.constraint_viewArchive_right.constant = 0.0f;
            }
            
        }
        [UIView animateWithDuration:0.3 animations:^{
            [cell layoutIfNeeded];
        }];
        
    }
    
}

-(void)leftSwipe:(UISwipeGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.tbMessaging];
    NSIndexPath * indexPath = [self.tbMessaging indexPathForRowAtPoint:location];
    
    if(indexPath){
        MsgListTableViewCell * cell = (MsgListTableViewCell *)[self.tbMessaging cellForRowAtIndexPath:indexPath];
        if (cell.constraint_viewUnread_width.constant != 0.0f) {
            cell.constraint_viewUnread_width.constant = 0.0f;
            cell.constraint_viewArchive_right.constant = 0.0f;
        }
        else
        {
            if (cell.constraint_viewMute_width.constant == 0) {
                cell.constraint_viewMute_width.constant = 55.0f;
                cell.constraint_viewArchive_width.constant = 60.0f;
                cell.constraint_viewUnread_left.constant = -115.0f;
            }
            else
            {
                cell.constraint_viewMute_width.constant = 0.0f;
                cell.constraint_viewArchive_width.constant = 0.0f;
                cell.constraint_viewUnread_left.constant = 0.0f;
            }
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [cell layoutIfNeeded];
        }];
    }
    
}

-(void)btnTapShowHideSection:(UIButton*)sender
{
    if(sender.tag == 3)
    {
        isSelectedForUnRead = !isSelectedForUnRead;
        [self setLblClearallWithCount];
    }
    else
    {
        if (![arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:sender.tag]])
        {
            [arrSelectedSectionIndex removeAllObjects];
            [arrSelectedSectionIndex addObject:[NSNumber numberWithInteger:sender.tag]];
        }
        else{
            [arrSelectedSectionIndex removeObject:[NSNumber numberWithInteger:sender.tag]];
        }
        
    }
    [self.tbFilter reloadData];
    
}

#pragma mark - MsgListTableViewCellDelegate
- (void) onBtnRead:(id) cell
{
    MsgListTableViewCell *tmpCell = (MsgListTableViewCell *) cell;
    NSIndexPath *indexPath = [self.tbMessaging indexPathForCell:tmpCell];
    NSMutableDictionary *dic = [arrMsgs objectAtIndex:indexPath.row];
    NSNumber *numb = [dic objectForKey:@"msg_unread"];
    if ([numb integerValue] > 0) {
        numb = [NSNumber numberWithInt:0];
        
    }
    else
        numb = [NSNumber numberWithInt:1];
    [dic setObject:numb forKey:@"msg_unread"];
    [arrMsgs replaceObjectAtIndex:indexPath.row withObject:dic];
    [self.tbMessaging reloadData];
    
    tmpCell.constraint_viewUnread_width.constant = 0.0f;
    tmpCell.constraint_viewArchive_right.constant = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        [tmpCell layoutIfNeeded];
    }];
}

- (void) onBtnMute:(id) cell
{
    MsgListTableViewCell *tmpCell = (MsgListTableViewCell *) cell;
    NSIndexPath *indexPath = [self.tbMessaging indexPathForCell:tmpCell];
    NSMutableDictionary *dic = [arrMsgs objectAtIndex:indexPath.row];
    bool isMute = [dic[@"mute"] boolValue];
    NSNumber *numMute = [NSNumber numberWithBool:!isMute];
    [dic setObject:numMute forKey:@"mute"];
    [arrMsgs replaceObjectAtIndex:indexPath.row withObject:dic];
    [self.tbMessaging reloadData];
    
    tmpCell.constraint_viewMute_width.constant = 0.0f;
    tmpCell.constraint_viewArchive_width.constant = 0.0f;
    tmpCell.constraint_viewUnread_left.constant = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        [tmpCell layoutIfNeeded];
    }];
}
- (void) onBtnArchive:(id) cell
{
    MsgListTableViewCell *tmpCell = (MsgListTableViewCell *) cell;
    NSIndexPath *indexPath = [self.tbMessaging indexPathForCell:tmpCell];
    NSMutableDictionary *dic = [arrMsgs objectAtIndex:indexPath.row];
    bool isArchived = [dic[@"archived"] boolValue];
    [dic setObject:[NSNumber numberWithBool:!isArchived] forKey:@"archived"];
    [arrMsgs removeObjectAtIndex:indexPath.row];
    tmpCell.constraint_viewMute_width.constant = 0.0f;
    tmpCell.constraint_viewArchive_width.constant = 0.0f;
    tmpCell.constraint_viewUnread_left.constant = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        [tmpCell layoutIfNeeded];
    }];
    [self.tbMessaging reloadData];
}
#pragma mark - FilterContentTableViewCellDelegate
- (void) clickCheck:(id) cell
{
    NSIndexPath *indexPath = [self.tbFilter indexPathForCell:cell];
    NSArray *arrTmp = [arrFilters objectAtIndex:indexPath.section];
    NSString *strTmp = [arrTmp objectAtIndex:indexPath.row];
    
    if (arrTmp.count == indexPath.row+1) {
        for (int i=0; i<arrTmp.count; i++) {
            NSString *strTmp1 = [arrTmp objectAtIndex:i];
            if (![arrSelectedFilters containsObject:strTmp1]) {
                [arrSelectedFilters addObject:strTmp1];
            }
        }
    }
    else
    {
        if (![arrSelectedFilters containsObject:strTmp]) {
            [arrSelectedFilters addObject:strTmp];
        }
        else
        {
            [arrSelectedFilters removeObject:strTmp];
            NSString *strTmpLast = [arrTmp lastObject];
            if ([arrSelectedFilters containsObject: strTmpLast]) {
                [arrSelectedFilters removeObject:strTmpLast];
            }
        }
    }
    
    // ----- All Staf -----
    NSMutableDictionary *dic = [arrSetions firstObject];
    
    if ([arrSelectedFilters containsObject:@"All staf"]) {
        [dic setObject:@"All staf" forKey:@"section_content"];
        
        [arrSetions replaceObjectAtIndex:0 withObject:dic];
    }
    else
    {
        
        if ([arrSelectedFilters containsObject:@"Julie Kilmartin"] || [arrSelectedFilters containsObject:@"Me"]) {
            if ([arrSelectedFilters containsObject:@"Julie Kilmartin"]) {
                NSString *strTmp1 = @"Julie Kilmartin";
                if ([arrSelectedFilters containsObject:@"Me"]) {
                    strTmp1 = @"Julie Kilmartin, Me";
                }
                [dic setObject:strTmp1 forKey:@"section_content"];
                [arrSetions replaceObjectAtIndex:0 withObject:dic];
            }
            else
            {
                NSString *strTmp1 = @"Me";
                [dic setObject:strTmp1 forKey:@"section_content"];
                [arrSetions replaceObjectAtIndex:0 withObject:dic];
            }
            
        }
    }
    // -----
    
    // ----- Parents -----
    NSMutableDictionary *dic1 = [arrSetions objectAtIndex:1];
    if ([arrSelectedFilters containsObject:@"All parents"]) {
        [dic1 setObject:@"All parents" forKey:@"section_content"];
        [arrSetions replaceObjectAtIndex:1 withObject:dic1];
    }
    else
    {
        if ([arrSelectedFilters containsObject:@"Parent 1"] || [arrSelectedFilters containsObject:@"Parent 2"]) {
            if ([arrSelectedFilters containsObject:@"Parent 1"]) {
                NSString *strTmp2 = @"Parent 1";
                if ([arrSelectedFilters containsObject:@"Parent 2"]) {
                    strTmp2 = @"Parent 1, Parent 2";
                }
                [dic1 setObject:strTmp2 forKey:@"section_content"];
                [arrSetions replaceObjectAtIndex:1 withObject:dic1];
            }
            else
            {
                NSString *strTmp2 = @"Parent 2";
                [dic1 setObject:strTmp2 forKey:@"section_content"];
                [arrSetions replaceObjectAtIndex:1 withObject:dic1];
            }

        }
    }
    
    
    [self.tbFilter reloadData];
    [self setLblClearallWithCount];
}
#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.tbFilter]) {
        return arrSetions.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tbFilter]) {
        return 58.0f;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tbFilter])
    {
        if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
        {
            NSArray *arrTmp = [arrFilters objectAtIndex:section];
            return arrTmp.count;
        }else{
            return 0;
        }
    }
    return arrMsgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tbFilter])
    {
        FilterContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterContentTableViewCell"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FilterContentTableViewCell"];
        }
        NSArray *arrTmp = [arrFilters objectAtIndex:indexPath.section];
        NSString *strTmp = [arrTmp objectAtIndex:indexPath.row];
        BOOL isIncluding = false;
        if ([arrSelectedFilters containsObject:strTmp]) {
            isIncluding = YES;
        }

        [cell configureCell:strTmp isSelected:isIncluding];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else
    {
        NSDictionary *dic = [arrMsgs objectAtIndex:indexPath.row];
        MsgListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgListTableViewCell"];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MsgListTableViewCell"];
        }
        cell.delegate = self;
        [cell configureCell:dic andStrSearch:strSearch];
        
        return cell;
    }
    
    return nil;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    FilterHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterHeaderTableViewCell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FilterHeaderTableViewCell"];
    }
    NSDictionary *dic = [arrSetions objectAtIndex:section];
    
    cell.lblTitle.text = [dic objectForKey:@"section_title"];
    cell.lblContent.text = [dic objectForKey:@"section_content"];
    if (section == 3) {
        [cell.btnCollapse setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [cell.btnCollapse setImage:[UIImage imageNamed:@"check1.png"] forState:UIControlStateSelected];
        if (isSelectedForUnRead) {
            cell.btnCollapse.selected = YES;
        }
        else
            cell.btnCollapse.selected = NO;
    }
    else
    {
        [cell.btnCollapse setImage:[UIImage imageNamed:@"chevron_down.png"] forState:UIControlStateNormal];
        [cell.btnCollapse setImage:[UIImage imageNamed:@"expanded.png"] forState:UIControlStateSelected];
        if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
        {
            cell.btnCollapse.selected = YES;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell btnOverwrap] setTag:section];
    [[cell btnOverwrap] addTarget:self action:@selector(btnTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tbMessaging deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *vc = [[UIStoryboard storyboardWithName:@"Messages" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
    
    if (indexPath.row == 1) {
        vc.isNoReply = YES;
        vc.strType = @"";
    }
    else
    {
        vc.isNoReply = false;
        vc.strType = @"";
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (![self.tfSearch.text isEqualToString:@""]) {
        self.lblSearchMsg.hidden = YES;
    }
    else
    {
        self.lblSearchMsg.hidden = NO;
    }
    self.constraint_viewNav_height.constant = 10;
    self.constraint_btnCancel_width.constant = 46.0f;
    self.constraint_imgSearch_widht.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.imgSearch.alpha = 0.0f;
        self.lblTitle.alpha = 0.0f;
        self.btnBack.alpha = 0.0f;
        [self.view layoutIfNeeded];
    }];
    self.btnFilter.hidden = YES;
    self.btnSearchClose.hidden = false;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        self.lblSearchMsg.hidden = false;
        self.constraint_viewNav_height.constant = 64.0f;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
            self.lblTitle.alpha = 1.0f;
            self.btnBack.alpha = 1.0f;
        }];
    }
    self.btnSearchClose.hidden = YES;
    self.btnFilter.hidden = false;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strText =  [textField.text stringByReplacingCharactersInRange:range withString:string];
    strSearch = strText;
    [self setMsgArrayWithSearchAndFilter];
    return YES;
}

// Here : Set Messages array with search and filter

- (void) setMsgArrayWithSearchAndFilter
{
    [arrMsgs removeAllObjects];
    if (strSearch.length > 0) {
        
        for (int i=0; i<arrTestData.count; i++) {
            NSDictionary *dic = [arrTestData objectAtIndex:i];
            if (isSelectedForUnRead) {
                if ([dic[@"msg_unread"] integerValue] > 0) {
                    [arrMsgs addObject:dic];
                    continue;
                }
            }
            if ([[[dic objectForKey:@"msg_title"] lowercaseString] rangeOfString:[strSearch lowercaseString]].location != NSNotFound || [[[dic objectForKey:@"msg_content"] lowercaseString] rangeOfString:[strSearch lowercaseString]].location != NSNotFound) {
                
                if (arrSelectedFilters.count == 0) {
                    [arrMsgs addObject:dic];
                }
                else
                {
                    for (int j=0; j<arrSelectedFilters.count; j++) {
                        NSString *strTmp = [arrSelectedFilters objectAtIndex:j];
                        if ([strTmp isEqualToString:[dic objectForKey:@"type_name"]]) {
                            [arrMsgs addObject:dic];
                        }
                    }
                }
            }
        }
        self.lblSearchMsg.hidden = YES;
    }
    else
    {
        self.lblSearchMsg.hidden = NO;
        
        for (int i=0; i<arrTestData.count; i++) {
            NSDictionary *dic = [arrTestData objectAtIndex:i];
            if (isSelectedForUnRead) {
                if ([dic[@"msg_unread"] integerValue] > 0) {
                    [arrMsgs addObject:dic];
                    continue;
                }
            }
            if (arrSelectedFilters.count == 0) {
                [arrMsgs addObject:dic];
            }
            else
            {
                for (int j=0; j<arrSelectedFilters.count; j++) {
                    NSString *strTmp = [arrSelectedFilters objectAtIndex:j];
                    if ([strTmp isEqualToString:[dic objectForKey:@"type_name"]]) {
                        [arrMsgs addObject:dic];
                    }
                }
            }
        }
    }
    
    [self.tbMessaging reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tfSearch resignFirstResponder];
    return YES;
}
#pragma mark - Actions
- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnPlus:(id)sender {
    if (self.viewNewMsg.alpha == 1.0f) {
        [self hideItemsInNewMsgView];
        return;
    }
    [self showNewMsgView];
}

- (void) hideFilterView
{
    isShowingFilterView = false;
    [self showFilterView];
    [self showBlackOpaqueView];
}

- (IBAction)onBtnFilter:(id)sender {
    
    if (self.constraint_btnCancel_width.constant != 0) {
        self.constraint_viewFilter_right.constant = -46.0f;
    }
    else
        self.constraint_viewFilter_right.constant = 0.0f;
//    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
//    }];
    isShowingFilterView = !isShowingFilterView;
    if (isShowingFilterView) {
        [self showBlackOpaqueView];
        [self showFilterView];
    }
    else
    {
        [self showFilterView];
        [self showBlackOpaqueView];
    }
}

- (IBAction)onBtnCancel:(id)sender
{
    self.tfSearch.text = @"";
    self.lblSearchMsg.hidden = false;
    [self.tfSearch resignFirstResponder];
    self.constraint_imgSearch_widht.constant = 30.0f;
    self.constraint_btnCancel_width.constant = 0.0f;
    self.constraint_viewNav_height.constant = 64.0f;
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.imgSearch.alpha = 1.0f;
        self.lblTitle.alpha = 1.0f;
        self.btnBack.alpha = 1.0f;
    }];
    strSearch = @"";
    [self setMsgArrayWithSearchAndFilter];
    
    [self.tbMessaging reloadData];
    
}

- (IBAction)onBtnComposeOne:(id)sender {
    [self hideItemsInNewMsgView];
    MsgCreateViewController *vc = [[UIStoryboard storyboardWithName:@"Messages" bundle:nil] instantiateViewControllerWithIdentifier:@"MsgCreateViewController"];
    vc.msgType = @"private";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBtnComposeGroup:(id)sender {
    [self hideItemsInNewMsgView];
    NewGroupMessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewGroupMessageViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBtnSearchClose:(id)sender {
    if (self.tfSearch.text.length == 0) {
        return;
    }
//    self.btnSearchClose.hidden = YES;
//    self.btnFilter.hidden = NO;
    self.tfSearch.text = @"";
    self.lblSearchMsg.hidden = false;
}

- (IBAction)onClear:(id)sender {
    [self setTestDataForSection];
    [arrSelectedFilters removeAllObjects];
    isSelectedForUnRead = false;
    [self setLblClearallWithCount];
    [self.tbFilter reloadData];
}
@end
