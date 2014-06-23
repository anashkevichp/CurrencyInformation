//
//  CIBankDetailTableViewController.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 09.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIBankDetailTableViewController.h"
#import "CIMapViewController.h"
#import "CIBank.h"

#define BANK_NAME_SECTION 0
#define BANK_NAME_ROW 0
#define BRANCH_NAME_ROW 1

#define CONTACT_SECTION 1
#define PHONE_NUMBER_ROW 0
#define ADDRESS_ROW 1
#define SITE_ROW 2

#define WORKTIME_SECTION 2
#define MON_FRI_TIME_ROW 0
#define SAT_TIME_ROW 1

@interface CIBankDetailTableViewController ()

@end

@implementation CIBankDetailTableViewController

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section) {
        case BANK_NAME_SECTION:
            rows = 2;
            break;
        case CONTACT_SECTION:
            rows = 3;
            break;
        case WORKTIME_SECTION:
            rows = 2;
            break;
        default:
            NSLog(@"section number error");
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    
    long section = [indexPath section];
    long row = [indexPath row];
    
    switch (section) {
        
        case BANK_NAME_SECTION:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (row == BANK_NAME_ROW) {
                cell.textLabel.text = @"Банк:";
                cell.detailTextLabel.text = self.bank.bankName;
            } else if (row == BRANCH_NAME_ROW) {
                cell.textLabel.text = @"Отделение:";
                cell.detailTextLabel.text = @"Головной офис";
            }
            break;
            
        case CONTACT_SECTION:
            if (row == PHONE_NUMBER_ROW) {
                cell.textLabel.text = @"Телефон:";
                cell.detailTextLabel.text = self.bank.phoneNumber;
            } else if (row == ADDRESS_ROW ) {
                cell.textLabel.text = @"Адрес:";
                cell.detailTextLabel.text = self.bank.address;
            } else if (row == SITE_ROW) {
                cell.textLabel.text = @"Сайт:";
                cell.detailTextLabel.text = self.bank.site;
            }
            break;
        
        case WORKTIME_SECTION:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (row == MON_FRI_TIME_ROW) {
                cell.textLabel.text = @"Пн-Чт:";
                cell.detailTextLabel.text = self.bank.monThuWorkTime;
            } else if (row == SAT_TIME_ROW) {
                cell.textLabel.text = @"Пт:";
                cell.detailTextLabel.text = self.bank.friWorkTime;
            }
            break;
    }
     
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case BANK_NAME_SECTION:
            return @"название банка";
        case CONTACT_SECTION:
            return @"контактные данные";
        case WORKTIME_SECTION:
            return @"время работы";
        default:
            return @"";
    }
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    
    if (section == CONTACT_SECTION) {
        if (row == ADDRESS_ROW) {
            CIMapViewController *mapController = [[CIMapViewController alloc] init];
            mapController.address = [self.bank address];
            [self.navigationController pushViewController:mapController animated:YES];
        } else if (row == SITE_ROW) {
            NSString *urlString = [NSString stringWithFormat:@"tel://%@", [self.bank site]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        } else if (row == PHONE_NUMBER_ROW) {
            /*
            NSString *phoneUrl = [NSString stringWithFormat:@"telpromt:%@", [self.bank phoneNumber]];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:phoneUrl]];
            */
        }
    }
    
}

@end
