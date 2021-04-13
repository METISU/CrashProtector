//
//  NSAttributedString+CrashProtector.m
//  CrashProtector
//
//  Created by Mac on 2021/4/13.
//

#import "NSAttributedString+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import <objc/runtime.h>

@implementation NSAttributedString (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSConcreteAttributedString = objc_getClass("NSConcreteAttributedString");
        
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSConcreteAttributedString originalSel:@selector(initWithString:) swizzledSel:@selector(crashProtector_initWithString:)];
    });
}

#pragma mark - NSConcreteAttributedString
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

@end
