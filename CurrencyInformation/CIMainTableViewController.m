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
#import "CIBankDetail.h"
#import "CICurrencyRate.h"

#define JSON_URL @"http://wm.shadurin.com/select.php"
#define REQUEST_TIMEOUT_INTERVAL 7.0        // request time interval in seconds
#define UPDATE_PAUSE 0.5                    // update pause in hours

#define BANK_DETAILS_PLIST_NAME @"bankDetails"
#define CURRENCY_RATES_PLIST_NAME @"currencyRates.plist"

#define NO_CONNECTION 0
#define UNKNOWN_CONNECTION -1
#define WWAN_CONNECTION 1
#define WIFI_CONNECTION 2

@interface CIMainTableViewController ()

- (void) networkOperation:(UIActivityIndicatorView *) indicator;
- (UIAlertView *) connectionErrorAlert;
- (UIAlertView *) updateDataAlert;
- (void) ReloadNotification:(NSNotification *)notification;
- (void) readCurrencyRatesFromPlist;
- (void) parseRatesDict;
- (void) readBankDetailsFromPlist;
- (NSString *) getFilePathByFilename: (NSString *)fileName;

@end

@implementation CIMainTableViewController {
    NSMutableArray *ratesArray;
    NSMutableDictionary *banksDetailsDict;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadNotification:) name:@"SaveToPlist" object:nil];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    [self readBankDetailsFromPlist];
    ratesArray = [NSMutableArray arrayWithCapacity:10];
    
    [self changeConnectionStatusMonitoring];
}

- (void) changeConnectionStatusMonitoring {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // ratesArray = [NSMutableArray arrayWithCapacity:10];
        
        switch (status) {
            case NO_CONNECTION:
            {
                NSLog(@"Connection is off!");
                
                NSString *filePath = [self getFilePathByFilename:CURRENCY_RATES_PLIST_NAME];
                if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                    NSLog(@"Plist with rates is not exists!");
                    
                    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setUserInteractionEnabled:NO];
                    [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel] setTextColor:[UIColor grayColor]];
                    UIAlertView *alertView = [self connectionErrorAlert];
                    [alertView setMessage:@"Для просмотра курсов валют потребуется подключение к интернету!"];
                    [self.tableView setUserInteractionEnabled:YES];
                    [alertView show];
                }
                break;
            }
            case WWAN_CONNECTION:
            case WIFI_CONNECTION:
            {
                NSLog(@"Connection is on");
                
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [indicator setCenter:[self.tableView center]];
                [indicator setHidesWhenStopped:YES];
                [indicator startAnimating];
                [self.view addSubview:indicator];
                
                NSString *filePath = [self getFilePathByFilename:CURRENCY_RATES_PLIST_NAME];
                NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                    NSDate *fileModifDate = [fileAttributes fileModificationDate];
                    NSDateComponents *curComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSHourCalendarUnit fromDate:[NSDate date]];
                    NSDateComponents *fileModifComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSHourCalendarUnit fromDate:fileModifDate];
                    
                    if ([curComponents day] == [fileModifComponents day]) {
                        if (([curComponents hour] - [fileModifComponents hour]) >= UPDATE_PAUSE) {
                            [self networkOperation:indicator];
                        } else {
                            NSLog(@"Plist data are actual!");
                            [self readCurrencyRatesFromPlist];
                            [self.tableView setUserInteractionEnabled:YES];
                            [indicator stopAnimating];
                        }
                    } else {
                        [self networkOperation:indicator];
                    }
                } else {
                    [self networkOperation:indicator];
                }
            }
                break;
            default:
                break;
        }
    }];
}

- (void) networkOperation: (UIActivityIndicatorView *) indicator
{
    /*              *** start networking ***              */
    NSLog(@"Networking operation started!");
    
    NSURL *url = [NSURL URLWithString:JSON_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Successful request!");
        ratesDict = (NSMutableDictionary *) responseObject;
        [self parseRatesDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveToPlist" object:self];
        
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setUserInteractionEnabled:YES];
        [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel] setTextColor:[UIColor blackColor]];
        [indicator stopAnimating];
        [self.tableView setUserInteractionEnabled:YES];
        
        [[self tableView] reloadData];
        [[self updateDataAlert] show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Unseccessful request!");
        UIAlertView *alertView = [self connectionErrorAlert];
        
        NSString *filePath = [self getFilePathByFilename:CURRENCY_RATES_PLIST_NAME];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setUserInteractionEnabled:YES];
            [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel] setTextColor:[UIColor blackColor]];
            [alertView setMessage:@"Будут использованы ранее сохраненные данные."];
            
        } else {
            
            [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setUserInteractionEnabled:NO];
            [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel] setTextColor:[UIColor grayColor]];
            [alertView setMessage:@"Для просмотра курсов валют потребуется подключение к интернету!"];
        
        }
        [indicator stopAnimating];
        [self.tableView setUserInteractionEnabled:YES];
        [self readCurrencyRatesFromPlist];
        
        [alertView show];
        
        [[self tableView] reloadData];
    }];
    
    [operation start];
    
    /*                *** end networking ***              */
}

- (UIAlertView *) connectionErrorAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка получения данных!"
                                                        message:@"Будут использованы ранее сохраненные данные."
                                                       delegate:nil
                                              cancelButtonTitle:@"Продолжить"
                                              otherButtonTitles:nil];
    return alertView;
}

- (UIAlertView *) updateDataAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Успешное подключение к интернету!"
                                                        message:@"Данные обновлены."
                                                       delegate:nil
                                              cancelButtonTitle:@"Продолжить"
                                              otherButtonTitles:nil];
    return alertView;
}

- (NSString *) getFilePathByFilename: (NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:fileName];
}

- (void) ReloadNotification: (NSNotification *)notification
{
    NSString *filePath = [self getFilePathByFilename:CURRENCY_RATES_PLIST_NAME];
    [ratesDict writeToFile:filePath atomically:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) readCurrencyRatesFromPlist
{
    NSString *filePath = [self getFilePathByFilename:CURRENCY_RATES_PLIST_NAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        ratesDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        [self parseRatesDict];
    }
}

- (void) parseRatesDict
{
    CICurrencyRate *currencyRate;
    [ratesArray removeAllObjects];
    
    for (NSString *key in [ratesDict allKeys]) {
        NSDictionary *rates = [ratesDict valueForKey:key];
        currencyRate = [[CICurrencyRate alloc] init];
        
        currencyRate._key = key;
        currencyRate.bankSellEUR = [[rates objectForKey:@"EUR_BUY"] integerValue];
        currencyRate.bankBuyEUR = [[rates objectForKey:@"EUR_SELL"] integerValue];
        currencyRate.bankSellUSD = [[rates objectForKey:@"USD_BUY"] integerValue];
        currencyRate.bankBuyUSD = [[rates objectForKey:@"USD_SELL"] integerValue];
        currencyRate.bankSellRUB = [[rates objectForKey:@"RUR_BUY"] doubleValue];
        currencyRate.bankBuyRUB = [[rates objectForKey:@"RUR_SELL"] doubleValue];
        
        [ratesArray addObject:currencyRate];
    }
}

- (void) readBankDetailsFromPlist
{
    NSString *bankDetailsFilePath = [[NSBundle mainBundle] pathForResource:BANK_DETAILS_PLIST_NAME ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:bankDetailsFilePath]) {
         banksDetailsDict = [NSMutableDictionary dictionaryWithContentsOfFile:bankDetailsFilePath];
    }
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
        [ratesArray sortUsingComparator:^NSComparisonResult(CICurrencyRate *currencyRate1, CICurrencyRate *currencyRate2) {
            NSInteger rate1 = currencyRate1.bankSellUSD;
            NSInteger rate2 = currencyRate2.bankSellUSD;
            if (rate1 < rate2) {
                return NSOrderedAscending;
            } else if (rate1 > rate2) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        sellViewController.currencyRates = [ratesArray mutableCopy];
        sellViewController.bankDetails = banksDetailsDict;
        
        CIBuyTableViewController *buyViewController = [[tabBarController viewControllers] objectAtIndex: 0];
        
        // sort banks array by bankBuyUSD
        [ratesArray sortUsingComparator:^NSComparisonResult(CICurrencyRate *currencyRate1, CICurrencyRate *currencyRate2) {
            NSInteger rate1 = currencyRate1.bankBuyUSD;
            NSInteger rate2 = currencyRate2.bankBuyUSD;
            if (rate1 < rate2) {
                return NSOrderedDescending;
            } else if (rate1 > rate2) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];
        buyViewController.currencyRates = [ratesArray mutableCopy];
        buyViewController.bankDetails = banksDetailsDict;
        
    } else if ([[segue identifier] isEqualToString:@"MainToBankListSegue"]) {
        
        CIBankListTableViewController *bankListController = [segue destinationViewController];
        bankListController.allBanksDetailsDict = banksDetailsDict;
    }
}

@end
