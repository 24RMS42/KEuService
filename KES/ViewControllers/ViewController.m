//
//  ViewController.m
//  KES
//
//  Created by matata on 2/9/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <EAIntroDelegate> {
    UIView *rootView;
    EAIntroView *_intro;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rootView = self.navigationController.view;
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didTapGoToRight:)
                                                 name:NOTIFICATION_SIGNUP
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didTapGoToLeft:)
                                                 name:NOTIFICATION_LOGIN
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(forgotPassword:)
                                                 name:NOTIFICATION_FORGOT
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setIntroPage:)
                                                 name:NOTIFICATION_QUESTION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goHome:)
                                                 name:NOTIFICATION_GO_HOME
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loggedOut:)
                                                 name:NOTIFICATION_LOGOUT
                                               object:nil];
    
    quoteApi = [NSString stringWithFormat:@"%@%@?category=%@", BASE_URL, NEWS_LIST, @"Quotes"];
    [objWebServices callApiWithParameters:nil apiName:quoteApi type:GET_REQUEST loader:NO view:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSInteger currentIndex = _pagemenu.currentPageIndex;
    [self setWebServiceObjAgain:currentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeView {
    _splashView.hidden = YES;
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    if ([[userInfo objectForKey:KEY_REMEMBER] isEqualToString:@"yes"]) {
        [self goHome:nil];
        [userInfo setObject:@"yes" forKey:KEY_LOGGEDIN];//Go home directly
    }else
        [self setLoginForm];
    
    if (![[userInfo objectForKey:KEY_LAUNCHED] isEqualToString:@"yes"]) {
        [self setIntroPage:nil];
    }
    [userInfo setObject:@"yes" forKey:KEY_LAUNCHED];
    
    [_TopView setBackgroundColor:[UIColor colorWithHex:COLOR_PRIMARY]];
}

- (void)startTimer {
    [NSTimer scheduledTimerWithTimeInterval:4.0
                                     target:self
                                   selector:@selector(initializeView)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)setIntroPage:(NSNotification *) notification{
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"intro1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"intro2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"intro3"];
    
    UIView *viewForPage4 = [[UIView alloc] initWithFrame:self.view.bounds];
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnStart setFrame:CGRectMake(30, SCREEN_HEIGHT*0.75, SCREEN_WIDTH - 60, 100)];
    [btnStart setTitle:@"" forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(removeIntro:) forControlEvents:UIControlEventTouchUpInside];
    [viewForPage4 addSubview:btnStart];
    
    EAIntroPage *page4 = [EAIntroPage pageWithCustomView:viewForPage4];
    page4.bgImage = [UIImage imageNamed:@"intro4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[btn setFrame:CGRectMake(0, 0, 360, 0)];
    [btn setTitle:@"    " forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    intro.skipButton = btn;
    intro.skipButtonY = SCREEN_HEIGHT - 30.0f;
    //intro.skipButtonAlignment = EAViewAlignmentRight;
    
    //intro.pageControlY = 42.f;
    [intro.pageControl setHidden:YES];
    
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.3];
    _intro = intro;
}

- (void)removeIntro: (UIButton*)sender{
    [_intro removeFromSuperview];
}

- (void)setLoginForm
{
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    loginController.title = @"Log in";
    signupController = [self.storyboard instantiateViewControllerWithIdentifier:@"signup"];
    signupController.title = @"Sign up";
    [controllerArray addObject:loginController];
    [controllerArray addObject:signupController];
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithHex:COLOR_PRIMARY],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithHex:COLOR_PRIMARY],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithHex:COLOR_THIRD],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor colorWithHex:0x99e8f8],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"Roboto-Regular" size:PageMenuOptionMenuItemFont],
                                 CAPSPageMenuOptionMenuHeight: @(PageMenuOptionMenuHeight),
                                 CAPSPageMenuOptionSelectionIndicatorHeight : @(PageMenuOptionSelectionIndicatorHeight),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pagemenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, _TopView.frame.origin.y + _TopView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    _pagemenu.delegate = self;
    
    [self.view addSubview:_pagemenu.view];
}

- (void)didTapGoToLeft :(NSNotification *) notification{
    NSInteger currentIndex = _pagemenu.currentPageIndex;
    
    if (currentIndex > 0) {
        [_pagemenu moveToPage:currentIndex - 1];
    }
}

- (void)didTapGoToRight :(NSNotification *) notification{
    NSInteger currentIndex = _pagemenu.currentPageIndex;
    
    if (currentIndex < _pagemenu.controllerArray.count) {
        [_pagemenu moveToPage:currentIndex + 1];
    }
}

- (void)forgotPassword :(NSNotification *) notification {
    NSDictionary* info = notification.userInfo;
    NSString *infoinfo = [info valueForKey:@"info"];
    ForgotPasswordViewController *forgotController = [self.storyboard instantiateViewControllerWithIdentifier:@"forgotPwd"];
    forgotController.info = infoinfo;
    [self.navigationController pushViewController:forgotController animated:YES];
}

- (void)goHome :(NSNotification *) notification{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTab"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loggedOut :(NSNotification *) notification{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    if ([[userInfo objectForKey:KEY_LOGGEDIN] isEqualToString:@"yes"]) {
        [userInfo setObject:@"no" forKey:KEY_LOGGEDIN];
        [self setLoginForm];
    }
}

- (void)setWebServiceObjAgain:(NSInteger)index {
//    if (index == 0) {
//        loginController.objWebServices = [WebServices sharedInstance];
//        loginController.objWebServices.delegate = loginController;
//    } else if (index == 1) {
//        signupController.objWebServices = [WebServices sharedInstance];
//        signupController.objWebServices.delegate = signupController;
//    }
}

#pragma mark - webservice call delegate
-(void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error
{
    if ([apiName isEqualToString:quoteApi])
    {
        if(responseDict != nil)
        {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                NSArray* quoteObject = [responseDict valueForKey:@"news"];
                for (NSDictionary *obj in quoteObject) {
                    //_splashLbl.text = [obj valueForKey:@"content"];
                    NSAttributedString *quoteAttributedString = [[NSAttributedString alloc]
                                                                  initWithData: [[obj valueForKey:@"content"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                                  options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                  documentAttributes: nil
                                                                  error: nil
                                                                  ];
                    _quoteTxt.attributedText = quoteAttributedString;
                    _quoteTxt.textAlignment = NSTextAlignmentCenter;
                    _quoteTxt.textColor = [UIColor whiteColor];
                    [_quoteTxt setFont:[UIFont fontWithName:@"Roboto-Regular" size:13]];
                    break;
                }
                [self startTimer];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - CAPageMenu delegate
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index {
    // NSLog(@"index will:%ld", (long)index);
    [self setWebServiceObjAgain:index];
}

- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index {
}
@end
