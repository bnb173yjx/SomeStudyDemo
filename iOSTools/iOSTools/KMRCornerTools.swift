//
//  KMRTools.swift
//  iOSTools
//
//  Created by kagen on 16/5/18.
//  Copyright © 2016年 kagenMonster. All rights reserved.
//

import Foundation
import UIKit

private func roundbyunit(num: Double, inout _ unit: Double) -> Double {
    let remain = modf(num, &unit)
    if (remain > unit / 2.0) {
        return ceilbyunit(num, &unit)
    } else {
        return floorbyunit(num, &unit)
    }
}
private func ceilbyunit(num: Double, inout _ unit: Double) -> Double {
    return num - modf(num, &unit) + unit
}

private func floorbyunit(num: Double, inout _ unit: Double) -> Double {
    return num - modf(num, &unit)
}

private func pixel(num: Double) -> Double {
    var unit: Double
    switch Int(UIScreen.mainScreen().scale) {
    case 1: unit = 1.0 / 1.0
    case 2: unit = 1.0 / 2.0
    case 3: unit = 1.0 / 3.0
    default: unit = 0.0
    }
    return roundbyunit(num, &unit)
}

extension UIView {
    func kmr_addCorner(radius radius: CGFloat) {
        self.kmr_addCorner(radius: radius, borderWidth: 1, backgroundColor: UIColor.clearColor(), borderColor: UIColor.blackColor())
    }
    
    func kmr_addCorner(radius radius: CGFloat,
                              borderWidth: CGFloat,
                              backgroundColor: UIColor,
                              borderColor: UIColor) {
        
        let imageView = UIImageView(image: kmr_drawRectWithRoundedCorner(radius: radius,
            borderWidth: borderWidth,
            backgroundColor: backgroundColor,
            borderColor: borderColor))
        self.insertSubview(imageView, atIndex: 0)
    }
    
    func kmr_drawRectWithRoundedCorner(radius radius: CGFloat,
                                              borderWidth: CGFloat,
                                              backgroundColor: UIColor,
                                              borderColor: UIColor) -> UIImage {
        
        let sizeToFit = CGSize(width: pixel(Double(self.bounds.size.width)), height: Double(self.bounds.size.height))
        let halfBorderWidth = CGFloat(borderWidth / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(sizeToFit, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, borderWidth)
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor)
        
        let width = sizeToFit.width, height = sizeToFit.height
        CGContextMoveToPoint(context, width - halfBorderWidth, radius + halfBorderWidth)  // 开始坐标右边开始
        CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radius - halfBorderWidth, height - halfBorderWidth, radius)  // 右下角角度
        CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius - halfBorderWidth, radius) // 左下角角度
        CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius) // 左上角
        CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, radius + halfBorderWidth, radius) // 右上角
        
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }
}

extension UIImageView {
    override func kmr_addCorner(radius radius: CGFloat) {
        self.image = self.image?.kmr_drawRectWithRoundedCorner(radius: radius, self.bounds.size)
    }
}

extension UIImage {
    func kmr_drawRectWithRoundedCorner(radius radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        CGContextAddPath(UIGraphicsGetCurrentContext(),
                         UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
                            cornerRadii: CGSize(width: radius, height: radius)).CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())
        
        self.drawInRect(rect)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return output
    }
}

