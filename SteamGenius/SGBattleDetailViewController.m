//
//  SGBattleDetailViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 12/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleDetailViewController.h"
#import "Model.h"
#import "SGBattleFormViewController.h"

@interface SGBattleDetailViewController ()

@end

@implementation SGBattleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.form = self.battle ? [[SGBattleDetailForm alloc] init:self.battle] : [[SGBattleDetailForm alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.formController.form = self.form;
    [self.formController.tableView reloadData];
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
