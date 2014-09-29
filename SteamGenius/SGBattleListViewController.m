//
//  SGBattleListViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/11/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleListViewController.h"
#import "Battle.h"
#import "Caster.h"
#import "Model.h"
#import "SGBattleCell.h"

@interface SGBattleListViewController ()

@end

@implementation SGBattleListViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.recordView = [[SG_BattleRecordView alloc] initWithFrame:CGRectMake(0, 64.f, 320.f, kRecordViewHeight)];
    //[self.view addSubview:self.recordView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BattleCell";
    SGBattleCell *cell = (SGBattleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[SGBattleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SGBattleCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
    /*static NSString *CellIdentifier = @"BattleCell";
    SG_BattleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SG_BattleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;*/
}

- (void)configureCell:(SGBattleCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Battle *battle = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.battle = battle;
    
    //cell.textLabel.text = battle.playerCaster.model.name;
    
    /*cell.backgroundColor = [UIColor clearColor];
    if ([battle.result.winValue intValue] > 0) {
        cell.backgroundImageView.image = [UIImage imageNamed:@"BattleBarWin"];
    }
    if ([battle.result.winValue intValue] == 0) {
        cell.backgroundImageView.image = [UIImage imageNamed:@"BattleBarDraw"];
    }
    if ([battle.result.winValue intValue] < 0) {
        cell.backgroundImageView.image = [UIImage imageNamed:@"BattleBarLoss"];
    }
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowBlurRadius:2.0f];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowOffset:CGSizeMake(0, 1.0f)];
    
    // Date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"M/d/yy"];
    NSMutableAttributedString *dateAttributed = [[NSMutableAttributedString alloc] initWithString:[dateFormat stringFromDate:battle.date]];
    [dateAttributed addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0]
                           range:NSMakeRange(0, dateAttributed.length)];
    [dateAttributed addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:NSMakeRange(0, dateAttributed.length)];
    [dateAttributed addAttribute:NSShadowAttributeName
                           value:shadow
                           range:NSMakeRange(0, dateAttributed.length)];
    cell.dateLabel.attributedText = dateAttributed;
    
    // Player caster name
    // Opponent caster name
    NSRange firstPlayerSpace = [battle.playerCaster.model.name rangeOfString:@", "];
    NSString *fullPlayerCasterName;
    if (firstPlayerSpace.location != NSNotFound) {
        NSString *name = [battle.playerCaster.model.name substringToIndex:firstPlayerSpace.location];
        NSString *title = [[battle.playerCaster.model.name substringFromIndex:firstPlayerSpace.location + 1] uppercaseString];
        fullPlayerCasterName = [NSString stringWithFormat:@"%@ %@", name, title];
    } else {
        fullPlayerCasterName = battle.playerCaster.model.name;
    }
    NSMutableParagraphStyle *playerStyle = [[NSMutableParagraphStyle alloc] init];
    [playerStyle setMaximumLineHeight:13.f];
    
    NSMutableAttributedString *playerCasterName = [[NSMutableAttributedString alloc] initWithString:fullPlayerCasterName];
    NSUInteger lastPlayerIndex = playerCasterName.length - 1;
    if (firstPlayerSpace.location != NSNotFound) {
        [playerCasterName addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"AvenirNext-Medium" size:12.0]
                                 range:NSMakeRange(0, firstPlayerSpace.location)];
        [playerCasterName addAttribute:NSParagraphStyleAttributeName
                                 value:playerStyle
                                 range:NSMakeRange(0, firstPlayerSpace.location)];
        [playerCasterName addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Futura" size:7.0]
                                 range:NSMakeRange(firstPlayerSpace.location + 1, lastPlayerIndex - firstPlayerSpace.location)];
        [playerCasterName replaceCharactersInRange:firstPlayerSpace withString:@"\n"];
    } else {
        [playerCasterName addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"AvenirNext-Medium" size:12.0]
                                 range:NSMakeRange(0, playerCasterName.length)];
        [playerCasterName addAttribute:NSParagraphStyleAttributeName
                                 value:playerStyle
                                 range:NSMakeRange(0, playerCasterName.length)];
    }
    [playerCasterName addAttribute:NSForegroundColorAttributeName
                             value:[UIColor whiteColor]
                             range:NSMakeRange(0, playerCasterName.length)];
    [playerCasterName addAttribute:NSShadowAttributeName
                             value:shadow
                             range:NSMakeRange(0, playerCasterName.length)];
    
    cell.playerFactionImageView.image = [UIImage imageNamed:battle.playerCaster.faction.imageName];
    cell.playerCasterName.attributedText = playerCasterName;
    
    // Opponent caster name
    NSRange firstOpponentSpace = [battle.opponentCaster.model.name rangeOfString:@", "];
    NSString *fullOpponentCasterName;
    if (firstOpponentSpace.location != NSNotFound) {
        NSString *name = [battle.opponentCaster.model.name substringToIndex:firstOpponentSpace.location];
        NSString *title = [[battle.opponentCaster.model.name substringFromIndex:firstOpponentSpace.location + 1] uppercaseString];
        fullOpponentCasterName = [NSString stringWithFormat:@"%@ %@", name, title];
    } else {
        fullOpponentCasterName = battle.opponentCaster.model.name;
    }
    NSMutableParagraphStyle *opponentStyle = [[NSMutableParagraphStyle alloc] init];
    [opponentStyle setMaximumLineHeight:15.f];
    
    NSMutableAttributedString *opponentCasterName = [[NSMutableAttributedString alloc] initWithString:fullOpponentCasterName];
    NSUInteger lastOpponentIndex = opponentCasterName.length - 1;
    if (firstOpponentSpace.location != NSNotFound) {
        [opponentCasterName addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]
                                   range:NSMakeRange(0, firstOpponentSpace.location)];
        [opponentCasterName addAttribute:NSParagraphStyleAttributeName
                                   value:opponentStyle
                                   range:NSMakeRange(0, firstOpponentSpace.location)];
        [opponentCasterName addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Futura" size:8.0]
                                   range:NSMakeRange(firstOpponentSpace.location + 1, lastOpponentIndex - firstOpponentSpace.location)];
        [opponentCasterName replaceCharactersInRange:firstOpponentSpace withString:@"\n"];
    } else {
        [opponentCasterName addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]
                                   range:NSMakeRange(0, opponentCasterName.length)];
        [opponentCasterName addAttribute:NSParagraphStyleAttributeName
                                   value:opponentStyle
                                   range:NSMakeRange(0, opponentCasterName.length)];
    }
    [opponentCasterName addAttribute:NSForegroundColorAttributeName
                               value:[UIColor whiteColor]
                               range:NSMakeRange(0, opponentCasterName.length)];
    [opponentCasterName addAttribute:NSShadowAttributeName
                               value:shadow
                               range:NSMakeRange(0, opponentCasterName.length)];
    
    cell.opponentFactionImageView.image = [UIImage imageNamed:battle.opponentCaster.faction.imageName];
    cell.opponentCasterName.attributedText = opponentCasterName;*/
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[self.fetchedResultsController managedObjectContext] deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [self.appDelegate saveContext];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*UINavigationController *editBattle = [[UINavigationController alloc] initWithRootViewController:[[SG_BattleFormViewController alloc] initWithStyle:UITableViewStyleGrouped battle:[self.fetchedResultsController objectAtIndexPath:indexPath]]];
    
    [self presentViewController:editBattle animated:YES completion:nil];*/
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Battle" inManagedObjectContext:[self.appDelegate managedObjectContext]]];
    
    NSSortDescriptor *sortName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortName]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self.appDelegate managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - Fetched Results Controller Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            //[self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

@end