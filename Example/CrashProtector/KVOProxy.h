//
//  KVOProxy.h
//  CrashProtector_Example
//
//  Created by METISU on 2021/4/17.
//  Copyright © 2021 erchuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ViewController;

@interface KVOProxy : NSObject
@property (nonatomic, strong) ViewController *ctr;
@property (nonatomic, strong) ViewController *ctr2;
@property (nonatomic, assign) int age;
@end

NS_ASSUME_NONNULL_END
