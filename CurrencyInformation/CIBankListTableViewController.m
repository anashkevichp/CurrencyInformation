//
//  CIBankListTableViewController.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 30.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIBankListTableViewController.h"
#import "CIBankDetailTableViewController.h"
#import "CIBank.h"

@interface CIBankListTableViewController ()

@end

@implementation CIBankListTableViewController {
    NSArray *searchResults;
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

- (void)searchThroughData
{
	NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"bankName contains [search] %@", self.searchBar.text];
	searchResults = [self.banks filteredArrayUsingPredicate:resultsPredicate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.tableView) {
		return [self.banks count];
	} else {
		[self searchThroughData];
		return [searchResults count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BankNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
     
	if (tableView == self.tableView) {
		cell.textLabel.text = [self.banks [indexPath.row] bankName];
	} else {
		cell.textLabel.text = [searchResults [indexPath.row] bankName];
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchDisplayController.isActive) {
		[self performSegueWithIdentifier:@"BankNameToDetail" sender:self];
	}
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"BankNameToDetail"]) {
		CIBankDetailTableViewController *detail = [segue destinationViewController];
        NSIndexPath *indexPath = nil;
        
		if ([self.searchDisplayController isActive]) {
			indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForSelectedRow];
			detail.bank = searchResults[indexPath.row];
		} else {
			indexPath = [self.tableView indexPathForSelectedRow];
			detail.bank = self.banks [indexPath.row];
		}
	}
}

@end
