//
//  SGThemeOptionsViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/16/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGThemeOptionsViewController.h"
#import "SGSettingsManager.h"

@interface SGThemeOptionsViewController ()

@end

@implementation SGThemeOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SGSettingsManager updateTheme:indexPath.row];
}

@end
