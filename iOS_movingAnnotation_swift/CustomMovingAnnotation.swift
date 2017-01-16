//
//  CustomMovingAnnotation.swift
//  iOS_movingAnnotation
//
//  Created by shaobin on 17/1/16.
//  Copyright © 2017年 yours. All rights reserved.
//

import UIKit

typealias CustomMovingAnnotationCallback = () -> Void

class CustomMovingAnnotation: MAAnimatedAnnotation {
    var stepCallback : CustomMovingAnnotationCallback = {}
    
    override func step(_ timeDelta: CGFloat) {
        super.step(timeDelta)
        self.stepCallback()
    }
    
    override func rotateDegree() -> CLLocationDirection {
        return 0
    }
}
