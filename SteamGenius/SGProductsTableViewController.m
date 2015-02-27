//
//  SGProductsTableViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 1/27/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGProductsTableViewController.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"

@interface SGProductsTableViewController () <RMStoreObserver>

@end

@implementation SGProductsTableViewController {
    RMStoreKeychainPersistence *_persistence;
    NSArray *_productIdentifiers;
    NSArray *_premium;
    NSArray *_premiumFeatures;
    BOOL _productsRequestFinished;
}

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block BOOL premiumProductLoaded = NO;
    __block BOOL premiumFeaturesLoaded = NO;
    
    RMStore *store = [RMStore defaultStore];
    [store addStoreObserver:self];
    _persistence = store.transactionPersistor;
    _productIdentifiers = [[_persistence purchasedProductIdentifiers] allObjects];
    
    NSURL *premiumUrl = [[NSBundle mainBundle] URLForResource:@"SGPremium" withExtension:@"plist"];
    _premium = [NSArray arrayWithContentsOfURL:premiumUrl];
    
    NSURL *featuresUrl = [[NSBundle mainBundle] URLForResource:@"SGPremiumFeatures" withExtension:@"plist"];
    _premiumFeatures = [NSArray arrayWithContentsOfURL:featuresUrl];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Premium request
    [store requestProducts:[NSSet setWithArray:_premium] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        premiumProductLoaded = YES;
        if (premiumFeaturesLoaded) {
            [self productsReceived];
        }
    }failure:^(NSError *error) {
        [self productsNotReceived:error.localizedDescription];
    }];
    
    // Premium features request
    [store requestProducts:[NSSet setWithArray:_premiumFeatures] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        premiumFeaturesLoaded = YES;
        if (premiumProductLoaded) {
            [self productsReceived];
        }
    }failure:^(NSError *error) {
        [self productsNotReceived:error.localizedDescription];
    }];
}

- (void)productsReceived
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _productsRequestFinished = YES;
    [self.tableView reloadData];
}

- (void)productsNotReceived:(NSString *)errorMessage
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Products request failed." message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc
{
    [[RMStore defaultStore] removeStoreObserver:self];
}

#pragma mark - Store Actions

- (void)restoreAction
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_persistence removeTransactions];
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        _productIdentifiers = [[_persistence purchasedProductIdentifiers] allObjects];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _productsRequestFinished ? _premium.count : 0;
    } else if (section == 1) {
        return _productsRequestFinished ? _premiumFeatures.count : 0;
    }
    else {
        return _productsRequestFinished ? 1 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProductCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    if (indexPath.section == 0) {
        NSString *productId = [_premium objectAtIndex:indexPath.row];
        SKProduct *product = [[RMStore defaultStore] productForIdentifier:productId];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ – %@", product.localizedTitle, [RMStore localizedPriceOfProduct:product]];
        cell.detailTextLabel.text = product.localizedDescription;
        cell.detailTextLabel.numberOfLines = 0;
        
        if ([_productIdentifiers containsObject:product.productIdentifier]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if (indexPath.section == 1) {
        NSString *productId = [_premiumFeatures objectAtIndex:indexPath.row];
        SKProduct *product = [[RMStore defaultStore] productForIdentifier:productId];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ – %@", product.localizedTitle, [RMStore localizedPriceOfProduct:product]];
        cell.detailTextLabel.text = product.localizedDescription;
        cell.detailTextLabel.numberOfLines = 0;
        
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
        NSString *productId = [_premium objectAtIndex:indexPath.row];
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
    } else if (indexPath.section == 1) {
        NSString *productId = [_premiumFeatures objectAtIndex:indexPath.row];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_productsRequestFinished) {
        if (section == 0) {
            return @"All Premium Features";
        } else if (section == 1) {
            return @"Individual Premium Features";
        } else {
            return @"";
        }
    }
    return @"";
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
