//
//  SKExtension.swift
//  SKCycleScrollView
//
//  Created by nachuan on 2016/10/29.
//  Copyright © 2016年 nachuan. All rights reserved.
//
import UIKit
import Foundation

extension UIView {
    var sk_width: CGFloat {
        get {
            return self.frame.size.width;
        }
        set {
            var tempFrame = self.frame;
            tempFrame.size.width = newValue;
            self.frame = tempFrame;
        }
    }
    
    var sk_height: CGFloat {
        get {
            return self.frame.size.height;
        }
        set {
            var tempFrame = self.frame;
            tempFrame.size.height = newValue;
            self.frame = tempFrame;
        }
    }
    
    var sk_x: CGFloat {
        get {
            return self.frame.origin.x;
        }
        set {
            var tempFrame = self.frame;
            tempFrame.origin.x = newValue;
            self.frame = tempFrame;
        }
    }
    
    var sk_y: CGFloat {
        get {
            return self.frame.origin.y;
        }
        set {
            var tempFrame = self.frame;
            tempFrame.origin.y = newValue;
            self.frame = tempFrame;
        }
    }
    
    var sk_centerX: CGFloat {
        get {
            return self.center.x;
        }
        set {
            var tempCenter = self.center;
            tempCenter.x = newValue;
            self.center = tempCenter;
        }
    }
    
    var sk_centerY: CGFloat {
        get {
            return self.center.y;
        }
        set {
            var tempCenter = self.center;
            tempCenter.y = newValue;
            self.center = tempCenter;
        }
    }
    
    
    /// getter
    ///
    /// - parameter base:        属性所属的对象.一般为self
    /// - parameter key:         属性的键地址
    /// - parameter initialiser: 初始值设置
    ///
    /// - returns: 属性值
    func sk_getAssociatedObject<ValueType: Any>(base: AnyObject, key: UnsafePointer<UInt8>, initialiser:() -> ValueType) -> ValueType {
        if let associated = objc_getAssociatedObject(base, key) as? ValueType {
            return associated;
        }
        let associated = initialiser();
        objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN);
        return associated;
        
    }
    
    
    /// setter
    ///
    /// - parameter base:  属性所属对象
    /// - parameter key:   属性的键地址
    /// - parameter value: 属性值
    func sk_setAssociatedObject<ValueType: Any>(base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN);
    }

    
    
}
