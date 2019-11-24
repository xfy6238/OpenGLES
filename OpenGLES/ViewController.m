//
//  ViewController.m
//  OpenGLES
//
//  Created by 微光星芒 on 2019/3/9.
//  Copyright © 2019 微光星芒. All rights reserved.
//

#import "ViewController.h"
#import "GLBaseViewController.h"
#import "TranslateController.h"
#import "MatrixController.h"
#import "CamerController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *datasource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
    
    _datasource = [NSMutableArray array];
    NSString *str1 = @"OpenGL基础";
    NSString *str2 = @"形变";
    NSString *str3 = @"矩阵";
    NSString *str4 = @"摄像机";


    [_datasource addObject:str1];
    [_datasource addObject:str2];
    [_datasource addObject:str3];
    [_datasource addObject:str4];

}

//MARK: 表视图代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text  = _datasource[indexPath.row];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentStr = _datasource[indexPath.row];
    
    UIViewController *con;
    if ([currentStr containsString:@"基础"]) {
        con = [[GLBaseViewController alloc]init];
    }
    if ([currentStr containsString:@"形变"]) {
          con = [[TranslateController alloc]init];
      }
   if ([currentStr containsString:@"矩阵"]) {
         con = [[MatrixController alloc]init];
     }
    
    if ([currentStr containsString:@"摄像机"]) {
          con = [[CamerController alloc]init];
      }
    
    [self.navigationController pushViewController:con animated:YES];
}


@end
