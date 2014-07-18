//
//  PercentChange.h
//  CoinBot
//
//  Created by Oliver Fisher on 11/19/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PercentChange : UILabel
@property (nonatomic) CGFloat amountChange;
@property (nonatomic) CGFloat percentChange;
- (void)updateChange:(CGFloat)change andAmount:(CGFloat)amount;
@end
