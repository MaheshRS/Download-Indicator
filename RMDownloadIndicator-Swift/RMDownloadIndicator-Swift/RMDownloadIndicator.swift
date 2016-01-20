//
//  RMDownloadIndicator.swift
//  RMDownloadIndicator-Swift
//
//  Created by Mahesh Shanbhag on 10/08/15.
//  Copyright (c) 2015 Mahesh Shanbhag. All rights reserved.
//

import UIKit

enum RMIndicatorType: Int {
    case kRMClosedIndicator = 0
    case kRMFilledIndicator
    case kRMMixedIndictor
}

class RMDownloadIndicator: UIView {
    
    // this value should be 0 to 0.5 (default: (kRMFilledIndicator = 0.5), (kRMMixedIndictor = 0.4))
    var radiusPercent: CGFloat = 0.5 {
        didSet {
            if type == RMIndicatorType.kRMClosedIndicator {
                self.radiusPercent = 0.5
            }
            if radiusPercent > 0.5 || radiusPercent < 0 {
                radiusPercent = oldValue
            }
        }
    }
    
    // used to fill the downloaded percent slice (default: (kRMFilledIndicator = white), (kRMMixedIndictor = white))
    var fillColor: UIColor = UIColor.clearColor() {
        didSet {
            if type == RMIndicatorType.kRMClosedIndicator {
                fillColor = UIColor.clearColor()
            }
        }
    }
    
    // used to stroke the covering slice (default: (kRMClosedIndicator = white), (kRMMixedIndictor = white))
    var strokeColor: UIColor = UIColor.whiteColor()
    
    // used to stroke the background path the covering slice (default: (kRMClosedIndicator = gray))
    var closedIndicatorBackgroundStrokeColor: UIColor = UIColor.whiteColor()
    
    
    // Private properties
    private var paths: [CGPath] = []
    private var indicateShapeLayer: CAShapeLayer!
    private var coverLayer: CAShapeLayer!
    private var animatingLayer: CAShapeLayer!
    private var type: RMIndicatorType!
    private var coverWidth: CGFloat = 0.0
    private var lastUpdatedPath: UIBezierPath!
    private var lastSourceAngle: CGFloat = 0.0
    private var animationDuration: CGFloat = 0.0
    
    
    
    // init with frame and type
    // if() - (id)initWithFrame:(CGRect)frame is used the default type = kRMFilledIndicator
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        self.type = .kRMFilledIndicator
        self.initAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rectframe: CGRect, type: RMIndicatorType) {
        super.init(frame: rectframe)
        
        self.type = type
        self.initAttributes()
    }
    
    func initAttributes() {
        if type == RMIndicatorType.kRMClosedIndicator {
            self.radiusPercent = 0.5
            coverLayer = CAShapeLayer()
            animatingLayer = coverLayer
            fillColor = UIColor.clearColor()
            strokeColor = UIColor.whiteColor()
            closedIndicatorBackgroundStrokeColor = UIColor.grayColor()
            coverWidth = 2.0
        }
        else {
            if type == RMIndicatorType.kRMFilledIndicator {
                indicateShapeLayer = CAShapeLayer()
                animatingLayer = indicateShapeLayer
                radiusPercent = 0.5
                coverWidth = 2.0
                closedIndicatorBackgroundStrokeColor = UIColor.clearColor()
            }
            else {
                indicateShapeLayer = CAShapeLayer()
                coverLayer = CAShapeLayer()
                animatingLayer = indicateShapeLayer
                coverWidth = 2.0
                radiusPercent = 0.4
                closedIndicatorBackgroundStrokeColor = UIColor.whiteColor()
            }
            fillColor = UIColor.whiteColor()
            strokeColor = UIColor.whiteColor()
        }
        
        animatingLayer.frame = self.bounds
        self.layer.addSublayer(animatingLayer)
        animationDuration = 0.5
    }
    
    // prepare the download indicator
    func loadIndicator() {
        let center: CGPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
        let initialPath: UIBezierPath = UIBezierPath.init()
        if type == RMIndicatorType.kRMClosedIndicator {
            initialPath.addArcWithCenter(center, radius: (fmin(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))), startAngle: degreeToRadian(-90), endAngle: degreeToRadian(-90), clockwise: true)
        }
        else {
            if type == RMIndicatorType.kRMMixedIndictor {
                self.setNeedsDisplay()
            }
            let radius: CGFloat = (fmin(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2) * self.radiusPercent
            initialPath.addArcWithCenter(center, radius: radius, startAngle: degreeToRadian(-90), endAngle: degreeToRadian(-90), clockwise: true)
        }
        animatingLayer.path = initialPath.CGPath
        animatingLayer.strokeColor = strokeColor.CGColor
        animatingLayer.fillColor = fillColor.CGColor
        animatingLayer.lineWidth = coverWidth
        self.lastSourceAngle = degreeToRadian(-90)
    }
    
    func keyframePathsWithDuration(duration: CGFloat, lastUpdatedAngle: CGFloat, newAngle: CGFloat, radius: CGFloat, type: RMIndicatorType) -> [CGPath] {
        let frameCount: Int = Int(ceil(duration * 60))
        var array: [CGPath] = []
        for var frame = 0; frame <= frameCount; frame++ {
            let startAngle = degreeToRadian(-90)
            
            let angleChange = ((newAngle - lastUpdatedAngle) * CGFloat(frame))
            let endAngle = lastUpdatedAngle + (angleChange / CGFloat(frameCount))
            array.append((self.pathWithStartAngle(startAngle, endAngle: endAngle, radius: radius, type: type).CGPath))
        }
        return array
    }
    
    func pathWithStartAngle(startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat, type: RMIndicatorType) -> UIBezierPath {
        let clockwise: Bool = startAngle < endAngle
        let path: UIBezierPath = UIBezierPath()
        let center: CGPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
        if type == RMIndicatorType.kRMClosedIndicator {
            path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        }
        else {
            path.moveToPoint(center)
            path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
            path.closePath()
        }
        return path
    }
    
    override func drawRect(rect: CGRect) {
        if type == RMIndicatorType.kRMMixedIndictor {
            let radius: CGFloat = fmin(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2 - self.coverWidth
            let center: CGPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
            let coverPath: UIBezierPath = UIBezierPath()
            coverPath.lineWidth = coverWidth
            coverPath.addArcWithCenter(center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
            closedIndicatorBackgroundStrokeColor.set()
            coverPath.stroke()
        }
        else {
            if type == RMIndicatorType.kRMClosedIndicator {
                let radius: CGFloat = (fmin(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2) - self.coverWidth
                let center: CGPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                let coverPath: UIBezierPath = UIBezierPath()
                coverPath.lineWidth = coverWidth
                coverPath.addArcWithCenter(center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
                closedIndicatorBackgroundStrokeColor.set()
                coverPath.lineWidth = self.coverWidth
                coverPath.stroke()
            }
        }
    }
    
    // update the downloadIndicator
    func updateWithTotalBytes(bytes: CGFloat, downloadedBytes: CGFloat) {
        lastUpdatedPath = UIBezierPath.init(CGPath: animatingLayer.path!)
        paths.removeAll(keepCapacity: false)
        let destinationAngle: CGFloat = self.destinationAngleForRatio((downloadedBytes / bytes))
        let radius: CGFloat = (fmin(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * radiusPercent) - self.coverWidth
        paths = self.keyframePathsWithDuration(self.animationDuration, lastUpdatedAngle: self.lastSourceAngle, newAngle: destinationAngle, radius: radius, type: type)
        animatingLayer.path = paths[(paths.count - 1)]
        self.lastSourceAngle = destinationAngle
        let pathAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "path")
        pathAnimation.values = paths
        pathAnimation.duration = CFTimeInterval(animationDuration)
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        pathAnimation.removedOnCompletion = true
        animatingLayer.addAnimation(pathAnimation, forKey: "path")
        if downloadedBytes >= bytes{
            self.removeFromSuperview()
        }
    }
    
    func destinationAngleForRatio(ratio: CGFloat) -> CGFloat {
        return (degreeToRadian((360 * ratio) - 90))
    }
    
    
    func degreeToRadian(degree: CGFloat) -> CGFloat
    {
        return (CGFloat(degree) * CGFloat(M_PI)) / CGFloat(180.0);
    }
//    
//    func setLayerFillColor(fillColor: UIColor) {
//        if type == RMIndicatorType.kRMClosedIndicator {
//            self.fillColor = UIColor.clearColor()
//        }
//        else {
//            self.fillColor = fillColor
//        }
//    }
    
//    func setLayerRadiusPercent(radiusPercent: CGFloat) {
//        if type == RMIndicatorType.kRMClosedIndicator {
//            self.radiusPercent = 0.5
//            return
//        }
//        if radiusPercent > 0.5 || radiusPercent < 0 {
//            return
//        }
//        else {
//            self.radiusPercent = radiusPercent
//        }
//    }
    
    // update the downloadIndicator
    func setIndicatorAnimationDuration(duration: CGFloat) {
        self.animationDuration = duration
    }
}
