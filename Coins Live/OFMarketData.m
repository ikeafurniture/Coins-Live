//
//  OFMarketData.m
//  Coins Live
//
//  Created by O on 6/10/14.
//  Copyright (c) 2014 O. All rights reserved.
//

#import "OFMarketData.h"
#import <Pusher/Pusher.h>
#import "Market.h"

@interface OFMarketData () <PTPusherDelegate>
@property NSMutableDictionary *markets;
@property PTPusher *pusherClient;
@property NSInteger lastUpdated;
@end

@implementation OFMarketData

- (id)initWithMarkets:(NSArray *)markets
{
    self = [super init];
    if (self) {
        
        self.pusherClient = [PTPusher pusherWithKey:@"772e3efac9290a5818b7" delegate:self encrypted:NO];
        [self.pusherClient connect];
        [self.pusherClient bindToEventNamed:@"price" handleWithBlock:^(PTPusherEvent *event) {
            // event.data is a NSDictionary of the JSON object received
            NSLog(@"%@", event.channel);
            NSLog(@"%@", event.data);
        }];
        
        self.markets = [@{} mutableCopy];
        for (NSString *symbol in markets) {
            Market *market = [[Market alloc] initWithSymbol:symbol];
            [self.markets setObject:market forKey:symbol];
            [self subscribeToMarket:market.symbol];
        }
        
        //[self updateHistoricalPrices];
    }
    return self;
}

- (void)subscribeToMarket:(NSString *)market
{
    [self.pusherClient subscribeToChannelNamed:market];
}

- (void)unsubscribeFromMarket:(NSString *)market
{
    PTPusherChannel *channel = [self.pusherClient channelNamed:market];
    [channel unsubscribe];
}

@end
