//
//  SGBattleListViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 10/2/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleListViewController.h"
#import "SGSettingsManager.h"

@interface SGBattleListViewController ()

@end

@implementation SGBattleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.contentInset = UIEdgeInsetsMake(35.f, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(35.f, 0, 0, 0);
    
    [self.recordView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"RecordBar"]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.backgroundColor = [SGSettingsManager getBarColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BattleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Hello.";
    return cell;
}

@end