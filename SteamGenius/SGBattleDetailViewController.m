//
//  SGBattleDetailViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 12/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleDetailViewController.h"
#import "Caster.h"
#import "Model.h"
#import "Opponent.h"
#import "Result.h"
#import "Scenario.h"
#import "Event.h"
#import "SGBattleFormViewController.h"
#import "SGEmptyView.h"

@interface SGBattleDetailViewController ()

@end

@implementation SGBattleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.battle == nil) {
        self.tableView.backgroundView = [[SGEmptyView alloc] initWithFrame:self.view.bounds emptyMessage:@"No battle selected." color:[UIColor blackColor]];
    } else {
        self.tableView.backgroundView = nil;
    }
    [self configureView];
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
    [self.tableView reloadData];
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
    
    cell.userInteractionEnabled = NO;
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.f];
    cell.textLabel.textColor = [UIColor blackColor];
    
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
                        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBoldItalic" size:16.f];
                        cell.textLabel.textColor = [UIColor lightGrayColor];
                    }
                    break;
            }
            
            break;
            
        case 2:
            
            switch(indexPath.row) {
                case 0:
                    cell.textLabel.text = [[self getDateFormatter] stringFromDate:self.battle.date];
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
                    cell.textLabel.text = self.battle.killPoints ? [NSString stringWithFormat:@"%@ kill points", [self.battle.killPoints stringValue]] : @"No kill points entered";
                    if (!self.battle.killPoints) {
                        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBoldItalic" size:16.f];
                        cell.textLabel.textColor = [UIColor lightGrayColor];
                    }
                    break;
                case 1:
                    cell.textLabel.text = self.battle.scenario ? self.battle.scenario.name : @"No scenario selected";
                    if (!self.battle.scenario) {
                        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBoldItalic" size:16.f];
                        cell.textLabel.textColor = [UIColor lightGrayColor];
                    }
                    break;
                case 2:
                    cell.textLabel.text = self.battle.controlPoints ? [NSString stringWithFormat:@"%@ control points", [self.battle.killPoints stringValue]] : @"No control points entered";
                    if (!self.battle.controlPoints) {
                        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBoldItalic" size:16.f];
                        cell.textLabel.textColor = [UIColor lightGrayColor];
                    }
                    break;
                case 3:
                    cell.textLabel.text = self.battle.event ? self.battle.event.name : @"No event selected";
                    if (!self.battle.event) {
                        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBoldItalic" size:16.f];
                        cell.textLabel.textColor = [UIColor lightGrayColor];
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

#pragma mark - UITableViewDelegate Methods

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

#pragma mark - Class Methods

- (NSDateFormatter *)getDateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM d, yyyy";
    return formatter;
}

@end
