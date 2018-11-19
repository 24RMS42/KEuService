//
//  ChatViewController.m
//  KES
//
//  Created by Piglet on 25.09.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()
{
    NSMutableArray *currentMessages;
    ChatCellSettings *chatCellSettings;
    
}


@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (weak, nonatomic) IBOutlet ContentView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (strong,nonatomic) ChatTableViewCellXIB *chatCell;
@property (strong,nonatomic) ContentView *handler;
@end

@implementation ChatViewController
@synthesize chatCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgViewPhoto.layer.cornerRadius = 3.0f;
    self.imgViewPhoto.layer.masksToBounds = YES;
    [self createCameraSelectView];
    strTVPlaceholder = @"Write a message";
    
    [Functions setBoundsWithView:self.chatTextView];
    
    currentMessages = [[NSMutableArray alloc] init];
    chatCellSettings = [ChatCellSettings getInstance];
    
    [chatCellSettings setSenderBubbleColorHex:@"00c6ee"];
    [chatCellSettings setReceiverBubbleColorHex:@"e5e5ea"];
    [chatCellSettings setSenderBubbleNameTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleNameTextColorHex:@"1E1E1E"];
    [chatCellSettings setSenderBubbleMessageTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleMessageTextColorHex:@"1E1E1E"];
    [chatCellSettings setSenderBubbleTimeTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleTimeTextColorHex:@"838383"];
    
    [chatCellSettings setSenderBubbleFontWithSizeForName:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    [chatCellSettings setReceiverBubbleFontWithSizeForName:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    [chatCellSettings setSenderBubbleFontWithSizeForMessage:[UIFont fontWithName:@"Roboto-Regular" size:16]];
    [chatCellSettings setReceiverBubbleFontWithSizeForMessage:[UIFont fontWithName:@"Roboto-Regular" size:16]];
    [chatCellSettings setSenderBubbleFontWithSizeForTime:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    [chatCellSettings setReceiverBubbleFontWithSizeForTime:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    
    [chatCellSettings senderBubbleTailRequired:YES];
    [chatCellSettings receiverBubbleTailRequired:YES];
    
    
    [[self chatTable] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UINib *nib = [UINib nibWithNibName:@"ChatSendCell" bundle:nil];
    
    [[self chatTable] registerNib:nib forCellReuseIdentifier:@"chatSend"];
    
    nib = [UINib nibWithNibName:@"ChatReceiveCell" bundle:nil];
    
    [[self chatTable] registerNib:nib forCellReuseIdentifier:@"chatReceive"];
    
    
    //Instantiating custom view that adjusts itself to keyboard show/hide
    self.handler = [[ContentView alloc] initWithTextView:self.chatTextView ChatTextViewHeightConstraint:self.chatTextViewHeightConstraint contentView:self.contentView ContentViewHeightConstraint:self.contentViewHeightConstraint andContentViewBottomConstraint:self.contentViewBottomConstraint];
    
    //Setting the minimum and maximum number of lines for the textview vertical expansion
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:3];
    
    //Tap gesture on table view so that when someone taps on it, the keyboard is hidden
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.chatTable addGestureRecognizer:gestureRecognizer];
    
    if (self.isNoReply) {
        self.contentViewHeightConstraint.constant = 0;
        self.chatTextViewHeightConstraint.constant = 0;
        self.viewBottom.alpha = 0.0f;
        self.contentView.alpha = 0.0f;
        [self setTestDataForNoReply];
        self.lblNoreply.hidden = false;
    }
    
    [Functions setBoundsWithView:self.viewTitleSub];
    
    if (self.strType.length > 0) {
        self.constraint_viewTop_height.constant = 50.0f;
        NSString *strTitle;
        if ([self.strType isEqualToString:@"booking"]) {
            strTitle = @"2018 Maths H1 - Mon @4:00 - 5:00";
            
        }
        else
        {
            strTitle = @"Fitzwilliam Darcy";
            
        }
        self.tfTitle.text = strTitle;
        [self.tfTitle setTextColor:[UIColor colorWithRed:16.0/255 green:42.0/255 blue:108.0/255 alpha:1.0f]];
    }
    else{
        self.constraint_viewTop_height.constant = 0.0f;

    }
    
    
    [self.view layoutIfNeeded];
    NSString *strTitle = @"";
    for (int i=0; i<self.arrUsers.count; i++) {
        NSDictionary *dic = [self.arrUsers objectAtIndex:i];
        if (i==0) {
            strTitle = dic[@"name"];
        }
        else
            strTitle = [NSString stringWithFormat:@"%@, %@", strTitle, dic[@"name"]];
    }
    if (strTitle.length > 0) {
        self.lblTitle.text = strTitle;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) dismissKeyboard
{
    [self.chatTextView resignFirstResponder];
}

- (void) setTestDataForNoReply
{
    iMessage *sendMessage;
    
    sendMessage = [[iMessage alloc] initIMessageWithName:@"Prateek Grover" message:@"This is first msg. But not reply to here. Thank you." time:@"23:14" type:@"other"];
    [self.chatTable beginUpdates];
    
    NSIndexPath *row1 = [NSIndexPath indexPathForRow:currentMessages.count inSection:0];
    
    [currentMessages insertObject:sendMessage atIndex:currentMessages.count];
    
    [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.chatTable endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.chatTable numberOfRowsInSection:0]!=0)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.chatTable numberOfRowsInSection:0]-1 inSection:0];
        [self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}

-(void) updateTableView:(iMessage *)msg
{
    [self.chatTextView setText:@""];
    [self.handler textViewDidChange:self.chatTextView];
    
    [self.chatTable beginUpdates];
    
    NSIndexPath *row1 = [NSIndexPath indexPathForRow:currentMessages.count inSection:0];
    
    [currentMessages insertObject:msg atIndex:currentMessages.count];
    
    [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.chatTable endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.chatTable numberOfRowsInSection:0]!=0)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.chatTable numberOfRowsInSection:0]-1 inSection:0];
        [self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}
- (void) showEnableReplyBtn
{
    isEnableReply = !isEnableReply;
    if (isEnableReply)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.btnSwitch setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.btnSwitch setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
        }];
    }
}
- (void) createCameraSelectView
{
    self.cameraSelectView = [NSBundle.mainBundle loadNibNamed:@"CameraSelectView" owner:self options:nil].firstObject;
    self.cameraSelectView.delegate = self;
    [self.view addSubview:self.cameraSelectView];
    self.cameraSelectView.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (void) showCameraView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.cameraSelectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
}

#pragma mark - CameraSelectViewDelegate
- (void) hideCameraSelectView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.cameraSelectView.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
}

- (void) selectTakeAPhoto
{
    [self hideCameraSelectView];
    @try
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerCameraDeviceFront;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        picker.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:picker animated:YES completion:nil];
        });
        
        
        
    }
    @catch (NSException *exception)
    {

    }
}
- (void) selectGallery
{
    [self hideCameraSelectView];
    @try
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        picker.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:picker animated:YES completion:nil];
        });
        
    }
    @catch (NSException *exception)
    {

    }
}
#pragma mark - UIImagePicker Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    imgPost = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self showImgView];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) showImgView
{
    self.constraint_viewImgPost_height.constant = 85.0f;
    self.constraint_imgViewPhoto_height.constant = 75.0f;
    
    [self.imgViewPhoto setImage:imgPost];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Actions

- (IBAction)onBtnSend:(id)sender {
    isSend = !isSend;
    iMessage *sendMessage;
    
    self.constraint_viewImgPost_height.constant = 0.0f;
    self.constraint_imgViewPhoto_height.constant = 0.0f;
    self.imgViewPhoto.image = nil;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    if (self.chatTextView.text.length == 0 || [self.chatTextView.text isEqualToString:@"Write a message"]) {
        return;
    }
    if (isSend) {
        sendMessage = [[iMessage alloc] initIMessageWithName:@"Prateek Grover" message:self.chatTextView.text time:@"23:14" type:@"self"];
    }
    else
    {
        sendMessage = [[iMessage alloc] initIMessageWithName:@"Prateek Grover" message:self.chatTextView.text time:@"23:14" type:@"other"];
    }
    [self updateTableView:sendMessage];
}
- (IBAction)onBtnBack:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    NSArray *vcs = [self.navigationController viewControllers];
    for (int i=0; i<vcs.count; i++) {
        UIViewController *vc = [vcs objectAtIndex:i];
        if ([vc isKindOfClass:[MessagesViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (IBAction)onBtnSwitch:(id)sender
{
    [self showEnableReplyBtn];
}

- (IBAction)onBtnCamera:(id)sender
{
    [self.chatTextView resignFirstResponder];
    [self.tfTitle resignFirstResponder];
    [self showCameraView];
}

- (IBAction)onBtnMore:(id)sender {
    self.constraint_viewMore_height.constant = 265.0f;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        self.viewMore.alpha = 1.0f;
        self.viewBlackOpaqure.alpha = 0.7f;
    }];
}

- (void) hideMoreView
{
    self.constraint_viewMore_height.constant = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        self.viewMore.alpha = 0.0f;
        self.viewBlackOpaqure.alpha = 0.0f;
    }];
}

- (IBAction)onBtnAddPeople:(id)sender {
    [self hideMoreView];
}

- (IBAction)onBtnMute:(id)sender {
    [self hideMoreView];
}

- (IBAction)onBtnUnread:(id)sender {
    [self hideMoreView];
}

- (IBAction)onBtnArchive:(id)sender {
    [self hideMoreView];
}

- (IBAction)onBtnReport:(id)sender {
    [self hideMoreView];
}

- (IBAction)onBtnDelete:(id)sender {
    [self hideMoreView];
}

- (IBAction)onBtnClose:(id)sender {
    imgPost = nil;
    self.constraint_viewImgPost_height.constant = 0;
    self.constraint_imgViewPhoto_height.constant = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}



#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    
    if([message.messageType isEqualToString:@"self"])
    {
        chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        chatCell.chatMessageLabel.text = message.userMessage;
        chatCell.chatTimeLabel.text = message.userTime;
        
    }
    else
    {
        chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        chatCell.chatMessageLabel.text = message.userMessage;
        chatCell.chatTimeLabel.text = message.userTime;
    }
    
    return chatCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    
    CGSize size;
    
    CGSize Namesize;
    CGSize Timesize;
    CGSize Messagesize;
    
    NSArray *fontArray = [[NSArray alloc] init];
    
    //Get the chal cell font settings. This is to correctly find out the height of each of the cell according to the text written in those cells which change according to their fonts and sizes.
    //If you want to keep the same font sizes for both sender and receiver cells then remove this code and manually enter the font name with size in Namesize, Messagesize and Timesize.
    if([message.messageType isEqualToString:@"self"])
    {
        fontArray = chatCellSettings.getSenderBubbleFontWithSize;
    }
    else
    {
        fontArray = chatCellSettings.getReceiverBubbleFontWithSize;
    }
    
    //Find the required cell height
    Namesize = [@"Name" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontArray[0]}
                                     context:nil].size;
    
    
    
    Messagesize = [message.userMessage boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:fontArray[1]}
                                                    context:nil].size;
    
    
    Timesize = [@"Time" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontArray[2]}
                                     context:nil].size;
    
    
    size.height = Messagesize.height + Namesize.height + Timesize.height + 30.0f;
    
    return size.height;
}

@end
