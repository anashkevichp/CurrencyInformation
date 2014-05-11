//
//  CICurrencyRates.h
//  CurrencyInformation
//
//  Created by Admin on 17.04.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIBank : NSObject

@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *branchBankName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *workTime;

@property (nonatomic, assign) int bankBuyUSD;
@property (nonatomic, assign) int bankBuyEUR;
@property (nonatomic, assign) int bankBuyRUB;

@property (nonatomic, assign) int bankSellUSD;
@property (nonatomic, assign) int bankSellEUR;
@property (nonatomic, assign) int bankSellRUB;


@end
