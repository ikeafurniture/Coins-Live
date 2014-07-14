//
//  AddMarketsViewController.h
//  Coins Live
//
//  Created by O on 6/28/14.
//  Copyright (c) 2014 O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFMarketData.h"

@protocol AddMarket <NSObject>
- (void)addMarket:(NSString *)market;
@end

@interface AddMarketsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property id <MarketDataSource> marketDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *markets;
@property id  <AddMarket> addMarket;
- (IBAction)close:(id)sender;
@end
