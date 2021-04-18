//
//  CrashProtectorZoombie.m
//  CrashProtector
//
//  Created by METISU on 2021/4/18.
//

#import "CrashProtectorZoombie.h"
#import <objc/runtime.h>

@implementation CrashProtectorZoombie
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CrashProtectorZoombie *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = CrashProtectorZoombie.new;
    });
    
    return sharedInstance;
}

- (void)handleDeallocObject:(__unsafe_unretained id)object {

    // 指向动态生成的类，用 _GHLZoombie_ 拼接原有类名
    const char *clsName = class_getName(object_getClass(object));
    const char *zoombizPrx = "_CrashProtecotrZoombie_";
    char buff[1024];
    const char *zombieClassName = strcat(strcpy(buff, zoombizPrx), clsName);
//    free(buff);
    Class zombieCls = objc_lookUpClass(zombieClassName);
    if(zombieCls) return;
    zombieCls = objc_allocateClassPair([NSObject class], zombieClassName, 0);;
    
    objc_registerClassPair(zombieCls);
    class_addMethod([zombieCls class], @selector(forwardingTargetForSelector:), (IMP)forwardingTargetForSelector, "v@:@");

    object_setClass(object, zombieCls);
}

void forwardingTargetForSelector(id object, SEL _cmd, SEL aSelector) {

    NSString *className = NSStringFromClass([object class]);
    NSString *realClass = [className stringByReplacingOccurrencesOfString:@"_CrashProtecotrZoombie_" withString:@""];

    NSLog(@"[%@ %@] message sent to deallocated instance %@", realClass, NSStringFromSelector(aSelector), object);
}
@end
