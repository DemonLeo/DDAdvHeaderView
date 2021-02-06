//
//  DDAdvHeaderModel.h
//  DDAdvHeader
//
//  Created by Demon on 2021/2/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDAdvHeaderModel : NSObject

/// 图片链接
@property(nonatomic, copy) NSString *imageUrl;

/// 点击跳转链接
@property(nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
