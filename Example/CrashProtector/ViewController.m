//
//  ViewController.m
//  CrashProtector
//
//  Created by METISU on 04/11/2021.
//  Copyright (c) 2021 METISU. All rights reserved.
//

#import "ViewController.h"

typedef enum : NSInteger {
    InsertNilInArrayCrashType = 0,
    OutOfRangeInArrayCrashType,
    OutOfRangesInArrayCrashType,
    ObjectAtIndexedSubscriptCrashType,
    ObjectCannotBeNilInArrayCrashType
} CrashType;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *typeArray;
@property (nonatomic, copy) NSDictionary *typeDic;
@property (nonatomic, strong) UITableView *demoTableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.typeArray = @[@(InsertNilInArrayCrashType), @(OutOfRangeInArrayCrashType), @(OutOfRangesInArrayCrashType), @(ObjectAtIndexedSubscriptCrashType), @(ObjectCannotBeNilInArrayCrashType)];
    self.typeDic = @{@(InsertNilInArrayCrashType) : @"Insert Nil In Array", @(OutOfRangeInArrayCrashType):@"index 2 beyond bounds [0 .. 0]", @(OutOfRangesInArrayCrashType):@"index 2 in index set beyond bounds [0 .. 0]", @(ObjectAtIndexedSubscriptCrashType):@"objectAtIndexedSubscript", @(ObjectCannotBeNilInArrayCrashType):@"object cannot be nil"};
    [self.view addSubview:self.demoTableView];
}

- (UITableView *)demoTableView {
    if (!_demoTableView) {
        _demoTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _demoTableView.delegate = self;
        _demoTableView.dataSource = self;
    }
    
    return _demoTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = UITableViewCell.new;
    cell.textLabel.text = self.typeDic[self.typeArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch ([self.typeArray[indexPath.row] integerValue]) {
        case InsertNilInArrayCrashType:
        {
            NSString *nilStr = nil;
            NSArray *array = @[@1, nilStr];
            NSLog(@"%@", array);
        }
            break;
        case OutOfRangeInArrayCrashType:
        {
            NSArray *array = @[@1];
            NSLog(@"%@", array[2]);
        }
            break;
        case OutOfRangesInArrayCrashType:
        {
            NSArray *array = @[@1];
            NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndex:2];
            [set addIndex:2];
            [array objectsAtIndexes:[set copy]];
            NSLog(@"%@", array);
        }
            break;
        case ObjectAtIndexedSubscriptCrashType:
        {
            NSArray *array = [[NSArray alloc] initWithObjects:@1, nil];
            NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndex:2];
            [set addIndex:2];
            [array objectAtIndexedSubscript:2];
            NSLog(@"%@", array);
        }
            break;
        case ObjectCannotBeNilInArrayCrashType:
        {
            NSMutableArray *array = NSMutableArray.new;
            NSString *nilStr = nil;
            [array addObject:nilStr];
            NSLog(@"%@", array);
        }
            break;
        default:
            break;
    }
}

@end
