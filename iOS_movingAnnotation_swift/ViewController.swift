//
//  ViewController.swift
//  iOS_movingAnnotation_swift
//
//  Created by shaobin on 17/1/16.
//  Copyright © 2017年 yours. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MAMapViewDelegate {
    ///轨迹坐标点
    var s_coords : [CLLocationCoordinate2D] = []
    
    var mapView: MAMapView!
    ///车头方向跟随转动
    var car1: MAAnimatedAnnotation!
    ///车头方向不跟随转动
    var car2: CustomMovingAnnotation!
    ///全轨迹overlay
    var fullTraceLine: MAPolyline!
    ///走过轨迹的overlay
    var passedTraceLine: MAPolyline!
    var passedTraceCoordIndex: Int = 0
    var distanceArray = [Double]()
    var sumDistance: Double = 0.0
    weak var car1View: MAAnnotationView?
    weak var car2View: MAAnnotationView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        s_coords = [CLLocationCoordinate2D(latitude: 39.97617053371078, longitude: 116.3499049793749),
                    CLLocationCoordinate2D(latitude: 39.97619854213431, longitude: 116.34978804908442),
                    CLLocationCoordinate2D(latitude: 39.97623045687959, longitude: 116.349674596623),
                    CLLocationCoordinate2D(latitude: 39.97626931100656, longitude: 116.34955525200917),
                    CLLocationCoordinate2D(latitude: 39.976285626595036, longitude: 116.34943728748914),
                    CLLocationCoordinate2D(latitude: 39.97628129172198, longitude: 116.34930864705592),
        
                    CLLocationCoordinate2D(latitude: 39.976260803938594, longitude: 116.34918981582413),
                    CLLocationCoordinate2D(latitude: 39.97623535890678, longitude: 116.34906721558868),
                    CLLocationCoordinate2D(latitude: 39.976214717128855, longitude: 116.34895185151584),
                    CLLocationCoordinate2D(latitude: 39.976280148755315, longitude: 116.34886935936889),
                    CLLocationCoordinate2D(latitude: 39.97628182112874, longitude: 116.34873954611332),
                    
                    CLLocationCoordinate2D(latitude: 39.97626038855863, longitude: 116.34860763527448),
                    CLLocationCoordinate2D(latitude: 39.976306080391836, longitude: 116.3484658907622),
                    CLLocationCoordinate2D(latitude: 39.976358252119745, longitude: 116.34834585430347),
                    CLLocationCoordinate2D(latitude: 39.97645709321835, longitude: 116.34831166130878),
                    CLLocationCoordinate2D(latitude: 39.97655231226543, longitude: 116.34827643560175),
                    
                    CLLocationCoordinate2D(latitude: 39.976658372925556, longitude: 116.34824186261169),
                    CLLocationCoordinate2D(latitude: 39.9767570732376, longitude: 116.34825080406188),
                    CLLocationCoordinate2D(latitude: 39.976869087779995, longitude: 116.34825631960626),
                    CLLocationCoordinate2D(latitude: 39.97698451764595, longitude: 116.34822111635201),
                    CLLocationCoordinate2D(latitude: 39.977079745909876, longitude: 116.34822901510276),
                    
                    CLLocationCoordinate2D(latitude: 39.97718701787645, longitude: 116.34822234337618),
                    CLLocationCoordinate2D(latitude: 39.97730766147824, longitude: 116.34821627457707),
                    CLLocationCoordinate2D(latitude: 39.977417746816776, longitude: 116.34820593515043),
                    CLLocationCoordinate2D(latitude: 39.97753930933358, longitude: 116.34821013897107),
                    CLLocationCoordinate2D(latitude: 39.977652209132174, longitude: 116.34821304891533),
                    
                    CLLocationCoordinate2D(latitude: 39.977764016531076, longitude: 116.34820923399242),
                    CLLocationCoordinate2D(latitude: 39.97786190186833, longitude: 116.3482045955917),
                    CLLocationCoordinate2D(latitude: 39.977958856930286, longitude: 116.34822159449203),
                    CLLocationCoordinate2D(latitude: 39.97807288885813, longitude: 116.3482256370537),
                    CLLocationCoordinate2D(latitude: 39.978170063673524, longitude: 116.3482098441266),
                    
                    CLLocationCoordinate2D(latitude: 39.978266951404066, longitude: 116.34819564465377),
                    CLLocationCoordinate2D(latitude: 39.978380693859116, longitude: 116.34820541974412),
                    CLLocationCoordinate2D(latitude: 39.97848741209275, longitude: 116.34819672351216),
                    CLLocationCoordinate2D(latitude: 39.978593409607825, longitude: 116.34816588867105),
                    CLLocationCoordinate2D(latitude: 39.97870216883567, longitude: 116.34818489339459),
                    
                    CLLocationCoordinate2D(latitude: 39.978797222300166, longitude: 116.34818473446943),
                    CLLocationCoordinate2D(latitude: 39.978893492422685, longitude: 116.34817728972234),
                    CLLocationCoordinate2D(latitude: 39.978997133775266, longitude: 116.34816491505472),
                    CLLocationCoordinate2D(latitude: 39.97911413849568, longitude: 116.34815408537773),
                    CLLocationCoordinate2D(latitude: 39.97920553614499, longitude: 116.34812908154862),
                    
                    CLLocationCoordinate2D(latitude: 39.979308267469264, longitude: 116.34809495907906),
                    CLLocationCoordinate2D(latitude: 39.97939658036473, longitude: 116.34805113358091),
                    CLLocationCoordinate2D(latitude: 39.979491697188685, longitude: 116.3480310509613),
                    CLLocationCoordinate2D(latitude: 39.979588529006875, longitude: 116.3480082124968),
                    CLLocationCoordinate2D(latitude: 39.979685789111635, longitude: 116.34799530586834),
                    
                    CLLocationCoordinate2D(latitude: 39.979801430587926, longitude: 116.34798818413954),
                    CLLocationCoordinate2D(latitude: 39.97990758587515, longitude: 116.3479996420353),
                    CLLocationCoordinate2D(latitude: 39.980000796262615, longitude: 116.34798697544538),
                    CLLocationCoordinate2D(latitude: 39.980116318796085, longitude: 116.3479912988137),
                    CLLocationCoordinate2D(latitude: 39.98021407403913, longitude: 116.34799204219203),
                    
                    CLLocationCoordinate2D(latitude: 39.980325006125696, longitude: 116.34798535084123),
                    CLLocationCoordinate2D(latitude: 39.98042511477518, longitude: 116.34797702460183),
                    CLLocationCoordinate2D(latitude: 39.98054129336908, longitude: 116.34796288754136),
                    CLLocationCoordinate2D(latitude: 39.980656820423505, longitude: 116.34797509821901),
                    CLLocationCoordinate2D(latitude: 39.98074576792626, longitude: 116.34793922017285),
                    
                    CLLocationCoordinate2D(latitude: 39.98085620772756, longitude: 116.34792586413015),
                    CLLocationCoordinate2D(latitude: 39.98098214824056, longitude: 116.3478962642899),
                    CLLocationCoordinate2D(latitude: 39.98108306010269, longitude: 116.34782449883967),
                    CLLocationCoordinate2D(latitude: 39.98115277119176, longitude: 116.34774758827285),
                    CLLocationCoordinate2D(latitude: 39.98115430642997, longitude: 116.34761476652932),
                    
                    CLLocationCoordinate2D(latitude: 39.98114590845294, longitude: 116.34749135408349),
                    CLLocationCoordinate2D(latitude: 39.98114337322547, longitude: 116.34734772765582),
                    CLLocationCoordinate2D(latitude: 39.98115066909245, longitude: 116.34722082902628),
                    CLLocationCoordinate2D(latitude: 39.98114532232906, longitude: 116.34708205250223),
                    CLLocationCoordinate2D(latitude: 39.98112245161927, longitude: 116.346963237696),
                    
                    CLLocationCoordinate2D(latitude: 39.981136637759604, longitude: 116.34681500222743),
                    CLLocationCoordinate2D(latitude: 39.981146248090866, longitude: 116.34669622104072),
                    CLLocationCoordinate2D(latitude: 39.98112495260716, longitude: 116.34658043260109),
                    CLLocationCoordinate2D(latitude: 39.9811107163792, longitude: 116.34643721418927),
                    CLLocationCoordinate2D(latitude: 39.981085081075676, longitude: 116.34631638374302),
                    
                    CLLocationCoordinate2D(latitude: 39.98108046779486, longitude: 116.34614782996252),
                    CLLocationCoordinate2D(latitude: 39.981049089345206, longitude: 116.3460256053666),
                    CLLocationCoordinate2D(latitude: 39.98104839362087, longitude: 116.34588814050122),
                    CLLocationCoordinate2D(latitude: 39.9810544889668, longitude: 116.34575119741586),
                    CLLocationCoordinate2D(latitude: 39.981040940565734, longitude: 116.34562885420186),
                    
                    CLLocationCoordinate2D(latitude: 39.98105271658809, longitude: 116.34549232235582),
                    CLLocationCoordinate2D(latitude: 39.981052294975264, longitude: 116.34537348820508),
                    CLLocationCoordinate2D(latitude: 39.980956549928244, longitude: 116.3453513775533),
                    
        ]
        
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - mapview Delegate
    func mapInitComplete(_ mapView: MAMapView) {
        self.initRoute()
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if (annotation.isEqual(self.car1)) {
            let pointReuseIndetifier: String = "pointReuseIndetifier1"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                annotationView?.canShowCallout = true
                let imge = UIImage(named: "car1")
                annotationView?.image = imge
                self.car1View = annotationView
            }
            return annotationView!
        } else if (annotation.isEqual(self.car2)) {
            let pointReuseIndetifier: String = "pointReuseIndetifier2"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                annotationView?.canShowCallout = true
                let imge = UIImage(named: "car2")
                annotationView?.image = imge
                self.car2View = annotationView
            }
            return annotationView!
        } else if (annotation is MAPointAnnotation) {
            let pointReuseIndetifier: String = "pointReuseIndetifier3"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                annotationView?.canShowCallout = true
            }
            if (annotation.title == "route") {
                annotationView?.isEnabled = false
                annotationView?.image = UIImage(named: "trackingPoints")
            }
            
            self.car1View?.superview?.bringSubview(toFront: self.car1View!)
            self.car2View?.superview?.bringSubview(toFront: self.car2View!)
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if (overlay as! MAPolyline == self.fullTraceLine) {
            let polylineView = MAPolylineRenderer(polyline: overlay as! MAPolyline!)
            polylineView?.lineWidth = 6.0
            polylineView?.strokeColor = UIColor(red: CGFloat(0), green: CGFloat(0.47), blue: CGFloat(1.0), alpha: CGFloat(0.9))
            return polylineView
        }
        else if (overlay as! MAPolyline == self.passedTraceLine) {
            let polylineView = MAPolylineRenderer(polyline: overlay as! MAPolyline!)
            polylineView?.lineWidth = 6.0
            polylineView?.strokeColor = UIColor.gray
            return polylineView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView, didSelect view: MAAnnotationView) {
        print("cooridnate :\(view.annotation.coordinate.latitude), \(view.annotation.coordinate.longitude)")
    }
    
    // MARK: life cycle
    
    func initialize() {
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView = MAMapView(frame: self.view.frame)
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
        self.initBtn()
        let count: Int = s_coords.count
        var sum: Double = 0
        var arr = [Double]() /* capacity: count */
        for i in 0..<count - 1 {
            let begin = CLLocation(latitude: s_coords[i].latitude, longitude: s_coords[i].longitude)
            let end = CLLocation(latitude: s_coords[i + 1].latitude, longitude: s_coords[i + 1].longitude)
            let distance: CLLocationDistance = end.distance(from: begin)
            arr.append(Double(distance))
            sum += distance
        }
        
        self.distanceArray = arr
        self.sumDistance = sum
    }
    
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
    
    func initBtn() {
        let btn = UIButton(type: .roundedRect)
        btn.frame = CGRect(x: CGFloat(0), y: CGFloat(100), width: CGFloat(60), height: CGFloat(40))
        btn.backgroundColor = UIColor.gray
        btn.setTitle("move", for: .normal)
        btn.addTarget(self, action: #selector(self.mov), for: .touchUpInside)
        self.view.addSubview(btn)
        let btn1 = UIButton(type: .roundedRect)
        btn1.frame = CGRect(x: CGFloat(0), y: CGFloat(200), width: CGFloat(60), height: CGFloat(40))
        btn1.backgroundColor = UIColor.gray
        btn1.setTitle("stop", for: .normal)
        btn1.addTarget(self, action: #selector(self.stop), for: .touchUpInside)
        self.view.addSubview(btn1)
    }
    
    // MARK: - Action
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
    
    func stop() {
        for animation: MAAnnotationMoveAnimation in self.car1.allMoveAnimations() {
            animation.cancel()
        }
        self.car1.movingDirection = 0
        self.car1.coordinate = s_coords[0]
        for animation: MAAnnotationMoveAnimation in self.car2.allMoveAnimations() {
            animation.cancel()
        }
        self.car2.movingDirection = 0
        self.car2.coordinate = s_coords[0]
        if (self.passedTraceLine != nil) {
            self.mapView.remove(self.passedTraceLine)
            self.passedTraceLine = nil
        }
    }
    
    func updatePassedTrace() {
        if self.car2.isAnimationFinished() {
            return
        }
        if (self.passedTraceLine != nil) {
            self.mapView.remove(self.passedTraceLine)
        }
        let needCount: Int = self.passedTraceCoordIndex + 2
        
        let buffer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: needCount)
        for i in 0..<self.passedTraceCoordIndex + 1 {
            buffer[i] = s_coords[i]
        }
        buffer[needCount - 1] = self.car2.coordinate
        
        self.passedTraceLine = MAPolyline.init(coordinates: buffer, count:UInt(needCount))
        self.mapView.add(self.passedTraceLine)
       
        buffer.deallocate(capacity: needCount)
    }
}

