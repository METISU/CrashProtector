//
//  NSMutableDictionary+CrashProtector.m
//  CrashProtector
//
//  Created by METISU on 2021/4/12.
//

#import "NSMutableDictionary+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSDictionaryM = objc_getClass("__NSDictionaryM");
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSDictionaryM originalSel:@selector(setObject:forKeyedSubscript:) swizzledSel:@selector(crashProtector_setObject:forKeyedSubscript:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSDictionaryM originalSel:@selector(setObject:forKey:) swizzledSel:@selector(crashProtector_setObject:forKey:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSDictionaryM originalSel:@selector(removeObjectForKey:) swizzledSel:@selector(crashProtector_removeObjectForKey:)];
    });
}

#pragma mark - __NSDictionaryM
- (void)crashProtector_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    @try {
        [self crashProtector_setObject:obj forKeyedSubscript:key];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

- (void)crashProtector_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self crashProtector_setObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

- (void)crashProtector_removeObjectForKey:(id)aKey {
    @try {
        [self crashProtector_removeObjectForKey:aKey];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

@end
