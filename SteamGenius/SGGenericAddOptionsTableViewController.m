//
//  SGGenericOptionsTableViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/25/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "AppDelegate.h"
#import "SGGenericAddOptionsTableViewController.h"
#import "SGOpponentFormViewController.h"

#define IDIOM   UI_USER_INTERFACE_IDIOM()
#define IPHONE  UIUserInterfaceIdiomPhone

@interface SGGenericAddOptionsTableViewController ()

@end

@implementation SGGenericAddOptionsTableViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.title = self.field.title;
    UIBarButtonItem *addOption = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addObject:)];
    self.navigationItem.rightBarButtonItem = addOption;
    
    [self updateTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation Methods

- (void)addObject:(id)sender {
    NSString *viewController = [NSString stringWithFormat:@"SG%@FormViewController", NSStringFromClass(self.field.valueClass)];
    [self.navigationController pushViewController:[[NSClassFromString(viewController) alloc] init] animated:YES];
}

- (void)handleLongPress:(SGLongPressTableViewCell *)cell
{
    id obj = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    
    NSString *viewController = [NSString stringWithFormat:@"SG%@FormViewController", NSStringFromClass(self.field.valueClass)];
    id EditViewController = [[NSClassFromString(viewController) alloc] init];
    if ([EditViewController respondsToSelector:@selector(object)]) {
        [EditViewController setObject:obj];
    }
    [self.navigationController pushViewController:EditViewController animated:YES];
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
    static NSString *CellIdentifier = @"Cell";
    SGLongPressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SGLongPressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.text = [obj valueForKey:@"name"];
    
    if ([obj respondsToSelector:@selector(date)]) {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:[obj valueForKey:@"date"]
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        SEL tournament = NSSelectorFromString(@"isTournament");
        if ([obj respondsToSelector:tournament]) {
            NSString *tourneyString = [[obj valueForKey:@"isTournament"] boolValue] ? @"TOURNAMENT" : nil;
            if (tourneyString) {
                dateString = [NSString stringWithFormat:@"%@ — %@", dateString, tourneyString];
            }
        }
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.text = dateString;
    }
    
    FXFormController *form = self.field.form;
    NSManagedObject *current = [form valueForKey:self.field.key] ? (NSManagedObject *)[form valueForKey:self.field.key] : nil;
    cell.accessoryType = current == obj ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    FXFormController *form = self.field.form;
    [form setValue:obj forKey:self.field.key];
    
    if (self.field.action) self.field.action(self);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSString *message;
        if ([obj respondsToSelector:@selector(battles)]) {
            NSUInteger associatedBattles = [[obj valueForKey:@"battles"] count];
            message = associatedBattles > 0 ? [NSString stringWithFormat:@"Are you sure you want to delete the %@, %@? %@ is associated with %lu battles.", NSStringFromClass(self.field.valueClass), [obj valueForKey:@"name"], [obj valueForKey:@"name"], (unsigned long)associatedBattles] : [NSString stringWithFormat:@"Are you sure you want to delete the %@, %@? %@ is not associated with any battles.", NSStringFromClass(self.field.valueClass), [obj valueForKey:@"name"], [obj valueForKey:@"name"]];
        } else {
            message = [NSString stringWithFormat:@"Are you sure you want to delete the %@, %@?", NSStringFromClass(self.field.valueClass), [obj valueForKey:@"name"]];
        }
        
        UIAlertController *alert;
        if (IDIOM == IPHONE) {
            alert = [UIAlertController alertControllerWithTitle:@"Confirm delete" message:message preferredStyle:UIAlertControllerStyleActionSheet];
        } else {
            alert = [UIAlertController alertControllerWithTitle:@"Confirm delete" message:message preferredStyle:UIAlertControllerStyleAlert];
        }
        [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            [[self.fetchedResultsController managedObjectContext] deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            [self.appDelegate saveContext];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass(self.field.valueClass) inManagedObjectContext:[self.appDelegate managedObjectContext]]];
    
    NSSortDescriptor *sortName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
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
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
    [self updateTable];
}

#pragma mark - Private Methods

- (void)updateTable {
    if ([self.fetchedResultsController.fetchedObjects count] < 1) {
        UILabel *empty = [[UILabel alloc] init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"No %@s found.", self.field.valueClass]
                                                                         attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:1],
                                                                                      NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:25.f],
                                                                                      NSTextEffectAttributeName: NSTextEffectLetterpressStyle}];
        empty.attributedText = attrString;
        empty.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = empty;
        
    } else {
        self.tableView.backgroundView = nil;
    }
}

@end
