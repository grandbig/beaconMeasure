//
//  iBeaconPeripheral.m
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/12.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import "iBeaconPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

// デフォルトのUUID
static NSString *const defaultUUID = @"33B7DD31-897F-4357-B41E-0F1CE208DBCB";
// デフォルトのmajor
static NSInteger const defaultMajor = 0;
// デフォルトのminor
static NSInteger const defaultMinor = 0;

@interface iBeaconPeripheral()<CBPeripheralManagerDelegate>

@property(strong, nonatomic) CBPeripheralManager *pm;
@property(strong, nonatomic) NSUUID *proximityUUID;
@property(strong, nonatomic) CLBeaconRegion *beaconRegion;
@property(strong, nonatomic) CLBeacon *beacon;

@end

@implementation iBeaconPeripheral

#pragma mark - init
// 初期化処理
- (id)init
{
    return [self initWithUUID:defaultUUID major:defaultMajor minor:defaultMinor];
}

- (id)initWithUUID:(NSString *)uuid major:(NSInteger)major minor:(NSInteger)minor
{
    self = [super init];
    
    if(self) {
        // CBPeripheralManagerの初期化
        self.pm = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
        self.pm.delegate = self;
        // NSUUID型のUUIDを作成
        self.proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
        // Bundleの取得
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *bid = [bundle bundleIdentifier];
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID major:major minor:minor identifier:bid];
    }
    
    return self;
}

#pragma mark - other method
// iBeacon信号を発信する処理
- (void)startAdvertising
{
    // iBeacon信号を発信
    NSDictionary *beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    [self.pm startAdvertising:beaconPeripheralData];
}

// iBeacon信号の発信を停止する処理
- (void)stopAdvertising
{
    // iBeacon信号を停止
    [self.pm stopAdvertising];
}

#pragma mark - CBPeripheralManagerDelegate
// iBeacon発信が開始されたときに呼び出されるメソッド
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    // 何もしない
}

// iBeacon通信が更新したときに呼び出されるメソッド
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOff:
        case CBPeripheralManagerStateResetting:
        case CBPeripheralManagerStateUnauthorized:
        case CBPeripheralManagerStateUnsupported:
        case CBPeripheralManagerStateUnknown:
        {
            NSLog(@"Unavailable");
            if([self.delegate respondsToSelector:@selector(didFailToUseBluetooth)]) {
                // didFailToUseBluetoothデリゲートメソッドを呼び出す
                [self.delegate didFailToUseBluetooth];
            }
        }
            break;
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"Available");
            break;
        default:
            break;
    }
}

@end
