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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
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
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
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
            NSString *urlString = [NSString stringWithFormat:@"http://%@", [self.bank site]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        } else if (row == PHONE_NUMBER_ROW) {
            /*
            NSString *phoneUrl = [NSString stringWithFormat:@"telpromt:%@", [self.bank phoneNumber]];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:phoneUrl]];
            */
        }
    }
    
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}
*/

@end
