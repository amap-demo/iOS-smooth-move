//
//  PausableMovingAnnotation.m
//  iOS_movingAnnotation
//
//  Created by shaobin on 2018/3/5.
//  Copyright © 2018年 yours. All rights reserved.
//

#import "PausableMovingAnnotation.h"

@implementation PausableMovingAnnotation

- (void)step:(CGFloat)timeDelta {
    if(self.isPaused) {
        return;
    }
    
    [super step:timeDelta];
}

@end
