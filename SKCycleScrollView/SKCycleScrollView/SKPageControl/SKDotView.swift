//
//  SKDotView.swift
//  SKCycleScrollView
//
//  Created by nachuan on 2016/11/1.
//  Copyright © 2016年 nachuan. All rights reserved.
//

import UIKit

class SKDotView: SKAbstractDotView {

    
    override init(frame: CGRect) {
        super.init(frame: frame);
        initialization();
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        initialization();
    }

    func initialization() -> Void {
        self.backgroundColor = UIColor.clear;
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.borderColor = UIColor.white.cgColor;
        self.layer.borderWidth = 2;
    }
    
    override func change(activeState: Bool) -> Void {
        super.change(activeState: activeState);
        if activeState {
            self.backgroundColor = UIColor.white;
        }else{
            self.backgroundColor = UIColor.clear;
        }
    }
    
}
