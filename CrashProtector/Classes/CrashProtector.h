//
//  CrashProtector.h
//  CrashProtector
//
//  Created by METISU on 2021/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CrashProtector : NSObject
/// AOP操作
/// @param exception 异常
+ (void)dealWithException:(NSException *)exception;

@end

NS_ASSUME_NONNULL_END
