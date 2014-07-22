//
//  MarketCell.m
//  Coins Live
//
//  Created by O on 6/26/14.
//  Copyright (c) 2014 O. All rights reserved.
//

#import "MarketCell.h"

@implementation MarketCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.name.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
