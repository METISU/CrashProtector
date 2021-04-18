//
//  CrashProtectorZoombie.h
//  CrashProtector
//
//  Created by METISU on 2021/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CrashProtectorZoombie : NSObject
+ (instancetype)sharedInstance;

- (void)handleDeallocObject:(__unsafe_unretained id)object;
@end

NS_ASSUME_NONNULL_END
