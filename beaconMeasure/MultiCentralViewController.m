//
//  MultiCentralViewController.m
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/20.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import "MultiCentralViewController.h"
#import "iBeaconCentral.h"

@interface MultiCentralViewController()<iBeaconCentralDelegate>

/// iBeaconCentral
@property(strong, nonatomic) iBeaconCentral *central;

@end

@implementation MultiCentralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 端末内部に保存したパラメータを取得
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [defaults objectForKey:@"uuid"];
    if(uuid.length > 0) {
        // 端末内部に保存したパラメータを使ってiBeaconCentralを初期化
        _central = [[iBeaconCentral alloc] initWithUUID:uuid];
        _central.delegate = self;
    } else {
        // デフォルトパラメータでiBeaconCentralを初期化
        _central = [[iBeaconCentral alloc] init];
        _central.delegate = self;
    }
}

#pragma mark - iBeaconCentralDelegate
// iBeaconを検知したときに呼び出される処理
- (void)measureBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if(beacons.count > 0) {
        // 最寄りのiBeaconオブジェクトを取得
        CLBeacon *beacon = beacons.firstObject;
    }
}

// 位置情報サービスの機能を利用できない場合に呼び出される処理
- (void)didFailToUseLocationService
{
    // アラートの表示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認"
                                                    message:@"位置情報サービスが利用できません。"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

/**
 戻るボタンをタップしたときのアクション
 @param sender アクション
 */
- (IBAction)backToViewController:(id)sender {
    // 画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
