//
//  NSMutableString+CrashProtector.m
//  CrashProtector
//
//  Created by METISU on 2021/4/12.
//

#import "NSMutableString+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import <objc/runtime.h>

@implementation NSMutableString (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSCFString = objc_getClass("__NSCFString");
        
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSCFString originalSel:@selector(replaceCharactersInRange:withString:) swizzledSel:@selector(crashProtector_replaceCharactersInRange:withString:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSCFString originalSel:@selector(insertString:atIndex:) swizzledSel:@selector(crashProtector_insertString:atIndex:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSCFString originalSel:@selector(deleteCharactersInRange:) swizzledSel:@selector(crashProtector_deleteCharactersInRange:)];
    });
}

#pragma mark - __NSCFString
- (void)crashProtector_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        [self crashProtector_replaceCharactersInRange:range withString:aString];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

- (void)crashProtector_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    @try {
        [self crashProtector_insertString:aString atIndex:loc];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

- (void)crashProtector_deleteCharactersInRange:(NSRange)range {
    @try {
        [self crashProtector_deleteCharactersInRange:range];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        
    }
}

@end
