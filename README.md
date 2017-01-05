# iOS_smooth_move
annotation移动及转向动画
-请先执行pod install --repo-update 安装依赖库
-查看Demo请打开.xcworkspace文件

### 使用教程

- 添加MAAnimatedAnnotation
```
- (void)initRoute {
    int count = sizeof(s_coords) / sizeof(s_coords[0]);
    
    self.fullTraceLine = [MAPolyline polylineWithCoordinates:s_coords count:count];
    [self.mapView addOverlay:self.fullTraceLine];
    
    NSMutableArray * routeAnno = [NSMutableArray array];
    for (int i = 0 ; i < count; i++) {
        MAPointAnnotation * a = [[MAPointAnnotation alloc] init];
        a.coordinate = s_coords[i];
        a.title = @"route";
        [routeAnno addObject:a];
    }
    [self.mapView addAnnotations:routeAnno];
    [self.mapView showAnnotations:routeAnno animated:NO];
    
    self.car1 = [[MAAnimatedAnnotation alloc] init];
    self.car1.title = @"Car1";
    [self.mapView addAnnotation:self.car1];
    
    __weak typeof(self) weakSelf = self;
    self.car2 = [[CustomMovingAnnotation alloc] init];
    self.car2.stepCallback = ^() {
        [weakSelf updatePassedTrace];
    };
    self.car2.title = @"Car2";
    [self.mapView addAnnotation:self.car2];
    
    [self.car1 setCoordinate:s_coords[0]];
    [self.car2 setCoordinate:s_coords[0]];
}

```
- 开启动画
```
- (void)mov {
    double speed_car1 = 80.0 / 3.6; //80 km/h
    int count = sizeof(s_coords) / sizeof(s_coords[0]);
    [self.car1 setCoordinate:s_coords[0]];
    [self.car1 addMoveAnimationWithKeyCoordinates:s_coords count:count withDuration:self.sumDistance / speed_car1 withName:nil completeCallback:^(BOOL isFinished) {
        ;
    }];
    
    
    //小车2走过的轨迹置灰色, 采用添加多个动画方法
    double speed_car2 = 60.0 / 3.6; //60 km/h
    __weak typeof(self) weakSelf = self;
    [self.car2 setCoordinate:s_coords[0]];
    self.passedTraceCoordIndex = 0;
    for(int i = 1; i < count; ++i) {
        NSNumber *num = [self.distanceArray objectAtIndex:i - 1];
        [self.car2 addMoveAnimationWithKeyCoordinates:&(s_coords[i]) count:1 withDuration:num.doubleValue / speed_car2 withName:nil completeCallback:^(BOOL isFinished) {
            weakSelf.passedTraceCoordIndex = i;
        }];
    }
}
```



### 截图效果

![result](https://raw.githubusercontent.com/amap-demo/iOS-smooth-move/master/ios_movingAnnotation_demo.PNG)
