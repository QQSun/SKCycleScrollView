//
//  SKCycleScrollView.swift
//  SKCycleScrollView
//
//  Created by nachuan on 2016/10/28.
//  Copyright © 2016年 nachuan. All rights reserved.
//

import UIKit


/// pageControl对齐方式
///
/// - right:        右对齐
/// - center//中间显示: 中间对齐
/// - left:         左对齐
enum SKCycleScrollViewPageControlAlignment {
    case right
    case center
    case left
}


/// pageControl显示样式
///
/// - classic     系统自带经典样式
/// - animated    动画效果
/// - none        不显示
enum SKCycleScrollViewPageControlStyle {
    case classic
    case animated
    case none
}


/// 滚动方向
///
/// - up:    向上滚动
/// - left:  向左滚动
/// - down:  向下滚动
/// - right: 向右滚动
enum SKCycleScrollViewScrollDirection {
    case up
    case left
    case down
    case right
}

protocol SKCycleScrollViewDelegate: class {

    func sk_cycleScrollView(_ cycleSrollView: SKCycleScrollView, didSelectItemAt index: Int) -> Void
    
    func sk_cycleScrollView(_ cycleSrollView: SKCycleScrollView, didScrollTo index: Int) -> Void
}

typealias cycleScrollViewClosure = (_ cycleScrollView: SKCycleScrollView, _ index: Int) -> Void;


private let kSKCycleScrollViewPageControlDotSize = CGSize.init(width: 10.0, height: 10.0)


extension SKCycleScrollView {
    
    
    
    /// 默认图片
    var placeholderImage: UIImage? {
        get {
            return _backgroundImageView?.image;
        }
        set {
            
            if newValue != nil {
                if _backgroundImageView == nil {
                    _backgroundImageView = UIImageView();
                    _backgroundImageView?.backgroundColor = UIColor.red;
                    _backgroundImageView!.contentMode = _bannerImageViewContentMode;
                    _backgroundImageView!.image = newValue!;
                    self.insertSubview(_backgroundImageView!, belowSubview: _mainView);
                }
            }
        }
    }
    
    
    /// 是否自动滚动
    var autoScroll: Bool {
        get {
            return _autoScroll;
        }
        set {
            _autoScroll = newValue;
            invalidateTimer();
            if _autoScroll == true {
                setupTimer();
            }
        }
        
    }
    
    
    /// 自动滚动时间间隔
    var autoScrollTimeIntervar: Double! {
        get {
            return _autoScrollTimeIntervar;
        }
        
        set {
            _autoScrollTimeIntervar = newValue;
            self.autoScroll = _autoScroll;
        }
    }
    
    /// 图片数组
    var imagePathGroup: [Any]? {
        get {
            return _imagePathGroup;
        }
        set {
            invalidateTimer();
            _imagePathGroup = newValue;
            if _imagePathGroup != nil && _imagePathGroup!.count > 1 {
                _imagePathGroup!.insert(_imagePathGroup![_imagePathGroup!.count - 1], at: 0);
                _imagePathGroup!.append(_imagePathGroup![1]);
                _mainView.isScrollEnabled = true;
                _autoScroll = autoScroll;
                autoScroll = _autoScroll;
            }else{
                _mainView.isScrollEnabled = false;
            }
            setupPageControl();
            _mainView.reloadData();
            
        }
    }
    
    /// 图片URLSting数组
    var imageURLStringGroup: [Any]? {
        get {
            return _imageURLStringGroup;
        }
        set {
            _imageURLStringGroup = newValue;
            var tempArray = [Any]();
            if _imageURLStringGroup != nil && _imageURLStringGroup!.count > 0 {
                for (_, obj) in _imageURLStringGroup!.enumerated() {
                    var URLString: String
                    if obj is String {
                        URLString = obj as! String;
                    }else if obj is URL {
                        let tempURL = obj as! URL;
                        URLString = tempURL.absoluteString;
                    }else{
                        return;
                    }
                    tempArray.append(URLString);
                }
                _imagePathGroup = tempArray;
            }
        }
    }
    
    ///文字数组
    var titleGroup: [String]? {
        get {
            return nil;
        }
        set {
            _titleGroup = newValue;
            if _titleGroup != nil && _titleGroup!.count > 1 {
                _titleGroup!.insert(_titleGroup![_titleGroup!.count - 1], at: 0);
                _titleGroup!.append(_titleGroup![1]);
            }
            
        }
    }
    
    
    /// 视图滚动方向
    var scrollDirection: SKCycleScrollViewScrollDirection {
        get {
            return _scrollDirection;
        }
        set {
            _scrollDirection = newValue;
            switch _scrollDirection {
            case .up, .down:
                _flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical;
                break;
            default:
                _flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal;
            }
        }
    }
    
    
    /// 无线循环标示
    var infiniteLoop: Bool {
        get {
            return _infiniteLoop;
        }
        set {
            _infiniteLoop = newValue;
            if imagePathGroup != nil && imagePathGroup!.count > 0 {
                _imagePathGroup = imagePathGroup;
                imagePathGroup = _imagePathGroup;
            }
        }
    }
    
    
    /// 指示圆点颜色.非活动状态
    var pageIndicatorTintColor: UIColor? {
        get {
            return _pageIndicatorTintColor;
        }
        set {
            _pageIndicatorTintColor = newValue;
        }
    }
    
    
    /// 当前页圆点颜色
    var currentPageIndicatorTintColor: UIColor? {
        get {
            return _currentPageIndicatorTintColor;
        }
        set {
            _currentPageIndicatorTintColor = newValue;
        }
    }
    
    var pageDotImage: UIImage? {
        get {
            return _pageDotImage;
        }
        set {
            _pageDotImage = newValue;
            if pageControlStyle != .animated {
                pageControlStyle = .animated;
            }
            setCustomPageControl(dotImage: pageDotImage, isCurrentPageDot:false);
        }
    }
    
    var currentPageDotImage: UIImage? {
        get {
            return _currentPageDotImage;
        }
        set {
            if pageControlStyle != .animated {
                pageControlStyle = .animated;
            }
            setCustomPageControl(dotImage: currentPageDotImage, isCurrentPageDot:true);
        }
    }
    
    var pageControlStyle: SKCycleScrollViewPageControlStyle {
        get {
            return _pageControlStyle;
        }
        set {
            _pageControlStyle = newValue;
            setupPageControl();
        }
    }
    
    var pageControlDotSize: CGSize {
        get {
            return _pageControlDotSize;
        }
        set {
            _pageControlDotSize = newValue;
            setupPageControl();
            if _pageControl != nil && _pageControl! is SKPageControl {
                let pageControl = _pageControl as! SKPageControl;
                pageControl.dotSize = _pageControlDotSize;
            }
        }
    }
    
}



class SKCycleScrollView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let identifier: String = "SKCollectionViewCell"
    private var _totalItemCount: Int!
    
    weak var delegate: SKCycleScrollViewDelegate?
    var didSelectItemAt: cycleScrollViewClosure?;
    var didScrollTo: cycleScrollViewClosure?
    
    
    var _flowLayout: UICollectionViewFlowLayout!
    var _mainView: UICollectionView!
    var timer: Timer?
    var _backgroundImageView: UIImageView?
    var _imagePathGroup: [Any]?
    var _imageURLStringGroup: [Any]?
    var _titleGroup: [String]?
    var _titleLabelTextColor: UIColor!
    var _titleLabelFont: UIFont!
    var _titleLabelBackgrounderColor: UIColor!
    var _titleLabelHeight: CGFloat!
    var _onlyDisplayText: Bool!
    var _autoScroll: Bool = true;
    var _autoScrollTimeIntervar: Double!
    var _scrollDirection = SKCycleScrollViewScrollDirection.left;
    var _infiniteLoop: Bool = true;
    var _pageControl: UIControl?
    var _pageDotImage: UIImage?
    var _currentPageDotImage: UIImage?
    var _showPageControl: Bool!
    var _pageControlDotSize: CGSize!
    var _pageControlBottomOffset: CGFloat!
    var _pageControlRightOffset: CGFloat!
    var _pageControlAlignment = SKCycleScrollViewPageControlAlignment.center;
    var _pageControlStyle = SKCycleScrollViewPageControlStyle.classic;
    var _hidesForSinglePage: Bool!
    var _pageIndicatorTintColor: UIColor?
    var _currentPageIndicatorTintColor: UIColor?
    var _bannerImageViewContentMode: UIViewContentMode!
    
    
    
    /// 快速创建对象.类方法
    ///
    /// - parameter frame:                 frame
    /// - parameter delegate:              代理
    /// - parameter placeholderImageNamed: 默认图片
    ///
    /// - returns: 返回实例对象
    class func sk_cycleScrollView(frame: CGRect, delegate: SKCycleScrollViewDelegate?, placeholderImageNamed: String?) -> SKCycleScrollView {
        let cycle: SKCycleScrollView = SKCycleScrollView.init(frame: frame);
        cycle.delegate = delegate;
        if placeholderImageNamed != nil {
            cycle.placeholderImage = UIImage.init(named: placeholderImageNamed!);
        }
        return cycle;
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        initialization();
        setMainView();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        initialization();
        setMainView();
        
    }
    
    
    /// 初始化属性值
    func initialization() -> Void {
        _autoScrollTimeIntervar = 2.0;
        _onlyDisplayText = false;
        _titleLabelFont = UIFont.systemFont(ofSize: 14.0);
        _titleLabelTextColor = UIColor.white;
        _titleLabelBackgrounderColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5);
        _titleLabelHeight = 30.0;
        _autoScroll = true;
        _scrollDirection = SKCycleScrollViewScrollDirection.left;
        _infiniteLoop = true;
        _showPageControl = true;
        _pageControlDotSize = kSKCycleScrollViewPageControlDotSize;
        _pageControlBottomOffset = 0;
        _pageControlRightOffset = 0;
        _pageControlAlignment = SKCycleScrollViewPageControlAlignment.center;
        _pageControlStyle = SKCycleScrollViewPageControlStyle.classic;
        _hidesForSinglePage = true;
        _currentPageIndicatorTintColor = UIColor.white;
        _pageIndicatorTintColor = UIColor.lightGray;
        _bannerImageViewContentMode = UIViewContentMode.scaleToFill;
        
        self.backgroundColor = UIColor.lightGray;
    }
    
    
    
    
    /// 设置主显示视图
    func setMainView() -> Void {
        _flowLayout = UICollectionViewFlowLayout.init();
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal;
        
        _mainView = UICollectionView.init(frame: self.bounds, collectionViewLayout: _flowLayout);
        _mainView.backgroundColor = UIColor.clear;
        _mainView.isPagingEnabled = true;
        _mainView.showsVerticalScrollIndicator = false;
        _mainView.showsHorizontalScrollIndicator = false;
        _mainView.register(SKCollectionViewCell.self, forCellWithReuseIdentifier: identifier);
        _mainView.delegate = self;
        _mainView.dataSource = self;
        _mainView.scrollsToTop = false;
        _mainView.contentOffset = CGPoint(x: self.bounds.size.width, y: self.bounds.size.height);
        self.addSubview(_mainView);

    }
    
    //MARK: - PageControl
    func setupPageControl() -> Void {
        if _pageControl != nil {
            _pageControl!.removeFromSuperview();
            _pageControl = nil;
        }
        if imagePathGroup == nil || imagePathGroup!.count == 0 || _onlyDisplayText! == true {
            return;
        }
        if (imagePathGroup != nil && imagePathGroup!.count == 1) && _hidesForSinglePage! == true {
            return;
        }
        
        let indexOnPageControl: Int = 0;
        var numberOfPages: Int = getTotalItemCount();
        if numberOfPages > 2 {
            numberOfPages -= 2;
        }
        
        switch _pageControlStyle {
        case .animated:
            
            /// 自定义的pageControl设置
            let pageControl: SKPageControl = SKPageControl();
            pageControl.numberOfPages = numberOfPages;
            pageControl.dotColor = currentPageIndicatorTintColor;
            pageControl.isUserInteractionEnabled = true;
            pageControl.currentPage = indexOnPageControl;
            self.addSubview(pageControl);
            _pageControl = pageControl;
            break;
            
        case .classic:
            
            /// 系统的pageControl设置
            let pageControl: UIPageControl = UIPageControl();
            pageControl.backgroundColor = UIColor.blue;
            pageControl.numberOfPages = numberOfPages;
            pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
            pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
            pageControl.isUserInteractionEnabled = true;
            pageControl.currentPage = indexOnPageControl;
            self.addSubview(pageControl);
            _pageControl = pageControl;
            break;
            
        default:
            break;
        }
        
        if currentPageDotImage != nil {
            _currentPageDotImage = currentPageDotImage;
            currentPageDotImage = _currentPageDotImage;
        }
        
        if pageDotImage != nil {
            _pageDotImage = pageDotImage;
            pageDotImage = _pageDotImage;
        }
        
        
    }
    
    /// 设置自定义pageControl.通过dotImage设置
    func setCustomPageControl(dotImage: UIImage?, isCurrentPageDot: Bool) -> Void {
        if dotImage == nil || _pageControl == nil {
            return;
        }
        
        if _pageControl is SKPageControl {
            let pageControl: SKPageControl = _pageControl as! SKPageControl;
            if isCurrentPageDot {
                pageControl.currentDotImage = dotImage;
            }else{
                pageControl.dotImage = dotImage;
            }
        }
        
        
        
    }
    
    //MARK: - Timer相关设置
    func setupTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: _autoScrollTimeIntervar, target: self, selector: #selector(autoScrollImageView), userInfo: nil, repeats: true);
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes);
    }
    
    
    /// 关闭定时器
    func invalidateTimer() -> Void {
        if timer != nil {
            timer!.invalidate();
            timer = nil;
        }
    }
    
    func autoScrollImageView() -> Void {
        if getTotalItemCount() == 0 || getTotalItemCount() == 1 {
            return;
        }
        var currentIndex: Int = getCurrentIndex();
        var targetIndex: Int = getTargetIndex(index: &currentIndex);
        scrollToIndex(index: &targetIndex);
    }
    
    
    /// 滚动到指定Index
    ///
    /// - parameter index: 指定index的地址
    func scrollToIndex( index: inout Int) -> Void {
        
        
        var indexPath: IndexPath = IndexPath(item: index, section: 0);
        
        if _infiniteLoop {
            
            
            if index >= getTotalItemCount() - 1 {
                /// left 或者 up滚动方向
                index = 0;
                indexPath = IndexPath(item: index, section: 0);
                _mainView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.init(rawValue: 0), animated: false);
                index += 1;
            }else if index <= -1 {
                /// right 或者 down滚动方向
                index = getTotalItemCount() - 2;
                indexPath = IndexPath(item: index, section: 0);
                _mainView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.init(rawValue: 0), animated: false);
                index -= 1;
            }
        }
        
        indexPath = IndexPath(item: index, section: 0);
        _mainView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.init(rawValue: 0), animated: true);
        
    }
    
    
    /// 获取当前index
    func getCurrentIndex() -> Int {
        if _mainView.sk_width == 0 || _mainView.sk_height == 0 {
            return 0;
        }
        var index: CGFloat = 0;
        if _flowLayout.scrollDirection == UICollectionViewScrollDirection.horizontal {
            index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
        }else{
            index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
        }
        return max(0, Int(index));
    }
    
    
    /// 获取目标index
    ///
    /// - parameter index: 当前index
    func getTargetIndex(index: inout Int) -> Int {
        var targetIndex: Int = 0;
        switch _scrollDirection {
        case .up:
            print("up");
            targetIndex = index + 1;
            break;
        case .left:
            print("left");
            targetIndex = index + 1;
            break;
        case .down:
            print("down");
            targetIndex = index - 1;
            break;
        case .right:
            print("right");
            targetIndex = index - 1;
            break;
        }
        return targetIndex;
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return getTotalItemCount();
    }
    
    
    /// 获取item总数
    func getTotalItemCount() -> Int {
        if _imagePathGroup == nil {
            if _titleGroup == nil {
                return 0;
            }else{
                return _titleGroup!.count;
            }
        }else{
            if _titleGroup == nil {
                return _imagePathGroup!.count;
            }else{
                return (_imagePathGroup!.count > _titleGroup!.count) ? _imagePathGroup!.count : _titleGroup!.count;
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SKCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SKCollectionViewCell;
        cell.imageView.image = nil;
        cell.title = nil;
        let itemIndex = indexPath.item;
        if _imagePathGroup != nil && _imagePathGroup!.count > itemIndex {
            let imagePath: Any = _imagePathGroup![itemIndex];
            if !_onlyDisplayText && imagePath is String {
                let imagePathString: String = imagePath as! String;
                if imagePathString.hasPrefix("http") {
                    //WARNING - 此处加了网络请求
                }else{
                    var image: UIImage? = UIImage.init(named: imagePathString);
                    if image == nil {
                        image = UIImage.init(contentsOfFile: imagePathString);
                    }
                    cell.imageView.image = image;
                }
            }else if !_onlyDisplayText && imagePath is UIImage {
                cell.imageView.image = imagePath as? UIImage;
            }
        }
        
        if _titleGroup != nil {
            if _titleGroup!.count != 0 && itemIndex < _titleGroup!.count {
                cell.title = _titleGroup![itemIndex];
            }
        }
        
        if !cell.hasConfigured {
            cell.titleLabelFont = _titleLabelFont;
            cell.titleLabelHeight = _titleLabelHeight;
            cell.titleLabelTextColor = _titleLabelTextColor;
            cell.titleLabelBackgroundColor = _titleLabelBackgrounderColor;
            cell.hasConfigured = true;
            cell.imageView.contentMode = _bannerImageViewContentMode;
            cell.clipsToBounds = true;
            cell.onlyDisplayText = _onlyDisplayText;
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate!.sk_cycleScrollView(self, didSelectItemAt: pageControlIndexWithCurrentCellIndex(indexPath.item));
        }
        if self.didSelectItemAt != nil {
            didSelectItemAt!(self, pageControlIndexWithCurrentCellIndex(indexPath.item));
        }
        
        
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if imagePathGroup == nil || imagePathGroup!.count == 0 {
            return;
        }
        let currentIndex = getCurrentIndex();
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(currentIndex);
        if _pageControl != nil {
            if _pageControl! is SKPageControl {
                let pageControl = _pageControl as! SKPageControl;
                pageControl.currentPage = indexOnPageControl;
            }else{
                let pageControl = _pageControl as! UIPageControl;
                pageControl.currentPage = indexOnPageControl;
                
            }
        }
        
        
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoScroll {
            invalidateTimer();
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll {
            setupTimer();
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(_mainView);
    }
   
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if imagePathGroup == nil || imagePathGroup!.count == 0 {
            return;
        }
        let indexOfPageControl = pageControlIndexWithCurrentCellIndex(getCurrentIndex());
        if delegate != nil {
            delegate!.sk_cycleScrollView(self, didScrollTo: indexOfPageControl);
        }
        if didScrollTo != nil {
            didScrollTo!(self, indexOfPageControl);
        }
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews();
        _flowLayout.itemSize = self.frame.size;
        if _backgroundImageView != nil {
            _backgroundImageView!.frame = self.bounds;
        }
        
        /// 以下为pageControl的相关布局
        var size: CGSize = CGSize.zero;
        if _pageControl != nil && imagePathGroup != nil && imagePathGroup!.count != 0 {
            var tempCount = imagePathGroup!.count;
            if tempCount > 2 {
                tempCount -= 2;
            }
            if _pageControl! is SKPageControl {
                ///自定义pageControl样式
                let pageControl: SKPageControl = _pageControl as! SKPageControl;
                if !(pageDotImage != nil && currentPageDotImage != nil && __CGSizeEqualToSize(kSKCycleScrollViewPageControlDotSize, pageControlDotSize)) {
                    pageControl.dotSize = pageControlDotSize;
                }
                size = pageControl.size(forNumberOfPages: tempCount);
            }else{
                ///系统自带pageControl样式
                size = CGSize(width: CGFloat(tempCount) * pageControlDotSize.width * 1.5, height: pageControlDotSize.height);
            }
            var tempX: CGFloat = (self.sk_width - size.width) * 0.5;
            if _pageControlAlignment == .right {
                tempX = _mainView.sk_width - size.width - 10;
            }else if _pageControlAlignment == .left {
                tempX = 10;
                
            }
            let tempY: CGFloat = (_mainView.sk_height - size.height - 10);
            if _pageControl != nil && _pageControl! is SKPageControl {
                let pageControl: SKPageControl = _pageControl as! SKPageControl;
                pageControl.sizeToFit();
                
            }
            
            var pageControlFrame: CGRect = CGRect(x: tempX, y: tempY, width: size.width, height: size.height);
            pageControlFrame.origin.x -= _pageControlRightOffset;
            pageControlFrame.origin.y -= _pageControlBottomOffset;
            _pageControl!.frame = pageControlFrame;
            _pageControl!.isHidden = !_showPageControl;
            
        }
    }
    
    func pageControlIndexWithCurrentCellIndex(_ index: Int) -> Int {
        var tempIndex = 0;
        if index == 0 {
            tempIndex = getTotalItemCount() - 2;
        }else if index == getTotalItemCount() - 1 {
            tempIndex = 0;
        }else{
            tempIndex = index;
        }
        return tempIndex - 1;
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview);
        if newSuperview != nil {
            invalidateTimer();
        }
    }
    
    
    deinit {
        _mainView.delegate = nil;
        _mainView.dataSource = nil;
    }
    
}







































