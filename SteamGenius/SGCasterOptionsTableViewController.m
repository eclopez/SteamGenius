//
//  SGCasterOptionsTableViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGCasterOptionsTableViewController.h"
#import "AppDelegate.h"
#import "Caster.h"
#import "Model.h"
#import "SGGenericRepository.h"

@interface SGCasterOptionsTableViewController ()

@end

@implementation SGCasterOptionsTableViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.faction.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Caster *caster = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.text = caster.model.name;
    
    FXFormController *form = self.field.form;
    Caster *currentCaster = [form valueForKey:self.field.key] ? (Caster *)[form valueForKey:self.field.key] : nil;
    cell.accessoryType = currentCaster == caster ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Caster *caster = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    FXFormController *form = self.field.form;
    [form setValue:caster forKey:self.field.key];
    
    if (self.field.action) self.field.action(self);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Caster" inManagedObjectContext:[appDelegate managedObjectContext]]];
    
    NSSortDescriptor *sortShortName = [[NSSortDescriptor alloc] initWithKey:@"model.shortName" ascending:YES];
    NSSortDescriptor *sortIncarnation = [[NSSortDescriptor alloc] initWithKey:@"model.incarnation" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortShortName, sortIncarnation]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"faction = %@", self.faction];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[appDelegate managedObjectContext] sectionNameKeyPath:@"model.shortName" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        #warning Handle this error.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - Class Methods

- (NSArray *)sortedCastersArray {
    NSSortDescriptor *sortShortName = [[NSSortDescriptor alloc] initWithKey:@"model.shortName" ascending:YES];
    NSSortDescriptor *sortIncarnation = [[NSSortDescriptor alloc] initWithKey:@"model.incarnation" ascending:YES];
    return [self.faction.casters sortedArrayUsingDescriptors:@[sortShortName, sortIncarnation]];
}

- (NSArray *)sortedCasterShortNamesArray {
    return [[[self sortedCastersArray] valueForKeyPath:@"@distinctUnionOfObjects.model.shortName"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

@end
