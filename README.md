# iOS_smooth_move
annotation移动及转向动画
-请先执行pod install --repo-update 安装依赖库
-查看Demo请打开.xcworkspace文件

## 核心类/接口 ##
| 类    | 接口  | 说明   | 版本  |
| -----|:-----:|:-----:|:-----:|
| MAAnimatedAnnotation	| - (void)addMoveAnimationWithKeyCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSUInteger)count  withDuration:(CGFloat)duration withName:(NSString *)name completeCallback:(void(^)(BOOL isFinished))completeCallback; | 添加移动动画, 第一个添加的动画以当前coordinate为起始点，沿传入的coordinates点移动，否则以上一个动画终点为起始点 | 4.6.0 | 


## 核心难点 ##
### objective-c
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

### swift
- 添加MAAnimatedAnnotation
```
 func initRoute() {
        let count: Int = s_coords.count
        self.fullTraceLine = MAPolyline(coordinates: &s_coords, count: UInt(count))
        self.mapView.add(self.fullTraceLine)
        var routeAnno = [Any]()
        for i in 0..<count {
            let a = MAPointAnnotation()
            a.coordinate = s_coords[i]
            a.title = "route"
            routeAnno.append(a)
        }
        self.mapView.addAnnotations(routeAnno)
        self.mapView.showAnnotations(routeAnno, animated: false)
        self.car1 = MAAnimatedAnnotation()
        self.car1.title = "Car1"
        self.mapView.addAnnotation(self.car1)
        
        weak var weakSelf = self
        self.car2 = CustomMovingAnnotation()
        self.car2.stepCallback = {() -> Void in
            weakSelf?.updatePassedTrace()
        }
        self.car2.title = "Car2"
        self.mapView.addAnnotation(self.car2)
        self.car1.coordinate = s_coords[0]
        self.car2.coordinate = s_coords[0]
    }
```
- 开启动画
```
    func mov() {
        let speed_car1: Double = 120.0 / 3.6
        //80 km/h
        let count: Int = s_coords.count
        self.car1.coordinate = s_coords[0]
        let duration = self.sumDistance / speed_car1;
        self.car1.addMoveAnimation(withKeyCoordinates: &s_coords, count: UInt(count), withDuration: CGFloat(duration), withName: nil, completeCallback: {(_ isFinished: Bool) -> Void in
        })
        
        //小车2走过的轨迹置灰色, 采用添加多个动画方法
        let speed_car2: Double = 100.0 / 3.6
        //60 km/h
        weak var weakSelf = self
        self.car2.coordinate = s_coords[0]
        self.passedTraceCoordIndex = 0
        for i in 1..<count {
            let num = self.distanceArray[i - 1]
            let tempDuration = num / speed_car2
            self.car2.addMoveAnimation(withKeyCoordinates: &(s_coords[i]), count: 1, withDuration: CGFloat(tempDuration), withName: nil, completeCallback: {(_ isFinished: Bool) -> Void in
                weakSelf?.passedTraceCoordIndex = i
            })
        }
    }

```

### 截图效果

![result](https://raw.githubusercontent.com/amap-demo/iOS-smooth-move/master/ios_movingAnnotation_demo.png)
