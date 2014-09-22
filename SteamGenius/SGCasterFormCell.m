//
//  SGCasterFormCell.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGCasterFormCell.h"
#import "SGFactionOptionsTableViewController.h"

@implementation SGCasterFormCell

- (void)setUp
{
    [super setUp];
}

- (void)update
{
    [super update];
    self.textLabel.text = @"Caster";
    NSLog(@"Updated!");
}

- (void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
    SGFactionOptionsTableViewController *subController = [[SGFactionOptionsTableViewController alloc] init];
    subController.field = self.field;
    [controller.navigationController pushViewController:subController animated:YES];
    
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

@end