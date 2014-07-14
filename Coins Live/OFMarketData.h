//
//  OFMarketData.h
//  Coins Live
//
//  Created by O on 6/10/14.
//  Copyright (c) 2014 O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Market.h"

@protocol MarketDataSource <NSObject>

#pragma Market Info
- (CGFloat)price:(NSString *)market;
- (CGFloat)lastPrice:(NSString *)market;
- (NSString *)displayName:(NSString *)market;
- (NSString *)currency:(NSString *)market;
- (NSString *)item:(NSString *)market;
- (NSArray *)subscribedMarkets;
- (NSArray *)availableMarkets;

#pragma Pusher
- (void)subscribeToMarket:(NSString *)market;
- (void)unsubscribeFromMarket:(NSString *)market;

#pragma Price History
- (void)fetchHistoricalPrices;
- (CGFloat)percentChange:(NSString *)market inRange:(NSInteger)range;
- (CGFloat)amountChange:(NSString *)market inRange:(NSInteger)range;
- (NSArray *)prices:(NSString *)market inRange:(NSInteger)range;

@end

@interface OFMarketData : NSObject <MarketDataSource>
- (id)initWithMarkets:(NSArray *)markets;
@end
