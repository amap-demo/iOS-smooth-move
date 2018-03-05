//
//  ViewController.m
//  test
//
//  Created by yi chen on 14-8-20.
//  Copyright (c) 2014年 yi chen. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CustomMovingAnnotation.h"

static CLLocationCoordinate2D s_coords[] =
{
    {39.97617053371078, 116.3499049793749},
    {39.97619854213431, 116.34978804908442},
    {39.97623045687959, 116.349674596623},
    {39.97626931100656, 116.34955525200917},
    {39.976285626595036, 116.34943728748914},
    {39.97628129172198, 116.34930864705592},
    {39.976260803938594, 116.34918981582413},
    {39.97623535890678, 116.34906721558868},
    {39.976214717128855, 116.34895185151584},
    {39.976280148755315, 116.34886935936889},
    {39.97628182112874, 116.34873954611332},
    {39.97626038855863, 116.34860763527448},
    {39.976306080391836, 116.3484658907622},
    {39.976358252119745, 116.34834585430347},
    {39.97645709321835, 116.34831166130878},
    {39.97655231226543, 116.34827643560175},
    {39.976658372925556, 116.34824186261169},
    {39.9767570732376, 116.34825080406188},
    {39.976869087779995, 116.34825631960626},
    {39.97698451764595, 116.34822111635201},
    {39.977079745909876, 116.34822901510276},
    {39.97718701787645, 116.34822234337618},
    {39.97730766147824, 116.34821627457707},
    {39.977417746816776, 116.34820593515043},
    {39.97753930933358, 116.34821013897107},
    {39.977652209132174, 116.34821304891533},
    {39.977764016531076, 116.34820923399242},
    {39.97786190186833, 116.3482045955917},
    {39.977958856930286, 116.34822159449203},
    {39.97807288885813, 116.3482256370537},
    {39.978170063673524, 116.3482098441266},
    {39.978266951404066, 116.34819564465377},
    {39.978380693859116, 116.34820541974412},
    {39.97848741209275, 116.34819672351216},
    {39.978593409607825, 116.34816588867105},
    {39.97870216883567, 116.34818489339459},
    {39.978797222300166, 116.34818473446943},
    {39.978893492422685, 116.34817728972234},
    {39.978997133775266, 116.34816491505472},
    {39.97911413849568, 116.34815408537773},
    {39.97920553614499, 116.34812908154862},
    {39.979308267469264, 116.34809495907906},
    {39.97939658036473, 116.34805113358091},
    {39.979491697188685, 116.3480310509613},
    {39.979588529006875, 116.3480082124968},
    {39.979685789111635, 116.34799530586834},
    {39.979801430587926, 116.34798818413954},
    {39.97990758587515, 116.3479996420353},
    {39.980000796262615, 116.34798697544538},
    {39.980116318796085, 116.3479912988137},
    {39.98021407403913, 116.34799204219203},
    {39.980325006125696, 116.34798535084123},
    {39.98042511477518, 116.34797702460183},
    {39.98054129336908, 116.34796288754136},
    {39.980656820423505, 116.34797509821901},
    {39.98074576792626, 116.34793922017285},
    {39.98085620772756, 116.34792586413015},
    {39.98098214824056, 116.3478962642899},
    {39.98108306010269, 116.34782449883967},
    {39.98115277119176, 116.34774758827285},
    {39.98115430642997, 116.34761476652932},
    {39.98114590845294, 116.34749135408349},
    {39.98114337322547, 116.34734772765582},
    {39.98115066909245, 116.34722082902628},
    {39.98114532232906, 116.34708205250223},
    {39.98112245161927, 116.346963237696},
    {39.981136637759604, 116.34681500222743},
    {39.981146248090866, 116.34669622104072},
    {39.98112495260716, 116.34658043260109},
    {39.9811107163792, 116.34643721418927},
    {39.981085081075676, 116.34631638374302},
    {39.98108046779486, 116.34614782996252},
    {39.981049089345206, 116.3460256053666},
    {39.98104839362087, 116.34588814050122},
    {39.9810544889668, 116.34575119741586},
    {39.981040940565734, 116.34562885420186},
    {39.98105271658809, 116.34549232235582},
    {39.981052294975264, 116.34537348820508},
    {39.980956549928244, 116.3453513775533}
};

@interface ViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

///车头方向跟随转动
@property (nonatomic, strong) PausableMovingAnnotation *car1;
///车头方向不跟随转动
@property (nonatomic, strong) CustomMovingAnnotation *car2;

///全轨迹overlay
@property (nonatomic, strong) MAPolyline *fullTraceLine;
///走过轨迹的overlay
@property (nonatomic, strong) MAPolyline *passedTraceLine;
@property (nonatomic, assign) int passedTraceCoordIndex;

@property (nonatomic, strong) NSArray *distanceArray;
@property (nonatomic, assign) double sumDistance;

@property (nonatomic, weak) MAAnnotationView *car1View;
@property (nonatomic, weak) MAAnnotationView *car2View;

@property (nonatomic, strong) NSMutableArray *carsArray;

@property (nonatomic, strong) UIButton *pauseBtn;

@end

@implementation ViewController

#pragma mark - Map Delegate
- (void)mapInitComplete:(MAMapView *)mapView {
    [self initRoute];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if (annotation == self.car1 || [self.carsArray containsObject:annotation]) {
        NSString *pointReuseIndetifier = @"pointReuseIndetifier1";
        
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if(!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            
            annotationView.canShowCallout = YES;
            
            UIImage *imge  =  [UIImage imageNamed:@"car1"];
            annotationView.image =  imge;
            
            if(annotation == self.car1) {
                self.car1View = annotationView;
            }
        }

        return annotationView;
    } else if(annotation == self.car2) {
        NSString *pointReuseIndetifier = @"pointReuseIndetifier2";
        
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if(!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            
            annotationView.canShowCallout = YES;
            
            UIImage *imge  =  [UIImage imageNamed:@"car2"];
            annotationView.image =  imge;
            
            self.car2View = annotationView;
        }
        
        return annotationView;
    } else if([annotation isKindOfClass:[MAPointAnnotation class]]) {
        NSString *pointReuseIndetifier = @"pointReuseIndetifier3";
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.canShowCallout = YES;
        }
        
        if ([annotation.title isEqualToString:@"route"]) {
            annotationView.enabled = NO;
            annotationView.image = [UIImage imageNamed:@"trackingPoints"];
        }
        
        [self.car1View.superview bringSubviewToFront:self.car1View];
        [self.car2View.superview bringSubviewToFront:self.car2View];
        
        return annotationView;
    }
    
    return nil;
}

- (MAPolylineRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if(overlay == self.fullTraceLine) {
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 6.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0.47 blue:1.0 alpha:0.9];
        
        return polylineView;
    } else if(overlay == self.passedTraceLine) {
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 6.f;
        polylineView.strokeColor = [UIColor grayColor];
        
        return polylineView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    NSLog(@"cooridnate :%f, %f", view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
}

#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    [self initBtn];
    
    
    int count = sizeof(s_coords) / sizeof(s_coords[0]);
    double sum = 0;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for(int i = 0; i < count - 1; ++i) {
        CLLocation *begin = [[CLLocation alloc] initWithLatitude:s_coords[i].latitude longitude:s_coords[i].longitude];
        CLLocation *end = [[CLLocation alloc] initWithLatitude:s_coords[i+1].latitude longitude:s_coords[i+1].longitude];
        CLLocationDistance distance = [end distanceFromLocation:begin];
        [arr addObject:[NSNumber numberWithDouble:distance]];
        sum += distance;
    }
    
    self.distanceArray = arr;
    self.sumDistance = sum;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

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
    
    self.car1 = [[PausableMovingAnnotation alloc] init];
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
    
    
#if 0
    const int carCount = 100;
    self.carsArray = [NSMutableArray arrayWithCapacity:carCount];
    for(int i = 0; i < carCount; ++i) {
        MAAnimatedAnnotation *car = [[MAAnimatedAnnotation alloc] init];
        car.title = [NSString stringWithFormat:@"car_%d", i];
        float deltaX = ((float)(rand() % 100)) / 1000.0;
        float deltaY = ((float)(rand() % 100)) / 1000.0;
        car.coordinate = CLLocationCoordinate2DMake(39.97617053371078 + deltaX, 116.3499049793749 + deltaY);
        [self.carsArray addObject:car];
    }
    [self.mapView addAnnotations:self.carsArray];
    
    [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        int temp = rand() % 10;
        for(int i = 0; i < carCount; ++i) {
            if(i % temp == 0) {
                MAAnimatedAnnotation *car = [self.carsArray objectAtIndex:i];
                float deltaX = ((float)(rand() % 10)) / 1000.0;
                float deltaY = ((float)(rand() % 10)) / 1000.0;
                CLLocationCoordinate2D coord = car.coordinate;
                if(i % 2 == 0) {
                    coord.latitude += deltaX;
                    coord.longitude += deltaY;
                } else {
                    coord.latitude -= deltaX;
                    coord.longitude -= deltaY;
                }
                [car addMoveAnimationWithKeyCoordinates:&coord count:1 withDuration:1 withName:nil completeCallback:^(BOOL isFinished) {
                    ;
                }];
            }
        }
    }];
#endif
}

- (void)initBtn {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 100, 60, 40);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"move" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(mov) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(0, 200, 60, 40);
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 setTitle:@"stop" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(0, 300, 60, 40);
    btn2.backgroundColor = [UIColor grayColor];
    [btn2 setTitle:@"pause" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    self.pauseBtn = btn2;
    [self.view addSubview:btn2];
}

#pragma mark - Action

- (void)mov {
    if(self.car1.isPaused) {
        [self pause:self.pauseBtn];
    }
    
    double speed_car1 = 120.0 / 3.6; //80 km/h
    int count = sizeof(s_coords) / sizeof(s_coords[0]);
    [self.car1 setCoordinate:s_coords[0]];
    [self.car1 addMoveAnimationWithKeyCoordinates:s_coords count:count withDuration:self.sumDistance / speed_car1 withName:nil completeCallback:^(BOOL isFinished) {
        ;
    }];
    
    
    //小车2走过的轨迹置灰色, 采用添加多个动画方法
    double speed_car2 = 100.0 / 3.6; //60 km/h
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

- (void)stop {
    if(self.car1.isPaused) {
        [self pause:self.pauseBtn];
    }
    for(MAAnnotationMoveAnimation *animation in [self.car1 allMoveAnimations]) {
        [animation cancel];
    }
    self.car1.movingDirection = 0;
    [self.car1 setCoordinate:s_coords[0]];

    for(MAAnnotationMoveAnimation *animation in [self.car2 allMoveAnimations]) {
        [animation cancel];
    }
    self.car2.movingDirection = 0;
    [self.car2 setCoordinate:s_coords[0]];
    
    if(self.passedTraceLine) {
        [self.mapView removeOverlay:self.passedTraceLine];
        self.passedTraceLine = nil;
    }
}

- (void)pause:(UIButton*)btn {
    self.car2.isPaused = self.car1.isPaused = !self.car1.isPaused;
    
    if(self.car1.isPaused) {
        [btn setTitle:@"resume" forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"pause" forState:UIControlStateNormal];
    }
}

//小车2走过的轨迹置灰色
- (void)updatePassedTrace {
    if(self.car2.isAnimationFinished) {
        return;
    }
    
    if(self.passedTraceLine) {
        [self.mapView removeOverlay:self.passedTraceLine];
    }
    
    int needCount = self.passedTraceCoordIndex + 2;
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * needCount);
    
    memcpy(coords, s_coords, sizeof(CLLocationCoordinate2D) * (self.passedTraceCoordIndex + 1));
    coords[needCount - 1] = self.car2.coordinate;
    self.passedTraceLine = [MAPolyline polylineWithCoordinates:coords count:needCount];
    [self.mapView addOverlay:self.passedTraceLine];
    
    if(coords) {
        free(coords);
    }
}

@end
