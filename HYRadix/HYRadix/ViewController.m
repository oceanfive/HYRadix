//
//  ViewController.m
//  HYRadix
//
//  Created by ocean on 2017/11/14.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "ViewController.h"
#import "HYRadix.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSString *radixValue = @"af1.1123";
//    NSString *decimal = [HYRadix hy_convertToDecimalFromHexadecimal:radixValue];
//    NSString *radixValueTwo = [HYRadix hy_convertToHexadecimalFromDecimal:decimal];
//
//    NSLog(@"radixValue:%@", radixValue);
//    NSLog(@"decimal:%@", decimal);
//    NSLog(@"radixValueTwo:%@", radixValueTwo);

    
//    NSString *radixValue = @"1011001001.100100";
//    NSString *decimal = [HYRadix hy_convertToDecimalFromBinary:radixValue];
//    NSString *radixValueTwo = [HYRadix hy_convertToBinaryFromDecimal:decimal];
//
//    NSLog(@"radixValue:%@", radixValue);
//    NSLog(@"decimal:%@", decimal);
//    NSLog(@"radixValueTwo:%@", radixValueTwo);
//
    
    NSString *radixValue = @"1011001001.100100";
    NSString *decimal = [HYRadix hy_convertToHexadecimalFromBinary:radixValue];
    NSString *radixValueTwo = [HYRadix hy_convertToBinaryFromHexadecimal:decimal];
    
    NSLog(@"radixValue:%@", radixValue);
    NSLog(@"decimal:%@", decimal);
    NSLog(@"radixValueTwo:%@", radixValueTwo);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
