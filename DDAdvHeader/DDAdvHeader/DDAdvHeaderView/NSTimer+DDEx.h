//
//  NSTimer+DDEx.h
//  DDAdvHeader
//
//  Created by Demon on 2021/2/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (DDEx)

/**
 生成计时器
 
 @param interval 计时间隔
 @param repeats 是否重复
 @param block 每次执行的操作
 @return 实例
 */
+ (nonnull NSTimer *)weakTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(nullable void(^)(NSTimer * _Nonnull timer))block;
   

@end

NS_ASSUME_NONNULL_END
