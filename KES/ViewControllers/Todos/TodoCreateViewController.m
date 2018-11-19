//
//  TodoCreateViewController.m
//  KES
//
//  Created by Piglet on 21.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "TodoCreateViewController.h"

@interface TodoCreateViewController ()
{
    UIView *floatingLineView;
    UIView *floatingNumberView;
    UILabel *lblNum;
    CGFloat width_between;
    float circleViewWidth;
    
}
@end

@implementation TodoCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaultHeight = 130.0f;
    strTVPlaceholder1 = @"Write a details";
    contentOffSet_y = -1;
    [self handleTagBlocks];
    [self.tagsView setBorderWidth:1.0f];
    [self.tagsView setBorderColor:[UIColor colorWithRed:214.0f/255 green:214.0f/255 blue:214.0f/255 alpha:1.0f]];
    
    [self.tfTitle addTarget:self
                     action:@selector(textFieldDidChange:)
           forControlEvents:UIControlEventEditingChanged];
    [self.tfAssign addTarget:self
                     action:@selector(textFieldDidChange:)
           forControlEvents:UIControlEventEditingChanged];
    [self.tfRegardingSearch addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
    [self setSliderInitialValue];
    
    [self setTestDataForPriority];
    [self setTestDataForAssign];
    [self setTestDataForStatus];
    [self setTestDataForRegarding];
    [self setTestDataForActivity];
    
    [self setUI];
    [self.tbPriority registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil]
          forCellReuseIdentifier:@"TypeTableViewCell"];
    
    [self.tbAssign registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil]
        forCellReuseIdentifier:@"TypeTableViewCell"];
    
    [self.tbStatus registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil]
        forCellReuseIdentifier:@"TypeTableViewCell"];
    
    [self.tbRegarding registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil]
        forCellReuseIdentifier:@"TypeTableViewCell"];
    
    [self.tbRegardingSearch registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil]
           forCellReuseIdentifier:@"TypeTableViewCell"];
    
    [self.tbActivity registerNib:[UINib nibWithNibName:@"TodoActivityTableViewCell" bundle:nil]
                 forCellReuseIdentifier:@"TodoActivityTableViewCell"];
    
    [self setupKeyboardToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeHeightOfTagView:)
                                                 name:@"change_tagview_height"
                                               object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBlackView)];
    [self.viewBlack1 addGestureRecognizer:tapGesture];
    [self.viewBlackInSc addGestureRecognizer:tapGesture];
    [self createDurationSlider];
}

#pragma mark - Keyboard

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardFrame = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRectangle = [keyboardFrame CGRectValue];
    CGFloat offsetY = keyboardRectangle.size.height;
    keyboardHeight = offsetY;
    [self changeScrollWhenSelectBtn:nil andHeightOfShownView:defaultHeight];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    keyboardHeight = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Functions
- (void) createDurationSlider
{
    circleViewWidth = 20;
    
    
    float width = [[UIScreen mainScreen] bounds].size.width;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, self.sliderDuration.center.y-1, width, 1);
    [view setBackgroundColor:[Functions blueColor]];
    [self.scContainView addSubview:view];
    
    width_between = (width - circleViewWidth * 2) / 60;
    for (int i=0; i<61; i++) {
        UIView *viewTmp = [[UIView alloc] init];
        
        float height = 10;
        if (i%10 == 0) {
            height = height * 3;
            viewTmp.frame = CGRectMake(circleViewWidth + width_between * i, self.sliderDuration.center.y-height*2/3, 1, height);
        }
        else if( i%5 == 0)
        {
            height = height * 2;
            viewTmp.frame = CGRectMake(circleViewWidth + width_between * i, self.sliderDuration.center.y-height*2/3, 1, height);
        }
        else
            viewTmp.frame = CGRectMake(circleViewWidth + width_between * i, self.sliderDuration.center.y-height/2, 1, height);
        [viewTmp setBackgroundColor:[Functions blueColor]];
        [self.scContainView addSubview:viewTmp];
        
        float width_label = 18;
        UILabel *label;
        if (i%5 == 0) {
            label = [[UILabel alloc] init];
            [label setTextColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f]];
            [label setFont:[UIFont fontWithName:@"Roboto-Light" size:12.0f]];
            label.textAlignment = NSTextAlignmentCenter;
            if (i%10 == 0) {
                [label setFont:[UIFont fontWithName:@"Roboto-Light" size:15.0f]];
            }
            NSLog(@"ss=%f", viewTmp.center.x-width_label/2);
            label.frame = CGRectMake(viewTmp.center.x-width_label/2,
                                     self.sliderDuration.center.y+width_label/2 + 9,
                                     width_label,
                                     width_label);
            label.text = [NSString stringWithFormat:@"%d", i];
            [self.scContainView addSubview:label];
        }
    }
    
    floatingLineView = [[UIView alloc] init];
    [floatingLineView setBackgroundColor:[Functions blueColor]];
    floatingLineView.frame = CGRectMake(circleViewWidth-1, self.sliderDuration.center.y-10*3, 2, 10*4);
    [self.scContainView addSubview:floatingLineView];
    
    floatingNumberView = [[UIView alloc] init];
    [floatingNumberView setBackgroundColor:[UIColor colorWithRed:14.0f/255 green:42.0f/255 blue:107.0f/255 alpha:1.0f]];
    [floatingNumberView setFrame:CGRectMake(0, self.sliderDuration.center.y-65, circleViewWidth*2, circleViewWidth*2)];
    floatingNumberView.layer.cornerRadius = circleViewWidth;
    floatingNumberView.clipsToBounds = YES;
    [self.scContainView addSubview:floatingNumberView];
    
    
    lblNum = [[UILabel alloc] init];
    [lblNum setTextColor:[UIColor whiteColor]];
    [lblNum setFont:[UIFont fontWithName:@"Roboto-Bold" size:20.0f]];
    [lblNum setFrame:CGRectMake(0, 0, circleViewWidth*2, circleViewWidth*2)];
    lblNum.textAlignment = NSTextAlignmentCenter;
    lblNum.text = [NSString stringWithFormat:@"%d", 0];
    [floatingNumberView addSubview:lblNum];
    
    [self.scContainView bringSubviewToFront:self.sliderDuration];
    [self.scContainView bringSubviewToFront:self.sliderDuration1];
}

- (void) changeHeightOfTagView:(NSNotification *) notification
{
    NSDictionary *dic = notification.userInfo;
    CGFloat height = [dic[@"height"] floatValue];
    if (self.constraint_tagsView_height.constant != height) {
        self.constraint_scDetails_height.constant += height - self.constraint_tagsView_height.constant;
        self.constraint_tagsView_height.constant = height;
        
    }
    
    [self.view layoutIfNeeded];

}

- (void) setRemindBtn
{
    if (isRemind) {
        [self.btnRemind setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
    }
    else
        [self.btnRemind setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    
}

- (void) setSliderInitialValue
{
    self.sliderDuration.value = 0.5;
}

- (void) setTestDataForActivity
{
    arrActivity = [NSMutableArray new];
    NSDictionary *dic = @{@"image":@"imgSample.png",
                          @"username":@"Elizabeth Bennet",
                          @"time":@"2mins ago",
                          @"detail":@"You created and assigned to Fitzwilliam"};
    NSDictionary *dic1 = @{@"image":@"imgSample.png",
                           @"username":@"Fitzwilliam Darcy",
                           @"time":@"1d",
                           @"detail":@"Re assign to you"};
    NSDictionary *dic2 = @{@"image":@"imgSample.png",
                           @"username":@"Elizabeth Bennet",
                           @"time":@"1w",
                           @"detail":@"You closed the todo"};
    [arrActivity addObject:dic];
    [arrActivity addObject:dic1];
    [arrActivity addObject:dic2];
}

- (void) setTestDataForRegarding
{
    arrRegardingAll = [NSMutableArray new];
    arrRegarding = [NSMutableArray new];
    [arrRegardingAll addObject:@"Regarding1"];
    [arrRegardingAll addObject:@"Regarding2"];
    [arrRegardingAll addObject:@"Regarding3"];
    [arrRegardingAll addObject:@"Regarding4"];
    [arrRegardingAll addObject:@"Regarding5"];
    [arrRegardingAll addObject:@"Regarding6"];
    [arrRegardingAll addObject:@"Regarding7"];
    [arrRegardingAll addObject:@"Regarding8"];
    [arrRegardingAll addObject:@"Regarding9"];
    
}

- (void) setTestDataForPriority
{
    arrPriority = [NSMutableArray new];
    [arrPriority addObject:@"Priority1"];
    [arrPriority addObject:@"Priority2"];
    [arrPriority addObject:@"Priority3"];
    [arrPriority addObject:@"Priority4"];
    [arrPriority addObject:@"Priority5"];
    [arrPriority addObject:@"Priority6"];
    [arrPriority addObject:@"Priority7"];
    [arrPriority addObject:@"Priority8"];
    
}

- (void) setTestDataForAssign
{
    arrAssignAll = [NSMutableArray new];
    arrAssign = [NSMutableArray new];
    [arrAssignAll addObject:@"Assign1"];
    [arrAssignAll addObject:@"Assign2"];
    [arrAssignAll addObject:@"Assign3"];
    [arrAssignAll addObject:@"Assign4"];
    [arrAssignAll addObject:@"Assign5"];
    [arrAssignAll addObject:@"Assign6"];
    [arrAssignAll addObject:@"Assign7"];
    [arrAssignAll addObject:@"Assign8"];
    
}

- (void) setTestDataForStatus
{
    arrStatus = [NSMutableArray new];
    [arrStatus addObject:@"Open"];
    [arrStatus addObject:@"In progress"];
    [arrStatus addObject:@"Closed"];
}

- (void) setUI
{
    [Functions setBoundsWithGreyColor:self.viewTitle];
    [Functions setBoundsWithGreyColor:self.viewPriority];
    [Functions setBoundsWithGreyColor:self.viewDetail];
    [Functions setBoundsWithGreyColor:self.viewAssign];
    [Functions setBoundsWithGreyColor:self.viewStatus];
    [Functions setBoundsWithGreyColor:self.viewDate];
    [Functions setBoundsWithGreyColor:self.viewTime];
    [Functions setBoundsWithGreyColor:self.viewTag];
    [Functions setBoundsWithGreyColor:self.viewRegarding];
    [Functions setBoundsWithGreyColor:self.viewRegardingSearch];
    
    [Functions setBoundsWithView:self.tbPriority];
    [Functions setBoundsWithView:self.tbTag];
    [Functions setBoundsWithView:self.tbAssign];
    [Functions setBoundsWithView:self.tbRegarding];
    [Functions setBoundsWithView:self.tbRegardingSearch];
    [Functions setBoundsWithView:self.tbStatus];
}
- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showPriorityTb
{
    float alpha = 0;
    if (self.tbPriority.alpha == 0) {
        alpha = 1;
        [self showBlackView];
    }
    else
    {
        alpha = 0;
        [self hideBlackView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tbPriority.alpha = alpha;
    }];
}

- (void) setPriorityLbl
{
    self.lblPrioriy.text = selectedPriority;
    [self.tbPriority reloadData];
}

- (void) showRegardingTbAll
{
    float alpha = 0;
    if (self.tbRegarding.alpha == 0) {
        alpha = 1;
        [self showBlackView];
    }
    else
    {
        alpha = 0;
        [self hideBlackView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tbRegarding.alpha = alpha;
    }];
}

- (void) setRegardingLbl
{
    [self.tfRegardingSearch resignFirstResponder];
    self.lblRegarding.text = selectedRegarding;
    [self.tbRegarding reloadData];
}

- (void) showAssignTb
{
    float alpha = 0;
    if(self.tbAssign.alpha == 0)
    {
        alpha = 1;
        [self showBlackView];
    }
    else
    {
        alpha = 0;
        [self hideBlackView];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.tbAssign.alpha = alpha;
    }];
    [self.tbAssign reloadData];
}
- (void) setAssignTf
{
    self.tfAssign.text = selectedAssign;
    [self.tfAssign resignFirstResponder];
    [self.tbAssign reloadData];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) showRegardingTbSearch
{
    float alpha = 0;
    if (self.tbRegardingSearch.alpha == 0) {
        alpha = 1;
        [self showBlackView];
    }
    else
    {
        alpha = 0;
        [self hideBlackView];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.tbRegardingSearch.alpha = alpha;
    }];
    [self.tbRegardingSearch reloadData];
}

- (void) setStatusTf
{
    self.tfStatus.text = selectedStatus;
    [self.tbStatus reloadData];
}

- (void) showStatusTb
{
    float alpha = 0;
    if (self.tbStatus.alpha == 0) {
        alpha = 1;
        [self showBlackView];
    }
    else
    {
        alpha = 0;
        [self hideBlackView];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.tbStatus.alpha = alpha;
    }];
    
    [self.tbStatus reloadData];
}

- (void) showBlackView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.viewBlack1.alpha = 0.7f;
        self.viewBlackInSc.alpha = 0.7;
        [self.scDetails setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }];
}

- (void) hideBlackView
{
    [UIView animateWithDuration:0.3f animations:^{
        if (contentOffSet_y != -1) {
            self.scDetails.contentOffset = CGPointMake(0, contentOffSet_y);
        }
        
        [self.scDetails setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.7f]];
        [self.tfRegardingSearch resignFirstResponder];
        [self.tfTag resignFirstResponder];
        [self.tfTitle resignFirstResponder];
        [self.tfAssign resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.tbTag.alpha = 0.0f;
            self.tbAssign.alpha = 0.0f;
            self.tbPriority.alpha = 0.0f;
            self.tbRegarding.alpha = 0.0f;
            self.tbRegardingSearch.alpha = 0.0f;
            self.tbStatus.alpha = 0.0f;
            self.viewDatePicker.alpha = 0.0f;
            self.viewBlack1.alpha = 0.0f;
            self.viewBlackInSc.alpha = 0.0f;
        }];
        
    }];
}

- (void) setupKeyboardToolBar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    [numberToolbar setBackgroundColor:[UIColor colorWithRed:220.0/255.0f green:220.0/255.0f blue:220.0/255.0f alpha:1.0f]];
    self.tvDetails.inputAccessoryView = numberToolbar;
    
}

-(void)doneWithNumberPad{
    [self.tvDetails resignFirstResponder];
}

- (void) setDateWithString:(NSString *) strDate
{
    self.tfDate.text = strDate;
}

- (void) setTimeWithString:(NSString *) strTime
{
    self.tfTime.text = strTime;
}
- (void) changeScrollWhenSelectBtn:(UIView *) button andHeightOfShownView:(CGFloat) height
{
    float top = 124.0f;
    if (height + mtfHeight + mtfposition + keyboardHeight + top> self.view.frame.size.height) {
        float d_height = height + mtfHeight + mtfposition + keyboardHeight + top + 5 - self.view.frame.size.height;
        contentOffSet_y = self.scDetails.contentOffset.y;
        [UIView animateWithDuration:0.3f animations:^{
            self.scDetails.contentOffset = CGPointMake(0, d_height);
        }];
    }
}

- (void) showDetailsOrActivity
{
    switch (self.segCategory.selectedSegmentIndex) {
        case 0:
            self.scDetails.alpha = 1.0f;
            self.tbActivity.alpha = 0.0f;
            break;
       case 1:
            self.scDetails.alpha = 0.0f;
            self.tbActivity.alpha = 1.0f;
            break;
        default:
            break;
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return true;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    tmpTV = textView;
    if([textView isEqual:self.tvDetails])
    {
        mtfposition = textView.superview.frame.origin.y;
        mtfHeight = textView.superview.frame.size.height;
        
        if ([textView.text isEqualToString:strTVPlaceholder1]) {
            textView.text = @"";
            [textView setTextColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0]];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.tvDetails]) {
        NSString *strSub = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *strSub1 = [strSub stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if ([textView.text isEqualToString:@""] || strSub1.length == 0) {
            textView.text = strTVPlaceholder1;
            [textView setTextColor:[UIColor colorWithRed:120.0/255 green:120.0/255 blue:120.0/255 alpha:1.0f]];
        }
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *strComment = textView.text;
    NSRange selectedRange = textView.selectedRange;
    //    textView.attributedText = strComment;
    textView.selectedRange = selectedRange;
    [self showCommentBar1:strComment];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    return true;
}
- (void) showCommentBar1:(NSString *) strComment
{
    
    CGFloat width = self.tvDetails.bounds.size.width - 2.0 * self.tvDetails.textContainer.lineFragmentPadding;
    CGRect boundingRect = [self.tvDetails.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                            attributes:@{ NSFontAttributeName:self.tvDetails.font}
                                                               context:nil];
    
    CGFloat heightByBoundingRect = CGRectGetHeight(boundingRect);
    
    //CGFloat currentHeight = heightByBoundingRect + self.chatTextView.font.lineHeight;
    
    CGFloat currentHeight = heightByBoundingRect + self.tvDetails.textContainerInset.top + self.tvDetails.textContainerInset.bottom;
    
    
    if (currentHeight < 120) {
        [self.tvDetails sizeToFit];
        float height_tvMsg = currentHeight;
        if (currentHeight < 33) {
            currentHeight = 33;
        }
        self.tvDetails.frame = CGRectMake(15, 1, [UIScreen mainScreen].bounds.size.width-70, height_tvMsg);
        [self.tvDetails setContentOffset:CGPointZero animated:NO];
        self.constraint_viewDetails_height.constant = self.tvDetails.frame.size.height + 2;
        
        [UIView animateWithDuration:0.05 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else
    {
        currentHeight = 120;
        self.tvDetails.frame = CGRectMake(15, 1, [UIScreen mainScreen].bounds.size.width-70, currentHeight);
        self.constraint_viewDetails_height.constant = currentHeight + 2;
        [UIView animateWithDuration:0.05 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tbActivity]) {
        return UITableViewAutomaticDimension;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tbPriority]) {
        return arrPriority.count;
    }
    else if([tableView isEqual:self.tbAssign])
        return arrAssign.count;
    else if([tableView isEqual:self.tbStatus])
        return arrStatus.count;
    else if([tableView isEqual:self.tbRegarding])
        return arrRegardingAll.count;
    else if([tableView isEqual:self.tbRegardingSearch])
        return arrRegarding.count;
    else if([tableView isEqual:self.tbActivity])
        return arrActivity.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.tbActivity]) {
        TodoActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodoActivityTableViewCell"];
        NSDictionary *dic = [arrActivity objectAtIndex:indexPath.row];
        [cell configureCell:dic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    bool isSelected = false;
    
    if ([tableView isEqual:self.tbPriority]) {
        NSString *strPriority = [arrPriority objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strPriority;
        if ([strPriority isEqualToString:selectedPriority]) {
            isSelected = YES;
        }
        
    }
    else if([tableView isEqual:self.tbAssign])
    {
        NSString *strAssign = [arrAssign objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strAssign;
        if ([strAssign isEqualToString:selectedAssign]) {
            isSelected = YES;
        }
    }
    else if([tableView isEqual:self.tbStatus])
    {
        NSString *strStatus = [arrStatus objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strStatus;
        if ([strStatus isEqualToString:selectedStatus]) {
            isSelected = YES;
        }
    }
    else if([tableView isEqual:self.tbRegarding])
    {
        NSString *strRegard = [arrRegardingAll objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strRegard;
        if ([strRegard isEqualToString:selectedRegarding]) {
            isSelected = YES;
        }
    }
    else if([tableView isEqual:self.tbRegardingSearch])
    {
        NSString *strRegard = [arrRegarding objectAtIndex:indexPath.row];
        cell.lblTypeName.text = strRegard;
        if ([strRegard isEqualToString:selectedRegarding]) {
            isSelected = YES;
        }
    }
    if (isSelected) {
        [cell.lblTypeName setTextColor:[UIColor colorWithRed:0.0f/255 green:198.0f/255 blue:238.0f/255 alpha:1.0]];
    }
    else
        [cell.lblTypeName setTextColor:[UIColor colorWithRed:48.0f/255 green:48.0f/255 blue:48.0f/255 alpha:1.0]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tbPriority]) {
        selectedPriority = [arrPriority objectAtIndex:indexPath.row];
        [self setPriorityLbl];
        [self showPriorityTb];
    }
    else if ([tableView isEqual:self.tbAssign])
    {
        selectedAssign = [arrAssign objectAtIndex:indexPath.row];
        [self setAssignTf];
        [self showAssignTb];
        
    }
    else if([tableView isEqual:self.tbStatus])
    {
        selectedStatus = [arrStatus objectAtIndex:indexPath.row];
        [self setStatusTf];
        [self showStatusTb];
    }
    else if([tableView isEqual:self.tbRegarding])
    {
        selectedRegarding = [arrRegardingAll objectAtIndex:indexPath.row];
        [self setRegardingLbl];
        [self showRegardingTbAll];
    }
    else if([tableView isEqual:self.tbRegardingSearch])
    {
        selectedRegarding = [arrRegarding objectAtIndex:indexPath.row];
        [self setRegardingLbl];
        [self showRegardingTbSearch];
    }
}
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tmpTf = textField;
    NSString *strSub = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([textField isEqual:self.tfAssign]) {
        
        [arrAssign removeAllObjects];
        if (textField.text.length == 0 || strSub.length == 0 ) {
            
            [arrAssign addObjectsFromArray:arrAssignAll];
            
        }
        else
        {
            for (int i=0; i<arrAssignAll.count; i++) {
                NSString *string = [arrAssignAll objectAtIndex:i];
                if ([[string lowercaseString] containsString:[textField.text lowercaseString]]) {
                    [arrAssign addObject:string];
                }
            }
            
        }
        mtfposition = textField.superview.frame.origin.y;
        mtfHeight = textField.superview.frame.size.height;
        [self showAssignTb];
        
    }
    else if([textField isEqual:self.tfTag])
    {
        mtfposition = textField.superview.frame.origin.y;
        mtfHeight = textField.superview.frame.size.height;
    }
    else if([textField isEqual:self.tfRegardingSearch])
    {
        [arrRegarding removeAllObjects];
        if (textField.text.length == 0 || strSub.length == 0) {
            [arrRegarding addObjectsFromArray:arrRegardingAll];
        }
        else
        {
            for (int i=0; i<arrRegardingAll.count; i++) {
                NSString *string = [arrRegardingAll objectAtIndex:i];
                if ([[string lowercaseString] containsString:[textField.text lowercaseString]]) {
                    [arrRegarding addObject:string];
                }
            }
        }
        mtfposition = textField.superview.frame.origin.y;
        mtfHeight = textField.superview.frame.size.height;
        [self showRegardingTbSearch];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.tfAssign]) {
        
    }
}
- (void) textFieldDidChange:(UITextField *)textField
{
    
    NSString *strTxt = textField.text;
    if ([textField isEqual:self.tfAssign]) {
        [arrAssign removeAllObjects];
        NSString *strTxt1 = [strTxt stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (strTxt.length == 0 || strTxt1.length == 0) {
            [arrAssign addObjectsFromArray:arrAssignAll];
        }
        else
        {
            for (int i=0; i<arrAssignAll.count; i++) {
                NSString *string = [arrAssignAll objectAtIndex:i];
                if ([[string lowercaseString] containsString:[textField.text lowercaseString]]) {
                    [arrAssign addObject:string];
                }
            }
        }
        [self.tbAssign reloadData];
    }
    else if([textField isEqual:self.tfRegardingSearch])
    {
        [arrRegarding removeAllObjects];
        NSString *strTxt1 = [strTxt stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (strTxt.length == 0 || strTxt1.length == 0) {
            [arrRegarding addObjectsFromArray:arrRegardingAll];
        }
        else
        {
            for (int i=0; i<arrRegardingAll.count; i++) {
                NSString *string = [arrRegardingAll objectAtIndex:i];
                if ([[string lowercaseString] containsString:[textField.text lowercaseString]]) {
                    [arrRegarding addObject:string];
                }
            }
        }
        [self.tbRegardingSearch reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:self.tfTag]) {
        NSString *strTag = textField.text;
        NSString *strTagTmp = [strTag stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (strTag.length == 0 || strTagTmp.length == 0) {
            return true;
        }
        if (strTag.length > 1 && [[strTag substringToIndex:1] isEqualToString:@"#"]) {
            
        }
        else
            strTag = [NSString stringWithFormat:@"#%@", strTag];
        [self.tagsView addTag:strTag];
        textField.text = @"";
    }
    if ([textField isEqual:self.tfRegardingSearch]) {
        [self showRegardingTbSearch];
    }
    return true;
}

#pragma mark - Tag blocks

- (void)handleTagBlocks
{
    __weak typeof(self) weakSelf = self;
    [_tagsView setTapBlock:^(NSString *tagText, NSInteger idx)
     {
//         NSString *message = [NSString stringWithFormat:@"You tapped: %@", tagText];
         
     }];
    
    [_tagsView setDeleteBlock:^(NSString *tagText, NSInteger idx)
     {
//         NSString *message = [NSString stringWithFormat:@"You deleted: %@", tagText];
         
         [weakSelf.tagsView deleteTagAtIndex:idx];
     }];
}
#pragma mark - Actions
- (IBAction)segValueChanged:(id)sender {
    [self showDetailsOrActivity];
}

- (IBAction)onBtnPriority:(id)sender {
    [self showPriorityTb];
    UIButton *btn = (UIButton *) sender;
    mtfposition = btn.superview.frame.origin.y;
    mtfHeight = btn.superview.frame.size.height;
    [self changeScrollWhenSelectBtn:(UIButton *)sender andHeightOfShownView:defaultHeight];
}

- (IBAction)onBtnStatus:(id)sender {
    [self showStatusTb];
    UIButton *btn = (UIButton *) sender;
    mtfposition = btn.superview.frame.origin.y;
    mtfHeight = btn.superview.frame.size.height;
    [self changeScrollWhenSelectBtn:(UIButton *)sender andHeightOfShownView:defaultHeight];
}

- (IBAction)onBtnCalendar:(id)sender {
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSString *strFormatter = @"LLL dd, yyyy";
    if (strSelectedDate.length == 0 ) {
        NSDate *currentDate = [NSDate date];
        self.datePicker.date = currentDate;
        
        NSString *strDate = [Functions convertDateToString:currentDate format:strFormatter];
        strSelectedDate = strDate;
        [self setDateWithString:strSelectedDate];
        
    }
    else
    {
        NSDate *date = [Functions convertStringToDate:strSelectedDate format:strFormatter];
        self.datePicker.date = date;
    }
    CGFloat heightOfViewPicker = 261.0f;
    
    UIButton *btn = (UIButton *) sender;
    mtfposition = btn.frame.origin.y;
    mtfHeight = btn.frame.size.height;
    [self changeScrollWhenSelectBtn:(UIButton *)sender andHeightOfShownView:heightOfViewPicker];
    
    [self showBlackView];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        
        self.viewDatePicker.alpha = 1.0f;
    }];
}

- (IBAction)onBtnTime:(id)sender {
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    NSString *strFormatter = @"hh:mm";
    if (strSelectedTime.length == 0) {
        NSDate *currentTime = [NSDate date];
        self.datePicker.date = currentTime;
        
        NSString *strTime = [Functions convertDateToString:currentTime format:strFormatter];
        [self setTimeWithString:strTime];
    }
    else
    {
        NSDate *time = [Functions convertStringToDate:strSelectedTime format:strFormatter];
        self.datePicker.date = time;
    }
    
    CGFloat heightOfViewPicker = 261.0f;
    
    UIButton *btn = (UIButton *) sender;
    mtfposition = btn.frame.origin.y;
    mtfHeight = btn.frame.size.height;
    [self changeScrollWhenSelectBtn:(UIButton *)sender andHeightOfShownView:heightOfViewPicker];
    
    [self showBlackView];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        
        self.viewDatePicker.alpha = 1.0f;
    }];
}

- (IBAction)onBtnRegarding:(id)sender {
    [self showRegardingTbAll];
    UIButton *btn = (UIButton *) sender;
    mtfposition = btn.superview.frame.origin.y;
    mtfHeight = btn.superview.frame.size.height;
    [self changeScrollWhenSelectBtn:(UIButton *)sender andHeightOfShownView:defaultHeight];
}

- (IBAction)durationValueChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    duration = slider.value;
    [self.sliderDuration setValue:duration];
    [self.sliderDuration1 setValue:duration];
    lblNum.text = [NSString stringWithFormat:@"%d", duration];
    self.lblDuration.text = [NSString stringWithFormat:@"%d", duration];
    floatingLineView.center = CGPointMake(circleViewWidth + width_between * duration, floatingLineView.center.y);
    floatingNumberView.center = CGPointMake(circleViewWidth + width_between * duration, floatingNumberView.center.y);
}

- (IBAction)onBtnRemindme:(id)sender {
    isRemind = !isRemind;
    [self setRemindBtn];
}

- (IBAction)onBtnCancel:(id)sender {
    [self goBack];
}

- (IBAction)onBtnSave:(id)sender {
    // save here
    
    [self goBack];
}

- (IBAction)onDoneDate:(id)sender {
    [tmpTf resignFirstResponder];
    [tmpTV resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBlackView];
    });
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
        self.viewDatePicker.alpha = 0.0f;
    }];
    
}

- (IBAction)datePickerChanged:(id)sender {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    if (self.datePicker.datePickerMode == UIDatePickerModeDate) {
        
        [formatter setDateFormat:@"LLL dd, yyyy"];
        NSString *strDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
        strSelectedDate = strDate;
        
        [self setDateWithString:strSelectedDate];
    }
    else
    {
        [formatter setDateFormat:@"hh:mm"];
        NSString *strTime = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.datePicker.date]];
        strSelectedTime = strTime;
        [self setTimeWithString:strSelectedTime];
    }
}
@end
