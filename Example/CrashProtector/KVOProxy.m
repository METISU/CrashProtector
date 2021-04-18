//
//  KVOProxy.m
//  CrashProtector_Example
//
//  Created by METISU on 2021/4/17.
//  Copyright © 2021 erchuan. All rights reserved.
//

#import "KVOProxy.h"
#import "ViewController.h"

@implementation KVOProxy
- (instancetype)init {
    self = [super init];
    if (self) {
        self.ctr = ViewController.new;
        self.ctr2 = ViewController.new;
        [self.ctr addObserver:self forKeyPath:@"view.tag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.ctr addObserver:self forKeyPath:@"view.tag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.ctr.view.tag = 2;
        self.ctr.view.tag = 2;
//        [self.ctr removeObserver:self forKeyPath:@"view.tag"];
//        [self.ctr removeObserver:self forKeyPath:@"view.tag"];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", context);
}
@end
