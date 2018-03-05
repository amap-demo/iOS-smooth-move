//
//  PausableMovingAnnotation.h
//  iOS_movingAnnotation
//
//  Created by shaobin on 2018/3/5.
//  Copyright © 2018年 yours. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface PausableMovingAnnotation : MAAnimatedAnnotation

@property (nonatomic, assign) BOOL isPaused; //默认NO

@end
