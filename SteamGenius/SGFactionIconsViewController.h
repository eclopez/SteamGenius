//
//  SGFactionIconsViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 4/30/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

@import UIKit;
#import "Faction.h"

@interface SGFactionIconsViewController : UIImagePickerController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) Faction *faction;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UINavigationController *navController;

@end
