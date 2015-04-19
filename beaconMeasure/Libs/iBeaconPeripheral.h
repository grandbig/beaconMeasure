//
//  iBeaconPeripheral.h
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/12.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iBeaconPeripheralDelegate <NSObject>

/**
 Bluetoothの機能を使えない場合に呼び出される処理
 */
- (void)didFailToUseBluetooth;

@end

@interface iBeaconPeripheral : NSObject

/// デリゲート先で参照するためのプロパティ
@property (nonatomic, assign) id<iBeaconPeripheralDelegate> delegate;

#pragma mark - init
/** 
 初期化処理
 @return iBeaconPeripheralオブジェクト
 */
- (id)init;

/**
 iBeaconのプロパティを付与する初期化処理
 @param uuid iBeaconのUUID
 @param major iBeaconのmajor
 @param minor iBeaconのminor
 @return iBeaconPeripheralオブジェクト
 */
- (id)initWithUUID:(NSString *)uuid major:(NSInteger)major minor:(NSInteger)minor;

#pragma mark - other method
/**
 iBeacon信号を発信する処理
 */
- (void)startAdvertising;

/**
 iBeacon信号の発信を停止する処理
 */
- (void)stopAdvertising;

@end
