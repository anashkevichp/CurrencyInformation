//
//  CICurrencyTableViewCell.h
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 01.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CICurrencyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *currencyRateLabel;

@end
