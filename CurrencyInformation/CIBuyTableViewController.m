//
//  CIBuyTableViewController.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 09.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIBuyTableViewController.h"
#import "CICurrencyTableViewCell.h"
#import "CIBankDetailTableViewController.h"
#import "CIBank.h"

#define USD_SEGMENT 0
#define EUR_SEGMENT 1
#define RUB_SEGMENT 2

@interface CIBuyTableViewController ()

@end

@implementation CIBuyTableViewController {
    int _segmentIndex;
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
- (IBAction)BuySegmented:(id)sender
{
    UISegmentedControl* control = sender;
    switch (control.selectedSegmentIndex) {
        
        case USD_SEGMENT:
            [self.banks sortUsingComparator:^NSComparisonResult(CIBank *bank1, CIBank *bank2) {
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
            break;
        case EUR_SEGMENT:
            [self.banks sortUsingComparator:^NSComparisonResult(CIBank *bank1, CIBank *bank2) {
                NSInteger rate1 = bank1.bankBuyEUR;
                NSInteger rate2 = bank2.bankBuyEUR;
                if (rate1 < rate2) {
                    return NSOrderedDescending;
                } else if (rate1 > rate2) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedSame;
                }
            }];
            break;
        case RUB_SEGMENT:
            [self.banks sortUsingComparator:^NSComparisonResult(CIBank *bank1, CIBank *bank2) {
                NSInteger rate1 = bank1.bankBuyRUB;
                NSInteger rate2 = bank2.bankBuyRUB;
                if (rate1 < rate2) {
                    return NSOrderedDescending;
                } else if (rate1 > rate2) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedSame;
                }
            }];
            break;
    }
    
    _segmentIndex = control.selectedSegmentIndex;
    [self.tableView reloadData];
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
    
    switch (_segmentIndex) {
        case USD_SEGMENT:
            cell.bankNameLabel.text = bank.bankName;
            cell.branchBankNameLabel.text = bank.branchBankName;
            cell.currencyRateLabel.text = [NSString stringWithFormat: @"%i", bank.bankBuyUSD];
            break;
        case EUR_SEGMENT:
            cell.bankNameLabel.text = bank.bankName;
            cell.branchBankNameLabel.text = bank.branchBankName;
            cell.currencyRateLabel.text = [NSString stringWithFormat: @"%i", bank.bankBuyEUR];
            break;
        case RUB_SEGMENT:
            cell.bankNameLabel.text = bank.bankName;
            cell.branchBankNameLabel.text = bank.branchBankName;
            cell.currencyRateLabel.text = [NSString stringWithFormat: @"%i", bank.bankBuyRUB];
            break;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BuyToDetailSegue"]) {
        CIBankDetailTableViewController *detail = [segue destinationViewController];
        NSInteger selected = [[self.tableView indexPathForSelectedRow] row];
        
        detail.bank = [self.banks objectAtIndex:selected];
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
@end
