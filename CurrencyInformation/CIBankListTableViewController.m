//
//  CIBankListTableViewController.m
//  CurrencyInformation
//
//  Created by Pavel Anashkevich on 30.05.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIBankListTableViewController.h"
#import "CIBank.h"

@interface CIBankListTableViewController ()

@end

@implementation CIBankListTableViewController

- (NSMutableArray *)objects
{
	if (!_objects) {
		_objects = [[NSMutableArray alloc] init];
	}
	
	return _objects;
}

- (NSMutableArray *)results
{
	if (!_results) {
		_results = [[NSMutableArray alloc] init];
	}
	
	return _results;
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
    
    [self.objects addObject:@"YouTube"];
	[self.objects addObject:@"Google"];
	[self.objects addObject:@"Yahoo"];
	[self.objects addObject:@"Apple"];
	[self.objects addObject:@"Amazon"];
	[self.objects addObject:@"Bing"];
	[self.objects addObject:@"Udemy"];
	[self.objects addObject:@"Flickr"];
    
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
	self.results = nil;
	
	NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF contains [search] %@", self.searchBar.text];
	self.results = [[self.objects filteredArrayUsingPredicate:resultsPredicate] mutableCopy];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.tableView) {
		return self.objects.count;
	} else {
		[self searchThroughData];
		return self.results.count;
	}
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return [self.banks count];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BankNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
	if (tableView == self.tableView) {
		cell.textLabel.text = self.objects[indexPath.row];
	} else {
		cell.textLabel.text = self.results[indexPath.row];
	}
    
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankNameCell" forIndexPath:indexPath];
//    cell.textLabel.text = [[self.banks objectAtIndex:[indexPath row]] bankName];
//
//    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchDisplayController.isActive) {
		[self performSegueWithIdentifier:@"ShowDetail" sender:self];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"ShowDetail"]) {
		NSString *object = nil;
		NSIndexPath *indexPath = nil;
		
		if (self.searchDisplayController.isActive) {
			indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForSelectedRow];
			object = self.results[indexPath.row];
		} else {
			indexPath = [self.tableView indexPathForSelectedRow];
			object = self.objects[indexPath.row];
		}
		
		//[[segue destinationViewController] setDetailLabelContents:object];
	}
}


@end
