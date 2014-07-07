//
//  CICurrencyRates.h
//  CurrencyInformation
//
//  Created by Admin on 17.04.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CICurrencyRate : NSObject

@property (nonatomic, strong) NSString *_key;

@property (nonatomic, assign) int bankBuyUSD;
@property (nonatomic, assign) int bankBuyEUR;
@property (nonatomic, assign) double bankBuyRUB;

@property (nonatomic, assign) int bankSellUSD;
@property (nonatomic, assign) int bankSellEUR;
@property (nonatomic, assign) double bankSellRUB;
 
@end
