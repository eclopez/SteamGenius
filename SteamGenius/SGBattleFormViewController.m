//
//  SGBattleFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleFormViewController.h"
#import "SGBattleForm.h"
#import "AppDelegate.h"
#import "SGRepository.h"

@interface SGBattleFormViewController ()

@end

@implementation SGBattleFormViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.formController.form = [[SGBattleForm alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Class Methods

- (IBAction)saveBattle:(id)sender {
    [self.tableView resignFirstResponder];
    
    [self.tableView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SGBattleForm *form = self.formController.form;
    
    int validate = 0;
    NSArray *validateFields = @[ @"playerCaster",
                                 @"opponentCaster",
                                 @"date",
                                 @"pointSize",
                                 @"result" ];
    NSArray *validateFieldNames = @[ @"Player caster",
                                     @"Opponent caster",
                                     @"Date",
                                     @"Point size",
                                     @"Result" ];
    NSMutableString *validationList = [[NSMutableString alloc] init];
    
    for (NSString *field in validateFields) {
        if (![form valueForKey:field]) {
            [validationList appendString:[NSString stringWithFormat:@"- %@ can't be empty.\n", [validateFieldNames objectAtIndex:[validateFields indexOfObject:field]]]];
            validate++;
        }
    }
    
    if (validate == 0) {
        if (self.battle) {
            self.battle.playerCaster = form.playerCaster;
            self.battle.opponentCaster = form.opponentCaster;
            self.battle.opponent = form.opponent;
            self.battle.date = form.date;
            self.battle.points = form.pointSize;
            self.battle.result = form.result;
            self.battle.killPoints = form.killPoints;
            self.battle.scenario = form.scenario;
            self.battle.controlPoints = form.controlPoints;
            self.battle.event = form.event;
        } else {
            [SGRepository initWithPlayerCaster:form.playerCaster opponentCaster:form.opponentCaster opponent:form.opponent date:form.date points:form.pointSize result:form.result killPoints:form.killPoints scenario:form.scenario controlPoints:form.controlPoints event:form.event context:appDelegate.managedObjectContext];
        }
        [appDelegate saveContext];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *validationMessage = [[UIAlertView alloc] initWithTitle:@"Form invalid" message:validationList delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [validationMessage show];
    }
}

@end