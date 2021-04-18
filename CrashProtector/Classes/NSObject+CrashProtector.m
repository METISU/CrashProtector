//
//  NSObject+CrashProtector.m
//  CrashProtector
//
//  Created by METISU on 2021/4/11.
//

#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import "CrashProtectorZoombie.h"
#import <objc/runtime.h>

@interface CrashProtector_KVOProxy : NSObject

@property (nonatomic, strong) NSMutableDictionary *infoDic;

@end

@implementation CrashProtector_KVOProxy

- (instancetype)init {
    if (self = [super init]) {
        self.infoDic = NSMutableDictionary.new;
    }
    
    return self;
}

- (BOOL)addMapInfoWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    @synchronized (self) {
        if (keyPath.length == 0) {
            // 返回YES走try catch，把错误抛出去
            return YES;
        }
        if ([self.infoDic.allKeys containsObject:keyPath]) {
            if ([self.infoDic[keyPath] containsObject:observer]) {
                return NO;
            }
            
            NSHashTable *table = self.infoDic[keyPath];
            if (table.count > 0) {
                if (![table containsObject:observer]) {
                    [table addObject:observer];
                    return NO;
                }
            }
        }
        
        
        NSHashTable *table = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:3];
        [table addObject:observer];
        self.infoDic[keyPath] = table;
        
        return YES;
    }
}

- (void)removeMapInfoObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    @synchronized (self) {
        NSHashTable *table = self.infoDic[keyPath];
        if (table) {
            [table removeObject:observer];
            if (table.count == 0) {
                [self.infoDic removeObjectForKey:keyPath];
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSHashTable *info = self.infoDic[keyPath];
    for (NSObject *object in info) {
        @try {
            if ([object respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]) {
                [object observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            }
        } @catch (NSException *exception) {
            [CrashProtector dealWithException:exception];
        } @finally {
            
        }
    }
}

@end

static void *crashProtector_KVOProtectorProxyKey = &crashProtector_KVOProtectorProxyKey;
static NSString *const crashProtector_KVODefenderValue = @"crashProtector__KVODefender";
static void *crashProtector_KVODefenderKey = &crashProtector_KVODefenderKey;

@implementation NSObject (CrashProtector)
+ (void)load {
    Class __NSObject = objc_getClass("NSObject");
    
    [self crashProtector_swizzleInstanceMethodWithAClass:__NSObject originalSel:@selector(setValue:forUndefinedKey:) swizzledSel:@selector(crashProtector_setValue:forUndefinedKey:)];
    [self crashProtector_swizzleInstanceMethodWithAClass:__NSObject originalSel:@selector(methodSignatureForSelector:) swizzledSel:@selector(crashProtector_methodSignatureForSelector:)];
    [self crashProtector_swizzleInstanceMethodWithAClass:__NSObject originalSel:@selector(forwardInvocation:) swizzledSel:@selector(crashProtector_forwardInvocation:)];
    
    // KVO
    [self crashProtector_swizzleInstanceMethodWithAClass:__NSObject originalSel:@selector(addObserver:forKeyPath:options:context:) swizzledSel:@selector(crashProtector_addObserver:forKeyPath:options:context:)];
    [self crashProtector_swizzleInstanceMethodWithAClass:__NSObject originalSel:@selector(removeObserver:forKeyPath:) swizzledSel:@selector(crashProtector_removeObserver:forKeyPath:)];
    [self crashProtector_swizzleInstanceMethodWithAClass:__NSObject originalSel:NSSelectorFromString(@"dealloc") swizzledSel:@selector(crashProtector_dealloc)];
}

static inline BOOL isSystemClass(Class cls) {
    BOOL isSystem = NO;
    NSString *className = NSStringFromClass(cls);
    if ([className hasPrefix:@"NS"] || [className hasPrefix:@"__NS"] || [className hasPrefix:@"OS_xpc"]) {
        isSystem = YES;
        return isSystem;
    }
    NSBundle *mainBundle = [NSBundle bundleForClass:cls];
    if (mainBundle == [NSBundle mainBundle]) {
        isSystem = NO;
    }else{
        isSystem = YES;
    }
    return isSystem;
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

- (CrashProtector_KVOProxy *)kvoProxy {
    CrashProtector_KVOProxy *_kvoProxy = objc_getAssociatedObject(self, &crashProtector_KVOProtectorProxyKey);
    if (!_kvoProxy) {
        _kvoProxy = CrashProtector_KVOProxy.new;
        objc_setAssociatedObject(self, &crashProtector_KVOProtectorProxyKey, _kvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _kvoProxy;
}

- (void)setKvoProxy:(CrashProtector_KVOProxy *)kvoProxy {
    objc_setAssociatedObject(self, &crashProtector_KVOProtectorProxyKey, kvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

#pragma mark - KVO
- (void)crashProtector_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    @try {
        if (!isSystemClass(self.class)) {
            objc_setAssociatedObject(self, crashProtector_KVODefenderKey, crashProtector_KVODefenderValue, OBJC_ASSOCIATION_RETAIN);
            if ([self.kvoProxy addMapInfoWithObserver:observer forKeyPath:keyPath]) {
                [self crashProtector_addObserver:self.kvoProxy forKeyPath:keyPath options:options context:context];
            }
        } else {
            [self crashProtector_addObserver:self.kvoProxy forKeyPath:keyPath options:options context:context];
        }
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

- (void)crashProtector_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    @try {
        [self crashProtector_removeObserver:self.kvoProxy forKeyPath:keyPath];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        if (!isSystemClass(self.class)) {
            [self.kvoProxy removeMapInfoObserver:observer forKeyPath:keyPath];
        }
    }
}

- (void)crashProtector_dealloc {
    if (!isSystemClass(self.class)) {
        if ([(NSString *)objc_getAssociatedObject(self, crashProtector_KVODefenderKey) isEqualToString:crashProtector_KVODefenderValue]) {
            if (self.kvoProxy.infoDic.allKeys.count > 0) {
                for (NSString *keyPath in self.kvoProxy.infoDic.allKeys) {
                    [self removeObserver:self.kvoProxy forKeyPath:keyPath];
                }
            }
        }
        [[CrashProtectorZoombie sharedInstance] handleDeallocObject:self];
        
    } else {
        [self crashProtector_dealloc];
    }
}

@end
