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
#import <QuartzCore/QuartzCore.h>

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
    _bmFontView.text = [self getSleepingString];
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

#pragma mark - other method

/**
 Advertisingモードへの変更処理
 */
- (void)changeAdvertiseMode
{
    _bmFontView.text = [self getAdvertiseString];
    [_peripheral startAdvertising];
    [_advBtn setTitle:NSLocalizedString(@"stopBtn", nil) forState:UIControlStateNormal];
    _flag = YES;
    [self blinkImage:_bmFontView];
}

/**
 Sleepモードへの変更処理
 */
- (void)changeSleepMode
{
    _bmFontView.text = [self getSleepingString];
    [_peripheral stopAdvertising];
    [_advBtn setTitle:NSLocalizedString(@"startBtn", nil) forState:UIControlStateNormal];
    _flag = NO;
    [self noBlinkImage:_bmFontView];
}

/**
 点滅処理
 @param target 点滅させたいUIViewオブジェクト
 */
- (void)blinkImage:(UIView *)target {
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.5f;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VAL; //infinite loop -> HUGE_VAL
    animation.fromValue = [NSNumber numberWithFloat:1.0f]; //MAX opacity
    animation.toValue = [NSNumber numberWithFloat:0.0f]; //MIN opacity
    [target.layer addAnimation:animation forKey:@"blink"];
}

/**
 点滅終了処理
 @param target 点滅を終了させたいUIViewオブジェクト
 */
- (void)noBlinkImage:(UIView *)target {
    [target.layer removeAnimationForKey:@"blink"];
}

/**
 iBeacon信号の発信停止中に表示する文字列を返却する処理
 @return iBeacon信号の発信停止中に表示する文字列
 */
- (NSString *)getSleepingString
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    NSString *sleepingString;
    
    if(width == 320) {
        // 3.5inchの場合
        sleepingString = @"SLEEPING ";
    } else if(width == 414) {
        sleepingString = @"  SLEEPING  ";
    } else {
        sleepingString = @" SLEEPING  ";
    }
    
    return sleepingString;
}

/**
 iBeacon信号の発信中に表示する文字列を返却する処理
 @return iBeacon信号の発信中に表示する文字列
 */
- (NSString *)getAdvertiseString
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    NSString *advertiseString;
    
    if(width == 320) {
        // 3.5inchの場合
        advertiseString = @"ADVERTISE";
    } else if(width == 414) {
        advertiseString = @"ADVERTISING ";
    } else {
        advertiseString = @"ADVERTISING";
    }
    
    return advertiseString;
}

#pragma mark - action
/**
 戻るボタンをタップしたときのアクション
 @param sender アクション
 */
- (IBAction)backToViewController:(id)sender {
    // iBeaconの発信状態を取得
    BOOL isAdvertising = [_peripheral isAdvertising];
    if(isAdvertising) {
        [_peripheral stopAdvertising];
    }
    
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
