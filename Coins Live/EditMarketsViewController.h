//
//  EditMarketsViewController.h
//  
//
//  Created by O on 6/26/14.
//
//

#import <UIKit/UIKit.h>
#import "OFMarketData.h"

@interface EditMarketsViewController : UITableViewController
@property id <MarketDataSource> marketDataSource;
@property UITableView *editingTableView;
@property NSMutableArray *markets;
- (IBAction)close:(id)sender;
@end
