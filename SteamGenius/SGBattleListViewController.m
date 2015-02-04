//
//  SGBattleListViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 10/2/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleListViewController.h"
#import "SGSettingsManager.h"
#import "SGBattleDetailViewController.h"
#import "SGBattleInfoCell.h"
#import "Faction.h"
#import "Battle.h"
#import "Caster.h"
#import "Model.h"
#import "Result.h"
#import "SGGenericRepository.h"
#import "BattleFilter.h"
#import "SGEmptyView.h"

#define kEmptyTableMessage @"No battles found."

@interface SGBattleListViewController ()

@end

@implementation SGBattleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIEdgeInsets battleTableInsets = UIEdgeInsetsMake(35.f, 0, 0, 0);
    self.tableView.contentInset = battleTableInsets;
    self.tableView.scrollIndicatorInsets = battleTableInsets;
    
    self.recordViewBackgroundImage.image = [UIImage imageNamed:@"RecordBar"];
    
    [self updateRecord];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBattleListUpdate:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:[self.appDelegate managedObjectContext]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = [SGSettingsManager getBarColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SGBattleInfoCell";
    SGBattleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    [cell setNeedsDisplay];
    return cell;
}

- (void)configureCell:(SGBattleInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Battle *battle = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDictionary *attr = @{NSShadowAttributeName:[self getTextShadow]};
    
    switch ([battle.result.winValue intValue]) {
        case 1: {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BattleBarWin"]];
            [self removeLabelShadow:cell.pointsHeader];
            [self removeLabelShadow:cell.pointsLabel];
            [self removeLabelShadow:cell.resultHeader];
            [self removeLabelShadow:cell.resultNameLabel];
            cell.pointsLine.backgroundColor = [UIColor blackColor];
            cell.resultLine.backgroundColor = [UIColor blackColor];
        }
            break;
        case 0:
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BattleBarDraw"]];
            [self addLabelShadow:cell.pointsHeader];
            [self addLabelShadow:cell.pointsLabel];
            [self addLabelShadow:cell.resultHeader];
            [self addLabelShadow:cell.resultNameLabel];
            cell.pointsLine.backgroundColor = [UIColor whiteColor];
            cell.resultLine.backgroundColor = [UIColor whiteColor];
            break;
        case -1:
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BattleBarLoss"]];
            [self addLabelShadow:cell.pointsHeader];
            [self addLabelShadow:cell.pointsLabel];
            [self addLabelShadow:cell.resultHeader];
            [self addLabelShadow:cell.resultNameLabel];
            cell.pointsLine.backgroundColor = [UIColor whiteColor];
            cell.resultLine.backgroundColor = [UIColor whiteColor];
            break;
            break;
    }
    
    // Opponent caster name
    NSMutableString *oCasterName = [NSMutableString stringWithString:battle.opponentCaster.model.name];
    NSRange oCasterLineBreak = [oCasterName rangeOfString:@", "];
    NSMutableAttributedString *fullOpponentCasterName;
    NSMutableParagraphStyle *opponentStyle = [[NSMutableParagraphStyle alloc] init];
    opponentStyle.maximumLineHeight = 15.f;
    if (oCasterLineBreak.location != NSNotFound) {
        NSString *name = [NSString stringWithString:[oCasterName substringToIndex:oCasterLineBreak.location]];
        NSString *title = [NSString stringWithString:[[oCasterName substringFromIndex:oCasterLineBreak.location + 2] uppercaseString]];
        fullOpponentCasterName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", name, title]
                                                                        attributes:attr];
        [fullOpponentCasterName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura" size:8.f] range:NSMakeRange(name.length + 1, title.length)];
        [fullOpponentCasterName addAttribute:NSParagraphStyleAttributeName value:opponentStyle range:NSMakeRange(0, name.length - 1)];
        [fullOpponentCasterName replaceCharactersInRange:NSMakeRange(name.length, 1) withString:@"\n"];
    } else {
        fullOpponentCasterName = [[NSMutableAttributedString alloc] initWithString:oCasterName
                                                                        attributes:attr];
        [fullOpponentCasterName addAttribute:NSParagraphStyleAttributeName value:opponentStyle range:NSMakeRange(0, fullOpponentCasterName.length - 1)];
    }
    cell.opponentCasterName.attributedText = fullOpponentCasterName;
    cell.opponentFactionColor.backgroundColor = (UIColor *)battle.opponentCaster.faction.color;
    cell.opponentFactionColor.layer.cornerRadius = cell.opponentFactionColor.bounds.size.width / 2.f;
    cell.opponentFactionColor.layer.borderWidth = 1.f;
    cell.opponentFactionColor.layer.borderColor = [UIColor blackColor].CGColor;
    
    // Player caster name
    NSMutableString *pCasterName = [NSMutableString stringWithString:battle.playerCaster.model.name];
    NSRange pCasterLineBreak = [pCasterName rangeOfString:@", "];
    NSMutableAttributedString *fullPlayerCasterName;
    NSMutableParagraphStyle *playerStyle = [[NSMutableParagraphStyle alloc] init];
    playerStyle.maximumLineHeight = 13.f;
    if (pCasterLineBreak.location != NSNotFound) {
        NSString *name = [NSString stringWithString:[pCasterName substringToIndex:pCasterLineBreak.location]];
        NSString *title = [NSString stringWithString:[[pCasterName substringFromIndex:pCasterLineBreak.location + 2] uppercaseString]];
        fullPlayerCasterName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", name, title]
                                                                      attributes:attr];
        [fullPlayerCasterName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura" size:7.f] range:NSMakeRange(name.length + 1, title.length)];
        [fullPlayerCasterName addAttribute:NSParagraphStyleAttributeName value:playerStyle range:NSMakeRange(0, name.length - 1)];
        [fullPlayerCasterName replaceCharactersInRange:NSMakeRange(name.length, 1) withString:@"\n"];
    } else {
        fullPlayerCasterName = [[NSMutableAttributedString alloc] initWithString:pCasterName
                                                                      attributes:attr];
        [fullPlayerCasterName addAttribute:NSParagraphStyleAttributeName value:playerStyle range:NSMakeRange(0, fullPlayerCasterName.length - 1)];
    }
    cell.playerCasterName.attributedText = fullPlayerCasterName;
    cell.playerFactionColor.backgroundColor = (UIColor *)battle.playerCaster.faction.color;
    cell.playerFactionColor.layer.cornerRadius = cell.playerFactionColor.bounds.size.width / 2.f;
    cell.playerFactionColor.layer.borderWidth = 1.f;
    cell.playerFactionColor.layer.borderColor = [UIColor blackColor].CGColor;
    
    cell.dateLabel.text = [[self getDateFormatter] stringFromDate:battle.date];
    cell.resultNameLabel.text = battle.result.name;
    cell.pointsLabel.text = [battle.points stringValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.f;
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
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Battle" inManagedObjectContext:[self.appDelegate managedObjectContext]]];
    
    NSSortDescriptor *sortDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSSortDescriptor *sortPoints = [[NSSortDescriptor alloc] initWithKey:@"points" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDate, sortPoints]];
    
    //STORED FILTERS
    NSArray *storedFilters = [SGGenericRepository findAllEntitiesOfType:@"BattleFilter" context:[self.appDelegate managedObjectContext]];
    if ([storedFilters count] > 0) {
        NSMutableArray *predicates = [NSMutableArray array];
        for (BattleFilter *filter in storedFilters) {
            [predicates addObject:(NSComparisonPredicate *)filter.predicate];
        }
        NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        [fetchRequest setPredicate:compoundPredicate];
    }
    // END STORED FILTERS
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self.appDelegate managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    // Fetch the data
    [self fetchResults];
    return _fetchedResultsController;
}

#pragma mark - Fetched Results Controller Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self updateRecord];
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
            //[self configureCell:(SGBattleInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            break;
    }
}

#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SGBattleDetailViewController *controller = (SGBattleDetailViewController *)[(UINavigationController *)[segue destinationViewController] topViewController];
        controller.battle = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        controller.navigationItem.leftBarButtonItem = [self.splitViewController displayModeButtonItem];
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Display Methods

- (NSShadow *)getTextShadow {
    NSShadow *textShadow = [[NSShadow alloc] init];
    textShadow.shadowColor = [UIColor blackColor];
    textShadow.shadowBlurRadius = 2.f;
    textShadow.shadowOffset = CGSizeMake(0, 1.f);
    return textShadow;
}

- (void)removeLabelShadow:(UILabel *)label {
    label.layer.shadowOpacity = 0;
    label.layer.shadowRadius = 0;
    label.layer.shadowOffset = CGSizeZero;
    label.textColor = [UIColor blackColor];
}

- (void)addLabelShadow:(UILabel *)label {
    label.layer.shadowOpacity = 1.f;
    label.layer.shadowRadius = 0;
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 1.f);
    label.textColor = [UIColor whiteColor];
}

- (NSDateFormatter *)getDateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d/yy hh:mm:ss";
    return formatter;
}


#pragma mark - Data Methods

- (void)handleBattleListUpdate:(NSNotification *)notification {
    NSSet *insertedObjects = [[notification userInfo] objectForKey:NSInsertedObjectsKey];
    NSSet *updatedObjects = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
    NSSet *deletedObjects = [[notification userInfo] objectForKey:NSDeletedObjectsKey];
    
    NSPredicate *filterSearch = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[BattleFilter class]];
    }];
    NSSet *filterInserted = [insertedObjects filteredSetUsingPredicate:filterSearch];
    NSSet *filterDeleted = [deletedObjects filteredSetUsingPredicate:filterSearch];
    
    NSPredicate *battleSearch = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[Battle class]];
    }];
    NSSet *battleUpdated = [updatedObjects filteredSetUsingPredicate:battleSearch];
    
    if ([filterDeleted count] > 0 || [filterInserted count] > 0) {
        [self refetch];
        [self updateRecord];
    }
    
    if ([battleUpdated count] > 0) {
        [_tableView reloadData];
    }
}

- (void)refetch {
    self.fetchedResultsController = nil;
    [self fetchResults];
    [self.tableView reloadData];
}

- (void)fetchResults {
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Error in refetch: %@", [error localizedDescription]);
        abort();
    }
}

- (void)updateRecord {
    NSPredicate *wins = [NSPredicate predicateWithFormat:@"result.winValue > %@", @0];
    NSPredicate *draws = [NSPredicate predicateWithFormat:@"result.winValue == %@", @0];
    NSPredicate *losses = [NSPredicate predicateWithFormat:@"result.winValue < %@", @0];
    
    NSUInteger numberOfWins = [[self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:wins] count];
    NSUInteger numberOfDraws = [[self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:draws] count];
    NSUInteger numberOfLosses = [[self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:losses] count];
    NSUInteger numberOfTotal = [self.fetchedResultsController.fetchedObjects count];
    NSUInteger totalBattles = [[SGGenericRepository findAllEntitiesOfType:@"Battle" context:[self.appDelegate managedObjectContext]] count];
    
    self.winTotal.text = [@(numberOfWins) stringValue];
    self.drawTotal.text = [@(numberOfDraws) stringValue];
    self.lossTotal.text = [@(numberOfLosses) stringValue];
    
    
    NSString *filteredTotalText;
    if (numberOfTotal == totalBattles) {
        filteredTotalText = totalBattles != 1 ? [NSString stringWithFormat:@"%@ battles", [@(totalBattles) stringValue]] : [NSString stringWithFormat:@"%@ battle", [@(totalBattles) stringValue]];
    } else {
        filteredTotalText = totalBattles != 1 ? [NSString stringWithFormat:@"%@ (of %@ battles)", [@(numberOfTotal) stringValue], [@(totalBattles) stringValue]] : [NSString stringWithFormat:@"%@ (of %@ battle)", [@(numberOfTotal) stringValue], [@(totalBattles) stringValue]];
    }
    self.filteredTotal.attributedText = [[NSAttributedString alloc] initWithString:filteredTotalText
                                                                        attributes:@{NSShadowAttributeName:[self getTextShadow]}];
    
    [self.winTotal sizeToFit];
    [self.drawTotal sizeToFit];
    [self.lossTotal sizeToFit];
    
    [self defineTableViewBackgroundView];
}

- (void)defineTableViewBackgroundView {
    if ([self.fetchedResultsController.fetchedObjects count] < 1) {
        self.tableView.backgroundView = [[SGEmptyView alloc] initWithFrame:self.tableView.bounds message:kEmptyTableMessage textColor:[UIColor whiteColor]];
    }
    else {
        self.tableView.backgroundView = nil;
    }
}

@end