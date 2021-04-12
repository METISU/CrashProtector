//
//  NSObject+CrashProtector.m
//  CrashProtector
//
//  Created by Mac on 2021/4/11.
//

#import "NSObject+CrashProtector.h"
#import <objc/runtime.h>

@implementation NSObject (CrashProtector)
+ (void)crashProtector_swizzleInstanceMethodWithAClass:(Class)aClass originalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel {
    Method originalMethod = class_getInstanceMethod(aClass, originalSel);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSel);
    
    if (class_addMethod(aClass, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(aClass, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
