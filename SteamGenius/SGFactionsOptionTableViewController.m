//
//  SGFactionsOptionTableViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 2/4/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGFactionsOptionTableViewController.h"
#import "SGColorCircleView.h"
#import "Game.h"
#import "Caster.h"

@interface SGFactionsOptionTableViewController ()

@end

@implementation SGFactionsOptionTableViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)init:(void (^)(UINavigationController *navControlller, FXFormField *field, Faction *faction))selectionHandler
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _selectionHandler = selectionHandler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Factions";
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 36.f, 0, 0);
}

#pragma mark - Class Methods

- (NSArray *)sortedFactionsArray:(NSUInteger)section {
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"releaseOrder" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sort, nil];
    return [[((Game *)[self.field optionAtIndex:section]).factions allObjects] sortedArrayUsingDescriptors:sortDescriptors];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FactionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Faction *faction = [[self sortedFactionsArray:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = faction.name;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    SGColorCircleView *circle = [[SGColorCircleView alloc] initWithFrame:CGRectMake(10.f, 14.f, 16.f, 16.f)];
    circle.color = (UIColor *)faction.color;
    [cell addSubview:circle];
    
    FXFormController *form = self.field.form;
    Faction *currentFaction = [form valueForKey:self.field.key] ? ((Caster *)[form valueForKey:self.field.key]).faction : nil;
    cell.accessoryType = currentFaction == faction ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *factions = [self sortedFactionsArray:indexPath.section];
    Faction *faction = [factions objectAtIndex:indexPath.row];
    
    if (_selectionHandler != nil) {
        _selectionHandler(self.navigationController, self.field, faction);
    } else {
        FXFormController *form = self.field.form;
        [form setValue:faction.name forKey:self.field.key];
        
        if (self.field.action) self.field.action(self);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
