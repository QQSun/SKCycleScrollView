//
//  SKPageControl.swift
//  SKCycleScrollView
//
//  Created by nachuan on 2016/11/1.
//  Copyright © 2016年 nachuan. All rights reserved.
//

import UIKit
private var dotViewClassKey: UInt8 = 0;
private var dotImageKey: UInt8 = 1;
private var currentDotImageKey: UInt8 = 2;
private var dotSizeKey: UInt8 = 3;
private var dotColorKey: UInt8 = 4;
private var spaceBetweenDotsKey: UInt8 = 5;
private var numberOfPagesKey: UInt8 = 6;
private var currentPageKey: UInt8 = 7;
private var hidesForSinglePageKey: UInt8 = 8;
private var shouldResizeFromCenterKey: UInt8 = 9;


extension SKPageControl {
    
    var dotViewClass: AnyClass? {
        get {
            return sk_getAssociatedObject(base: self, key: &dotViewClassKey, initialiser: {
                return nil;
            });
        }
        set {
            sk_setAssociatedObject(base: self, key: &dotViewClassKey, value: newValue);
            dotSize = kDefaultDotSize;
            resetDotViews();
        }
    }
    
    var dotImage: UIImage? {
        get {
            return sk_getAssociatedObject(base: self, key: &dotImageKey, initialiser: {
                return nil;
            });
        }
        set {
            sk_setAssociatedObject(base: self, key: &dotImageKey, value: newValue);
            resetDotViews();
            dotViewClass = nil;
        }
    }
    
    var currentDotImage: UIImage? {
        get {
            return sk_getAssociatedObject(base: self, key: &currentDotImageKey, initialiser: {
                return nil;
            });
        }
        set {
            sk_setAssociatedObject(base: self, key: &currentDotImageKey, value: newValue);
            resetDotViews();
            dotViewClass = nil;
        }
    }
    
    var dotSize: CGSize {
        get {
            if dotImage != nil && __CGSizeEqualToSize(_dotSize, CGSize.zero) {
                _dotSize = dotImage!.size;
            }else if dotViewClass != nil && __CGSizeEqualToSize(_dotSize, CGSize.zero) {
                _dotSize = kDefaultDotSize;
            }
            return _dotSize;
        }
        set {
            _dotSize = newValue;
        }
    }
    
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
    
    var spaceBetweenDots: CGFloat {
        get {
            return sk_getAssociatedObject(base: self, key: &spaceBetweenDotsKey, initialiser: {
                return 0.0
            });
        }
        set {
            sk_setAssociatedObject(base: self, key: &spaceBetweenDotsKey, value: newValue);
            resetDotViews();
        }
    }
    
    var numberOfPages: Int {
        get {
            return sk_getAssociatedObject(base: self, key: &numberOfPagesKey, initialiser: {
                return kDefaultNumberOfPages;
            });
        }
        set {
            sk_setAssociatedObject(base: self, key: &numberOfPagesKey, value: newValue);
            resetDotViews();
        }
    }
    
    var currentPage: Int {
        get {
            return sk_getAssociatedObject(base: self, key: &currentPageKey, initialiser: {
                return kDefaultCurrentPage;
            });
        }
        set {
            if numberOfPages == 0 {
                sk_setAssociatedObject(base: self, key: &currentPageKey, value: newValue);
                return;
            }
            changeActivity(active: false, at: currentPage);
            sk_setAssociatedObject(base: self, key: &currentPageKey, value: newValue);
            changeActivity(active: true, at: currentPage);
            
            
        }
    }
    
    var hidesForSinglePage: Bool {
        get {
            return sk_getAssociatedObject(base: self, key: &hidesForSinglePageKey, initialiser: {
                return kDefaultHidesForSinglePage;
            });
        }
        set {
            sk_setAssociatedObject(base: self, key: &hidesForSinglePageKey, value: newValue);
        }
    }
    
    var shouldResizeFromCenter: Bool {
        get {
            return sk_getAssociatedObject(base: self, key: &shouldResizeFromCenterKey, initialiser: {
                return kDefaultShouldResizeFromCenter;
            });
        }
        set {
            sk_setAssociatedObject(base: self, key: &shouldResizeFromCenterKey, value: newValue);
        }
    }
    

    
    
    
    
}


protocol SKPageControlDelegate: class {
    func sk_pageControl(_ pageControl: SKPageControl, didSelectedPageAt index: Int) -> Void;
}


private let kDefaultNumberOfPages: Int = 0;
private let kDefaultCurrentPage: Int = 0;
private let kDefaultHidesForSinglePage: Bool = false;
private let kDefaultShouldResizeFromCenter: Bool = true;
private let kDefaultSpaceBetweenDots: CGFloat = 8;
private let kDefaultDotSize: CGSize = CGSize(width: 8.0, height: 8.0);

class SKPageControl: UIControl {
    weak var delegate: SKPageControlDelegate?
    var dots: [UIView] = [UIView]();
    var _dotSize: CGSize = kDefaultDotSize;
//    var dotViewClass: AnyClass?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        initialization();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        initialization();
    }
    
    
    /// 初始化相关属性
    private func initialization() -> Void {
        dotViewClass = SKAnimationDotView.self;
        spaceBetweenDots = kDefaultSpaceBetweenDots;
        numberOfPages = kDefaultNumberOfPages;
        currentPage = kDefaultCurrentPage;
        hidesForSinglePage = kDefaultHidesForSinglePage;
        shouldResizeFromCenter = kDefaultShouldResizeFromCenter;
    }
    
    //MARK: - 点击事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        if let touch = touches.first {
            if let view = touch.view {
                if let index = dots.index(where: {$0 == view}) {
                    print(index);
                    if delegate != nil {
                        delegate!.sk_pageControl(self, didSelectedPageAt: index);
                    }
                }
            }
        }
    }
    
    //MARK: - layout
    
    override func sizeToFit() -> Void {
        super.sizeToFit();
        updateFrame(true);
    }
    
    
    
    /// 通过pageNumber获取相应的size
    func size(forNumberOfPages pageCount: Int?) -> CGSize {
        var tempCount = pageCount;
        
        if tempCount == nil {
            tempCount = 0;
        }
        
        let size: CGSize = CGSize(width: (dotSize.width + spaceBetweenDots) * CGFloat(tempCount!), height: dotSize.height);
        return size;
    }
    
    
    /// 更新self的frame
    func updateFrame(_ overrideExistingFrame : Bool) -> Void {
        let center = self.center;
        let requiredSize = size(forNumberOfPages: numberOfPages);
        if overrideExistingFrame || self.sk_width < requiredSize.width || self.sk_height < requiredSize.height {
            self.frame = CGRect(x: self.sk_x, y: self.sk_y, width: requiredSize.width, height: requiredSize.height);
            if shouldResizeFromCenter {
                self.center = center;
            }
        }
        resetDotViews();
    }
    
    
    /// 调整圆点frame
    func resetDotViews() -> Void {
        for dotView: UIView in dots {
            dotView.removeFromSuperview();
        }
        dots.removeAll();
        updateDots();
    }
    
    func hideForSinglePage() -> Void {
        if dots.count == 1 && hidesForSinglePage {
            self.isHidden = true;
        }else{
            self.isHidden = false;
        }
    }
    
    func updateDots() -> Void {
        if numberOfPages == 0 {
            return;
        }
        for index in 0..<numberOfPages {
            var dot: UIView
            if index < dots.count {
                dot = dots[index];
            }else{
                dot = generationDotView();
            }
            updateDotFrame(dot: dot, at: index);
        }
        changeActivity(active: true, at: currentPage);
        hideForSinglePage();
        
        
    }
    
    
    /// 处理圆点.生成相应的圆点
    func generationDotView() -> UIView {
        let dotView: UIView;
        if dotViewClass != nil {
            let animationDotView: SKAnimationDotView;
            dotView = SKAnimationDotView.init(frame: CGRect(origin: CGPoint.zero, size: dotSize));
            if dotView.isKind(of: SKAnimationDotView.self) {
                animationDotView = dotView as! SKAnimationDotView;
                animationDotView.dotColor = dotColor;
            }
        }else{
            dotView = UIImageView.init(image: dotImage);
            dotView.frame = CGRect.init(origin: CGPoint.zero, size: dotSize);
        }
        
        self.addSubview(dotView);
        self.dots.append(dotView);
        
        dotView.isUserInteractionEnabled = true;
        return dotView;
    }
    
    
    /// 跟新圆点的frame
    func updateDotFrame(dot: UIView, at index: Int) -> Void {
        let x = (dotSize.width + spaceBetweenDots) * CGFloat(index) + (spaceBetweenDots / 2);
        let y = (self.sk_height - dotSize.height) / 2;
        dot.frame = CGRect.init(origin: CGPoint.init(x: x, y: y), size: dotSize);
    }
    
    
    /// 改变处于是否活动状态的圆点
    ///
    /// - parameter active: 状态标示
    /// - parameter index:  位置index
    func changeActivity(active: Bool, at index: Int) -> Void {
        if self.dotViewClass != nil {
            let abstractDotView: SKAbstractDotView? = dots[index] as? SKAbstractDotView;
            if abstractDotView != nil {
                if abstractDotView!.responds(to: #selector(SKAbstractDotView.change(activeState:))) {
                    abstractDotView!.change(activeState: active);
                }else{
                    print("自定义视图\(dotViewClass!)需要实现change(activeState: Bool) -> Void 方法,你可以使用\(SKAbstractDotView.self)的子类来获得帮助");
                }
            }
        }else if dotImage != nil && currentDotImage != nil {
            let dotView: UIImageView? = dots[index] as? UIImageView;
            if dotView != nil {
                dotView!.image = active ? currentDotImage : dotImage;
            }
        }
    }
    
 
    
    
    
}
