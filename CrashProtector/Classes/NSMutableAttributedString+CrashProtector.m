//
//  NSMutableAttributedString+CrashProtector.m
//  CrashProtector
//
//  Created by Mac on 2021/4/13.
//

#import "NSMutableAttributedString+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import <objc/runtime.h>

@implementation NSMutableAttributedString (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSConcreteMutableAttributedString = objc_getClass("NSConcreteMutableAttributedString");
        
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSConcreteMutableAttributedString originalSel:@selector(initWithString:) swizzledSel:@selector(crashProtector_initWithString:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSConcreteMutableAttributedString originalSel:@selector(initWithString:attributes:) swizzledSel:@selector(crashProtector_initWithString:attributes:)];
    });
}

- (instancetype)crashProtector_initWithString:(NSString *)str {
    id instance = nil;
    
    @try {
        instance = [self crashProtector_initWithString:str];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        return instance;
    }
}

- (instancetype)crashProtector_initWithString:(NSString *)str attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    id instance = nil;
    
    @try {
        instance = [self crashProtector_initWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        return instance;
    }
}

@end
