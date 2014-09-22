//
//  SGFactionOptionsTableViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGFactionOptionsTableViewController.h"
#import "Game.h"
#import "Faction.h"
#import "SGCasterOptionsTableViewController.h"
#import "SGResizableImageViewCell.h"

@interface SGFactionOptionsTableViewController ()

@end

@implementation SGFactionOptionsTableViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Factions";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 52.f, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.field.optionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((Game *)[self.field optionAtIndex:section]).factions.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((Game *)[self.field optionAtIndex:section]).name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"FactionCell";
    SGResizableImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[SGResizableImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.imageViewFrame = CGRectMake(10.f, 6.f, 32.f, 32.f);
    }
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"releaseOrder" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sort, nil];
    NSArray *factions = [[((Game *)[self.field optionAtIndex:indexPath.section]).factions allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    Faction *faction = [factions objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.text = faction.name;
    cell.imageView.image = [UIImage imageNamed:faction.imageName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SGCasterOptionsTableViewController *subController = [[SGCasterOptionsTableViewController alloc] init];
    subController.field = self.field;
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"releaseOrder" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sort, nil];
    NSArray *factions = [[((Game *)[self.field optionAtIndex:indexPath.section]).factions allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    subController.faction = [factions objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:subController animated:YES];
    
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

@end
