//
//  CIBankDetailTableViewController.h
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 09.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CIBank.h"

@interface CIBankDetailTableViewController : UITableViewController

@property (nonatomic, strong) CIBank *bank;
@property (nonatomic, strong) NSDictionary *data;


@end
