//
//  ViewController.m
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/12.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import "ViewController.h"
#import "CHTumblrMenuView.h"
#import "CentralViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu
{
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    [menuView addMenuItemWithTitle:@"Peripheral" andIcon:[UIImage imageNamed:@"peripheral.png"] andSelectedBlock:^{
        NSLog(@"Peripheral selected");
        [self performSegueWithIdentifier:@"iBeaconPeripheralSegue" sender:self];
    }];
    [menuView addMenuItemWithTitle:@"Central" andIcon:[UIImage imageNamed:@"central.png"] andSelectedBlock:^{
        NSLog(@"Central selected");
        [self performSegueWithIdentifier:@"iBeaconCentralSegue" sender:self];
    }];
    [menuView addMenuItemWithTitle:@"Setting" andIcon:[UIImage imageNamed:@"settings.png"] andSelectedBlock:^{
        NSLog(@"Setting selected");
        [self performSegueWithIdentifier:@"SettingSegue" sender:self];
    }];
    
    [menuView show];
}

- (IBAction)showMenuItems:(id)sender {
    [self showMenu];
}

@end
