# iOS_smooth_move
annotation移动及转向动画

### 前述

- [高德官方网站申请key](http://id.amap.com/?ref=http%3A%2F%2Fapi.amap.com%2Fkey%2F).
- 阅读[参考手册](http://api.amap.com/Public/reference/iOS%20API%20v2_3D/).
- 工程基于iOS 3D地图SDK实现
- 运行demo请先执行pod install --repo-update 安装依赖库，完成后打开.xcworkspace 文件

### 核心类/接口 ##
| 类    | 接口  | 说明   | 版本  |
| -----|:-----:|:-----:|:-----:|
| MAMapview	| - (void)addOverlay:(id <MAOverlay>)overlay; | 添加轨迹线 | v4.0.0 |
| MAMapview	| - (void)addAnnotation:(id <MAAnnotation>)annotation; | 添加汽车 | v4.0.0 |

### 核心实现
- MovingAnnotationView 自定义annotationview，其layer是自定义的CACoordLayer
```
/**
 动画AnnotationView，只试用于高德3D地图SDK。
 */
@interface MovingAnnotationView : MAAnnotationView

/*!
 @brief 添加动画
 @param points 轨迹点串，每个轨迹点为TracingPoint类型
 @param duration 动画时长，包括从上一个动画的终止点过渡到新增动画起始点的时间
 */
- (void)addTrackingAnimationForPoints:(NSArray *)points duration:(CFTimeInterval)duration;

@end

+ (Class)layerClass
{
    return [CACoordLayer class];
}

```
- CACoordLayer，每次显示时根据mapPoint计算屏幕坐标
```
- (void)display
{
    CACoordLayer * layer = [self presentationLayer];
    MAMapPoint mappoint = MAMapPointMake(layer.mapx, layer.mapy);
    
    CGPoint center = [self.mapView pointForMapPoint:mappoint];
    center.x += self.centerOffset.x;
    center.y += self.centerOffset.y;
    
    self.position = center;
}

```

注：多次调用添加动画接口，会按调用顺序依次执行添加的动画。


### 截图效果

![result](https://raw.githubusercontent.com/amap-demo/iOS-smooth-move/master/ios_movingAnnotation_demo_gif.gif)
