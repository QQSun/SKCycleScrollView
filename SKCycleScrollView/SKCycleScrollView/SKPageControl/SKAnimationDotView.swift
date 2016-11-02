//
//  SKAnimationDotView.swift
//  SKCycleScrollView
//
//  Created by nachuan on 2016/11/1.
//  Copyright © 2016年 nachuan. All rights reserved.
//

import UIKit
private var dotColorKey: UInt8 = 0;
extension SKAnimationDotView {
    
    
    var dotColor: UIColor? {
        get {
            return sk_getAssociatedObject(base: self, key: &dotColorKey, initialiser: {
                return UIColor.white;
            });
        }
        set {
            sk_setAssociatedObject(base: self, key: &dotColorKey, value: newValue);
        }
    }
}

let kAnimationDuration: TimeInterval = 1;


class SKAnimationDotView: SKAbstractDotView {
        
    override init(frame: CGRect) {
        super.init(frame: frame);
        initialization();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        initialization();
    }
    
    private func initialization() -> Void {
        dotColor = UIColor.white;
        self.backgroundColor = UIColor.clear;
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.borderWidth = 2;
        self.layer.borderColor = UIColor.white.cgColor;
    }
    
    override func change(activeState: Bool) {
//        super.change(activeState: activeState);
        if activeState {
            animationToActiveState();
        }else{
            animationToDeactiveState();
        }
    }
    
    func animationToActiveState() -> Void {
        UIView.animate(withDuration: kAnimationDuration, delay: 0, options: UIViewAnimationOptions.overrideInheritedDuration, animations: { 
            self.backgroundColor = self.dotColor;
            self.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4);
        }, completion: nil);
    }
    
    func animationToDeactiveState() -> Void {
        UIView.animate(withDuration: kAnimationDuration, delay: 0, options: UIViewAnimationOptions.overrideInheritedDuration, animations: { 
            self.backgroundColor = UIColor.clear;
            self.transform = CGAffineTransform.identity;
        }, completion: nil);
    }
    

}
