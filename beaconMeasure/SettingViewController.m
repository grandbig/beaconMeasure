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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"確認"
                                                                                 message:@"パラメータを保存しますか？"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 端末内部に各パラメータを保存
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:uuid forKey:@"uuid"];
            [defaults setObject:major forKey:@"major"];
            [defaults setObject:minor forKey:@"minor"];
            [defaults synchronize];
            
            // 結果用アラートの生成
            UIAlertController *resultAlertController = [UIAlertController alertControllerWithTitle:@"確認"
                                                                                           message:@"パラメータを保存しました。"
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [resultAlertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 何もしない
            }]];
            
            // アラートの表示
            [self presentViewController:resultAlertController animated:YES completion:nil];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // 何もしない
        }]];
        
        // アラートの表示
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // 各パラメータがテキストフィールドに入力されていない場合
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"確認"
                                                                                 message:@"正しい値を入力してください。"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 何もしない
        }]];
        
        // アラートの表示
        [self presentViewController:alertController animated:YES completion:nil];
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

/**
 UUIDのテキストフィールド入力時にEnterをタップしたときのアクション
 @param sender アクション
 */
- (IBAction)exitInputUUID:(id)sender {
    // キーボードを閉じる処理
    [sender resignFirstResponder];
}

/**
 majorのテキストフィールド入力時にEnterをタップしたときのアクション
 @param sender アクション
 */
- (IBAction)exitInputMajor:(id)sender {
    // キーボードを閉じる処理
    [sender resignFirstResponder];
}

/**
 minorのテキストフィールド入力時にEnterをタップしたときのアクション
 @param sender アクション
 */
- (IBAction)exitInputMinor:(id)sender {
    // キーボードを閉じる処理
    [sender resignFirstResponder];
}

- (IBAction)onSingleTap:(UITapGestureRecognizer *)sender {
    // キーボードを閉じる処理
    [self.view endEditing:YES];
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
