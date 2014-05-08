//
//  CICurrencyRates.h
//  CurrencyInformation
//
//  Created by Admin on 17.04.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIBank : NSObject

@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *branchBankName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *workTime;

@property (nonatomic, assign) int bankBuyUSD;
@property (nonatomic, assign) int bankBuyEUR;
@property (nonatomic, assign) int bankBuyRUB;

@property (nonatomic, assign) int bankSellUSD;
@property (nonatomic, assign) int bankSellEUR;
@property (nonatomic, assign) int bankSellRUB;

@end
