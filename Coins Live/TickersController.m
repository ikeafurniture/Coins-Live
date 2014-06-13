//
//  TickerController.m
//  Coins
//
//  Created by Oliver Fisher on 11/9/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import "TickersController.h"
#import "TickerCell.h"
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
    self.range = 3600*24;
    
    self.markets = [NSKeyedUnarchiver unarchiveObjectWithData:
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"Markets"]];
    if (!self.markets)
        self.markets = [@[@"bitstampBTCUSD",
                          @"btceBTCUSD",
                          @"coinbaseBTCUSD",
                          @"bitfinexBTCUSD",
                          @"virtexBTCCAD",
                          @"btcchinaBTCCNY",
                          @"okcoinBTCCNY",
                          @"btceNMCUSD",
                          @"btceLTCUSD",
                          ] mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(price:)
                                                 name:@"price" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(prices:)
                                                 name:@"prices" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    self.marketDataSource = [[OFMarketData alloc] initWithMarkets:self.markets];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)enterForeground
{
    NSLog(@"ENTER FOREGROUND");
    [self.marketDataSource fetchHistoricalPrices];
    //maybe cancel all animations? got to work out the little ticker glitches somehow
}


#pragma Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TickerCell *cell = (TickerCell *)[tableView dequeueReusableCellWithIdentifier:@"Ticker" forIndexPath:indexPath];
    
    //Info
    NSString *symbol = self.markets[indexPath.row];
    NSString *displayName = [self.marketDataSource displayName:symbol];
    NSString *currency = [self.marketDataSource currency:symbol];
    NSString *item = [self.marketDataSource item:symbol];
    CGFloat price = [self.marketDataSource price:symbol];
    CGFloat percentChange = [self.marketDataSource percentChange:symbol inRange:self.range];
    CGFloat amountChange = [self.marketDataSource amountChange:symbol inRange:self.range];
    NSArray *prices = [self.marketDataSource prices:symbol inRange:self.range];
    
    //Set Values
    cell.name.text = displayName;
    cell.currency.text = [NSString stringWithFormat:@"%@/%@", currency, item];
    cell.ticker.currency = currency;
    cell.ticker.lastPrice = price;
    cell.ticker.price = price;
    [cell.percent updateChange:percentChange andAmount:amountChange];
    
    //Graph
    cell.graph.range = self.range;
    cell.graph.prices = [prices mutableCopy];
    [cell.graph setNeedsDisplay];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.tableView.bounds.size.height > 300) ? self.tableView.bounds.size.height/4 : self.tableView.bounds.size.height;
}

//apparently this method is a performance hit--

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.tableView.bounds.size.height > 300) ? self.tableView.bounds.size.height/4 : self.tableView.bounds.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.markets count];
}

- (TickerCell *)cellForMarket:(NSString *)market
{
    int i = 0;
    for (NSString *m in self.markets) {
        if ([market isEqual:m])
            return (TickerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        i++;
    }
    return nil;
}


#pragma Toolbar

- (void)changeRange:(UIButton *)sender
{
    if ([sender.currentTitle isEqual:@"H"])
        self.range = 3600;
    
    else if ([sender.currentTitle isEqual:@"D"])
        self.range = 3600*24;
    
    else if ([sender.currentTitle isEqual:@"W"])
        self.range = 3600*24*7;
    
    else if ([sender.currentTitle isEqual:@"M"])
        self.range = 3600*24*30;
    
    else if ([sender.currentTitle isEqual:@"Y"])
        self.range = 3600*24*365;
    
    [self reloadGraphs];
    
    for (UIButton *button in self.rangeButtons)
        ([button isEqual:sender]) ? [sender setSelected:YES] : [button setSelected:NO];
}


#pragma Market Data

- (void)price:(NSNotification *)notification
{
    NSString *symbol = notification.userInfo[@"symbol"];
    TickerCell *cell = [self cellForMarket:symbol];
    
    NSArray *prices = [self.marketDataSource prices:symbol inRange:self.range];
    
    cell.ticker.lastPrice = [self.marketDataSource lastPrice:symbol];
    cell.ticker.price = [self.marketDataSource price:symbol];
    cell.graph.prices = [prices mutableCopy];
    cell.graph.range = self.range;
    [cell.graph setNeedsDisplay];
    PricePoint *firstPrice = [prices firstObject];
    CGFloat amount = [self.marketDataSource amountChange:symbol inRange:self.range];
    CGFloat change = [self.marketDataSource percentChange:symbol inRange:self.range];
    [cell.percent updateChange:change andAmount:amount];
}

- (void)prices:(NSNotification *)notification
{
    NSString *market = notification.userInfo[@"symbol"];
    TickerCell *cell = [self cellForMarket:market];
    
    if ([[self.tableView visibleCells] containsObject:cell]) {
        NSArray *prices = [self.marketDataSource prices:market inRange:self.range];
        cell.graph.prices = [prices mutableCopy];
        cell.graph.range = self.range;
        [cell.graph setNeedsDisplay];
        
        
        cell.ticker.lastPrice = [self.marketDataSource price:market];
        cell.ticker.price = [self.marketDataSource price:market];
        
        PricePoint *firstPrice = [prices firstObject];
        CGFloat amount = [self.marketDataSource amountChange:market inRange:self.range];
        CGFloat change = [self.marketDataSource percentChange:market inRange:self.range];
        [cell.percent updateChange:change andAmount:amount];
    }
}


- (void)recursivelyReloadGraphs
{
    [self reloadGraphs];
#warning WEIRD
    double delayInSeconds = 2; //FIX THIS!! Should only reload so often in hour view
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self recursivelyReloadGraphs];
    });
}

- (void)reloadGraphs
{
    for (TickerCell *cell in [self.tableView visibleCells]) {
        NSString *market = self.markets[[self.tableView indexPathForCell:cell].row];
        NSArray *prices = [self.marketDataSource prices:market inRange:self.range];
        cell.graph.prices = [prices mutableCopy];
        cell.graph.range = self.range;
        
        [cell.graph setNeedsDisplay];
        
        CGFloat amount = [self.marketDataSource amountChange:market inRange:self.range];
        CGFloat change = [self.marketDataSource percentChange:market inRange:self.range];
        [cell.percent updateChange:change andAmount:amount];
    }
}


@end
