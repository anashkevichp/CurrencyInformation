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

#define REQUEST_TIMEOUT_INTERVAL 7.0    // request time interval in seconds

#define UPDATE_PAUSE 3                  // update pause in hours

#define BANK_DETAILS_PLIST_NAME @"bankDetails"
#define CURRENCY_RATES_PLIST_NAME @"currencyRates.plist"

#define NO_CONNECTION 0
#define UNKNOWN_CONNECTION -1
#define WWAN_CONNECTION 1
#define WIFI_CONNECTION 2

@interface CIMainTableViewController ()

- (void) networkingOperation;
- (UIAlertView *) connectionErrorAlert;
- (UIAlertView *) updateDataAlert;
- (void) ReloadNotification:(NSNotification *)notification;
- (void) mergeDictionaries;
- (void) readBankDetailsFromPlist;
- (NSString *) getFilePathByFilename: (NSString *)fileName;

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
    
    banks = [NSMutableArray arrayWithCapacity:10];
    [self.tableView setUserInteractionEnabled:NO];
    [self readBankDetailsFromPlist];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadNotification:) name:@"SaveToPlist" object:nil];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case NO_CONNECTION:
                NSLog(@"connection off!");
                break;
            case WWAN_CONNECTION:
            case WIFI_CONNECTION:
            {
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setUserInteractionEnabled:YES];
                [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel] setTextColor:[UIColor blackColor]];

                NSString *filePath = [self getFilePathByFilename:CURRENCY_RATES_PLIST_NAME];
                NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                    NSDate *fileModifDate = [fileAttributes fileModificationDate];
                    NSDateComponents *curComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSHourCalendarUnit fromDate:[NSDate date]];
                    NSDateComponents *fileModifComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSHourCalendarUnit fromDate:fileModifDate];
                    
                    if ([curComponents day] == [fileModifComponents day]) {
                        if (([curComponents hour] - [fileModifComponents hour]) >= UPDATE_PAUSE) {
                            [self networkingOperation];
                        } else {
                            ratesDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                            [self mergeDictionaries];
                            [self.tableView setUserInteractionEnabled:YES];
                        }
                    } else {
                        [self networkingOperation];
                    }
                } else {
                    [self networkingOperation];
                }
            }
                break;
            default:
                break;
        }
    }];
}

- (void) networkingOperation
{
    NSLog(@"Networking operation started!");
    
    banks = [NSMutableArray arrayWithCapacity:10];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setCenter:self.tableView.center];
    [indicator setHidesWhenStopped:YES];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
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
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setUserInteractionEnabled:YES];
        [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel] setTextColor:[UIColor blackColor]];
        [self.tableView setUserInteractionEnabled:YES];
        
        [[self tableView] reloadData];
        [[self updateDataAlert] show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSString *filePath = [self getFilePathByFilename:CURRENCY_RATES_PLIST_NAME];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            ratesDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
            [self mergeDictionaries];
            [indicator stopAnimating];
            [self.tableView setUserInteractionEnabled:YES];
            [[self connectionErrorAlert] show];
            
        } else {
            [self mergeDictionaries];
            [indicator stopAnimating];
            [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setUserInteractionEnabled:YES];
            [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel] setTextColor:[UIColor blackColor]];
            [self.tableView setUserInteractionEnabled:YES];
            
            [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setUserInteractionEnabled:NO];
            [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel] setTextColor:[UIColor grayColor]];
            
            UIAlertView *alertView = [self connectionErrorAlert];
            [alertView setMessage:@"Для просмотра курсов валют потребуется подключение к интернету!"];
            [alertView show];
        }
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
