//
//  NSTimerViewController.m
//  CrashProtector_Example
//
//  Created by METISU on 2021/4/18.
//  Copyright © 2021 erchuan. All rights reserved.
//

#import "NSTimerViewController.h"

@interface NSTimerViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation NSTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(selectWithTimer:) userInfo:@{@1:@2} repeats:YES];
    [self.timer fire];
}

- (void)selectWithTimer:(NSTimer *)timer {
    NSLog(@"%@", timer.userInfo);
}

@end
