//
//  iBeaconCentral.h
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/12.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol iBeaconCentralDelegate <NSObject>

/**
 位置情報サービスの機能を利用できない場合に呼び出される処理
 */
- (void)didFailToUseLocationService;

/**
 iBeaconを検知したときに呼び出される処理
 @param beacons 検知したiBeaconの配列
 @param region 侵入しているiBeacon領域
 */
- (void)measureBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@end

@interface iBeaconCentral : NSObject

#pragma mark - init
/**
 初期化処理
 @return iBeaconCentralオブジェクト
 */
- (id)init;

/**
 初期化処理(UUIDを指定可能)
 @param uuid iBeaconのUUID
 @return iBeaconCentralオブジェクト
 */
- (id)initWithUUID:(NSString *)uuid;

/// デリゲート先で参照するためのプロパティ
@property (nonatomic, assign) id<iBeaconCentralDelegate> delegate;

#pragma mark - other method
/**
 レンジング開始処理
 */
- (void)startRangingBeacons;

/**
 レンジング終了処理
 */
- (void)stopRangingBeacons;

@end
