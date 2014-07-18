//
//  Ticker.m
//  BitBot
//
//  Created by Oliver Fisher on 5/14/13.
//
//

#import "Ticker.h"

@implementation Ticker

- (void)setPrice:(CGFloat)price
{
    if (price > 0) {
        CGFloat lastPrice = self.lastPrice;
        self.changeInPrice = price - lastPrice;
        _price = price;

        if (self.changeInPrice != price) {
            UIColor *green = [UIColor colorWithRed:0.15f green:0.80f blue:0.15f alpha:1];
            UIColor *red = [UIColor colorWithRed:0.85f green:0.05f blue:0.05f alpha:1];
            if (self.changeInPrice > 0)
                [self animateWithColor:green
                                 price:price
                          andLastPrice:lastPrice];
            else if (self.changeInPrice < 0)
                [self animateWithColor:red
                                 price:price
                          andLastPrice:lastPrice];
        }
        [self setLabel:price];
    }

    else
        [self setText:@""];
}

- (void)animateWithColor:(UIColor *)color price:(CGFloat)price andLastPrice:(CGFloat)lastPrice
{
    void (^animateLabel)(void);

    animateLabel = ^{
        
        //if (!self.isAnimating) {
            
            self.isAnimating = YES;

            [self.colorizedLabel removeFromSuperview];
            self.colorizedLabel = [self overlayLabel:self withColor:self.textColor];

            NSString *oldPrice;
            NSString *newPrice;

            if ([self.currency isEqual:@"RUR"]) { //get other large currency symbols
                oldPrice = [NSString stringWithFormat:@"???%.02f", lastPrice];
                newPrice = [NSString stringWithFormat:@"???%.02f", price];
            }
            
            else if ([self.currency isEqual:@"PLN"]) { //get other large currency symbols
                oldPrice = [NSString stringWithFormat:@"??%.02f", lastPrice];
                newPrice = [NSString stringWithFormat:@"??%.02f", price];
            }
            
            else {
                oldPrice = [NSString stringWithFormat:@"?%.02f", lastPrice];
                newPrice = [NSString stringWithFormat:@"?%.02f", price];
            }
            
            NSUInteger digitWherePriceBeginsToChange = 0;
            for (NSUInteger i = 0; i < [oldPrice length]; i++) {
                if ([oldPrice characterAtIndex:i] != [newPrice characterAtIndex:i]) {
                    digitWherePriceBeginsToChange = i;
                    break;
                };
            }
            
            if (digitWherePriceBeginsToChange <= [newPrice length] && digitWherePriceBeginsToChange >= 1) {
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
                                                  initWithString:[NSString stringWithFormat:@"%@%.02f", [[Ticker symbols] objectForKey:self.currency], price]];
                [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(digitWherePriceBeginsToChange, str.length-digitWherePriceBeginsToChange)];
                self.colorizedLabel.attributedText = str;
                
                [UIView beginAnimations:nil context:nil];
                self.colorizedLabel.alpha = 1;
                [UIView commitAnimations];
                double delayInSeconds = 1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                if (self.colorizedLabel) {
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [UIView animateWithDuration:1 animations:^{
                            self.colorizedLabel.alpha = 0;
                        } completion:^(BOOL finished) {
                            if (finished) [self.colorizedLabel removeFromSuperview];
                            self.isAnimating = NO;
                        }];
                    });
                }
            }
        // }
    };

    animateLabel();
}

- (UILabel *)overlayLabel:(UILabel *)label withColor:(UIColor *)color
{
    UILabel *labelCopy = [[UILabel alloc] init];
    labelCopy.backgroundColor = [UIColor blackColor];
    labelCopy.alpha = 0;
    labelCopy.textAlignment = label.textAlignment;
    labelCopy.font = label.font;
    labelCopy.textColor = color;
    labelCopy.text = label.text;
    labelCopy.frame = label.frame;
    labelCopy.clipsToBounds = NO;
    [label.superview addSubview:labelCopy];
    return labelCopy;
}

+(NSDictionary *)symbols
{
    NSDictionary *symbols = @{@"CNY" : @"¥",
                              @"JPY" : @"¥",
                              @"EUR" : @"€",
                              @"GBP" : @"£",
                              @"NIS" : @"₪",
                              @"USD" : @"$",
                              @"PLN" : @"zł",
                              @"CAD" : @"CA$",
                              @"RUR" : @"pyб",
                              @"LTC" : @"Ł",
                              @"NOK" : @"kr",
                              @"SGD" : @"$",
                              @"SEK" : @"kr",
                              @"RUB" : @"pyб",
                              @"DKK" : @"kr",
                              @"NZD" : @"$",
                              @"AUD" : @"$",
                              @"CZK" : @"Kč",
                              @"THB" : @"฿",
                              @"KRW" : @"₩",
                              @"INR" : @"₹",
                              @"ZAR" : @"R",
                              @"NMC" : @"ℕ",
                              @"BTC" : @"฿"};
    return symbols;
}


- (void)setLabel:(CGFloat)price
{
    [self setText:[NSString stringWithFormat:@"%@%.02f", [[Ticker symbols] objectForKey:self.currency], price]];
}

@end
