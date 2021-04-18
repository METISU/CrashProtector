//
//  CrashProtector+Deal.h
//  CrashProtector_Example
//
//  Created by METISU on 2021/4/11.
//  Copyright © 2021 METISU. All rights reserved.
//

#import <CrashProtector/CrashProtector.h>

NS_ASSUME_NONNULL_BEGIN

@interface CrashProtector (Deal)
+ (void)dealWithException:(NSException *)exception;
@end

NS_ASSUME_NONNULL_END
