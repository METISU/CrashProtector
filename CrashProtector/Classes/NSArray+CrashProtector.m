//
//  NSArray+CrashProtector.m
//  CrashProtector
//
//  Created by Mac on 2021/4/11.
//

#import "NSArray+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import <objc/runtime.h>

@implementation NSArray (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self startCrashProtector];
    });
}

+ (void)startCrashProtector {
    [self crashProtector_swizzleInstanceMethodWithAClass:objc_getClass("__NSPlaceholderArray") originalSel:@selector(initWithObjects:count:) swizzledSel:@selector(crashProtector_initWithObjects:count:)];
    [self crashProtector_swizzleInstanceMethodWithAClass:objc_getClass("__NSSingleObjectArrayI") originalSel:@selector(objectAtIndex:) swizzledSel:@selector(crashProtector_objectAtIndex:)];
    [self crashProtector_swizzleInstanceMethodWithAClass:objc_getClass("__NSArrayI") originalSel:@selector(objectAtIndexedSubscript:) swizzledSel:@selector(crashProtector_objectAtIndexedSubscript:)];
    [self crashProtector_swizzleInstanceMethodWithAClass:objc_getClass("NSArray") originalSel:@selector(objectsAtIndexes:) swizzledSel:@selector(crashProtector_objectsAtIndexes:)];
}

- (instancetype)crashProtector_initWithObjects:(id _Nonnull const *)objects
                                         count:(NSUInteger)cnt {
    id instance = nil;
    
    @try {
        instance = [self crashProtector_initWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
        
        NSInteger newCnt = 0;
        id _Nonnull newInstance[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newInstance[newCnt] = objects[i];
                newCnt++;
            }
        }
        instance = [self crashProtector_initWithObjects:newInstance count:newCnt];
    }
    @finally {
        return instance;
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

- (NSArray *)crashProtector_objectsAtIndexes:(NSIndexSet *)indexes {
    id array = nil;
    
    @try {
        array = [self crashProtector_objectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
        
        NSMutableIndexSet *newIndexes = NSMutableIndexSet.new;
        
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < self.count) {
                [newIndexes addIndex:idx];
            }
        }];
        
        if (newIndexes.count > 0) {
            array = [self crashProtector_objectsAtIndexes:[newIndexes copy]];
        }
    } @finally {
        return array;
    }
}

@end
