//
//  CrashProtector+Deal.m
//  CrashProtector_Example
//
//  Created by METISU on 2021/4/11.
//  Copyright © 2021 METISU. All rights reserved.
//

#import "CrashProtector+Deal.h"

@implementation CrashProtector (Deal)
+ (void)dealWithException:(NSException *)exception {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"have a crash" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:sureAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:^{
    }];
    NSLog(@"%@", exception.reason);
    NSLog(@"%@", exception.callStackSymbols);
}
@end
