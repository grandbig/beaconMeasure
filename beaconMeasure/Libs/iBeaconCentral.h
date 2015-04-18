//
//  iBeaconCentral.h
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/12.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iBeaconCentralDelegate <NSObject>

/**
 位置情報サービスの機能を利用できない場合に呼び出される処理
 */
- (void)didFailToUseLocationService;

@end

@interface iBeaconCentral : NSObject

/// デリゲート先で参照するためのプロパティ
@property (nonatomic, assign) id<iBeaconCentralDelegate> delegate;

@end
