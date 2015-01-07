//
//  SGFilterOptionsTableViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 10/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGFilterOptionsTableViewController.h"
#import "SGFiltersForm.h"

@interface SGFilterOptionsTableViewController ()

@end

@implementation SGFilterOptionsTableViewController

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
    
    SGFiltersForm *form = self.field.form;
    id obj = [self.field optionAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    if ([self.field.key isEqual:@"attribute"]) {
        cell.textLabel.text = [[form attributes] objectForKey:obj];
    }
    if ([self.field.key isEqual:@"operation"]) {
        cell.textLabel.text = [[form logicalOperators] objectForKey:obj];
    }
    if ([self.field.key isEqual:@"attributeValue"]) {
        cell.textLabel.text = [obj valueForKey:@"name"];
    }
    
    NSManagedObject *current = [form valueForKey:self.field.key] ? (NSManagedObject *)[form valueForKey:self.field.key] : nil;
    cell.accessoryType = current == obj ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *obj = [self.field optionAtIndex:indexPath.row];
    
    FXFormController *form = self.field.form;
    if ([obj isKindOfClass:[NSManagedObject class]]) {
        [form setValue:[obj valueForKey:@"name"] forKey:self.field.key];
    } else {
        [form setValue:obj forKey:self.field.key];
    }
    
    if (self.field.action) self.field.action(self);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
