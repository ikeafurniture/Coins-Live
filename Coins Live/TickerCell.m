//
//  TickerCell.m
//  Coins
//
//  Created by Oliver Fisher on 11/9/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import "TickerCell.h"

@implementation TickerCell

- (id)init
{
    self = [super init];
    if (self) {
        self.graph = [[PriceGraph alloc] init];
        self.ticker = [[Ticker alloc] init];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//    if(highlighted) {
//        self.name.textColor = [UIColor redColor];
//    } else {
//        self.name.textColor = [UIColor whiteColor];
//    }
//    
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    if(selected) {
//        self.name.textColor = [UIColor redColor];
//    } else {
//        self.name.textColor = [UIColor whiteColor];
//    }
//    
//}



@end
