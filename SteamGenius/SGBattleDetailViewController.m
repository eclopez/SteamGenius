//
//  SGBattleDetailViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 12/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleDetailViewController.h"
#import "SGBattleFormViewController.h"
#import "SGEmptyView.h"
#import "AppDelegate.h"
#import "Model.h"
#import "Caster.h"
#import "Opponent.h"
#import "Scenario.h"
#import "Event.h"
#import "Result.h"

#define kEmptyTableMessage @"No battle selected."

@interface SGBattleDetailViewController ()

@end

@implementation SGBattleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self configureView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBattleUpdate:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:[_appDelegate managedObjectContext]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureView {
    self.title = self.battle ? [NSString stringWithFormat:@"%@%@ vs. %@%@",
                                self.battle.playerCaster.model.shortName,
                                [self.battle.playerCaster.model.incarnation intValue] != 1 ? self.battle.playerCaster.model.incarnation : @"",
                                self.battle.opponentCaster.model.shortName,
                                [self.battle.opponentCaster.model.incarnation intValue] != 1 ? self.battle.opponentCaster.model.incarnation : @""] :
    @"Battle Detail";
    
    self.tableView.backgroundView = self.battle == nil ? [[SGEmptyView alloc] initWithFrame:self.tableView.bounds message:kEmptyTableMessage textColor:[UIColor blackColor]] : nil;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.battle ? 5 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 3;
        case 3:
            return 4;
        case 4:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SGBattleInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isEmptyData = NO;
    
    switch(indexPath.section) {
        case 0:
            
            switch(indexPath.row) {
                case 0:
                    cell.textLabel.text = self.battle.playerCaster.model.name;
                    break;
            }
            
            break;
            
        case 1:
            
            switch(indexPath.row) {
                case 0:
                    cell.textLabel.text = self.battle.opponentCaster.model.name;
                    break;
                case 1:
                    cell.textLabel.text = self.battle.opponent ? self.battle.opponent.name : @"No opponent";
                    if (!self.battle.opponent) {
                        isEmptyData = YES;
                    }
                    break;
            }
            
            break;
            
        case 2:
            
            switch(indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSDateFormatter localizedStringFromDate:self.battle.date
                                                                         dateStyle:NSDateFormatterMediumStyle
                                                                         timeStyle:NSDateFormatterNoStyle];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ points", [self.battle.points stringValue]];
                    break;
                case 2:
                    cell.textLabel.text = self.battle.result.name;
                    break;
            }
            
            break;
            
        case 3:
            
            switch(indexPath.row) {
                case 0:
                cell.textLabel.text = [self.battle.mark3 boolValue] ? @"Mark 3" : @"Mark 2";
                  break;
                case 1:
                    cell.textLabel.text = self.battle.killPoints ? [NSString stringWithFormat:@"%@ kill points", [self.battle.killPoints stringValue]] : @"No kill points entered";
                    if (!self.battle.killPoints) {
                        isEmptyData = YES;
                    }
                    break;
                case 2:
                    cell.textLabel.text = self.battle.scenario ? self.battle.scenario.name : @"No scenario selected";
                    if (!self.battle.scenario) {
                        isEmptyData = YES;
                    }
                    break;
                case 3:
                    cell.textLabel.text = self.battle.controlPoints ? [NSString stringWithFormat:@"%@ control points", [self.battle.controlPoints stringValue]] : @"No control points entered";
                    if (!self.battle.controlPoints) {
                        isEmptyData = YES;
                    }
                    break;
                case 4:
                    cell.textLabel.text = self.battle.opponentControlPoints ? [NSString stringWithFormat:@"%@ opponent control points", [self.battle.opponentControlPoints stringValue]] : @"No opponent control points entered";
                    if (!self.battle.opponentControlPoints) {
                        isEmptyData = YES;
                    }
                    break;
                case 5:
                    cell.textLabel.text = self.battle.event ? self.battle.event.name : @"No event selected";
                    if (!self.battle.event) {
                        isEmptyData = YES;
                    }
                    break;
            }
            
            break;
            
        case 4:
            
            switch(indexPath.row) {
                case 0:
                    cell.textLabel.text = self.battle.notes;
            }
            
            break;
    }
    
    if (isEmptyData) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:16.f];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.f];
    }
    
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return @"Your caster";
        case 1:
            return @"Your opponent";
        case 2:
            return @"Required";
        case 3:
            return @"Optional";
        case 4:
            return @"Notes";
        default:
            return 0;
    }
}

#pragma mark - Data Methods

- (void)handleBattleUpdate:(NSNotification *)notification {
    NSSet *updatedObjects = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
    NSSet *deletedObjects = [[notification userInfo] objectForKey:NSDeletedObjectsKey];
    
    NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject == self.battle;
    }];
    NSSet *battleUpdated = [updatedObjects filteredSetUsingPredicate:pred];
    NSSet *battleDeleted = [deletedObjects filteredSetUsingPredicate:pred];
    
    if ([battleUpdated count] > 0) {
        [self configureView];
        [_tableView reloadData];
    }
    
    if ([battleDeleted count] > 0) {
        self.battle = nil;
        [self configureView];
        [_tableView reloadData];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editBattle"]) {
        SGBattleFormViewController *formViewController = (SGBattleFormViewController *)[(UINavigationController *)[segue destinationViewController] topViewController];
        formViewController.battle = self.battle;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"editBattle"]) {
        if (!self.battle) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No battle selected." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        else {
            return YES;
        }
    }
    return YES;
}

@end
