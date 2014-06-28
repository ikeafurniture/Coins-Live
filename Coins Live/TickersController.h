//
//  TickersController.h
//  Coins
//
//  Created by Oliver Fisher on 11/9/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TickersController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rangeButtons;
- (IBAction)edit:(UIButton *)sender;
- (IBAction)changeRange:(UIButton *)sender;
@end
