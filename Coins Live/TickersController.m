//
//  TickerController.m
//  Coins
//
//  Created by Oliver Fisher on 11/9/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import "TickersController.h"
//#import "TickerCell.h"
#import "OFMarketData.h"
#import "PricePoint.h"
#import "Market.h"

@interface TickersController ()
@property id <MarketDataSource> marketDataSource;
@property NSMutableArray *markets;
@property NSInteger range;
@end

@implementation TickersController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.marketDataSource = [[OFMarketData alloc] initWithMarkets:@[@"bitstampBTCUSD",
                                                                    @"btceBTCUSD",
                                                                    @"coinbaseBTCUSD",
                                                                    @"bitfinexBTCUSD",
                                                                    @"virtexBTCCAD",
                                                                    @"btcchinaBTCCNY",
                                                                    @"okcoinBTCCNY",
                                                                    @"btceNMCUSD",
                                                                    @"btceLTCUSD",
                                                                    ]];
}

@end
