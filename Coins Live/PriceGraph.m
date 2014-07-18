//
//  PriceGraph.m
//  Coins
//
//  Created by Oliver Fisher on 10/21/13.
//  Copyright (c) 2013 Oliver Fisher. All rights reserved.
//

#import "PriceGraph.h"
#import "PricePoint.h"

@implementation PriceGraph

- (void)drawRect:(CGRect)rect {
    [self drawGraphInRect:CGRectInset(rect, 0, 5)];
}

- (void)drawGraphInRect:(CGRect)rect {
    UIBezierPath *graph  = [UIBezierPath bezierPath];
    graph.lineWidth = 1;
    graph.lineJoinStyle = kCGLineJoinBevel;
    graph.lineCapStyle = kCGLineCapSquare;
    [self caluclateHighAndLow];
    [self addPointsToPath:graph inRect:rect];
    //[self drawTickMarks];
    [self setColor];
    [graph stroke];
}

- (void)drawTickMarks
{
    CGFloat numberOfTicks = 0;

    if (self.range == 3600)
        numberOfTicks = 6;

    else if (self.range == 3600*24)
        numberOfTicks = 24;

    else if (self.range == 3600*24*7)
        numberOfTicks = 7;

    else if (self.range == 3600*24*30)
        numberOfTicks = 4;

    else if (self.range == 3600*24*365)
        numberOfTicks = 12;


    CGFloat x;
    UIBezierPath *ticks = [UIBezierPath bezierPath];
    for (CGFloat i = 1; i < numberOfTicks; i++) {

        x = (i/numberOfTicks)*self.bounds.size.width;
        [ticks moveToPoint:CGPointMake(x, self.bounds.size.height)];
        [ticks addLineToPoint:CGPointMake(x, self.bounds.size.height-5)];
    }


    [[UIColor colorWithRed:0.50f green:0.50f blue:0.50f alpha:1] setStroke];
    ticks.lineWidth = 1;
    [ticks stroke];
}

- (void)caluclateHighAndLow {
    self.highPrice = 0;
    self.lowPrice = 100000000;
    PricePoint *first = [self.prices firstObject];
    PricePoint *lastPrice = [self.prices lastObject];


    //HACK
    CGFloat x, y;
    NSTimeInterval startTime = [[NSDate dateWithTimeIntervalSinceNow:(0-self.range)] timeIntervalSince1970];
    NSTimeInterval endTime =  [[NSDate date] timeIntervalSince1970];


    for (NSUInteger j = 0; j<[self.prices count]; j++) {
        PricePoint *price = self.prices[j];
        x = ((price.timestamp - startTime) / (endTime - startTime))*self.bounds.size.width;
        y = ((self.highPrice - price.price) / (self.highPrice - self.lowPrice)) * self.bounds.size.height;
        if (price.price > self.highPrice && x>0)
            self.highPrice = price.price;
        if (price.price < self.lowPrice && x>0)
            self.lowPrice = price.price;
    }

    self.change = lastPrice.price - first.price;

    // handle special case where the first point (offscreen) is way higher/lower than first visible point
    // maybe i have to calculate the y value for x in that first segment
}

- (void)addPointsToPath:(UIBezierPath *)path inRect:(CGRect)rect {


    NSTimeInterval startTime = [[NSDate dateWithTimeIntervalSinceNow:(0-self.range)] timeIntervalSince1970];
    NSTimeInterval endTime =  [[NSDate date] timeIntervalSince1970];

    CGFloat x, y;
    for (NSUInteger i = 0; i<[self.prices count]; i++) {
        PricePoint *price = self.prices[i];
        x = ((price.timestamp - startTime) / (endTime - startTime))*rect.size.width;
        y = ((self.highPrice - price.price) / (self.highPrice - self.lowPrice)) * rect.size.height+6;

        if (x>-500 && x<700 && y>-500 && y<600) {  //Sanity check... but why are there bad points?
            CGPoint point = CGPointMake(x, y);
            ([path isEmpty]) ? [path moveToPoint:point] : [path addLineToPoint:point];
        }
    }
}

- (void)setColor {
    UIColor *greenColor = [UIColor colorWithRed:0.15f green:0.80f blue:0.15f alpha:1];
    UIColor *redColor = [UIColor colorWithRed:0.85f green:0.05f blue:0.05f alpha:1];
    (self.change >= 0) ? [greenColor setStroke] : [redColor setStroke];
}

@end
