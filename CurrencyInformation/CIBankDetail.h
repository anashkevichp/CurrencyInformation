//
//  CIBankDetail.h
//  Минск.Банки
//
//  Created by Pavel on 01.07.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIBankDetail : NSObject

@property (nonatomic, strong) NSString *_key;

@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *monThuWorkTime;
@property (nonatomic, strong) NSString *friWorkTime;

@property (nonatomic, assign) double _mapLatitude;
@property (nonatomic, assign) double _mapLongitude;

@end
