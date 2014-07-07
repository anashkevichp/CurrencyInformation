//
//  CIBankListTableViewController.h
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 30.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIBankListTableViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, strong) NSDictionary *allBanksDetailsDict;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
