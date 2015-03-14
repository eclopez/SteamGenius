//
//  SGFiltersListViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 12/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGFiltersListViewController.h"
#import "BattleFilter.h"
#import "SGEmptyView.h"

#define kEmptyTableMessage @"No filters found."

@interface SGFiltersListViewController ()

@end

@implementation SGFiltersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self defineTableViewBackgroundView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFilterUpdate:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:[self.appDelegate managedObjectContext]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SGFilterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BattleFilter *battleFilter = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = battleFilter.displayText;
    cell.textLabel.numberOfLines = 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[self.fetchedResultsController managedObjectContext] deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [self.appDelegate saveContext];
    }
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"BattleFilter" inManagedObjectContext:[self.appDelegate managedObjectContext]]];
    
    NSSortDescriptor *sortAlpha = [[NSSortDescriptor alloc] initWithKey:@"displayText" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortAlpha]];
    
    // Create the fetched results controller
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self.appDelegate managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    // Fetch the data
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        #warning Handle this error.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - Fetched Results Controller Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - Private Methods

- (void)handleFilterUpdate:(NSNotification *)notification {
    NSSet *insertedObjects = [[notification userInfo] objectForKey:NSInsertedObjectsKey];
    NSSet *deletedObjects = [[notification userInfo] objectForKey:NSDeletedObjectsKey];
    
    NSPredicate *filterSearch = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[BattleFilter class]];
    }];
    NSSet *filterInserted = [insertedObjects filteredSetUsingPredicate:filterSearch];
    NSSet *filterDeleted = [deletedObjects filteredSetUsingPredicate:filterSearch];
    
    if ([filterDeleted count] > 0 || [filterInserted count] > 0) {
        [self defineTableViewBackgroundView];
    }
}

- (void)defineTableViewBackgroundView {
    if ([self.fetchedResultsController.fetchedObjects count] < 1) {
        self.tableView.backgroundView = [[SGEmptyView alloc] initWithFrame:self.tableView.bounds message:kEmptyTableMessage textColor:[UIColor blackColor]];
    }
    else {
        self.tableView.backgroundView = nil;
    }
}

@end
