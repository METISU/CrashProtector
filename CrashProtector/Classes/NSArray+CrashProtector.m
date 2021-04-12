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
        Class __NSPlaceholderArray = objc_getClass("__NSPlaceholderArray");
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSPlaceholderArray originalSel:@selector(initWithObjects:count:) swizzledSel:@selector(crashProtector_initWithObjects:count:)];
        
        Class __NSSingleObjectArrayI = objc_getClass("__NSSingleObjectArrayI");
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSSingleObjectArrayI originalSel:@selector(objectAtIndex:) swizzledSel:@selector(crashProtector_objectAtIndex:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSSingleObjectArrayI originalSel:@selector(getObjects:range:) swizzledSel:@selector(crashProtectorI_getObjects:range:)];
        
        Class __NSArrayI = objc_getClass("__NSArrayI");
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSArrayI originalSel:@selector(objectAtIndexedSubscript:) swizzledSel:@selector(crashProtector_objectAtIndexedSubscript:)];
        
        Class __NSArray = objc_getClass("NSArray");
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSArray originalSel:@selector(objectsAtIndexes:) swizzledSel:@selector(crashProtector_objectsAtIndexes:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSArray originalSel:@selector(getObjects:) swizzledSel:@selector(crashProtector_getObjects:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSArray originalSel:@selector(getObjects:range:) swizzledSel:@selector(crashProtector_getObjects:range:)];
    });
}

#pragma mark - __NSPlaceholderArray
- (instancetype)crashProtector_initWithObjects:(id _Nonnull const [])objects
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

#pragma mark - __NSSingleObjectArrayI
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

- (void)crashProtectorI_getObjects:(id  _Nonnull __unsafe_unretained [])objects range:(NSRange)range {
    @try {
        [self crashProtectorI_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

#pragma mark - __NSArrayI
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

#pragma mark - NSArray
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

- (void)crashProtector_getObjects:(id  _Nonnull __unsafe_unretained [])objects {
    @try {
        [self crashProtector_getObjects:objects];
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


@end
