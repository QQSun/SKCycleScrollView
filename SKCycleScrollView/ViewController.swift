//
//  ViewController.swift
//  SKCycleScrollView
//
//  Created by nachuan on 2016/10/28.
//  Copyright © 2016年 nachuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SKCycleScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cycle = SKCycleScrollView.sk_cycleScrollView(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), delegate: self, placeholderImageNamed: "first_3");
        cycle.titleGroup = ["text1", "text2", "aaaaa", "bbbbb", "ddddd"];
        cycle.imagePathGroup = ["first_3","first_3", "first_3", "first_3", "first_3"];
        cycle.scrollDirection = SKCycleScrollViewScrollDirection.down;
        cycle.pageControlStyle = SKCycleScrollViewPageControlStyle.animated;
        cycle._pageControlAlignment = SKCycleScrollViewPageControlAlignment.right;
        cycle.didSelectItemAt = {
            (cycleScrollView: SKCycleScrollView, index: Int) in print(cycleScrollView.frame, index);
        };
        self.view.addSubview(cycle);
        
//        let pageControl: SKPageControl = SKPageControl(frame: CGRect(x: 0, y: 0, width: 50, height: 20));
//        
//        cycle.addSubview(pageControl);
        
        
        
    }
    
    
    func sk_cycleScrollView(_ cycleSrollView: SKCycleScrollView, didSelectItemAt index: Int) {
        print(index);
        
    }
    
    func sk_cycleScrollView(_ cycleSrollView: SKCycleScrollView, didScrollTo index: Int) {
        print(index);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

