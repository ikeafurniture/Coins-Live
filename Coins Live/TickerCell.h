//
//  TickerCell.h
//  Coins
//
//  Created by Oliver Fisher on 11/9/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticker.h"
#import "PriceGraph.h"
#import "PercentChange.h"

@interface TickerCell : UITableViewCell
@property IBOutlet UILabel *name;
@property IBOutlet Ticker *ticker;
@property IBOutlet PriceGraph *graph;
@property (strong, nonatomic) IBOutlet UILabel *currency;
@property (strong, nonatomic) IBOutlet PercentChange *percent;
@end
