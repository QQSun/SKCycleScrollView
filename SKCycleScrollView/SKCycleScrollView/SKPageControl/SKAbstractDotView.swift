//
//  SKAbstractDotView.swift
//  SKCycleScrollView
//
//  Created by nachuan on 2016/11/1.
//  Copyright © 2016年 nachuan. All rights reserved.
//

import UIKit

class SKAbstractDotView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 调用该方法.设置view是否为当前选中的page
    ///
    /// - parameter activeState: 状态标示
    func change(activeState: Bool) -> Void {
//        throw NSException.init(name: NSInternalInconsistencyException, reason: "You must ovverride \(NSStringFromSelector(_cmd)) in \()", userInfo: nil);
    }
    

}
