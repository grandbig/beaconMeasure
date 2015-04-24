//
//  MultiCentralViewController.m
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/20.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import "MultiCentralViewController.h"
#import "iBeaconCentral.h"

@interface MultiCentralViewController()<iBeaconCentralDelegate, UITableViewDataSource, UITableViewDelegate>

/// iBeaconCentral
@property(strong, nonatomic) iBeaconCentral *central;
/// テーブルビュー
@property (weak, nonatomic) IBOutlet UITableView *multiBeaconTableView;
/// セルの数
@property (assign, nonatomic) NSInteger cellNum;
/// 各セルのタイトルを保存する配列
@property (strong, nonatomic) NSMutableArray *titleArray;
/// 各セルのサブタイトルを保存する配列
@property (strong, nonatomic) NSMutableArray *subTitleArray;
/// カウント数
@property (assign, nonatomic) NSInteger cnt;

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
    
    // テーブルビューのデリゲート設定
    _multiBeaconTableView.delegate = self;
    _multiBeaconTableView.dataSource = self;
    _cnt = 0;
}

#pragma mark - iBeaconCentralDelegate
// iBeaconを検知したときに呼び出される処理
- (void)measureBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if(beacons.count > 0) {
        // iBeaconオブジェクトの数を取得
        _cellNum = beacons.count;
        
        // 配列の初期化
        _titleArray = [NSMutableArray array];
        _subTitleArray = [NSMutableArray array];
        
        for(NSInteger i=0; i<_cellNum; i++) {
            CLBeacon *beacon = [beacons objectAtIndex:i];
            NSString *title = [[NSString alloc] initWithFormat:@"major: %@, minor: %@", beacon.major, beacon.minor];
            NSString *proximityString = [self getProximityString:beacon.proximity];
            NSString *subTitle = [[NSString alloc] initWithFormat:@"proximity: %@, accuracy: %f", proximityString, beacon.accuracy];
            [_titleArray addObject:title];
            [_subTitleArray addObject:subTitle];
        }
        // iBeaconのレンジング処理を終了
        [_central stopRangingBeacons];
        // テーブルビューの更新
        [_multiBeaconTableView reloadData];
        _cnt++;
        NSLog(@"cnt: %ld", (long)_cnt);
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

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 0;
    if(_titleArray.count > 0 && _subTitleArray.count > 0) {
        rowNum = _titleArray.count;
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // "cell"というkeyでcellデータを取得
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    // cellデータが無い場合、UITableViewCellを生成して、"cell"というkeyでキャッシュする
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_subTitleArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.numberOfLines = 0;
    cell.imageView.image = [UIImage imageNamed:@"antenna.gif"];
    return cell;
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
 更新ボタンをタップしたときのアクション
 @param sender アクション
 */
- (IBAction)updateTableView:(id)sender {
    // iBeaconのレンジング開始処理
    [_central startRangingBeacons];
}

#pragma mark - other method
/**
 proximityの文字列変換処理
 @param proximity CLProximity型の距離情報
 @return 距離情報の文字列
 */
- (NSString *)getProximityString:(CLProximity)proximity
{
    NSString *proximityString;
    
    switch(proximity) {
        case CLProximityUnknown:
            proximityString = @"Unknown";
            break;
        case CLProximityImmediate:
            proximityString = @"Immediate";
            break;
        case CLProximityNear:
            proximityString = @"Near";
            break;
        case CLProximityFar:
            proximityString = @"Far";
            break;
        default:
            proximityString = @"";
            break;
    }
    
    return proximityString;
}

@end
