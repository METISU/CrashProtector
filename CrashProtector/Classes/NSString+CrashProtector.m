//
//  NSString+CrashProtector.m
//  CrashProtector
//
//  Created by METISU on 2021/4/12.
//

#import "NSString+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import <objc/runtime.h>

@implementation NSString (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        Class __NSCFConstantString = objc_getClass("__NSCFString");
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSCFConstantString originalSel:@selector(characterAtIndex:) swizzledSel:@selector(crashProtector_characterAtIndex:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSCFConstantString originalSel:@selector(substringToIndex:) swizzledSel:@selector(crashProtector_substringToIndex:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSCFConstantString originalSel:@selector(substringFromIndex:) swizzledSel:@selector(crashProtector_substringFromIndex:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSCFConstantString originalSel:@selector(substringWithRange:) swizzledSel:@selector(crashProtector_substringWithRange:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSCFConstantString originalSel:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) swizzledSel:@selector(crashProtector_stringByReplacingOccurrencesOfString:withString:options:range:)];
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSCFConstantString originalSel:@selector(stringByReplacingCharactersInRange:withString:) swizzledSel:@selector(crashProtector_stringByReplacingCharactersInRange:withString:)];
    });
}

#pragma mark - __NSCFString
- (unichar)crashProtector_characterAtIndex:(NSUInteger)index {
    unichar c;
    
    @try {
        c = [self crashProtector_characterAtIndex:index];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        return c;
    }
}

- (NSString *)crashProtector_substringToIndex:(NSUInteger)to {
    NSString *str = nil;
    
    @try {
        str = [self crashProtector_substringToIndex:to];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        return str;
    }
}

- (NSString *)crashProtector_substringFromIndex:(NSUInteger)from {
    NSString *str = nil;
    
    @try {
        str = [self crashProtector_substringFromIndex:from];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        return str;
    }
}

- (NSString *)crashProtector_substringWithRange:(NSRange)range {
    NSString *str = nil;
    
    @try {
        str = [self crashProtector_substringWithRange:range];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        return str;
    }
}

- (NSString *)crashProtector_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    NSString *str = nil;
    
    @try {
        str = [self crashProtector_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        if (str) {
            return str;
        }
        
        return self;
    }
}

- (NSString *)crashProtector_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    NSString *str = nil;
    
    @try {
        str = [self crashProtector_stringByReplacingCharactersInRange:range withString:replacement];
    } @catch (NSException *exception) {
        [CrashProtector dealWithException:exception];
    } @finally {
        if (str) {
            return str;
        }
        
        return self;
    }
}
@end
