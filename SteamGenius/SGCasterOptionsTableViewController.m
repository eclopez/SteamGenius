//
//  SGCasterOptionsTableViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGCasterOptionsTableViewController.h"
#import "Model.h"
#import "Caster.h"

@interface SGCasterOptionsTableViewController ()

@end

@implementation SGCasterOptionsTableViewController

@synthesize faction = _faction;

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.faction.name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.faction.casters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CasterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSSortDescriptor *sortShortName = [[NSSortDescriptor alloc] initWithKey:@"model.shortName" ascending:YES];
    NSSortDescriptor *sortIncarnation = [[NSSortDescriptor alloc] initWithKey:@"model.incarnation" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortShortName, sortIncarnation, nil];
    NSArray *casters = [[self.faction.casters allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    Caster *caster = [casters objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.text = caster.model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSSortDescriptor *sortShortName = [[NSSortDescriptor alloc] initWithKey:@"model.shortName" ascending:YES];
    NSSortDescriptor *sortIncarnation = [[NSSortDescriptor alloc] initWithKey:@"model.incarnation" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortShortName, sortIncarnation, nil];
    NSArray *casters = [[self.faction.casters allObjects] sortedArrayUsingDescriptors:sortDescriptors];

    self.field.value = ((Caster *)[casters objectAtIndex:indexPath.row]);
    [self.navigationController popToRootViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

@end
