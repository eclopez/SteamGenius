//
//  SGFactionFilterOptionsTableViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 10/14/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGFactionFilterOptionsTableViewController.h"
#import "Game.h"
#import "Faction.h"
#import "Caster.h"
#import "SGResizableImageViewCell.h"
#import "SGCasterOptionsTableViewController.h"
#import "SGColorCircleView.h"

@interface SGFactionFilterOptionsTableViewController ()

@end

@implementation SGFactionFilterOptionsTableViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Factions";
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 36.f, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.field.optionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((Game *)[self.field optionAtIndex:section]).name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((Game *)[self.field optionAtIndex:section]).factions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FactionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *factions = [self sortedFactionsArray:indexPath.section];
    Faction *faction = [factions objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.text = faction.name;
    cell.accessoryType = UITableViewCellAccessoryNone;
    SGColorCircleView *circle = [[SGColorCircleView alloc] initWithFrame:CGRectMake(10.f, 14.f, 16.f, 16.f)];
    circle.color = (UIColor *)faction.color;
    [cell addSubview:circle];
    
    FXFormController *form = self.field.form;
    Faction *currentFaction = [form valueForKey:self.field.key] ? (Faction *)[form valueForKey:self.field.key] : nil;
    cell.accessoryType = currentFaction == faction ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *factions = [self sortedFactionsArray:indexPath.section];
    Faction *faction = [factions objectAtIndex:indexPath.row];
    
    FXFormController *form = self.field.form;
    [form setValue:faction.name forKey:self.field.key];
    
    if (self.field.action) self.field.action(self);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Class Methods

- (NSArray *)sortedFactionsArray:(NSUInteger)section {
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"releaseOrder" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sort, nil];
    return [[((Game *)[self.field optionAtIndex:section]).factions allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

@end
