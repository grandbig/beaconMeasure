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
    [menuView addMenuItemWithTitle:NSLocalizedString(@"advertise", nil) andIcon:[UIImage imageNamed:@"peripheral.png"] andSelectedBlock:^{
        NSLog(@"Advertise selected");
        [self performSegueWithIdentifier:@"iBeaconPeripheralSegue" sender:self];
    }];
    [menuView addMenuItemWithTitle:NSLocalizedString(@"measure", nil) andIcon:[UIImage imageNamed:@"central.png"] andSelectedBlock:^{
        NSLog(@"Measure selected");
        [self performSegueWithIdentifier:@"iBeaconCentralSegue" sender:self];
    }];
    [menuView addMenuItemWithTitle:NSLocalizedString(@"search", nil) andIcon:[UIImage imageNamed:@"multiBeacon.png"] andSelectedBlock:^{
        NSLog(@"Search selected");
        [self performSegueWithIdentifier:@"multiBeaconSegue" sender:self];
    }];
    [menuView addMenuItemWithTitle:NSLocalizedString(@"about", nil) andIcon:[UIImage imageNamed:@"info.png"] andSelectedBlock:^{
        NSLog(@"About selected");
        [self performSegueWithIdentifier:@"infoSegue" sender:self];
    }];
    
    [menuView show];
}

- (IBAction)showMenuItems:(id)sender {
    [self showMenu];
}

@end
