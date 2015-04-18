//
//  SettingViewController.m
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/17.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController()

/// UUIDを入力するテキストフィールド
@property (weak, nonatomic) IBOutlet UITextField *uuidTextField;
/// major値を入力するテキストフィールド
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
/// minor値を入力するテキストフィールド
@property (weak, nonatomic) IBOutlet UITextField *minorTextField;

@end

@implementation SettingViewController

/**
 Saveボタンをタップしたときのアクション
 @param sender アクション
 */
- (IBAction)saveParameters:(id)sender {
    // テキストフィールドに入力された値を取得
    NSString *uuid = self.uuidTextField.text;
    NSString *major = self.majorTextField.text;
    NSString *minor = self.minorTextField.text;
    
    if(uuid.length > 0 && major.length > 0 && minor.length > 0) {
        // 各パラメータがテキストフィールドに入力されている場合
        // 端末内部に各パラメータを保存
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:uuid forKey:@"uuid"];
        [defaults setObject:major forKey:@"major"];
        [defaults setObject:minor forKey:@"minor"];
        [defaults synchronize];
    } else {
        // 各パラメータがテキストフィールドに入力されていない場合
        // TODO:アラートを表示
    }
}

/**
 戻るボタンをタップしたときのアクション
 @param sender アクション
 */
- (IBAction)backToViewController:(id)sender {
    // 画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
