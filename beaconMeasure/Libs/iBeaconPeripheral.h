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

@end
