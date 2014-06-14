//
//  Market.h
//  Coins
//
//  Created by O on 12/6/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PricePoint.h"

@interface Market : NSObject
@property NSString *exchange;
@property NSString *currency;
@property NSString *item;
@property NSString *symbol;
@property NSString *displayName;
@property CGFloat price;
@property CGFloat lastPrice;
@property NSInteger updated;

- (id)initWithSymbol:(NSString *)symbol;
- (void)updatePrice:(PricePoint *)price;
- (void)setPrices:(NSArray *)prices forRange:(NSInteger)range;
- (NSArray *)pricesInRange:(NSInteger)range;
//percent change in ranges
@end
