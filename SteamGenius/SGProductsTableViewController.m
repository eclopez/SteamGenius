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

#define kProductsFile @"SGProducts"

@interface SGProductsTableViewController () <RMStoreObserver>

@end

@implementation SGProductsTableViewController {
    RMStoreKeychainPersistence *_persistence;
    NSArray *_productInfo;
    NSMutableArray *_productIdentifiers;
    NSArray *_purchasedProductIdentifiers;
    BOOL _productsLoaded;
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
    _productsLoaded = NO;
    
    RMStore *store = [RMStore defaultStore];
    [store addStoreObserver:self];
    _persistence = store.transactionPersistor;
    _purchasedProductIdentifiers = [[_persistence purchasedProductIdentifiers] allObjects];
    
    _productInfo = [NSArray arrayWithContentsOfURL:[self getFileUrl:kProductsFile fileType:@"plist"]];
    _productIdentifiers = [[NSMutableArray alloc] init];
    for (NSDictionary *productClasses in _productInfo) {
        for (NSArray *productIds in [productClasses allValues]) {
            for (NSString *productId in productIds) {
                [_productIdentifiers addObject:productId];
            }
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [store requestProducts:[NSSet setWithArray:_productIdentifiers] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self showNotificationAlert:@"Products Request Failed" message:error.localizedDescription style:UIAlertControllerStyleAlert viewController:self];
    }];
}
- (void)productsNotReceived:(NSString *)errorMessage
{
    [self showNotificationAlert:@"Products request failed." message:errorMessage style:UIAlertControllerStyleAlert viewController:self];
}

- (void)dealloc
{
    [[RMStore defaultStore] removeStoreObserver:self];
}

#pragma mark - Store Actions

- (void)restorePurchases
{
    [_persistence removeTransactions];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        _purchasedProductIdentifiers = [[_persistence purchasedProductIdentifiers] allObjects];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self showNotificationAlert:NSLocalizedString(@"Restore Transactions Failed", @"") message:error.localizedDescription style:UIAlertControllerStyleAlert viewController:self];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_productsLoaded) return 0;
    return [_productInfo count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return [[[[_productInfo objectAtIndex:section] allValues] firstObject] count];
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProductCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
        case 1:
        {
            SKProduct *product = [[RMStore defaultStore] productForIdentifier:[[[[_productInfo objectAtIndex:indexPath.section] allValues] firstObject] objectAtIndex:indexPath.row]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", product.localizedTitle];
            cell.detailTextLabel.text = [RMStore localizedPriceOfProduct:product];
            cell.detailTextLabel.numberOfLines = 0;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if ([_purchasedProductIdentifiers containsObject:product.productIdentifier]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
            break;
        default:
            cell.textLabel.text = @"Restore Purchases";
            break;
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![RMStore canMakePayments]) return;
    switch (indexPath.section) {
        case 0:
        case 1:
        {
            NSString *productId = [_productIdentifiers objectAtIndex:indexPath.row];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [[RMStore defaultStore] addPayment:productId success:^(SKPaymentTransaction *transaction) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }failure:^(SKPaymentTransaction *transaction, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [self showNotificationAlert:@"Payment Transaction Failed" message:error.localizedDescription style:UIAlertControllerStyleAlert viewController:self];
            }];
        }
            break;
        default:
            [self restorePurchases];
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1:
            return [[[_productInfo objectAtIndex:section] allKeys] firstObject];
        default:
            return @"Restore";
    }
}

#pragma mark RMStoreObserver

- (void)storeProductsRequestFinished:(NSNotification*)notification
{
    _productsLoaded = YES;
    [self.tableView reloadData];
}

- (void)storePaymentTransactionFinished:(NSNotification*)notification
{
    _purchasedProductIdentifiers = [[_persistence purchasedProductIdentifiers] allObjects];
    [self.tableView reloadData];
}

- (void)storeRestoreTransactionsFinished:(NSNotification *)notification
{
    [self showNotificationAlert:@"Purchases Restored!" message:@"Thank you!" style:UIAlertControllerStyleAlert viewController:self];
}

#pragma mark Private Methods

- (NSURL *)getFileUrl:(NSString *)fileName fileType:(NSString *)fileType
{
    return [[NSBundle mainBundle] URLForResource:fileName withExtension:fileType];
}

- (void)showNotificationAlert:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style viewController:(UIViewController *)view
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [view presentViewController:alert animated:YES completion:nil];
}

@end
