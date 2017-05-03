//
//  ViewController.m
//  LCRefreshDemo
//
//  Created by lcc on 2017/4/28.
//  Copyright © 2017年 early bird international. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <MJRefresh.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIImageView *topImg;

@property (nonatomic,assign) NSInteger rowNum;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUI];
}

- (void)setUI{
    
    
    self.rowNum = 0;
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topImg];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        
    }];
    
    [self.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(202);
    }];
    
    
    //模仿网络请求访问
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.rowNum = 20;
        [self.tableView reloadData];
        
    });
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark- tableView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //页面没有加载的时候不进行调整
    if (!self.view.window) {
        
        return;
    }
    
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    //上拉加载更多（头部还没有隐藏），动态移动header
    if (offsetY > -202 & offsetY < 0) {
        
        [self.topImg mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(-offsetY - 202);
        }];
        
    }else if(offsetY > 0){ //头部隐藏，固定头部位置
        
        [self.topImg mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(-202);
        }];
        
    }else{ //下拉刷新
        
        [self.topImg mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
        }];
        
    }
    
    
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    
    cell.textLabel.text = @"我是cell";
    
    return cell;
}



#pragma -mark- lazy load

- (UIImageView *)topImg{
    
    if (!_topImg) {
        _topImg = [UIImageView new];
        _topImg.contentMode = UIViewContentModeScaleAspectFill;
        _topImg.layer.masksToBounds = YES;
        _topImg.image = [UIImage imageNamed:@"timg.jpg"];
    }
    
    return _topImg;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        MJWeakSelf;
        
        _tableView = [UITableView new];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        //设置内容偏移
        _tableView.contentInset = UIEdgeInsetsMake(202, 0, 0, 0);
        //设置滚动条偏移
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(202, 0, 0, 0);
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            weakSelf.rowNum = 10;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView.mj_header endRefreshing];
            });
            
            [weakSelf.tableView reloadData];
            
        }];
        
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            weakSelf.rowNum += 10;
            [weakSelf.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.tableView.mj_footer endRefreshing];
                
            });
            
            
        }];
        
        
        
        
    }
    
    
    return _tableView;
}


@end
