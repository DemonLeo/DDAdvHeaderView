//
//  DDAdvHeaderView.m
//  DDAdvHeader
//
//  Created by Demon on 2021/2/6.
//

#import "DDAdvHeaderView.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "NSTimer+DDEx.h"

@interface DDAdvHeaderView()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;

/// 页码控制器
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nullable, nonatomic, strong) NSTimer *timer;

@end

@implementation DDAdvHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.scrollEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        _scrollView = scrollView;
        [self addSubview:scrollView];
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.mas_offset(0);
            
        }];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setTitle:@"关" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.height.and.width.mas_equalTo(30);
            
        }];
        
    }
    return self;
}

#pragma mark - set

-(void)setModelArray:(NSArray<DDAdvHeaderModel *> *)modelArray{
    
    _modelArray = modelArray;
    
    //清除旧数据
    [self removeAllSubviews];
    
    if (modelArray.count <= 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (modelArray.count == 1) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:modelArray.firstObject.imageUrl]];
            
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advImageViewAction)];
            [imageView addGestureRecognizer:tap];
            
            [self.scrollView addSubview:imageView];
            
            [self.timer setFireDate:[NSDate distantFuture]];
            
            self.pageControl.hidden = YES;
            
        }else{
            
            NSMutableArray *imageUrlArray = [NSMutableArray array];
            
            [imageUrlArray addObject:modelArray.lastObject.imageUrl];
            
            [modelArray enumerateObjectsUsingBlock:^(DDAdvHeaderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                @autoreleasepool {
                    [imageUrlArray addObject:obj.imageUrl];
                }
                
            }];
            
            [imageUrlArray addObject:modelArray.firstObject.imageUrl];
            
            [imageUrlArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                @autoreleasepool {
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    [imageView sd_setImageWithURL:[NSURL URLWithString:obj]];
                    
                    imageView.userInteractionEnabled = YES;
                    
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advImageViewAction)];
                    [imageView addGestureRecognizer:tap];

                    [self.scrollView addSubview:imageView];
                    
                }
                
            }];
            
            /// 设置UIScrollView的偏移量
               self.scrollView.contentSize = CGSizeMake((self.modelArray.count + 2) * self.scrollView.frame.size.width, 0);
               
               /// 设置UIScrollView的起始偏移距离（将第一张图片跳过）
               self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
            
            self.timer.fireDate = [NSDate date];
            
            self.pageControl.hidden = NO;
            
        }
        
        /// 图片总数
        self.pageControl.numberOfPages = self.modelArray.count;
        self.pageControl.currentPage = 0;
        
    });
    
    
    
}

#pragma mark - way
-(void)updateTime{
    
    NSInteger nextIndex = self.pageControl.currentPage;
    
    nextIndex++;
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * (nextIndex + 1), 0) animated:YES];
    
    self.pageControl.currentPage = nextIndex;
    
}

/// 删除所有子视图
- (void)removeAllSubviews {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - action
-(void)closeButtonAction{
    
    if (self.closeBlock) {
        self.closeBlock();
    }
    
}

-(void)advImageViewAction{
    
    if ([self.modelArray count] == 0) {
        return;
    }
    
    DDAdvHeaderModel *bannerModel = nil;
    
    if ([self.modelArray count] > self.pageControl.currentPage) {
        
        bannerModel = self.modelArray[self.pageControl.currentPage];
        
    }
    
    if (self.advClickBlock && bannerModel) {
        self.advClickBlock(bannerModel);
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    /// 当UIScrollView滑动到第一位停止时，将UIScrollView的偏移位置改变
    if (scrollView.contentOffset.x == 0) {
        scrollView.contentOffset = CGPointMake(self.modelArray.count * self.scrollView.frame.size.width, 0);
        self.pageControl.currentPage = self.modelArray.count;
    /// 当UIScrollView滑动到最后一位停止时，将UIScrollView的偏移位置改变
    } else if (scrollView.contentOffset.x == (self.modelArray.count + 1)* self.scrollView.frame.size.width) {
        scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = scrollView.contentOffset.x / self.scrollView.frame.size.width - 1;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.timer setFireDate:[NSDate date]];
    });
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    /// 当UIScrollView滑动到第一位停止时，将UIScrollView的偏移位置改变
    if (scrollView.contentOffset.x == 0) {
        scrollView.contentOffset = CGPointMake(self.modelArray.count * self.scrollView.frame.size.width, 0);
        self.pageControl.currentPage = self.modelArray.count;
    /// 当UIScrollView滑动到最后一位停止时，将UIScrollView的偏移位置改变
    } else if (scrollView.contentOffset.x == (self.modelArray.count + 1)* self.scrollView.frame.size.width) {
        scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = scrollView.contentOffset.x / self.scrollView.frame.size.width - 1;
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [_timer setFireDate:[NSDate distantFuture]];
    
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - lazy
-(UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 10)];
        
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}

- (NSTimer *)timer {
    if (!_timer) {
        __weak __typeof(self)weakSelf = self;
        NSTimer *timer = [NSTimer weakTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;

            if (strongSelf) {

                [strongSelf updateTime];

            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

@end
