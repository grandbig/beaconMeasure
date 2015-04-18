//
//  iBeaconCentral.m
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/12.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import "iBeaconCentral.h"
#import <CoreLocation/CoreLocation.h>

// デフォルトのUUID
static NSString *const defaultUUID = @"33B7DD31-897F-4357-B41E-0F1CE208DBCB";

@interface iBeaconCentral()<CLLocationManagerDelegate>

@property(strong, nonatomic) CLLocationManager *lm;
@property(strong, nonatomic) NSUUID *proximityUUID;
@property(strong, nonatomic) CLBeaconRegion *beaconRegion;
@property(strong, nonatomic) CLBeacon *beacon;

@end

@implementation iBeaconCentral

#pragma mark - init
// 初期化処理
- (id)init
{
    return [self initWithUUID:defaultUUID];
}

// 初期化処理(UUIDを指定可能)
- (id)initWithUUID:(NSString *)uuid
{
    self = [super init];
    
    if(self) {
        // CLLocationManagerの初期化
        self.lm = [[CLLocationManager alloc] init];
        self.lm.delegate = self;
        // NSUUID型のUUIDを作成
        self.proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
        // Bundleの取得
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *bid = [bundle bundleIdentifier];
        // iBeacon領域の設定
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID: [[NSUUID alloc] initWithUUIDString:uuid] identifier: bid];
        
        // 位置情報の取得許可の設定(settingBeaconメソッドの後に実行する && 必ず実行する必要があるため)
        if ([self.lm respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            // requestAlwaysAuthorizationメソッドが利用できる場合(iOS8以上の場合)
            // 位置情報の取得許可を求めるメソッド(iOS8はこのメソッドを利用して初めて、アラートが表示される)
            [self.lm requestAlwaysAuthorization];
        } else {
            // requestAlwaysAuthorizationメソッドが利用できない場合(iOS8未満の場合)
            // iBeaconの領域観測を開始
            [self.lm startMonitoringForRegion:self.beaconRegion];
        }
    }
    
    return self;
}

#pragma mark - CLLocationManagerDelegate
// ユーザの位置情報の許可状態を確認するメソッド
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusAuthorizedAlways) {
        // ユーザが位置情報の使用を常に許可している場合
        if ([self.beaconRegion isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
            if ([self.lm respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                // requestAlwaysAuthorizationメソッドが利用できる場合(iOS8以上の場合)
                // iBeaconモニタリングを開始
                [self.lm startMonitoringForRegion:self.beaconRegion];
            }
        }
    } else {
        // ユーザが位置情報の使用を許可していない場合
        if([self.delegate respondsToSelector:@selector(didFailToUseLocationService)]) {
            // didFailToUseLocationServiceデリゲートメソッドを呼び出す
            [self.delegate didFailToUseLocationService];
        }
    }
}

// 領域計測が開始した場合
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    // 特に何もしない
}

// 指定した領域に侵入した場合
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        // 何もしない
    }
}

// 指定した領域から退室した場合
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        // 何もしない
    }
}

// iBeacon領域内に既にいるか/いないかの判定
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    // レンジング対象を取得
    NSSet *ranging = [self.lm rangedRegions];
    
    switch (state) {
        case CLRegionStateInside:
            if([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]){
                // モニタリング対象が設定されている && レンジングが可能な状態 && ユーザ登録済の場合
                if (ranging==nil || ranging.count==0) {
                    // レンジング対象がない場合
                    // iBeaconレンジングを開始
                    [self.lm startRangingBeaconsInRegion:self.beaconRegion];
                }
            }
            break;
        case CLRegionStateOutside:
            if([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]){
                // モニタリング対象が設定されている && レンジングが可能な状態 && ユーザ登録済の場合
                // iBeacon領域外にいるので何もしない
            }
            break;
        case CLRegionStateUnknown:
            if([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]){
                // モニタリング対象が設定されている && レンジングが可能な状態 && ユーザ登録済の場合
                // iBeacon領域内外のどちらにいるか不明なので何もしない
            }
            break;
        default:
            break;
    }
}

// iBeaconレンジングを検知したときに呼び出されるメソッド
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        // 1つ以上のiBeacon信号を受信した場合
        NSLog(@"%@", beacons);
    }
}

// 領域観測に失敗した場合
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    // 特に何もしない
}

@end
