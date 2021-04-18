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
#import "NSAttributedString+CrashProtector.h"
#import "NSDictionary+CrashProtector.h"
#import "NSMutableArray+CrashProtector.h"
#import "NSMutableAttributedString+CrashProtector.h"
#import "NSMutableDictionary+CrashProtector.h"
#import "NSMutableString+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "NSSet+CrashProtector.h"
#import "NSString+CrashProtector.h"
#import "NSTimer+CrashProtector.h"

FOUNDATION_EXPORT double CrashProtectorVersionNumber;
FOUNDATION_EXPORT const unsigned char CrashProtectorVersionString[];

