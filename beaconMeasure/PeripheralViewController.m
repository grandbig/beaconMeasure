//
//  PeripheralViewController.m
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/17.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import "PeripheralViewController.h"
#import "iBeaconPeripheral.h"
#import <FBDigitalFont/FBBitmapFontView.h>

@interface PeripheralViewController()<iBeaconPeripheralDelegate>
/// iBeaconPeripheral
@property (strong, nonatomic) iBeaconPeripheral *peripheral;
/// BitmapView
@property (weak, nonatomic) IBOutlet FBBitmapFontView *bmFontView;
/// STARTボタン
@property (weak, nonatomic) IBOutlet UIButton *advBtn;
/// フラグ
@property (assign, nonatomic) BOOL flag;

@end

@implementation PeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 端末内部に保存したパラメータを取得
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [defaults objectForKey:@"uuid"];
    NSString *major = [defaults objectForKey:@"major"];
    NSString *minor = [defaults objectForKey:@"minor"];
    if(uuid.length > 0 && major.length > 0 && minor.length > 0) {
        // 端末内部に保存したパラメータを使ってiBeaconPeripheralを初期化
        _peripheral = [[iBeaconPeripheral alloc] initWithUUID:uuid major:[major integerValue] minor:[minor integerValue]];
        _peripheral.delegate = self;
    } else {
        // デフォルトパラメータでiBeaconPeripheralを初期化
        _peripheral = [[iBeaconPeripheral alloc] init];
        _peripheral.delegate = self;
    }
    
    _flag = NO;
    _bmFontView.text = @" SLEEPING  ";
    _bmFontView.numberOfBottomPaddingDot = 1;
    _bmFontView.numberOfTopPaddingDot    = 1;
    _bmFontView.numberOfLeftPaddingDot   = 2;
    _bmFontView.numberOfRightPaddingDot  = 2;
    _bmFontView.glowSize = 20.0;
    _bmFontView.innerGlowSize = 3.0;
    _bmFontView.edgeLength = 3.0;
     
}

#pragma mark - iBeaconPeripheralDelegate
// Bluetoothの機能を使えない場合に呼び出される処理
- (void)didFailToUseBluetooth
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alertTitle", nil)
                                                                             message:NSLocalizedString(@"allowBluetoothMsg", nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"okBtn", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 何もしない
    }]];
    
    // アラートの表示
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - other method

/**
 Advertisingモードへの変更処理
 */
- (void)changeAdvertiseMode
{
    _bmFontView.text = @"ADVERTISING";
    [_peripheral startAdvertising];
    [_advBtn setTitle:NSLocalizedString(@"stopBtn", nil) forState:UIControlStateNormal];
    _flag = YES;
}

/**
 Sleepモードへの変更処理
 */
- (void)changeSleepMode
{
    _bmFontView.text = @" SLEEPING  ";
    [_peripheral stopAdvertising];
    [_advBtn setTitle:NSLocalizedString(@"startBtn", nil) forState:UIControlStateNormal];
    _flag = NO;
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

/**
 STARTボタンをタップしたときのアクション
 @param sender アクション
 */
- (IBAction)advToggleAction:(id)sender {
    if(_flag) {
        // フラグがYESの場合
        [self changeSleepMode];
    } else {
        // フラグがNOの場合
        [self changeAdvertiseMode];
    }
}
@end
