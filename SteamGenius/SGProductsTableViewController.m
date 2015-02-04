//
//  SGProductsTableViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 1/27/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGProductsTableViewController.h"
#import "SGEmptyView.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"

@interface SGProductsTableViewController () <RMStoreObserver>

@end

@implementation SGProductsTableViewController {
    RMStoreKeychainPersistence *_persistence;
    NSArray *_productIdentifiers;
    NSArray *_products;
    BOOL _productsRequestFinished;
}

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RMStore *store = [RMStore defaultStore];
    [store addStoreObserver:self];
    _persistence = store.transactionPersistor;
    _productIdentifiers = [[_persistence purchasedProductIdentifiers] allObjects];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Products" withExtension:@"plist"];
    _products = [NSArray arrayWithContentsOfURL:url];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [store requestProducts:[NSSet setWithArray:_products] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        _productsRequestFinished = YES;
        [self.tableView reloadData];
    }failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Products request failed." message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)dealloc
{
    [[RMStore defaultStore] removeStoreObserver:self];
}

#pragma mark - Store Actions

- (void)restoreAction
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restore Transactions Failed", @"")
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _productsRequestFinished ? _products.count : 0;
    } else {
        return _productsRequestFinished ? 1 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProductCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    if (indexPath.section == 0) {
        NSString *productId = [_products objectAtIndex:indexPath.row];
        SKProduct *product = [[RMStore defaultStore] productForIdentifier:productId];
        cell.textLabel.text = product.localizedTitle;
        cell.detailTextLabel.text = [RMStore localizedPriceOfProduct:product];
        
        if ([_productIdentifiers containsObject:product.productIdentifier]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        cell.textLabel.text = @"Restore Purchases";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![RMStore canMakePayments]) return;
    
    if (indexPath.section == 0) {
        NSString *productId = [_products objectAtIndex:indexPath.row];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[RMStore defaultStore] addPayment:productId success:^(SKPaymentTransaction *transaction) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }failure:^(SKPaymentTransaction *transaction, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Payment Transaction Failed" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    } else {
        [self restoreAction];
    }
}

#pragma mark RMStoreObserver

- (void)storeProductsRequestFinished:(NSNotification*)notification
{
    [self.tableView reloadData];
}

- (void)storePaymentTransactionFinished:(NSNotification*)notification
{
    _productIdentifiers = [[_persistence purchasedProductIdentifiers] allObjects];
    [self.tableView reloadData];
}

- (void)storeRestoreTransactionsFinished:(NSNotification *)notification
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Finished restoring purchases" message:@"Thank you!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
