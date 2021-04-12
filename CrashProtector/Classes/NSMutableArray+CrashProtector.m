//
//  NSMutableArray+CrashProtector.m
//  CrashProtector
//
//  Created by Mac on 2021/4/11.
//

#import "NSMutableArray+CrashProtector.h"
#import "CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import <objc/runtime.h>

@implementation NSMutableArray (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self startCrashProtector];
    });
}

+ (void)startCrashProtector {
    [self crashProtector_swizzleInstanceMethodWithAClass:objc_getClass("__NSArrayM") originalSel:@selector(insertObject:atIndex:) swizzledSel:@selector(crashProtection_insertObject:atIndex:)];
}

- (void)crashProtection_insertObject:(id)anObject
                             atIndex:(NSUInteger)index {
    @try {
        [self crashProtection_insertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    }
}

@end
