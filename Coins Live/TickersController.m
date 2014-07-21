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
#import "EditMarketsViewController.h"

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
    
    self.markets = [[NSUserDefaults standardUserDefaults] objectForKey:@"Markets"];
    if (!self.markets)
        self.markets = [@[@"bitstampBTCUSD",
                          @"btceBTCUSD",
                          @"coinbaseBTCUSD",
                          @"okcoinBTCCNY",
                          ] mutableCopy];
    
    self.marketDataSource = [[OFMarketData alloc] initWithMarkets:self.markets];
    [self recursivelyReloadGraphs];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(price:)
                                                 name:@"price"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(prices:)
                                                 name:@"prices"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)enterForeground
{
    [self.marketDataSource fetchHistoricalPrices];
}


#pragma Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Ticker"
                                                       forIndexPath:indexPath];
    
    //Info
    NSString *market = self.markets[indexPath.row];
    NSString *displayName = [self.marketDataSource displayName:market];
    NSString *currency = [self.marketDataSource currency:market];
    NSString *item = [self.marketDataSource item:market];
    CGFloat price = [self.marketDataSource price:market];
    NSArray *prices = [self.marketDataSource prices:market inRange:self.range];
    
    //Set Values
    cell.name.text = displayName;
    cell.currency.text = [NSString stringWithFormat:@"%@/%@", currency, item];
    cell.ticker.currency = currency;
    cell.ticker.lastPrice = price;
    cell.ticker.price = price;
    [cell.percent updateChange:[self.marketDataSource percentChange:market inRange:self.range]
                     andAmount:[self.marketDataSource amountChange:market inRange:self.range]];
    
    cell.name.textColor = [UIColor whiteColor];
    
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

- (void)edit:(UIButton *)sender
{
    
    [self performSegueWithIdentifier:@"Edit" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Edit"])
    {
        EditMarketsViewController *dest = [[segue destinationViewController] childViewControllers][0];
        dest.marketDataSource = self.marketDataSource;
        dest.markets = self.markets;
        dest.editingTableView = self.tableView;
    }
}


#pragma Market Data

- (void)price:(NSNotification *)notification
{
    NSString *market = notification.userInfo[@"symbol"];
    TickerCell *cell = [self cellForMarket:market];
    
    if ([[self.tableView visibleCells] containsObject:cell]) {
        
        //Graph
        NSArray *prices = [self.marketDataSource prices:market inRange:self.range];
        cell.graph.prices = [prices mutableCopy];
        cell.graph.range = self.range;
        [cell.graph setNeedsDisplay];
        
        //Ticker
        cell.ticker.lastPrice = [self.marketDataSource lastPrice:market];
        cell.ticker.price = [self.marketDataSource price:market];
        
        //Change
        [cell.percent updateChange:[self.marketDataSource percentChange:market inRange:self.range]
                         andAmount:[self.marketDataSource amountChange:market inRange:self.range]];
    }
}

- (void)prices:(NSNotification *)notification
{
    NSString *market = notification.userInfo[@"symbol"];
    TickerCell *cell = [self cellForMarket:market];
    
    if ([[self.tableView visibleCells] containsObject:cell]) {
        
        //Graph
        NSArray *prices = [self.marketDataSource prices:market inRange:self.range];
        cell.graph.prices = [prices mutableCopy];
        cell.graph.range = self.range;
        [cell.graph setNeedsDisplay];
        
        //Ticker
        cell.ticker.lastPrice = [self.marketDataSource lastPrice:market];
        cell.ticker.price = [self.marketDataSource price:market];
        
        //Change
        [cell.percent updateChange:[self.marketDataSource percentChange:market inRange:self.range]
                         andAmount:[self.marketDataSource amountChange:market inRange:self.range]];
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
        
        [cell.percent updateChange:[self.marketDataSource percentChange:market inRange:self.range]
                         andAmount:[self.marketDataSource amountChange:market inRange:self.range]];
    }
}


@end
