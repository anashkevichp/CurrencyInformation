//
//  CICurrencyTableViewCell.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 01.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CICurrencyTableViewCell.h"

@implementation CICurrencyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
