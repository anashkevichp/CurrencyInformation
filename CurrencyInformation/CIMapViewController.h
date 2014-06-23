//
//  CIViewController.h
//  CurrencyInformation
//
//  Created by Admin on 21.06.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIMapViewController : UIViewController

@property (strong, nonatomic) NSString *bankName;
@property (strong, nonatomic) NSString *address;

@property (assign, nonatomic) double _mapLatitude;
@property (assign, nonatomic) double _mapLongitude;

@end
