//
//  NewsMoreViewController.m
//  KES
//
//  Created by matata on 2/19/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "NewsMoreViewController.h"

@interface NewsMoreViewController ()

@end

@implementation NewsMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _titleLbl.text = _newsObj.title;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_newsObj.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    NSAttributedString *summaryAttributedString = [[NSAttributedString alloc]
                                                   initWithData: [_newsObj.summary dataUsingEncoding:NSUnicodeStringEncoding]
                                                   options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                   documentAttributes: nil
                                                   error: nil
                                                   ];
    NSAttributedString *detailAttributedString = [[NSAttributedString alloc]
                                                  initWithData: [_newsObj.content dataUsingEncoding:NSUnicodeStringEncoding]
                                                  options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                  documentAttributes: nil
                                                  error: nil
                                                  ];
    
    _summaryTxt.attributedText = summaryAttributedString;
    _detailTxt.attributedText = detailAttributedString;
    [_summaryTxt setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
    [_detailTxt setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
    [_summaryTxt sizeToFit];
    [_detailTxt sizeToFit];
    _summaryTxt.scrollEnabled = NO;
    _detailTxt.scrollEnabled = NO;
    
    CGRect detailLblFrame = _detailLbl.frame;
    detailLblFrame.origin.y = _summaryTxt.frame.origin.y + _summaryTxt.frame.size.height + 10;
    _detailLbl.frame = detailLblFrame;
    
    CGRect detailTxtFrame = _detailTxt.frame;
    detailTxtFrame.origin.y = _detailLbl.frame.origin.y + _detailLbl.frame.size.height + 1;
    _detailTxt.frame = detailTxtFrame;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _detailTxt.frame.origin.y + _detailTxt.frame.size.height + 64);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)OnCloseClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
