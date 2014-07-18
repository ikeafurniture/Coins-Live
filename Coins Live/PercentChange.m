//
//  PercentChange.m
//  CoinBot
//
//  Created by Oliver Fisher on 11/19/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import "PercentChange.h"

@implementation PercentChange

- (void)updateChange:(CGFloat)change andAmount:(CGFloat)amount
{
    if (change  == 100) {
        change = 0;
        amount = 0;
    }

    if (change == 0) {
        self.textColor = [UIColor colorWithRed:0.15f green:0.80f blue:0.15f alpha:1];
        self.text = @"0.00 (0.00%)";
    }

    else if (change  > 0 && change < 100000) {
        self.textColor = [UIColor colorWithRed:0.15f green:0.80f blue:0.15f alpha:1];
        self.text = [NSString stringWithFormat:@"+%.02f (%.02f%%)", amount, change];
    }
    
    else if (change  < 0 && change  > -100000) {
        self.textColor = [UIColor colorWithRed:0.85f green:0.05f blue:0.05f alpha:1];
        self.text = [NSString stringWithFormat:@"%.02f (%.02f%%)", amount, 0-change];
    }

    else {
        self.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        self.text = @"";
    }

    self.percentChange = change;
    self.amountChange = amount;
}

@end
