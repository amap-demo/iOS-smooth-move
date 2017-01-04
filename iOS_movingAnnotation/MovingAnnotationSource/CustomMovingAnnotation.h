//
//  CustomMovingAnnotation.h
//  iOS_movingAnnotation
//
//  Created by shaobin on 17/1/4.
//  Copyright © 2017年 yours. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

typedef void (^CustomMovingAnnotationCallback)(CLLocationCoordinate2D curLocation);

@interface CustomMovingAnnotation : MAAnimatedAnnotation

- (CLLocationDirection)rotateDegree;

@end
