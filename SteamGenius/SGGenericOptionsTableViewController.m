//
//  SGGenericOptionsTableViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGGenericOptionsTableViewController.h"
#import "AppDelegate.h"

@interface SGGenericOptionsTableViewController ()

@end

@implementation SGGenericOptionsTableViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.field.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.field optionCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSManagedObject *obj = [self.field optionAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.text = [obj valueForKey:@"name"];
    
    FXFormController *form = self.field.form;
    NSManagedObject *current = [form valueForKey:self.field.key] ? (NSManagedObject *)[form valueForKey:self.field.key] : nil;
    cell.accessoryType = current == obj ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *obj = [self.field optionAtIndex:indexPath.row];
    
    FXFormController *form = self.field.form;
    [form setValue:obj forKey:self.field.key];
    
    if (self.field.action) self.field.action(self);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
