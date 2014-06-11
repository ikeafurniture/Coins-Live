//
//  PricePoint.h
//  Coins
//
//  Created by Oliver Fisher on 10/21/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PricePoint : NSObject
@property CGFloat price;
@property NSInteger timestamp;
- (id)initWithJSON:(NSDictionary *)json;
- (id)initWithArray:(NSArray *)json;
+ (PricePoint *)make:(NSArray *)price;
@end
