//
//  SGStatsViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 7/5/16.
//  Copyright © 2016 Erik Lopez. All rights reserved.
//

#import "SGStatsViewController.h"

@interface SGStatsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SGStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"Battle" inManagedObjectContext:[_appDelegate managedObjectContext]]];
  
  NSSortDescriptor *sortDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
  NSSortDescriptor *sortPoints = [[NSSortDescriptor alloc] initWithKey:@"points" ascending:YES];
  [fetchRequest setSortDescriptors:@[sortDate, sortPoints]];
  
  //STORED FILTERS
  NSPredicate *activeFilterPredicate = [NSPredicate predicateWithFormat:@"isActive = %@", [NSNumber numberWithBool:YES]];
  NSArray *storedFilters = [SGKRepository findAllEntitiesOfType:@"BattleFilter" predicate:activeFilterPredicate context:[_appDelegate managedObjectContext]];
  if ([storedFilters count] > 0) {
    NSMutableArray *predicates = [NSMutableArray array];
    for (BattleFilter *filter in storedFilters) {
      [predicates addObject:(NSComparisonPredicate *)filter.predicate];
    }
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    [fetchRequest setPredicate:compoundPredicate];
  }
  // END STORED FILTERS
  
  NSError *error = nil;
  _battles = [[_appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
  
  _playerCasters = [self getNumberOfBattlesByCaster:YES];
  _opponentCasters = [self getNumberOfBattlesByCaster:NO];
  [_tableView reloadData];
}

- (NSMutableOrderedSet *)getNumberOfBattlesByCaster:(BOOL)player {
  static NSComparator battleCompare = ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    NSString *key1 = [[(NSDictionary *)obj1 allKeys] firstObject];
    NSString *key2 = [[(NSDictionary *)obj2 allKeys] firstObject];
    
    return [obj1 valueForKey:key1] < [obj2 valueForKey:key2];
  };
  
  NSMutableOrderedSet *casters = [[NSMutableOrderedSet alloc] init];
  for (Battle *b in _battles) {
    NSString *name = player ? b.playerCaster.model.name : b.opponentCaster.model.name;
    NSPredicate *predicate = player ? [NSPredicate predicateWithFormat:@"playerCaster.model.name = %@", name] : [NSPredicate predicateWithFormat:@"opponentCaster.model.name = %@", name];
    NSUInteger battleCountByCaster = [[_battles filteredArrayUsingPredicate:predicate] count];
    
    [casters addObject:@{ name:[NSNumber numberWithInteger:battleCountByCaster] }];
  }
  [casters sortUsingComparator:battleCompare];
  
  return casters;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    NSLog(@"Player: %lu", _playerCasters.count);
    return [_playerCasters count];
  } else {
    NSLog(@"Opponents: %lu", _playerCasters.count);
    return [_opponentCasters count];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"StatsCell";
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  cell.textLabel.text = @"Hi";
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"My casters";
  } else {
    return @"Enemy casters";
  }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//}

//#pragma mark - Fetched Results Controller
//
//- (NSFetchedResultsController *)fetchedResultsController {
//  if (_fetchedResultsController != nil) {
//    return _fetchedResultsController;
//  }
//  
//  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//  [fetchRequest setEntity:[NSEntityDescription entityForName:@"Battle" inManagedObjectContext:[_appDelegate managedObjectContext]]];
//  
//  NSSortDescriptor *sortDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
//  NSSortDescriptor *sortPoints = [[NSSortDescriptor alloc] initWithKey:@"points" ascending:YES];
//  [fetchRequest setSortDescriptors:@[sortDate, sortPoints]];
//  
//  //STORED FILTERS
//  NSPredicate *activeFilterPredicate = [NSPredicate predicateWithFormat:@"isActive = %@", [NSNumber numberWithBool:YES]];
//  NSArray *storedFilters = [SGKRepository findAllEntitiesOfType:@"BattleFilter" predicate:activeFilterPredicate context:[_appDelegate managedObjectContext]];
//  if ([storedFilters count] > 0) {
//    NSMutableArray *predicates = [NSMutableArray array];
//    for (BattleFilter *filter in storedFilters) {
//      [predicates addObject:(NSComparisonPredicate *)filter.predicate];
//    }
//    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
//    [fetchRequest setPredicate:compoundPredicate];
//  }
//  // END STORED FILTERS
//  
//  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[_appDelegate managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
//  aFetchedResultsController.delegate = self;
//  _fetchedResultsController = aFetchedResultsController;
//  
//  // Fetch the data
//  [self fetchResults];
//  return _fetchedResultsController;
//}

//#pragma mark - Fetched Results Controller Delegate Methods
//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
////  [self.tableView beginUpdates];
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
////  [self.tableView endUpdates];
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
////  switch(type) {
////    case NSFetchedResultsChangeInsert:
////      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
////      break;
////    case NSFetchedResultsChangeDelete:
////      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
////      break;
////    case NSFetchedResultsChangeMove:
////    case NSFetchedResultsChangeUpdate:
////      break;
////  }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
////  switch (type) {
////    case NSFetchedResultsChangeInsert:
////      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
////      break;
////    case NSFetchedResultsChangeDelete:
////      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
////      break;
////    case NSFetchedResultsChangeUpdate:
////      //[self configureCell:(SGBattleInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
////      break;
////    case NSFetchedResultsChangeMove:
////      break;
////  }
//}
//
//- (void)fetchResults {
//  NSError *error = nil;
//  if (![self.fetchedResultsController performFetch:&error]) {
//#warning Handle this error.
//    NSLog(@"Error in refetch: %@", [error localizedDescription]);
//    abort();
//  }
//}

@end
