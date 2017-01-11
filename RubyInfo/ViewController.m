//
//  ViewController.m
//  RubyInfo
//
//  Created by tyhmeng on 17/1/11.
//  Copyright © 2017年 tyhmeng. All rights reserved.
//

#import "ViewController.h"
#import "RubyPerson.h"
#import "RubyPersonTool.h"

@interface ViewController ()<UISearchBarDelegate>
//添加一个数组用来保存person
@property (nonatomic,strong) NSArray *persons;

@end

@implementation ViewController

- (NSArray *)persons {
    if (_persons == nil) {
        _persons = [RubyPersonTool query];
    }
    return _persons;

}

- (void)viewDidLoad {
    [super viewDidLoad];
//添加一个搜索框
    
    UISearchBar *sBar = [[UISearchBar alloc]init];
    sBar.frame = CGRectMake(0, 0, 300, 44);
    sBar.delegate = self;
    self.navigationItem.titleView = sBar;

}

//tableview数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _persons.count;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

//    设置每个cell值
//    先取出数据模型
    RubyPerson *per = self.persons[indexPath.row];
    cell.textLabel.text = per.name;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"年龄%d岁",per.age];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

- (IBAction)add:(UIBarButtonItem *)sender {
         // 初始化一些假数据
         NSArray *names = @[@"三生三世", @"王菲", @"钟汉良", @"孤芳不自赏", @"天气", @"赵薇", @"林心如", @"三生三世冰", @"新冰", @"李晨", @"王一伦", @"杨幂", @"张赵薇心"];
    for (int i = 0; i<20; i++) {
            RubyPerson *p = [[RubyPerson alloc] init];
            p.name = [NSString stringWithFormat:@"%@-%d", names[arc4random_uniform(names.count)], arc4random_uniform(100)];
            p.age = arc4random_uniform(20) + 20;
            [RubyPersonTool save:p];
        }
    
    
}
#pragma mark -- 搜索框代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    self.persons = [RubyPersonTool queryWithCondition:searchText];
    
//刷新表格
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];



}

@end
