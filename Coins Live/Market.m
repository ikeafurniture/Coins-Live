//
//  Market.m
//  Coins
//
//  Created by O on 12/6/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import "Market.h"

@interface Market ()
@property (nonatomic) NSMutableArray *hourPrices;
@property (nonatomic) NSMutableArray *dayPrices;
@property (nonatomic) NSMutableArray *weekPrices;
@property (nonatomic) NSMutableArray *monthPrices;
@property (nonatomic) NSMutableArray *yearPrices;
@end

@implementation Market
- (id)initWithSymbol:(NSString *)symbol
{
    self = [super init];
    if (self) {
        self.symbol = symbol;
        self.exchange = [symbol substringToIndex:symbol.length-6];
        self.item = [[symbol substringToIndex:symbol.length-3] substringFromIndex:symbol.length-6];
        self.currency = [symbol substringFromIndex:symbol.length-3];
        
        self.hourPrices = [@[] mutableCopy];
        self.dayPrices = [@[] mutableCopy];
        self.weekPrices = [@[] mutableCopy];
        self.monthPrices = [@[] mutableCopy];
        self.yearPrices = [@[] mutableCopy];


        #warning Move display names server side?

        if ([self.exchange isEqualToString:@"mtgox"])
            self.displayName = @"Mt. Gox";
        else if ([self.exchange isEqualToString:@"btcchina"])
            self.displayName = @"BTC China";
        else if ([self.exchange isEqualToString:@"btce"])
            self.displayName = @"BTC-E";
        else if ([self.exchange isEqualToString:@"bit2c"])
            self.displayName = @"Bit2C";
        else if ([self.exchange isEqualToString:@"virtex"])
            self.displayName = @"VirtEx";
        else if ([self.exchange isEqualToString:@"localbtc"])
            self.displayName = @"LocalBitcoins";
        else if ([self.exchange isEqualToString:@"okcoin"])
            self.displayName = @"OKCoin";
        else if ([self.exchange isEqualToString:@"796"])
            self.displayName = @"796";
        else if ([self.exchange isEqualToString:@"rmbtb"])
            self.displayName = @"RMBTB";
        else if ([self.exchange isEqualToString:@"fxbtc"])
            self.displayName = @"FXBTC";
        else
            self.displayName = [self.exchange capitalizedString];
    }
    return self;
}

- (void)updatePrice:(PricePoint *)price
{
    self.lastPrice = (self.price > 0) ? self.price : price.price;
    self.price = price.price;
    [self addPrice:price toPrices:self.hourPrices inRange:3600];
    [self addPrice:price toPrices:self.dayPrices inRange:86400];
    [self addPrice:price toPrices:self.weekPrices inRange:604800];
    [self addPrice:price toPrices:self.monthPrices inRange:2592000];
    [self addPrice:price toPrices:self.yearPrices inRange:31536000];
}

- (void)addPrice:(PricePoint *)price toPrices:(NSMutableArray *)prices inRange:(NSInteger)range
{
    if ([prices count] > 1) {
        PricePoint *secondToLast = [prices objectAtIndex:[prices count]-2];
        if (price.timestamp - secondToLast.timestamp < range/100)
            [prices removeLastObject];
    }
    [prices addObject:price];
    [self removeOldPrices:prices fromRange:range];
}

- (void)removeOldPrices:(NSMutableArray *)prices fromRange:(NSInteger)range
{
    NSMutableIndexSet *oldPrices = [[NSMutableIndexSet alloc] init];
    for (NSUInteger i = 0; i < [prices count]; i++) {
        PricePoint *p = prices[i];
        if ([[NSDate date] timeIntervalSince1970] - p.timestamp >= range)
            [oldPrices addIndex:i];
    }

    if ([oldPrices count]) {
        [oldPrices removeIndex:[oldPrices count] -1];
        [prices removeObjectsAtIndexes:[oldPrices copy]];
    }
}


- (void)setPrices:(NSArray *)prices forRange:(NSInteger)range
{
    NSMutableArray *mutablePrices = [prices mutableCopy];
    [self removeOldPrices:mutablePrices fromRange:range];

    if (range == 3600)
        self.hourPrices = mutablePrices;
    else if (range == 86400)
        self.dayPrices = mutablePrices;
    else if (range == 604800)
        self.weekPrices = mutablePrices;
    else if (range == 2592000)
        self.monthPrices = mutablePrices;
    else if (range == 31536000)
        self.yearPrices = mutablePrices;

    if (range == 3600) {
        PricePoint *mostRecent = [mutablePrices lastObject];
        self.price = mostRecent.price;
    }
}

- (NSArray *)getPricesInRange:(NSInteger)range
{
    if (range == 3600)
        return self.hourPrices;
    else if (range == 86400)
        return self.dayPrices;
    else if (range == 604800)
        return self.weekPrices;
    else if (range == 2592000)
        return self.monthPrices;
    else if (range == 31536000)
        return self.yearPrices;
    else
        return nil;
}

@end
