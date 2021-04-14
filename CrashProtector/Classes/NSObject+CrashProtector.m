//
//  NSObject+CrashProtector.m
//  CrashProtector
//
//  Created by Mac on 2021/4/11.
//

#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import <objc/runtime.h>

@implementation NSObject (CrashProtector)
+ (void)load {
    Class __NSObject = objc_getClass("NSObject");
    
    [self crashProtector_swizzleInstanceMethodWithAClass:__NSObject originalSel:@selector(setValue:forUndefinedKey:) swizzledSel:@selector(crashProtector_setValue:forUndefinedKey:)];
    [self crashProtector_swizzleInstanceMethodWithAClass:__NSObject originalSel:@selector(methodSignatureForSelector:) swizzledSel:@selector(crashProtector_methodSignatureForSelector:)];
    [self crashProtector_swizzleInstanceMethodWithAClass:__NSObject originalSel:@selector(forwardInvocation:) swizzledSel:@selector(crashProtector_forwardInvocation:)];
}

+ (void)crashProtector_swizzleInstanceMethodWithAClass:(Class)aClass originalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel {
    Method originalMethod = class_getInstanceMethod(aClass, originalSel);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSel);
    
    if (class_addMethod(aClass, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(aClass, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - __NSObject
- (void)crashProtector_setValue:(id)value forUndefinedKey:(NSString *)key {
    @try {
        [self crashProtector_setValue:value forUndefinedKey:key];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

- (NSMethodSignature *)crashProtector_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [self crashProtector_methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return signature;
}

- (void)crashProtector_forwardInvocation:(NSInvocation *)anInvocation {
    @try {
        [self crashProtector_forwardInvocation:anInvocation];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {

    }
}

@end
