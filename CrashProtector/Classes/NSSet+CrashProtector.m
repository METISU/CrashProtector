//
//  NSSet+CrashProtector.m
//  CrashProtector
//
//  Created by Mac on 2021/4/13.
//

#import "NSSet+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import <objc/runtime.h>

@implementation NSSet (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSPlaceholderSet = objc_getClass("__NSPlaceholderSet");
        
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSPlaceholderSet originalSel:@selector(initWithObjects:count:) swizzledSel:@selector(crashProtector_initWithObjects:count:)];
    });
}

- (instancetype)crashProtector_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id instance;
    
    @try {
        instance = [self crashProtector_initWithObjects:objects count:cnt];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
        
        int newCnt = 0; id  _Nonnull newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i]) {
                newObjects[newCnt] = objects[i];
                newCnt += 1;
            }
        }
        
        instance = [self crashProtector_initWithObjects:newObjects count:newCnt];
    } @finally {
        return instance;
    }
}

@end
