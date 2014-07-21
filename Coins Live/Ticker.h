//
//  Ticker.h
//  BitBot
//
//  Created by Oliver Fisher on 5/14/13.
//
//

#import <UIKit/UIKit.h>

@interface Ticker : UILabel
@property NSString *currency;
@property (nonatomic) CGFloat price;
@property CGFloat lastPrice;
@property CGFloat changeInPrice;
@property (strong) UILabel *colorizedLabel;
@property BOOL isAnimating;
@end
