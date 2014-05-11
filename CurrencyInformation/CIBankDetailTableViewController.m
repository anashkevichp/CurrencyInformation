//
//  CIBankDetailTableViewController.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 09.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIBankDetailTableViewController.h"
#import "CIBank.h"

#define BANK_NAME_SECTION 0
#define BANK_NAME_ROW 0
#define BRANCH_NAME_ROW 1

#define CONTACT_SECTION 1
#define ADDRESS_ROW 0
#define PHONE_NUMBER_ROW 1

#define WORKTIME_SECTION 2
#define MON_FRI_TIME_ROW 0
#define SAT_TIME_ROW 1
#define SUN_TIME_ROW 2
#define OTHER_TIME_ROW 3

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
            rows = 2;
            break;
        case WORKTIME_SECTION:
            rows = 4;
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
            if (row == BANK_NAME_ROW) {
                cell.textLabel.text = @"Банк:";
                cell.detailTextLabel.text = self.bank.bankName;
            } else if (row == BRANCH_NAME_ROW) {
                cell.textLabel.text = @"Отделение:";
                cell.detailTextLabel.text = self.bank.branchBankName;
            }
            break;
            
        case CONTACT_SECTION:
            if (row == ADDRESS_ROW) {
                cell.textLabel.text = @"Адрес:";
                cell.detailTextLabel.text = self.bank.address;
            } else if (row == PHONE_NUMBER_ROW) {
                cell.textLabel.text = @"Телефон:";
                cell.detailTextLabel.text = self.bank.phoneNumber;
            }
            break;
        
        case WORKTIME_SECTION:
            switch (row) {
                case MON_FRI_TIME_ROW:
                    cell.textLabel.text = @"Пн-Пт:";
                    cell.detailTextLabel.text = self.bank.workTime;
                    break;
                case SAT_TIME_ROW:
                    cell.textLabel.text = @"Сб:";
                    cell.detailTextLabel.text = self.bank.workTime;
                    break;
                case SUN_TIME_ROW:
                    cell.textLabel.text = @"Вс:";
                    cell.detailTextLabel.text = self.bank.workTime;
                    break;
                case OTHER_TIME_ROW:
                    cell.textLabel.text = @"Другое:";
                    cell.detailTextLabel.text = self.bank.workTime;
                    break;
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