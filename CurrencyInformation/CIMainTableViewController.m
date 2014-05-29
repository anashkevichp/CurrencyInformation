//
//  CIMainTableViewController.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 08.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIMainTableViewController.h"
#import "CISellTableViewController.h"
#import "CIBuyTableViewController.h"
#import "CIBank.h"
#import "AFNetworking.h"

static NSString * const BaseURLString = @"http://wm.shadurin.com/";
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
    
    banks = [NSMutableArray arrayWithCapacity:10];
    
    CIBank *bank = [[CIBank alloc] init];
    bank.bankName = @"Беларусбанк";
    bank.branchBankName = @"Отделение №252";
    bank.bankBuyUSD = 9950;
    bank.bankSellUSD = 10000;
    bank.bankBuyEUR = 13000;
    bank.bankSellEUR = 13030;
    bank.bankBuyRUB = 298;
    bank.bankSellRUB = 310;
    
    [banks addObject:bank];
    
    bank = [[CIBank alloc] init];
    bank.bankName = @"Белинвестбанк";
    bank.branchBankName = @"Головной офис";
    bank.bankBuyUSD = 9950;
    bank.bankSellUSD = 10010;
    bank.bankBuyEUR = 13000;
    bank.bankSellEUR = 13030;
    bank.bankBuyRUB = 298;
    bank.bankSellRUB = 310;
    [banks addObject:bank];
    
    bank = [[CIBank alloc] init];
    bank.bankName = @"Беларусбанк";
    bank.branchBankName = @"Отделение №123";
    bank.bankBuyUSD = 9960;
    bank.bankSellUSD = 10030;
    bank.bankBuyEUR = 13000;
    bank.bankSellEUR = 13030;
    bank.bankBuyRUB = 298;
    bank.bankSellRUB = 310;
    [banks addObject:bank];
    
    bank = [[CIBank alloc] init];
    bank.bankName = @"Белагропромбанк";
    bank.branchBankName = @"Отделение №356";
    bank.bankBuyUSD = 9960;
    bank.bankSellUSD = 10030;
    bank.bankBuyEUR = 13000;
    bank.bankSellEUR = 13030;
    bank.bankBuyRUB = 298;
    bank.bankSellRUB = 310;
    [banks addObject:bank];
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

- (IBAction)btn:(UIButton *)sender {
    
    //networking
    NSString *string = [NSString stringWithFormat:@"%@select.php", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        
        NSArray *data = [responseObject valueForKeyPath:@"\u041c\u043e\u0441\u043a\u0432\u0430-\u041c\u0438\u043d\u0441\u043a \u0411\u0430\u043d\u043a.USD_SELL"];
        NSLog(@"%@", data);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    
    
    

    [operation start];
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MainToRatesSegue"]) {
        UITabBarController *tabBarController = [segue destinationViewController];
        
        CISellTableViewController *sellViewController = [[tabBarController viewControllers] objectAtIndex: 1];
        sellViewController.banks = banks;
        
        CIBuyTableViewController *buyViewController = [[tabBarController viewControllers] objectAtIndex: 0];
        buyViewController.banks = banks;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
