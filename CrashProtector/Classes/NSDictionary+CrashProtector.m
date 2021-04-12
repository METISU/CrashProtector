//
//  NSDictionary+CrashProtector.m
//  CrashProtector
//
//  Created by Mac on 2021/4/12.
//

#import "NSDictionary+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import <objc/runtime.h>

@implementation NSDictionary (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSPlaceholderDictionary = objc_getClass("__NSPlaceholderDictionary");
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSPlaceholderDictionary originalSel:@selector(initWithObjects:forKeys:count:) swizzledSel:@selector(crashProtector_initWithObjects:forKeys:count:)];
    });
}

- (instancetype)crashProtector_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    id instance = nil;
    
    @try {
        instance = [self crashProtector_initWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
        
        NSInteger newCnt = 0;
        id _Nonnull newObject[cnt];
        id<NSCopying>  _Nonnull newKeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (keys[i] && objects[i]) {
                newObject[newCnt] = objects[i];
                newKeys[newCnt] = keys[i];
                newCnt++;
            }
        }
        
        instance = [self crashProtector_initWithObjects:newObject forKeys:newKeys count:newCnt];
    } @finally {
        return instance;
    }
}

@end
