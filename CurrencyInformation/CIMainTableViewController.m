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

@interface CIMainTableViewController ()

@end

@implementation CIMainTableViewController {
    NSMutableArray *banks;
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
    
    /*              *** start networking ***              */
    
    NSURL *url = [NSURL URLWithString:JSON_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        banks = [NSMutableArray arrayWithCapacity:10];
        CIBank *bank;
        NSDictionary *dict = (NSDictionary *) responseObject;
        
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
        
        #warning need to reload active view controller!
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
    
    /*                *** end networking ***              */
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 3;
}

- (IBAction)Slider:(id)sender {
    UISlider* Slider = sender;
    _sliderValue = (Slider.value * 1000);
    self.rangeSlider.text = [NSString stringWithFormat:@"%i м", _sliderValue];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_sliderValue forKey:@"_sliderValue"];
    NSLog(@"value = %ld", (long)[userDefaults integerForKey:@"_sliderValue"]);
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
        sellViewController.banks = banks;
        
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
        buyViewController.banks = banks;
        
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
