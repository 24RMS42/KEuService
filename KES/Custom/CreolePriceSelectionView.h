//
//  CreolePriceSelectionView.h
//
//
//  Created by Nirmalsinh Rathod on 09/05/17.
//  Copyright © 2017 CreoleStudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@protocol CreolePriceSelectionViewDelegate <NSObject>
@required
-(void)getPriceForSelectedIndex :(NSInteger)selectedIndex;
@end

@interface CreolePriceSelectionView : UIView<iCarouselDataSource, iCarouselDelegate>
{
    NSMutableArray *aryPrice;
}
@property (nonatomic, weak) id<CreolePriceSelectionViewDelegate> delegate;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) UIColor *selectItemColor, *normalItemColor, *selectedTextColor, *normalTextColor;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) BOOL isClicked;
@property (nonatomic, readwrite) float width;
@property (nonatomic, readwrite) float height;

-(void)setDefaultColor;
-(void)setup : (NSMutableArray *)yourItemArray;
-(void)setPriceForItem : (NSString *)price;

@end
