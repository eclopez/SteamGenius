//
//  SGBattleDetailViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 10/6/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleDetailViewController.h"
#import "Caster.h"
#import "Model.h"
#import "Result.h"

@interface SGBattleDetailViewController ()

@end

@implementation SGBattleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    self.title = self.battle ?
    [NSString stringWithFormat:@"%@%@ vs. %@%@",
     self.battle.playerCaster.model.shortName,
     [self.battle.playerCaster.model.incarnation intValue] != 1 ? self.battle.playerCaster.model.incarnation : @"",
     self.battle.opponentCaster.model.shortName,
     [self.battle.opponentCaster.model.incarnation intValue] != 1 ? self.battle.opponentCaster.model.incarnation : @""] :
    @"Battle Detail";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
