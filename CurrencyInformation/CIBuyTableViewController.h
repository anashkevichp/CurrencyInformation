//
//  CIBuyTableViewController.h
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 09.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIBuyTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *currencyRates;
@property (nonatomic, strong) NSDictionary *bankDetails;

@end
