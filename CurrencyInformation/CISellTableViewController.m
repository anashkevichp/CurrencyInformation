//
//  CISellTableViewController.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 01.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CISellTableViewController.h"
#import "CICurrencyTableViewCell.h"
#import "CIBankDetailTableViewController.h"
#import "CICurrencyRate.h"

#define USD_SEGMENT 0
#define EUR_SEGMENT 1
#define RUB_SEGMENT 2

@interface CISellTableViewController ()

@end

@implementation CISellTableViewController {
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (IBAction)SellSegmented:(id)sender
{
    UISegmentedControl* control = sender;
    switch (control.selectedSegmentIndex) {
            
        case USD_SEGMENT:
            
            [self.currencyRates sortUsingComparator:^NSComparisonResult(CICurrencyRate *bank1, CICurrencyRate *bank2) {
                NSInteger rate1 = bank1.bankSellUSD;
                NSInteger rate2 = bank2.bankSellUSD;
                if (rate1 > rate2) {
                    return NSOrderedDescending;
                } else if (rate1 < rate2) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedSame;
                }
            }];
            break;
        case EUR_SEGMENT:
            
            [self.currencyRates sortUsingComparator:^NSComparisonResult(CICurrencyRate *bank1, CICurrencyRate *bank2) {
                NSInteger rate1 = bank1.bankSellEUR;
                NSInteger rate2 = bank2.bankSellEUR;
                if (rate1 > rate2) {
                    return NSOrderedDescending;
                } else if (rate1 < rate2) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedSame;
                }
            }];
            break;
        case RUB_SEGMENT:
            
            [self.currencyRates sortUsingComparator:^NSComparisonResult(CICurrencyRate *bank1, CICurrencyRate *bank2) {
                double rate1 = bank1.bankSellRUB;
                double rate2 = bank2.bankSellRUB;
                if (rate1 > rate2) {
                    return NSOrderedDescending;
                } else if (rate1 < rate2) {
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currencyRates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"CurrencyRateCell";
    CICurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil) {
        cell = [[CICurrencyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    long row = [indexPath row];
    CICurrencyRate *bank = [self.currencyRates objectAtIndex:row];
    
    NSString *bankName = [[self.bankDetails objectForKey:[bank _key]] objectForKey:@"bankName"];
    cell.bankNameLabel.text = bankName;
    
    switch (_segmentIndex) {
        case USD_SEGMENT:
            cell.currencyRateLabel.text = [NSString stringWithFormat: @"%i", bank.bankSellUSD];
            break;
        case EUR_SEGMENT:
            cell.currencyRateLabel.text = [NSString stringWithFormat: @"%i", bank.bankSellEUR];
            break;
        case RUB_SEGMENT:
            cell.currencyRateLabel.text = [NSString stringWithFormat: @"%.1f", bank.bankSellRUB];
            break;
    }

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SellToDetailSegue"]) {
        CIBankDetailTableViewController *detail = [segue destinationViewController];
        
        NSInteger selected = [[self.tableView indexPathForSelectedRow] row];
        NSString *bankKey = [[self.currencyRates objectAtIndex:selected] _key];
        
        NSDictionary *detailDict = [self.bankDetails objectForKey:bankKey];
        
        detail.bankDetailsDict = detailDict;
    }
}

@end
