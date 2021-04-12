#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CrashProtector.h"
#import "NSArray+CrashProtector.h"
#import "NSDictionary+CrashProtector.h"
#import "NSMutableArray+CrashProtector.h"
#import "NSMutableDictionary+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "NSString+CrashProtector.h"

FOUNDATION_EXPORT double CrashProtectorVersionNumber;
FOUNDATION_EXPORT const unsigned char CrashProtectorVersionString[];

