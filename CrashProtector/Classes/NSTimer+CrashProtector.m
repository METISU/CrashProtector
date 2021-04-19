//
//  NSTimer+CrashProtector.m
//  CrashProtector
//
//  Created by METISU on 2021/4/18.
//

#import "NSTimer+CrashProtector.h"
#import "NSObject+CrashProtector.h"
#import "CrashProtector.h"
#import <objc/runtime.h>

@interface CrashProtectorSubTarget : NSObject
@property (nonatomic, weak) id aTarget;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) SEL aSelector;
@property (nonatomic, weak) id userInfo;
@end

@implementation CrashProtectorSubTarget

+ (instancetype)subTargetWithTarget:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo {
    return [[self alloc] initWithTarget:aTarget selector:aSelector userInfo:userInfo];
}

- (instancetype)initWithTarget:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo {
    if (self = [super init]) {
        _aTarget = aTarget;
        _aSelector = aSelector;
        _userInfo = userInfo;
    }
    
    return self;
}

- (void)fireProxyTimer {
    if (self.aTarget) {
        if ([self.aTarget respondsToSelector:self.aSelector]) {
            [self.aTarget performSelector:self.aSelector withObject:self.timer];
        }
    } else {
        [self.timer invalidate];
    }
}

@end

@implementation NSTimer (CrashProtector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSTimer = object_getClass(NSTimer.class);
        
        [self crashProtector_swizzleInstanceMethodWithAClass:__NSTimer originalSel:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) swizzledSel:@selector(crashProtector_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
    });
}

+ (NSTimer *)crashProtector_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    NSTimer *timer;
    if (yesOrNo) {
        CrashProtectorSubTarget *subTarget = [CrashProtectorSubTarget subTargetWithTarget:aTarget selector:aSelector userInfo:userInfo];
        timer = [NSTimer crashProtector_scheduledTimerWithTimeInterval:ti target:subTarget selector:@selector(fireProxyTimer) userInfo:userInfo repeats:yesOrNo];
        subTarget.timer = timer;
    } else {
        timer = [NSTimer crashProtector_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
    
    return timer;
}


@end
