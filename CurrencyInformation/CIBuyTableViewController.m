//
//  CIBuyTableViewController.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 09.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIBuyTableViewController.h"
#import "CICurrencyTableViewCell.h"
#import "CIBank.h"

@interface CIBuyTableViewController ()

@end

@implementation CIBuyTableViewController

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
- (IBAction)BuySegmented:(id)sender {
    UISegmentedControl* control = sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            __buyType = 0;
            [self.tableView reloadData];
            break;
        case 1:
            __buyType = 1;
            [self.tableView reloadData];
            break;
        case 2:
            __buyType = 2;
            [self.tableView reloadData];
            break;
            
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.banks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CurrencyRateCell";
    CICurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil) {
        cell = [[CICurrencyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    long row = [indexPath row];
    CIBank *bank = [self.banks objectAtIndex:row];
    
    if(__buyType == 0){
        cell.bankNameLabel.text = bank.bankName;
        cell.branchBankNameLabel.text = bank.branchBankName;
        cell.currencyRateLabel.text = [NSString stringWithFormat: @"%i", bank.bankBuyUSD];
    }
    else if(__buyType == 1){
        cell.bankNameLabel.text = bank.bankName;
        cell.branchBankNameLabel.text = bank.branchBankName;
        cell.currencyRateLabel.text = [NSString stringWithFormat: @"%i", bank.bankBuyEUR];
    }
    else if(__buyType == 2){
        cell.bankNameLabel.text = bank.bankName;
        cell.branchBankNameLabel.text = bank.branchBankName;
        cell.currencyRateLabel.text = [NSString stringWithFormat: @"%i", bank.bankBuyRUB];
    }
    
    return cell;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
