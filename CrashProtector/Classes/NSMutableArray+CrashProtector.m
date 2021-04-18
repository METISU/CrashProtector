//
//  NSMutableArray+CrashProtector.m
//  CrashProtector
//
//  Created by METISU on 2021/4/11.
//

#import "NSMutableArray+CrashProtector.h"
#import "CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import <objc/runtime.h>

@implementation NSMutableArray (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSArrayM = objc_getClass("__NSArrayM");
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSArrayM originalSel:@selector(insertObject:atIndex:) swizzledSel:@selector(crashProtector_insertObject:atIndex:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSArrayM originalSel:@selector(removeObjectsInRange:) swizzledSel:@selector(crashProtector_removeObjectsInRange:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSArrayM originalSel:@selector(objectAtIndexedSubscript:) swizzledSel:@selector(crashProtector_objectAtIndexedSubscript:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSArrayM originalSel:@selector(objectAtIndex:) swizzledSel:@selector(crashProtector_objectAtIndex:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSArrayM originalSel:@selector(setObject:atIndexedSubscript:) swizzledSel:@selector(crashProtetor_setObject:atIndexedSubscript:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSArrayM originalSel:@selector(getObjects:range:) swizzledSel:@selector(crashProtector_getObjects:range:)];
        
        Class __NSMutableArray = objc_getClass("NSMutableArray");
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSMutableArray originalSel:@selector(removeObject:inRange:) swizzledSel:@selector(crashProtector_removeObject:inRange:)];
    });
}

#pragma mark - __NSArrayM
- (void)crashProtector_insertObject:(id)anObject
                             atIndex:(NSUInteger)index {
    @try {
        [self crashProtector_insertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

- (id)crashProtector_objectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    
    @try {
        object = [self crashProtector_objectAtIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        return object;
    }
}

- (id)crashProtector_objectAtIndex:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self crashProtector_objectAtIndex:index];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        return object;
    }
}

- (void)crashProtector_removeObjectsInRange:(NSRange)range {
    @try {
        [self crashProtector_removeObjectsInRange:range];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

- (void)crashProtetor_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @try {
        [self crashProtetor_setObject:obj atIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

- (void)crashProtector_getObjects:(id  _Nonnull __unsafe_unretained [])objects range:(NSRange)range {
    @try {
        [self crashProtector_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

#pragma mark - NSMutableArray
- (void)crashProtector_removeObject:(id)anObject inRange:(NSRange)range {
    @try {
        [self crashProtector_removeObject:anObject inRange:range];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

@end
