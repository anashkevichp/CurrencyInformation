//
//  CIMainTableViewController.h
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 08.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIMainTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *rangeSlider;
@property (nonatomic, assign) int sliderValue;

@end
