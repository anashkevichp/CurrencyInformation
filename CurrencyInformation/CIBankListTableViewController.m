//
//  CIBankListTableViewController.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 30.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIBankListTableViewController.h"
#import "CIBankDetailTableViewController.h"
#import "CICurrencyRate.h"

@interface CIBankListTableViewController ()

@end

@implementation CIBankListTableViewController {
    NSArray *searchResults;
    NSMutableArray *bankDetailsArray;
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
    
    bankDetailsArray = [NSMutableArray arrayWithCapacity:10];
    
    CIBankDetail *bankDetail;
    for (NSDictionary *dict in [self.allBanksDetailsDict allValues]) {
        bankDetail = [[CIBankDetail alloc] init];
        
        bankDetail._key = [[self.allBanksDetailsDict allKeysForObject:dict] lastObject];
        
        bankDetail.bankName = [dict objectForKey:@"bankName"];
        bankDetail.address = [dict objectForKey:@"address"];
        bankDetail.phoneNumber = [dict objectForKey:@"phoneNumber"];
        bankDetail.site = [dict objectForKey:@"site"];
        bankDetail.monThuWorkTime = [dict objectForKey:@"monThuWorkTime"];
        bankDetail.friWorkTime = [dict objectForKey:@"friWorkTime"];
        
        bankDetail._mapLatitude = [[dict objectForKey:@"_mapLatitude"] doubleValue];
        bankDetail._mapLongitude = [[dict objectForKey:@"_mapLongitude"] doubleValue];
        
        [bankDetailsArray addObject:bankDetail];
    }
    
    [bankDetailsArray sortUsingComparator:^NSComparisonResult(CIBankDetail *bank1, CIBankDetail *bank2) {
        return [[bank1 bankName] compare:[bank2 bankName]];
    }];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)searchThroughData
{
	NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"bankName contains [search] %@", self.searchBar.text];
	searchResults = [bankDetailsArray filteredArrayUsingPredicate:resultsPredicate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.tableView) {
		return [bankDetailsArray count];
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
		cell.textLabel.text = [bankDetailsArray [indexPath.row] bankName];
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
        
        NSString *bankKey = [[NSString alloc] init];
        
		if ([self.searchDisplayController isActive]) {
			indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForSelectedRow];
            bankKey = [searchResults[indexPath.row] _key];
		} else {
			indexPath = [self.tableView indexPathForSelectedRow];
            bankKey = [bankDetailsArray[indexPath.row] _key];
		}
        
        detail.bankDetailsDict = [self.allBanksDetailsDict objectForKey:bankKey];
	}
}

@end
