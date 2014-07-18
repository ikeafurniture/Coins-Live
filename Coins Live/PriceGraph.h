//
//  PriceGraph.h
//  Coins
//
//  Created by Oliver Fisher on 10/21/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceGraph : UIView
@property (nonatomic, strong) NSMutableArray *prices;
@property CGFloat lowPrice;
@property CGFloat highPrice;
@property CGFloat range;
@property CGFloat change;
//do something where i can just add a few prices to the path.. only if the high or low changes should i have to redraw
@end
