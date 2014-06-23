//
//  CIMainTableViewController.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 08.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIMainTableViewController.h"
#import "CIBankListTableViewController.h"
#import "CISellTableViewController.h"
#import "CIBuyTableViewController.h"
#import "AFNetworking.h"
#import "CIBank.h"

#define JSON_URL @"http://wm.shadurin.com/select.php"
#define REQUEST_TIMEOUT_INTERVAL 7.0
#define BANK_DETAILS_PLIST_NAME @"bankDetails"
#define CURRENCY_RATES_PLIST_NAME @"currencyRates.plist"


@interface CIMainTableViewController ()

@end

@implementation CIMainTableViewController {
    NSMutableArray *banks;
    NSMutableDictionary *bankDetailsDict;
    NSMutableDictionary *ratesDict;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setUserInteractionEnabled:NO];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setCenter:self.tableView.center];
    [indicator setHidesWhenStopped:YES];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadNotification:) name:@"SaveToPlist" object:nil];
    
    banks = [NSMutableArray arrayWithCapacity:10];
    [self readBankDetailsFromPlist];
    
    /*              *** start networking ***              */
    
    NSURL *url = [NSURL URLWithString:JSON_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ratesDict = (NSMutableDictionary *) responseObject;
        [self mergeDictionaries];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveToPlist" object:self];
        
        [indicator stopAnimating];
        [self.tableView setUserInteractionEnabled:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *connectionErrorAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка получения данных!"
                                                            message:@"Будут использованы ранее сохраненные данные"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Продолжить"
                                                  otherButtonTitles:nil];
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *filePath = [documentsDir stringByAppendingPathComponent:CURRENCY_RATES_PLIST_NAME];
        
        ratesDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        [self mergeDictionaries];
        
        [indicator stopAnimating];
        [self.tableView setUserInteractionEnabled:YES];
        [connectionErrorAlert show];
    }];
    
    [operation start];
    
    /*                *** end networking ***              */
}

- (void)ReloadNotification:(NSNotification *)notification
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:CURRENCY_RATES_PLIST_NAME];
    [ratesDict writeToFile:filePath atomically:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) mergeDictionaries
{
    CIBank *bank;
    for (NSString *key in [bankDetailsDict allKeys]) {
        NSDictionary *details = [bankDetailsDict valueForKey:key];
        NSDictionary *rates = [ratesDict valueForKey:key];
        bank = [[CIBank alloc] init];
        
        bank.bankName = [details objectForKey:@"bankName"];
        bank.address = [details objectForKey:@"address"];
        bank.site = [details objectForKey:@"site"];
        bank.phoneNumber = [details objectForKey:@"phoneNumber"];
        bank.monThuWorkTime = [details objectForKey:@"monThuWorkTime"];
        bank.friWorkTime = [details objectForKey:@"friWorkTime"];
        bank._mapLatitude = [[details objectForKey:@"_mapLatitude"] doubleValue];
        bank._mapLongitude = [[details objectForKey:@"_mapLongitude"] doubleValue];
        
        bank.bankSellEUR = [[rates objectForKey:@"EUR_BUY"] integerValue];
        bank.bankBuyEUR = [[rates objectForKey:@"EUR_SELL"] integerValue];
        bank.bankSellUSD = [[rates objectForKey:@"USD_BUY"] integerValue];
        bank.bankBuyUSD = [[rates objectForKey:@"USD_SELL"] integerValue];
        bank.bankSellRUB = [[rates objectForKey:@"RUR_BUY"] integerValue];
        bank.bankBuyRUB = [[rates objectForKey:@"RUR_SELL"] integerValue];
        
        [banks addObject:bank];
    }
}

- (void) readBankDetailsFromPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:BANK_DETAILS_PLIST_NAME ofType:@"plist"];
    bankDetailsDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MainToRatesSegue"]) {
        UITabBarController *tabBarController = [segue destinationViewController];
        
        CISellTableViewController *sellViewController = [[tabBarController viewControllers] objectAtIndex: 1];
        
        // sort banks array by bankSellUSD
        [banks sortUsingComparator:^NSComparisonResult(CIBank *bank1, CIBank *bank2) {
            NSInteger rate1 = bank1.bankSellUSD;
            NSInteger rate2 = bank2.bankSellUSD;
            if (rate1 < rate2) {
                return NSOrderedAscending;
            } else if (rate1 > rate2) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        sellViewController.banks = [banks mutableCopy];
        
        CIBuyTableViewController *buyViewController = [[tabBarController viewControllers] objectAtIndex: 0];
        
        // sort banks array by bankBuyUSD
        [banks sortUsingComparator:^NSComparisonResult(CIBank *bank1, CIBank *bank2) {
            NSInteger rate1 = bank1.bankBuyUSD;
            NSInteger rate2 = bank2.bankBuyUSD;
            if (rate1 < rate2) {
                return NSOrderedDescending;
            } else if (rate1 > rate2) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];
        buyViewController.banks = [banks mutableCopy];
        
    } else if ([[segue identifier] isEqualToString:@"MainToBankListSegue"]) {
        CIBankListTableViewController *bankListController = [segue destinationViewController];
        
        // sort banks array by bankName
        [banks sortUsingComparator:^NSComparisonResult(CIBank *bank1, CIBank *bank2) {
            return [bank1.bankName compare:bank2.bankName];
        }];
        bankListController.banks = banks;
    }
}

@end
