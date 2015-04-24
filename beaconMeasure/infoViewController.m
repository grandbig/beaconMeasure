//
//  infoViewController.m
//  beaconMeasure
//
//  Created by 加藤 雄大 on 2015/04/20.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

#import "infoViewController.h"

@interface infoViewController()<UITableViewDataSource, UITableViewDelegate>

/// テーブルビュー
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
/// 各セルのタイトルを保存する配列
@property (strong, nonatomic) NSArray *titleArray;

@end

@implementation infoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _titleArray = @[@"Licence"];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // "cell"というkeyでcellデータを取得
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    // cellデータが無い場合、UITableViewCellを生成して、"cell"というkeyでキャッシュする
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

// セルが選択された場合の処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
            [self performSegueWithIdentifier:@"LicenceSegue" sender:self];
            break;
        case 1:
            break;
        default:
            break;
    }
    
    // セルの選択状態を解除
    [_infoTableView deselectRowAtIndexPath:[_infoTableView indexPathForSelectedRow] animated:NO];
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
@end
