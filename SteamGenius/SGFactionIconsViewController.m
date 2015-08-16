//
//  SGFactionIconsViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 4/30/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGFactionIconsViewController.h"
@import SteamGeniusKit;
#import "SGFactionsOptionTableViewController.h"

@interface SGFactionIconsViewController ()

@end

@implementation SGFactionIconsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

- (void)clearSelection
{
    NSString *path = [SGKFileAccess sharedIconsDirectory].path;
    NSString *iconPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.faction.shortName]];
    NSError *error;
    
    if ([SGKFileAccess factionIconExists:self.faction.shortName]) {
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL deleted = [manager removeItemAtPath:iconPath error:&error];
        if (deleted) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"factionIconCleared" object:self];
        } else {
            // Could not delete file.
#warning Handle error.
        }
    }
    [self reloadParentTable];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UINavigationController Delegate Methods

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearSelection)];
    viewController.navigationItem.leftBarButtonItem = clearButton;
}

#pragma mark UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@", [SGKFileAccess sharedIconsDirectory]);
    NSString *path = [SGKFileAccess sharedIconsDirectory].path;
    NSString *iconPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.faction.shortName]];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *factionIcon = [self image:[info objectForKey:UIImagePickerControllerOriginalImage] convertToSize:CGSizeMake(60.f, 60.f)];
        NSData *data = UIImagePNGRepresentation(factionIcon);
        [data writeToFile:iconPath atomically:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"factionIconSelected" object:self];
    }
    
    [self reloadParentTable];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self reloadParentTable];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Class Methods

- (void)reloadParentTable
{
    SGFactionsOptionTableViewController *parent = (SGFactionsOptionTableViewController *)[self.navController topViewController];
    [parent.tableView reloadData];
}

- (UIImage *)image:(UIImage *)image convertToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end