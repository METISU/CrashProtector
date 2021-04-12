//
//  NSObject+CrashProtector.h
//  CrashProtector
//
//  Created by Mac on 2021/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CrashProtector)
+ (void)crashProtector_swizzleInstanceMethodWithAClass:(Class)aClass originalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel;
@end

NS_ASSUME_NONNULL_END
