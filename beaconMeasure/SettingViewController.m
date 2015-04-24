//
//  SettingViewController.m
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/17.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import "SettingViewController.h"

// デフォルトのUUID
static NSString *const defaultUUID = @"33B7DD31-897F-4357-B41E-0F1CE208DBCB";
// デフォルトのmajor
static NSInteger const defaultMajor = 0;
// デフォルトのminor
static NSInteger const defaultMinor = 0;

@interface SettingViewController()

/// UUIDを入力するテキストフィールド
@property (weak, nonatomic) IBOutlet UITextField *uuidTextField;
/// major値を入力するテキストフィールド
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
/// minor値を入力するテキストフィールド
@property (weak, nonatomic) IBOutlet UITextField *minorTextField;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // テキストフィールドにiBeaconの各パラメータ値を入力
    [self setInputTextField];
}

#pragma mark - action
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

#pragma mark - other method
/**
 画面遷移時にテキストフィールドにiBeaconの各パラメータ値を入力する処理
 */
- (void)setInputTextField
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [defaults objectForKey:@"uuid"];
    NSString *major = [defaults objectForKey:@"major"];
    NSString *minor = [defaults objectForKey:@"minor"];
    
    // テキストフィールドにUUIDを入力
    if(uuid.length > 0) {
        self.uuidTextField.text = uuid;
    } else {
        self.uuidTextField.text = defaultUUID;
    }
    
    // テキストフィールドにmajorを入力
    if(major.length > 0) {
        self.majorTextField.text = major;
    } else {
        self.majorTextField.text = [[NSString alloc] initWithFormat:@"%ld", (long)defaultMajor];
    }
    
    // テキストフィールドにminorを入力
    if(minor.length > 0) {
        self.minorTextField.text = minor;
    } else {
        self.minorTextField.text = [[NSString alloc] initWithFormat:@"%ld", (long)defaultMinor];
    }
}

@end
