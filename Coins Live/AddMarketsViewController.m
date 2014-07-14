//
//  AddMarketsViewController.m
//  Coins Live
//
//  Created by O on 6/28/14.
//  Copyright (c) 2014 O. All rights reserved.
//

#import "AddMarketsViewController.h"
#import "MarketCell.h"

@interface AddMarketsViewController ()
@end

@implementation AddMarketsViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketCell *cell = (MarketCell *)[tableView dequeueReusableCellWithIdentifier:@"market"];
    
    NSString *market = self.markets[indexPath.row];
    NSString *displayName = [self.marketDataSource displayName:market];
    NSString *currency = [self.marketDataSource currency:market];
    NSString *item = [self.marketDataSource item:market];
    
    cell.name.text = displayName;
    cell.currency.text = [NSString stringWithFormat:@"%@/%@", currency, item];
    
    cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.markets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *market = self.markets[indexPath.row];
    [self.addMarket addMarket:market];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end