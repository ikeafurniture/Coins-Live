//
//  PricePoint.m
//  Coins
//
//  Created by Oliver Fisher on 10/21/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import "PricePoint.h"

@implementation PricePoint
- (id)initWithJSON:(NSDictionary *)json
{
    if (!self)
        self = [super init];
    if ([json valueForKey:@"price"])
        self.price = [[json valueForKey:@"price"] floatValue];
    if ([json valueForKey:@"time"])
        self.timestamp = [[json valueForKey:@"time"] integerValue];
    return self;
}

+ (PricePoint *)make:(NSArray *)price
{
    return [[PricePoint alloc] initWithArray:price];
}

- (id)initWithArray:(NSArray *)json
{
    if (!self)
        self = [super init];
    if (json[0])
        self.price = [json[0] floatValue];
    if (json[1])
        self.timestamp = [json[1] integerValue];
    return self;
}
@end
