//
//  CrashProtectorZoombie.m
//  CrashProtector
//
//  Created by METISU on 2021/4/18.
//

#import "CrashProtectorZoombie.h"
#import <objc/runtime.h>

@implementation CrashProtectorZoombie
{
    NSMutableArray *_zombieList;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CrashProtectorZoombie *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = CrashProtectorZoombie.new;
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _zombieList = NSMutableArray.new;
    }
    
    return self;
}

- (void)handleDeallocObject:(__unsafe_unretained id)object {

    // 指向动态生成的类，用 _CrashProtecotrZoombie_ 拼接原有类名
    const char *clsName = class_getName(object_getClass(object));
    const char *zoombizPrx = "_CrashProtecotrZoombie_";
    char buff[1024];
    const char *zombieClassName = strcat(strcpy(buff, zoombizPrx), clsName);

    Class zombieCls = objc_lookUpClass(zombieClassName);
    if(zombieCls) return;
    zombieCls = objc_allocateClassPair([NSObject class], zombieClassName, 0);;
    
    objc_registerClassPair(zombieCls);
    
    class_addMethod([zombieCls class], @selector(forwardingTargetForSelector:), (IMP)forwardingTargetForSelector, "v@:@");
    
    object_setClass(object, zombieCls);
    if (_zombieList.count < 10) {
        [_zombieList addObject:object];
    } else {
        id _object = _zombieList.firstObject;
        [_zombieList removeObject:_object];
        if ([_object respondsToSelector:@selector(crashProtector_dealloc)]) {
            [_object performSelector:@selector(crashProtector_dealloc)];
        }
        
        [_zombieList addObject:object];
    }
}

void forwardingTargetForSelector(id object, SEL _cmd, SEL aSelector) {

    NSString *className = NSStringFromClass([object class]);
    NSString *realClass = [className stringByReplacingOccurrencesOfString:@"_CrashProtecotrZoombie_" withString:@""];

    NSLog(@"[%@ %@] message sent to deallocated instance %@", realClass, NSStringFromSelector(aSelector), object);
}
@end
