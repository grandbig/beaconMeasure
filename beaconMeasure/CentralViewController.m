//
//  CentralViewController.m
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/17.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import "CentralViewController.h"
#import "iBeaconCentral.h"
#import <FBDigitalFont/FBBitmapFontView.h>

@interface CentralViewController()<iBeaconCentralDelegate>

/// iBeaconCentral
@property(strong, nonatomic) iBeaconCentral *central;
/// BitmapView
@property (weak, nonatomic) IBOutlet FBBitmapFontView *bmFontView;
@property (weak, nonatomic) IBOutlet FBBitmapFontView *bmFontView2;

@end

@implementation CentralViewController

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
    
    CGFloat defaultDistance = 0.000000;
    NSString *distanceString = [self getDistanceString:defaultDistance];
    NSArray *numberArray = [distanceString componentsSeparatedByString:@"."];
    
    _bmFontView.text = [numberArray objectAtIndex:0];
    _bmFontView.numberOfBottomPaddingDot = 1;
    _bmFontView.numberOfTopPaddingDot    = 1;
    _bmFontView.numberOfLeftPaddingDot   = 2;
    _bmFontView.numberOfRightPaddingDot  = 2;
    _bmFontView.glowSize = 20.0;
    _bmFontView.innerGlowSize = 3.0;
    _bmFontView.edgeLength = 3.0;
    
    _bmFontView2.text = [[NSString alloc] initWithFormat:@"%@m", [numberArray objectAtIndex:1]];
    _bmFontView2.numberOfBottomPaddingDot = 1;
    _bmFontView2.numberOfTopPaddingDot    = 1;
    _bmFontView2.numberOfLeftPaddingDot   = 2;
    _bmFontView2.numberOfRightPaddingDot  = 2;
    _bmFontView2.glowSize = 20.0;
    _bmFontView2.innerGlowSize = 3.0;
    _bmFontView2.edgeLength = 3.0;
}

#pragma mark - iBeaconCentralDelegate
// iBeaconを検知したときに呼び出される処理
- (void)measureBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if(beacons.count > 0) {
        // 最寄りのiBeaconオブジェクトを取得
        CLBeacon *beacon = beacons.firstObject;
        // 距離を取得
        CGFloat distance = beacon.accuracy;
        NSString *distanceString = [self getDistanceString:distance];
        NSArray *numberArray = [distanceString componentsSeparatedByString:@"."];
        NSString *integerString, *decimalString;
        if([numberArray count] == 2) {
            // 整数と小数がある場合
            integerString = [numberArray objectAtIndex:0];
            if([integerString isEqualToString:@"-1"]) {
                // -1の場合は0に置き換える
                integerString = @"0";
            }
            decimalString = [[NSString alloc] initWithFormat:@"%@m", [numberArray objectAtIndex:1]];
            _bmFontView.text = integerString;
            _bmFontView2.text = decimalString;
        } else {
            // その他
            CGFloat defaultDistance = 0.000000;
            NSString *distanceString = [self getDistanceString:defaultDistance];
            NSArray *numberArray = [distanceString componentsSeparatedByString:@"."];
            _bmFontView.text = [numberArray objectAtIndex:0];
            _bmFontView2.text = [[NSString alloc] initWithFormat:@"%@m", [numberArray objectAtIndex:1]];
        }
    }
}

// 位置情報サービスの機能を利用できない場合に呼び出される処理
- (void)didFailToUseLocationService
{
    if([UIAlertController class]) {
        // iOS8以上の場合
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alertTitle", nil)
                                                                                 message:NSLocalizedString(@"allowLocationServiceMsg", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"okBtn", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 何もしない
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"settingBtn", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // 設定画面へのURLスキーム
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }]];
        
        // アラートの表示
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // iOS7以下の場合
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alertTitle", nil)
                                                        message:NSLocalizedString(@"allowLocationServiceMsg", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"okBtn", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// Bluetoothの機能を使えない場合に呼び出される処理
- (void)didFailToUseBluetooth
{
    if([UIAlertController class]) {
        // iOS8以上の場合
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alertTitle", nil)
                                                                                 message:NSLocalizedString(@"allowBluetoothMsg", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"okBtn", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 何もしない
        }]];
        
        // アラートの表示
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // iOS7以下の場合
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alertTitle", nil)
                                                        message:NSLocalizedString(@"allowBluetoothMsg", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"okBtn", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - action
/**
 戻るボタンをタップしたときのアクション
 @param sender アクション
 */
- (IBAction)backToViewController:(id)sender {
    // 画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - other method
/**
 距離の文字列を取得する処理
 @param distance 距離
 @return 距離の文字列
 */
- (NSString *)getDistanceString:(CGFloat)distance
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    NSString *distanceString;
    
    if(width == 320) {
        // 3.5inchの場合
        distanceString = [[NSString alloc] initWithFormat:@"%.5f", distance];
    } else if(width == 414) {
        distanceString = [[NSString alloc] initWithFormat:@"%.8f", distance];
    } else {
        distanceString = [[NSString alloc] initWithFormat:@"%.7f", distance];
    }
    
    return distanceString;
}

@end
