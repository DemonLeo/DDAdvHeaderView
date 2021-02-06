//
//  ViewController.m
//  DDAdvHeader
//
//  Created by Demon on 2021/2/6.
//

#import "ViewController.h"

#import "DDAdvHeaderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDAdvHeaderView *advHeaderView = [[DDAdvHeaderView alloc] init];
    advHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    [self.view addSubview:advHeaderView];
    
    [advHeaderView setCloseBlock:^{
       
        NSLog(@"点击关闭");
    }];
    
    [advHeaderView setAdvClickBlock:^(DDAdvHeaderModel * _Nonnull clickModel) {
       
        NSLog(@"点击模型 %@",clickModel);
        
    }];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *imageArray = @[
    @"https://t7.baidu.com/it/u=2397542458,3133539061&fm=193&f=GIF",
    @"https://t7.baidu.com/it/u=1956604245,3662848045&fm=193&f=GIF",
    ];
    
    [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        DDAdvHeaderModel *headerModel = [[DDAdvHeaderModel alloc] init];
        headerModel.url = @"";
        headerModel.imageUrl = obj;
        
        [array addObject:headerModel];
        
    }];
    
    advHeaderView.modelArray = array;
}


@end
