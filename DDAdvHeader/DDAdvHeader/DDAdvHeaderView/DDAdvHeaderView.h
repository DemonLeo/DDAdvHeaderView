//
//  DDAdvHeaderView.h
//  DDAdvHeader
//
//  Created by Demon on 2021/2/6.
//

#import <UIKit/UIKit.h>

#import "DDAdvHeaderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDAdvHeaderView : UIView

/// 点击回调
@property(nonatomic, copy) void (^advClickBlock)(DDAdvHeaderModel *clickModel);

//关闭回调
@property(nonatomic, copy) void (^closeBlock)(void);

//模型数组
@property(nonatomic, strong) NSArray<DDAdvHeaderModel *> *modelArray;


@end

NS_ASSUME_NONNULL_END
