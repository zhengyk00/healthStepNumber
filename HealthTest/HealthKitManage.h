//
//  HealthKitManage.h
//  HealthTest
//
//  Created by BJ on 2017/6/14.
//  Copyright © 2017年 BJHealthTest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <UIKit/UIDevice.h>

#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define CustomHealthErrorDomain @"com.sdqt.healthError"

@interface HealthKitManage : NSObject

@property (nonatomic, strong) HKHealthStore *healthStore;

+(id)shareInstance;

/*
 *  @brief  检查是否支持获取健康数据
 */
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;

//获取步数
- (void)getStepCount:(void(^)(double value, NSError *error))completion;


//获取公里数
- (void)getDistance:(void(^)(double value, NSError *error))completion;

@end
