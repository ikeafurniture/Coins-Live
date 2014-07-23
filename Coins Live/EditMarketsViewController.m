//
//  EditMarketsViewController.m
//
//
//  Created by O on 6/26/14.
//
//

#import "EditMarketsViewController.h"
#import "MarketCell.h"

@interface EditMarketsViewController ()
@end

@implementation EditMarketsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setEditing:YES];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketCell *cell = (MarketCell *)[tableView dequeueReusableCellWithIdentifier:@"market"];
    
    NSString *market = self.markets[indexPath.row];
    NSString *displayName = [self.marketDataSource displayName:market];
    NSString *currency = [self.marketDataSource currency:market];
    NSString *item = [self.marketDataSource item:market];
    
    cell.name.adjustsFontSizeToFitWidth = YES;
    cell.name.text = displayName;
    cell.currency.text = [NSString stringWithFormat:@"%@/%@", currency, item];
    
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *market = self.markets[sourceIndexPath.row];
    [self.markets removeObjectAtIndex:sourceIndexPath.row];
    [self.markets insertObject:market atIndex:destinationIndexPath.row];
    [self.editingTableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:[self.markets copy] forKey:@"Markets"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *market = self.markets[indexPath.row];
        [self.marketDataSource unsubscribeFromMarket:market];
        [self.markets removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        [self.editingTableView deleteRowsAtIndexPaths:@[indexPath]
                                     withRowAnimation:UITableViewRowAnimationNone];
        [[NSUserDefaults standardUserDefaults] setObject:[self.markets copy] forKey:@"Markets"];
        [[NSUserDefaults standardUserDefaults] synchronize];
#warning keyed archiver??
    }
}


- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"add"])
    {
        AddMarketsViewController *dest = [segue destinationViewController];
        dest.marketDataSource = self.marketDataSource;
        dest.addMarket = self;
        dest.markets = [[self.marketDataSource availableMarkets] mutableCopy];
    }
}

- (void)addMarket:(NSString *)market
{
  
    [self.markets addObject:market];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.markets count]-1 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    [self.editingTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.markets count]-1 inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
    [self.marketDataSource subscribeToMarket:market];
    [self.marketDataSource fetchHistoricalPrices];
    
    NSDictionary *marketsCopy = [self.markets copy];
    [[NSUserDefaults standardUserDefaults] setObject:marketsCopy forKey:@"Markets"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
