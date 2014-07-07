//
//  CIBankDetailTableViewController.h
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 09.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CIBankDetail.h"
#import "CICurrencyRate.h"

@interface CIBankDetailTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *bankDetailsDict;

@end
