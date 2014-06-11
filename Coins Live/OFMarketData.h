//
//  OFMarketData.h
//  Coins Live
//
//  Created by O on 6/10/14.
//  Copyright (c) 2014 O. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MarketDataSource <NSObject>

#pragma Pusher
- (void)subscribeToMarket:(NSString *)market;
- (void)unsubscribeFromMarket:(NSString *)market;

#pragma History

@end

@interface OFMarketData : NSObject <MarketDataSource>
- (id)initWithMarkets:(NSArray *)markets;
@end
