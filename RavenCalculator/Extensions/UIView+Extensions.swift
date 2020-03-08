//
//  UIView+Extensions.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-02-29.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    enum Axis {
        case x, y
    }
    
    func constraintWidth(to constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func constraintHeight(to constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func constraintToCenter(axis:[Axis]) {
        guard let parent = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        if axis.contains(.x) {
            centerXAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.centerXAnchor).isActive = true
        }
        
        if axis.contains(.y) {
            centerYAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.centerYAnchor).isActive = true
        }
        
    }
    
    
    func constraintToSuperview(insets:UIEdgeInsets, ignoreSafeArea:Bool = false) {
        constraintToSuperview(insets.top, insets.left, insets.bottom, insets.right, ignoreSafeArea: ignoreSafeArea)
    }
    
    func constraintToSuperview(_ top:CGFloat?=nil, _ left:CGFloat?=nil, _ bottom:CGFloat?=nil, _ right:CGFloat?=nil, ignoreSafeArea:Bool = false) {
        guard let parent = self.superview else { return }
        
        var topAnchor = parent.topAnchor
        var leadingAnchor = parent.leadingAnchor
        var trailingAnchor = parent.trailingAnchor
        var bottomAnchor = parent.bottomAnchor
        
        if #available(iOS 11.0, *) {
            if !ignoreSafeArea {
                topAnchor = parent.safeAreaLayoutGuide.topAnchor
                leadingAnchor = parent.safeAreaLayoutGuide.leadingAnchor
                trailingAnchor = parent.safeAreaLayoutGuide.trailingAnchor
                bottomAnchor = parent.safeAreaLayoutGuide.bottomAnchor
            }
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        }
        if let left = left {
            self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: left).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom).isActive = true
        }
        if let right = right {
            self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -right).isActive = true
        }
        
        if top == nil, left == nil, bottom == nil, right == nil {
            self.topAnchor.constraint(equalTo: topAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
    
    func applyShadow(radius:CGFloat, opacity:Float, offset:CGSize, color:UIColor, shouldRasterize:Bool) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shouldRasterize = shouldRasterize
    }
    
    func snapshot(of rect: CGRect? = nil, _isOpaque:Bool?=nil) -> UIImageView? {
        let opaque = _isOpaque ?? isOpaque
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        guard let image = wholeImage, let rect = rect else { return nil }
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        let screenshot = UIImage(cgImage: cgImage, scale: scale, orientation: .up)
        let view = UIImageView(frame: rect)
        view.image = screenshot
        return view
    }
    
}
