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
#define PATH_TO_BANK_DETAILS_PLIST @"bankDetails"


@interface CIMainTableViewController ()

@end

@implementation CIMainTableViewController {
    NSMutableArray *banks;
    NSDictionary *dict;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadNotification:) name:@"SaveToPlist" object:nil];
    
    [self.tableView setUserInteractionEnabled:NO];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setCenter:self.tableView.center];
    [indicator setHidesWhenStopped:YES];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    /*              *** start networking ***              */
    
    banks = [NSMutableArray arrayWithCapacity:10];
    NSURL *url = [NSURL URLWithString:JSON_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dict = (NSDictionary *) responseObject;
        [self fillRatesArrayFromDictionary];
        [self readBankDetailsFromPlist];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveToPlist" object:self];
        
        [indicator stopAnimating];
        [self.tableView setUserInteractionEnabled:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка получения данных!"
                                                            message:@"Будут использованы ранее сохраненные данные"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Продолжить"
                                                  otherButtonTitles:nil];
        
        
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"saveData" ofType:@"plist"];
        
        dict = [NSDictionary dictionaryWithContentsOfFile:dataPath];
        [self fillRatesArrayFromDictionary];
        [self readBankDetailsFromPlist];
        
        [indicator stopAnimating];
        [self.tableView setUserInteractionEnabled:YES];
        [alertView show];
    }];
    
    [operation start];
    
    /*                *** end networking ***              */
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)ReloadNotification:(NSNotification *)notification
{
    [dict writeToFile:@"33ts/CurrencyInformation/CurrencyInformation/saveData.plist" atomically:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) fillRatesArrayFromDictionary
{
    CIBank *bank;
    for (NSArray *keysArray in dict) {
        NSDictionary *rates = [dict objectForKey:keysArray];
        
        bank = [[CIBank alloc] init];
        
        bank.bankName = (NSString *) keysArray;
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
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:PATH_TO_BANK_DETAILS_PLIST ofType:@"plist"];
    NSDictionary *bankDetailsDict = [NSDictionary dictionaryWithContentsOfFile:dataPath];
    NSEnumerator *enumerator = [banks objectEnumerator];
    
    for (NSArray *keysArray in bankDetailsDict) {
        NSDictionary *values = [bankDetailsDict objectForKey:keysArray];
        
        CIBank *bank = [enumerator nextObject];
        
        bank.bankName = [values objectForKey:@"bankName"];
        bank.address = [values objectForKey:@"address"];
        bank.site = [values objectForKey:@"site"];
        //bank._mapURL = [values objectForKey:@"_mapURL"];
        bank.phoneNumber = [values objectForKey:@"phoneNumber"];
        bank.monThuWorkTime = [values objectForKey:@"monThuWorkTime"];
        bank.friWorkTime = [values objectForKey:@"friWorkTime"];
    }
    
    //NSLog(bankDetailsDict);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
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
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
